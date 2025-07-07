import os
from jinja2 import Environment, FileSystemLoader, select_autoescape

# Determine the templates directory relative to this file
TEMPLATES_DIR = os.path.join(os.path.dirname(__file__), 'templates')

# Set up Jinja2 environment
env = Environment(
    loader=FileSystemLoader(TEMPLATES_DIR),
    autoescape=select_autoescape(['json', 'xml'])
)

def render_template(template_name: str, context: dict) -> str:
    """
    Render a template with the given context.

    :param template_name: Filename of the template in the templates directory.
    :param context: Dictionary of values to render into the template.
    :return: Rendered template as a string.
    """
    template = env.get_template(template_name)
    return template.render(context)
