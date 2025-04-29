#!/usr/bin/env python

import argparse
import getpass
import requests
import urllib3
from avi.sdk.avi_api import ApiSession
from subprocess import run
from os.path import abspath

if hasattr(requests.packages.urllib3, 'disable_warnings'):
    requests.packages.urllib3.disable_warnings()

if hasattr(urllib3, 'disable_warnings'):
    urllib3.disable_warnings()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-c', '--controller',
                        help='FQDN or IP address of Avi Controller')
    parser.add_argument('-u', '--user', help='Avi API Username',
                        default='admin')
    parser.add_argument('-p', '--password', help='Avi API Password')
    parser.add_argument('-t', '--tenant', help='Tenant',
                        default='admin')
    parser.add_argument('-x', '--apiversion', help='Avi API version')
    parser.add_argument('-tx', '--tfversion', help='Terraform provider version')
    parser.add_argument('objecttype', help='Type of the object')
    parser_n = parser.add_mutually_exclusive_group()
    parser_n.add_argument('-s', '--search',
                          help='Search for object names containing string')
    parser_n.add_argument('-n', '--names',
                          help='Comma-separated list of object names')
    parser.add_argument('filename', help='Output .tf file for resources')

    args = parser.parse_args()

    if args:
        controller = args.controller
        user = args.user
        password = args.password
        tenant = args.tenant
        api_version = args.apiversion
        tf_version = args.tfversion
        object_type = args.objecttype
        object_names = args.names
        object_search = args.search
        output_fn = abspath(args.filename)

        while not controller:
            controller = input('Controller:')

        while not password:
            password = getpass.getpass(f'Password for {user}@{controller}:')

        if not api_version:
            try:
                api = ApiSession.get_session(controller, user, password)
                api_version = api.remote_api_version['Version']
                api.delete_session()
            except Exception as e:
                print(f"Error discovering Controller version: {e}")
                exit(1)
            print(f'Discovered Controller version {api_version}.')

        api = ApiSession.get_session(controller, user, password,
                                     api_version=api_version)

        params = {'fields': 'uuid,name'}

        if object_search:
            params['search'] = f'(name,{object_search})'
        elif object_names:
            if ',' in object_names:
                params['name.in'] = object_names
            else:
                params['name'] = object_names

        matching_objects = api.get_objects_iter(object_type, tenant=tenant,
                                                params=params)

        print('Preparing environment', end='')

        with open('main.tf', mode='w', encoding='UTF-8') as tf_main:
            tf_version = tf_version or api_version
            tf_boilerplate = ['terraform {\n',
                              '  required_providers {\n',
                              '    avi = {\n',
                              '      source = "AVI_providers/"\n',
                              f'      version = "{tf_version}"\n',
                              '    }\n',
                              '  }\n',
                              '}\n',
                              '\n',
                              'provider "avi" {\n',
                              f'  avi_username    = "{user}"\n',
                              f'  avi_tenant      = "{tenant}"\n',
                              f'  avi_password    = "{password}"\n',
                              f'  avi_controller  = "{controller}"\n',
                              f'  avi_version     = "{api_version}"\n'
                              '}\n',
                              '\n']
            tf_main.writelines(tf_boilerplate)

            resources = []
            for obj in matching_objects:
                print('.', end='')
                object_uuid = obj['uuid']
                object_name = obj.get('name', object_uuid)
                rs = ('import {\n'
                      f'  to = avi_{object_type}.{object_uuid}\n'
                      f'  id = "{object_uuid}"\n'
                      '}\n')
                tf_main.write(rs)
                resources.append((object_uuid, object_name))
            tf_main.flush()

        try:
            p = run(['terraform', 'init'],
                    capture_output=True, check=True)
        except Exception as e:
            print(f"Error during terraform init: {e}")
            exit(1)
        print(f'Initializing Terraform (vmware/avi {tf_version})...')

        try:
            p = run(['terraform',
                            'plan',
                            f'-out={output_fn}'],
                        capture_output=True,
                        check=True)
        except Exception as e:
                print(f"Error during terraform plan: {e}")
                exit(1)
        else:
            print('Importing resources...')
            p = run(['terraform',
                        'plan',
                        f'-out={output_fn}'],
                    capture_output=True,
                    check=False)
            if p.returncode:
                print('Error invoking terraform plan:')
                print(p.stderr.decode('UTF-8'))
            else:
                print()
                print(f'Resources have been written to {output_fn}')

    else:
        parser.print_help()