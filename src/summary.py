import os
from src.colors import ELEMENT_BG, ELEMENT_BG, ENDOFL, ENDC

def display_table(cluster_info):
    print(f"{ELEMENT_BG}Cluster summary: {ENDC}")
    print("{: >20} {: >20} {: >20} {: >20}".format("hostname", "ip", "groups", "gpu"))
    for row in cluster_info:
        print("{: >20} {: >20} {: >20} {: >20}".format(*row))

def display_lico_settings():
    print(f"{ELEMENT_BG}LiCO Summary: {ENDC}")
    if(os.environ['lico_version']) is not None:
        print(f"lico_version: {os.environ['lico_version']}")  
    if "lico_vnc_mond" in os.environ:  
        print(f"lico_vnc_mond: {os.environ['lico_vnc_mond']}")
    if "lico_email_agent" in os.environ:  
        print(f"lico_email_agent: {os.environ['lico_email_agent']}")
    if "lico_sms_agent" in os.environ:  
        print(f"lico_sms_agent: {os.environ['lico_sms_agent']}")
    if "lico_wechat_agent" in os.environ:  
        print(f"lico_wechat_agent: {os.environ['lico_wechat_agent']}")
    
def display_ldap_settings():
    print(f"{ELEMENT_BG}LDAP Summary: {ENDC}")
    if "install_ldap" in os.environ:  
        print(f"install_ldap: {os.environ['install_ldap']}")
    if "existing_ldap_uri" in os.environ:  
        print(f"existing_ldap_uri: {os.environ['existing_ldap_uri']}")
    if "ldap_uri" in os.environ:
        print(f"ldap_uri: {os.environ['ldap_uri']}")
    
def display_mpi_settings():
    print(f"{ELEMENT_BG}MPI Summary: {ENDC}")
    if "mpi_default_module" in os.environ:  
        print(f"mpi_default_module: {os.environ['mpi_default_module']}")
    if "mvapich2" in os.environ:  
        print(f"mvapich2: {os.environ['mvapich2']}")

def summary(cluster_info):
    display_lico_settings()
    display_ldap_settings()
    display_mpi_settings()
    display_table(cluster_info)
    


