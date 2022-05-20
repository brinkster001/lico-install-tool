import os
from pathlib import Path
import subprocess
import logging
from src.playbooks import playbooks, playbooks_dir
from src.colors import SUCCESS, ERROR, ENDC


def install():
    for playbook in playbooks:
        playbook_path = os.path.join(playbooks_dir, playbook['file'])
        if(playbook['file'] == "ssh_keys.sh"):
            os.chmod(f"{playbooks_dir}/ssh_keys.expect", 0o755)
        if (Path(playbook_path).is_file()):
            try:
                os.chmod(playbook_path, 0o755)            
                command = ["/bin/bash", playbook_path]   
                child_proccess = subprocess.run(command)
                if(child_proccess.returncode == 0):
                    logging.info(f'{SUCCESS}Succesfully run:{ENDC} {playbook_path}')
                else:
                    raise Exception()     

            except Exception:
                logging.error(f'{ERROR}Failed to run {playbook_path}{ENDC}')
                exit()
            
        
