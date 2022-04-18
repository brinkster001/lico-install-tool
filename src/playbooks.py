import os

script_dir = os.path.dirname(__file__)

# set the path to where all the playbooks are located
playbooks_dir = os.path.join(script_dir, "playbooks")

# define the playbooks in the order they need to run
playbooks = [
    {
        "name": "repositories",
        "file": "repositories.sh"
    },
    {
        "name": "confluent",
        "file": "confluent.sh"
    },
    {
        "name": "security",
        "file": "security.sh"
    },
    {
        "name": "nfs setup",
        "file": "nfs.sh"
    },
    {
        "name": "distribute_repos",
        "file": "distribute_repos.sh"
    },
    {
        "name": "nginx",
        "file": "nginx.sh"
    },
    {
        "name": "slurm",
        "file": "slurm.sh"
    },
    {
        "name": "chrony",
        "file": "chrony.sh"
    },
    {
        "name": "icinga2",
        "file": "icinga2.sh"
    },
    {
        "name": "mpi",
        "file": "mpi.sh"
    },
    {
        "name": "singularity",
        "file": "singularity.sh"
    },
    {
        "name": "lico_dependencies",
        "file": "lico_dependencies.sh"
    },
    {
        "name": "lico_release",
        "file": "lico_release.sh"
    },
    {
        "name": "final_configuration",
        "file": "final_configuration.sh"
    }
]