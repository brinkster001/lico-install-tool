import os
import subprocess
from src.import_cluster_info import import_cluster_info
from src.precheck import precheck
from src.credentials import credentials
from src.summary import summary
from src.colors import ELEMENT_BG, ENDC, ENDOFL

def clear_screen():
    clear_command = ["/usr/bin/clear"]   
    child_proccess = subprocess.run(clear_command)

def select_version():
    print(f"{ELEMENT_BG}Select which LiCO version do you want to install:  {ENDC}")
    print("1. LiCO v6.3")
    print("2. LiCO v6.4")
    while True:
        reply = str(input('Choose 1/2: ')).lower().strip()
        if reply[:1] == '1':
            os.environ["lico_version"] = "6.3"
            return True
        if reply[:1] == '2':
            os.environ["lico_version"] = "6.4"
            return True

def ask_ldap_uri():
    while True:
        print("")
        uri = str(input(f"{ELEMENT_BG}Please provide existing LDAP uri:{ENDC} "))
        os.environ["ldap_uri"] = uri
        return True

def choose_components():
    print(f"{ELEMENT_BG}Components: {ENDC}")
    # lico-vnc-mond
    ask_user("lico_vnc_mond", "Do you want to install lico-vnc-mond?")

    # lico-sms-agent
    ask_user("lico_sms_agent", "Do you want to install lico-sms-agent?")

    # lico-email-agent
    ask_user("lico_email_agent", "Do you want to install lico-email-agent?")

    # lico-wechat-agent
    ask_user("lico_wechat_agent", "Do you want to install lico-wechat-agent?")

    # lico-container-builder - for versions bellow 6.3
    # ask_user("lico_container_builder", "Do you want to install lico-container-builder?")

    # ldap
    ask_user("install_ldap", "Do you want to install LDAP?")
    if (os.environ["install_ldap"] == 'False'):
        ask_user("existing_ldap_uri", "Do you want to provide existing LDAP uri?")
        if (os.environ["existing_ldap_uri"] == 'True'):
            ask_ldap_uri()

def select_mpi():
    print(f"{ELEMENT_BG}Select MPI default module: {ENDC}")
    print("1. OpenMPI")
    print("2. MPICH")
    print("3. MVAPICH - requires that Infiniband or OPA is present and working correctly.")
    while True:
        reply = str(input('Choose 1/2/3: ')).lower().strip()
        if reply[:1] == '1':
            os.environ["mpi_default_module"] = "openmpi"
            return True
        if reply[:1] == '2':
            os.environ["mpi_default_module"] = "mpich"
            return True
        if reply[:1] == '3':
            # TBD: MVAPICH implementation has not been tested with the installation
            # There might also be dependency faults between MVAPICH2 and MVAPICH2 (psm2)
            # generated by the mpi.sh playbook
            os.environ["mpi_default_module"] = "mvapich"
            print("")
            print(f"{ELEMENT_BG}Select: {ENDC}")
            print("1. MVAPICH2")
            print("2. MVAPICH2 (psm2)")
            reply = str(input('Choose 1/2: ')).lower().strip()
            if reply[:1] == '1':
                os.environ["mvapich2"] = "mvapich2-gnu9-ohpc"
                return True
            if reply[:1] == '2':
                os.environ["mvapich2"] = "mvapich2-psm2-gnu9-ohpc"
                return True
            return True

def ask_user(env_key, question):
    while True:
        print("")
        reply = str(input(f"{question} y/n:"))
        if reply[:1] == 'y':
            os.environ[f"{env_key}"] = "True"
            return True
        if reply[:1] == 'n':
            os.environ[f"{env_key}"] = "False"
            return False

def confirm_installation():
    while True:
        reply = str(input(f"Do you want to start the installation? yes/no:"))
        if reply[:3] == 'yes':
            os.environ[f"{confirm_installation}"] = "True"
            break
        if reply[:2] == 'no':
            os.environ[f"{confirm_installation}"] = "False"
            exit()

def setup():
    # first, import the cluster information
    cluster_info = import_cluster_info("cluster.csv")
    print(type(cluster_info))
    print(cluster_info)
    
    # select LiCO version
    select_version()

    # select MPI module
    select_mpi()

    # choose LiCO components
    choose_components() 

    # credentials input
    auth = credentials()

    # summary
    summary(cluster_info)

    # run prechecks
    precheck()

    # confirm installation
    confirm_installation()

   
    
