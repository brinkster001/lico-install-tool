from configparser import ConfigParser
import os
from pathlib import Path
import logging
from src.colors import SUCCESS, ERROR, ENDC

def precheck():
    
    conf = ConfigParser()
    conf.read('config')

    download_folder  = conf.get('download_folder', 'path')
    os.environ["download_folder"] = download_folder
    files = {}

    if(conf.items("files")):
        for (key, val) in conf.items("files"):
            files[key] = val
            os.environ[f"{key}"] = val

    if(conf.items("security")):
        for (key, val) in conf.items("security"):
            os.environ[f"{key}"] = val

    logging.info('Running pre-checks...')

    if (Path(download_folder).is_dir()):
        logging.info(f'Searching for necessary files in {download_folder}')
        for file in files.values():
            file_path = os.path.join(download_folder, file)
            if (Path(file_path).is_file()):
                logging.info(f'{SUCCESS}Found {file}{ENDC}')
            else:
                logging.error(f'{ERROR}Could not find {file}{ENDC}')
                exit()
    else:
        logging.error(f'{ERROR}Could not find {download_folder}{ENDC}')
        exit()

    