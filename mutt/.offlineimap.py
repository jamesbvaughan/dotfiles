#! /usr/bin/env python2
from subprocess import check_output


def get_pass():
    return check_output("pass offlineimap/yoyovaughan@gmail.com", shell=True).splitlines()[0]


folder_names = {
    'archive': '[Gmail]/All Mail',
    'sent': '[Gmail]/Sent Mail',
    'drafts': '[Gmail]/Drafts',
    'trash': '[Gmail]/Trash',
}


def invert_dict(dictionary):
    return {v: k for k, v in folder_names.items()}


def translate_folder(folder):
    return folder_names.get(folder, folder)


def untranslate_folder(folder):
    return invert_dict(folder_names).get(folder, folder)
