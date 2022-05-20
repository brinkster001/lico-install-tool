import os
import getpass
from src.colors import ELEMENT_BG, ENDC

def credentials():
    print(f"{ELEMENT_BG}Credentials: {ENDC}")
    credentials = {}

    while(True):
        root_password1 = getpass.getpass('Enter root PASSWORD: ')
        root_password2 = getpass.getpass('Confirm root PASSWORD: ')

        if(root_password1 == root_password2):
            credentials['root_password'] = root_password2
            break
           
        else:
            print('Root passwords don`t match')
            

    print('--------------------------------------------------------------')
    while(True):
        bmc_username = input('Enter BMC USERNAME: ')
        if(len(bmc_username) < 1):
            print('Please enter the BMC USERNAME')
        else:
            credentials['bmc_username'] = bmc_username
            break

    while(True):
        bmc_password1 = getpass.getpass('Enter BMC PASSWORD: ')
        bmc_password2 = getpass.getpass('Confirm BMC PASSWORD: ')

        if(bmc_password1 == bmc_password2):
            credentials['bmc_password'] = bmc_password2
            break
        else:
            print('BMC passwords don`t match')
            


    print('--------------------------------------------------------------')
    while(True):
        mysql_username = input('Enter MySQL USERNAME: ')
        if(len(mysql_username) < 1):
            print('Please enter the MySQL USERNAME')
        else:
            credentials['mysql_username'] = mysql_username
            break

    while(True):
        mysql_password1 = getpass.getpass('Enter MySQL PASSWORD: ')
        mysql_password2 = getpass.getpass('Confirm MySQL PASSWORD: ')

        if(mysql_password1 == mysql_password2):
            credentials['mysql_password'] = mysql_password2
            break
        else:
            print('MySQL passwords don`t match')


    print('--------------------------------------------------------------')
    while(True):
        influxdb_username = input('Enter InfluxDB USERNAME: ')
        if(len(influxdb_username) < 1):
            print('Please enter the InfluxDB USERNAME for LiCO')
        else:
            credentials['influxdb_username'] = influxdb_username
            break

    while(True):
        influxdb_password1 = getpass.getpass('Enter InfluxDB PASSWORD: ')
        influxdb_password2 = getpass.getpass('Confirm InfluxDB PASSWORD: ')

        if(influxdb_password1 == influxdb_password2):
            credentials['influxdb_password'] = influxdb_password2
            break
        else:
            print('InfluxDB passwords don`t match')


    print('--------------------------------------------------------------')
    while(True):
        confluent_username = input('Enter Confluent USERNAME: ')
        if(len(confluent_username) < 1):
            print('Please enter the Confluent USERNAME for LiCO')
        else:
            credentials['confluent_username'] = confluent_username
            break

    while(True):
        confluent_password1 = getpass.getpass('Enter Confluent PASSWORD: ')
        confluent_password2 = getpass.getpass('Confirm Confluent PASSWORD: ')

        if(confluent_password1 == confluent_password2):
            credentials['confluent_password'] = confluent_password2
            break
        else:
            print('Confluent passwords don`t match')

    print('--------------------------------------------------------------')
    while(True):
        ldap_password1 = getpass.getpass('Enter LDAP PASSWORD: ')
        ldap_password2 = getpass.getpass('Confirm LDAP PASSWORD: ')

        if(ldap_password1 == ldap_password2):
            credentials['ldap_password'] = ldap_password2
            break
        else:
            print('LDAP passwords don`t match')


    os.environ["LICO_ROOT_PASSWORD"] = credentials['root_password'] 
    os.environ["LICO_BMC_USERNAME"] = credentials['bmc_username']
    os.environ["LICO_BMC_PASSWORD"] = credentials['bmc_password']   
    os.environ["LICO_MYSQL_USERNAME"] = credentials['mysql_username']
    os.environ["LICO_MYSQL_PASSWORD"] = credentials['mysql_password']
    os.environ["LICO_INFLUXDB_USERNAME"] = credentials['influxdb_username']
    os.environ["LICO_INFLUXDB_PASSWORD"] = credentials['influxdb_password']
    os.environ["LICO_CONFLUENT_USERNAME"] = credentials['confluent_username']
    os.environ["LICO_CONFLUENT_PASSWORD"] = credentials['confluent_password']
    os.environ["LICO_LDAP_PASSWORD"] = credentials['ldap_password']
    
    return credentials