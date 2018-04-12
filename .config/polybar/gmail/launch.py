#!/usr/bin/env python

import os
import pathlib
import subprocess
import time
from apiclient import discovery, errors
from oauth2client import client, file
from httplib2 import ServerNotFoundError

DIR = os.path.dirname(os.path.realpath(__file__))
CREDENTIALS_PATH = os.path.join(DIR, 'credentials.json')

count_was = 0

def update_count(count_was):
    gmail = discovery.build('gmail', 'v1', credentials=file.Storage(CREDENTIALS_PATH).get())
    labels = gmail.users().labels().get(userId='me', id='INBOX').execute()
    count = labels['messagesUnread']
    print(str(count), flush=True)
    return count

while True:
    try:
        if pathlib.Path(CREDENTIALS_PATH).is_file():
            count_was = update_count(count_was)
            time.sleep(10)
        else:
            print('credentials not found', flush=True)
            time.sleep(2)
    except (errors.HttpError, ServerNotFoundError, OSError) as error:
        print('err', flush=True)
        time.sleep(5)
    except client.AccessTokenRefreshError:
        print('revoked/expired credentials', flush=True)
        time.sleep(5)
