
cluster_info = [['head', '10.241.57.205', 'head', 'FALSE'], ['c1', '10.241.57.247', 'compute', 'TRUE']]

def nodes_csv(cluster_info):
    output = ""

    for node in cluster_info:
        hostname = node[0]
        type = node[1]
        ip = node[2]
        imm_ip = node[3]
        mac = node[4]
        cpu = node[5]
        ram = node[6]
        gpu = node[7]
        gpu_type = node[8]
        groups = node[9]
        belonging_rack = node[10]
        belonging_chassis = node[11]
        location_u = node[12]

        if type.lower() in ['head', 'compute', 'login']:
            print("ok")



def lico_env(cluster_info):
    pass


nodes_csv(cluster_info)