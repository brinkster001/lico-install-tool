from configparser import ConfigParser
import os
from pathlib import Path
import logging
from src.colors import SUCCESS, ERROR, ENDC

def precheck():
    # read the config file
    conf = ConfigParser()
    conf.read('config')

    # set download_folder path from config
    download_folder  = conf.get('download_folder', 'path')
    os.environ["download_folder"] = download_folder

    # set the neccessary file names in files array
    # also store them as environment variables to make them available to the bash scripts
    files = {}

    if(conf.items("files")):
        for (key, val) in conf.items("files"):
            
            files[key] = val
            os.environ[f"{key}"] = val
    
    # get the security settings from config and make them available to the bash scripts
    if(conf.items("security")):
        for (key, val) in conf.items("security"):
            os.environ[f"{key}"] = val

    logging.info('Running pre-checks...')

    # check if all necessary files are present
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

    # check if LiCO is already installed
    # check firewall
    # check SELinux
    