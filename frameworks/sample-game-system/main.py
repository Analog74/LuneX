from .analytics import log_event
import json

# Load config
with open('config.json') as f:
    config = json.load(f)

# Example system logic
print('Sample Game System starting...')
log_event('system_start', {'config': config})

# ... game logic here ...

log_event('system_shutdown', {})
