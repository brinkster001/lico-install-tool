from src.credentials import credentials
from src.precheck import precheck
from src.install import install
import logging


logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s : %(levelname)s :  %(message)s',
    handlers=[
        logging.FileHandler("lico_install.log"),
        logging.StreamHandler()
    ]
)

def main():
    precheck()
    auth = credentials()
    install(auth)

if __name__ == "__main__":
    main()