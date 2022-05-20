# LiCO-install-tool
A tool to rapidly deploy LiCO v6.3

# Pre requistes:
- OS installed on all nodes
- nodes can ping eachother`s hostnames
- Python 3 installed on head node

`$ pip install -r requirements.txt`

## Edit node information in 'nodes.csv' and 'lico_env.local'
## If necessary adjust the settings in 'config' file

## Add the following to the ./files directory:

- centos84.iso
- confluent-3.2.3-xcat-2.16.1.lenovo2-el8.tar.bz2
- Lenovo-OpenHPC-2.3.CentOS_8.x86_64.tar
- lico-dep-6.3.0.el8.x86_64.tgz
- lico-release-6.3.0.el8.tar.gz

## Run lico-install-tool.py

