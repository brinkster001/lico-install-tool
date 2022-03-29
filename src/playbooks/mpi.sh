# Install MPI
dnf install -y openmpi4-gnu9-ohpc mpich-ofi-gnu9-ohpc mvapich2-gnu9-ohpc ucx-ib-ohpc

# Set the default module
dnf install -y lmod-defaults-gnu9-openmpi4-ohpc
# dnf install -y lmod-defaults-gnu9-mpich-ofi-ohpc
# dnf install -y lmod-defaults-gnu9-mvapich2-ohpc