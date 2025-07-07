import json
from datetime import datetime

def log_event(event_type, data):
    event = {
        'timestamp': datetime.utcnow().isoformat(),
        'event_type': event_type,
        'data': data
    }
    # Append to analytics log (could be cloud or local)
    with open('../../framework74/database/analytics-log.json', 'a') as f:
        f.write(json.dumps(event) + '\n')
