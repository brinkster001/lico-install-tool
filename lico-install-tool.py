from src.setup import setup
from src.install import install
import logging

# enable logging
logging.basicConfig(
    level=logging.INFO, 
    format='%(asctime)s : %(levelname)s :  %(message)s',
    handlers=[
        logging.FileHandler("lico_install.log"),
        logging.StreamHandler()
    ]
)


def main():
    # customize setup
    setup()

    # start the installation
    install()

if __name__ == "__main__":
    main()