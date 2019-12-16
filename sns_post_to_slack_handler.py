import json
from botocore.vendored import requests
import os

def lambda_handler(event, context):
    message = event.get('Records',[{}])[0].get('Sns',{}).get('Message')
    username = event.get('Records',[{}])[0].get('Sns',{}).get('Subject')

    webhook_url = os.getenv('WEBHOOK_URL')
    icon_emoji = os.getenv('ICON_EMOJI')
    slack_data = {
        'text': message,
        'username': username,
        'icon_emoji': icon_emoji
    }

    requests.post(
        webhook_url, data=json.dumps(slack_data),
        headers={'Content-Type': 'application/json'}
    )