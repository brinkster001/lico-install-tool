import os

script_dir = os.path.dirname(__file__)
playbooks_dir = os.path.join(script_dir, "playbooks")

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
        "name": "install dir",
        "file": "install_dir.sh"
    },
    {
        "name": "distribute_repos",
        "file": "distribute_repos.sh"
    },
    {
        "name": "security",
        "file": "security.sh"
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
        "name": "nfs",
        "file": "nfs.sh"
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