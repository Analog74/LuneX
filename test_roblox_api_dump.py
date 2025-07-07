"""
Test script for roblox_api_dump.py
Demonstrates basic queries and prints sample output.
"""
from library.roblox_api_dump import RobloxAPIDump

API_DUMP_PATH = '/Users/analog/Downloads/API-Dump.json'

def main():
    api = RobloxAPIDump(API_DUMP_PATH)
    print('Total classes:', len(api.list_classes()))
    print('Sample classes:', api.list_classes()[:5])
    print('\nMembers of Instance:')
    for member in api.get_members('Instance')[:5]:
        print(' -', member.get('Name'), '|', member.get('MemberType'))
    print('\nDeprecated members:')
    for class_name, member in api.find_by_tag('Deprecated')[:5]:
        print(f"{class_name}: {member.get('Name')}")

if __name__ == '__main__':
    main()
