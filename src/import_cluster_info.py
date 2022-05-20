
import csv
import json
import os
import logging
from src.colors import SUCCESS, ERROR, ENDC
  

def get_file_extension(filename: str):
    # this will return a tuple of root and extension
    split_tup = os.path.splitext(filename)

    # extract the file extension
    file_extension = split_tup[1]
    return file_extension


def csv_to_list(file):
    list = []
    file_extension = get_file_extension(file)

    if(file_extension == ".csv"):
        logging.info(f'Opening csv file from {file}')
        # Open a csv reader called DictReader
        with open(file, encoding='utf-8') as csvf:
            csv_reader = csv.DictReader(csvf)
            # Convert each row into a dictionary
            # and add it to data
            for row in csv_reader:
                temp_list = []
                temp_list.append(row['hostname'])
                temp_list.append(row['ip'])
                temp_list.append(row['groups'])
                temp_list.append(row['gpu'])
                list.append(temp_list)
            logging.info(f'{SUCCESS}Succesfully read {file} {ENDC}')
        return list
        
    else:
       logging.error(f'{ERROR}Wrong csv file type extension.{ENDC}')  

def json_to_list(file):
    list = []
    file_extension = get_file_extension(file)

    if(file_extension == ".json"):
        logging.info(f'Opening json file from {file}')
        with open(file) as json_file:
            json_data = json.load(json_file)
            for key, value in json_data.items():
                temp_list = []
                temp_list.append(value["hostname"])
                temp_list.append(value["ip"])
                temp_list.append(value["groups"])
                temp_list.append(value["gpu"])
                list.append(temp_list)
        return list
    else:
       logging.error(f'{ERROR}Wrong json file type extension.{ENDC}') 

def csv_file_to_json(csv_file_path, json_file_path):
     
    # create a dictionary
    data = {}
     
    # Open a csv reader called DictReader
    with open(csv_file_path, encoding='utf-8') as csvf:
        csvReader = csv.DictReader(csvf)
        for rows in csvReader:
            key = rows['hostname']
            data[key] = rows
 
    # Open a json writer, and use the json.dumps()
    # function to dump data
    with open(json_file_path, 'w', encoding='utf-8') as jsonf:
        jsonf.write(json.dumps(data, indent=4))


def import_cluster_info(file_path):
    # create a dictionary
    data = {}
    file_extension = get_file_extension(file_path)

    if(file_extension == ".csv"):
        data = csv_to_list(file_path)
    
    if(file_extension == ".json"):
        data = json_to_list(file_path)

    return data


  
# csv_file_to_json("cluster.csv", "cluster.json")