import json
from pathlib import Path

class RobloxAPIDump:
    def __init__(self, json_path):
        self.json_path = Path(json_path)
        with open(self.json_path, 'r', encoding='utf-8') as f:
            self.data = json.load(f)
        self.classes = {cls['Name']: cls for cls in self.data.get('Classes', []) if 'Name' in cls}

    def get_class(self, class_name):
        """Return the class dict for a given class name."""
        return self.classes.get(class_name)

    def list_classes(self):
        """Return a list of all class names."""
        return list(self.classes.keys())

    def get_members(self, class_name):
        """Return the members (properties, functions, events) of a class."""
        cls = self.get_class(class_name)
        return cls.get('Members', []) if cls else []

    def find_member(self, class_name, member_name):
        """Find a member by name in a class."""
        for member in self.get_members(class_name):
            if member.get('Name') == member_name:
                return member
        return None

    def find_by_tag(self, tag):
        """Find all members with a given tag across all classes."""
        results = []
        for class_name, cls in self.classes.items():
            for member in cls.get('Members', []):
                if tag in member.get('Tags', []):
                    results.append((class_name, member))
        return results

# Example usage:
# api = RobloxAPIDump('/Users/analog/Downloads/API-Dump.json')
# print(api.list_classes())
# print(api.get_members('Instance'))
