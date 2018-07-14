#!/usr/bin/env python

import os
import pathlib
from apiclient import discovery, errors
from oauth2client import client, file
from httplib2 import ServerNotFoundError

DIR = os.path.dirname(os.path.realpath(__file__))
CREDENTIALS_PATH = os.path.join(DIR, 'credentials.json')

try:
    if pathlib.Path(CREDENTIALS_PATH).is_file():
        credentials = file.Storage(CREDENTIALS_PATH).get()
        gmail = discovery.build('gmail', 'v1', credentials=credentials)
        labels = gmail.users().labels().get(userId='me', id='INBOX').execute()
        count = labels['messagesUnread']
        print(str(count))
    else:
        print('credentials not found')
except (errors.HttpError, ServerNotFoundError, OSError):
    # print('network error')
    pass
except client.AccessTokenRefreshError:
    print('revoked/expired credentials')
