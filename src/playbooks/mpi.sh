# Install MPI
dnf install -y openmpi4-gnu9-ohpc mpich-ofi-gnu9-ohpc ucx-ib-ohpc

# Set the default module

if [ "${mpi_default_module,,}" == "openmpi" ]
then
dnf install -y lmod-defaults-gnu9-openmpi4-ohpc
fi

if [ "${mpi_default_module,,}" == "mpich" ]
then
dnf install -y lmod-defaults-gnu9-mpich-ofi-ohpc
fi

if [ "${mvapich2,,}" == "mvapich2-gnu9-ohpc" ]
then
dnf install -y mvapich2-gnu9-ohpc
dnf install -y lmod-defaults-gnu9-mvapich2-ohpc
fi

if [ "${mvapich2,,}" == "mvapich2-psm2-gnu9-ohpc" ]
then
dnf install -y mvapich2-psm2-gnu9-ohpc
fi

