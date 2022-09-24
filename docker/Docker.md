# Docker

* [Introduction](#introduction) 
* [Usage](#usage) 
* [Environment](#environment) 
* [Dockerfile](#dockerfile) 
* [Docker-Compose](#docker-compose) 
* [Singularity](#singularity) 
* [Scripts](#scripts) 

# Introduction

This document details the use of containerisation tools (Docker & Singularity) for the deployment of GroIMP. 

This allows model developers to work within a standardised environment, where all users share the same configuration.

# Usage

## Windows

Windows users must install WSL, WSL 2, or Hyper-V to run Docker. **WSL 2** is the most recent of these technologies, and is recommended for most users.

No special requirements are required to run GroIMP headlessly. 

However, to run GroIMP using the GUI, users will need to ensure that they have a running **xserver** to render graphics. They can test this by executing: `echo $DISPLAY`. They should see a value. 

[MobaXterm](https://mobaxterm.mobatek.net/download.html) allows users to run an xserver with minimal configuration. Users should first SSH into their WLS 2 environment using MobaXterm. They should then execute `export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0` to set the `DISPLAY` environment variable. Finally, they can execute `docker compose run groimp` to run the GroIMP GUI.

## Linux

No special requirements are required to run GroIMP headlessly. 

Any distribution of Linux with a GUI can be used to launch the GroIMP GUI, as their versions of Linux will already have an xserver instance running. However, Linux users may run into permissions issues, preventing them from using the GroIMP GUI. Linux users can permit the Docker container user to access the host machine's instance of xserver by executing `xhost +local:all`. 

# Environment

Important information such as the Java JDK version, the GroIMP version, the Debian version, and the model name are contained within the [.env](../.env) file. This file has been added to your [.gitignore](../.gitignore) file, and should not be saved using git.

Edit `CONTAINER_REG_USER` to change the owner of the Docker image on GitHub Container Registry.

The default user is [junqi108](https://github.com/junqi108).

# Dockerfile

[The Dockerfile contains the set of instructions needed to build the GroIMP image.](../services/groimp/Dockerfile)

The steps executed within the Dockerfile are as follows:

1. Several dependencies will be installed.
2. A version of the JDK will be installed to run Java.
3. GroIMP will be installed in the `/usr/share/GroIMP/core.jar` directory.
4. Several local files will be copied into the container.
5. Finally, the workdir will be set to `/var/model`.

# Docker-Compose

[The docker-compose.yaml file contains service definitions for running Docker containers.](../docker-compose.yaml).

Currently, two definitions are provided: 

1. `groimp` is used to run the GUI version of GroIMP.
2. `groimp_headless` is used to run the headless version of GroIMP.

This file defines the environment variables available within the container, mounted volumes, and the Java command required to run GroIMP.

Note that any changes made outside of the container (as determined by the location of the mounted volumes) will modify the contents of files within the container.

# Singularity

Singularity offers additional security features when compared to Docker. Hence, it is more commonly used within multiuser super-computing environments.

While we do not offer a dedicated script to build a Singularity image, it is possible to convert the built Docker image into a Singularity image.

# Scripts

Several convenience scripts are provided. 

* [groimp_build.sh will pull a Debian image from DockerHub. The GroIMP Docker image will then be built.](../groimp_build.sh)
* [groimp_headless_run.sh will execute GroIMP headlessly.](../groimp_headless_run.sh)
* [groimp_run.sh will run the GUI version of GroIMP.](../groimp_run.sh)
* [singularity_pull.sh will pull the Docker image from the GitHub Container Registry, and convert it to Singularity image.](../singularity_pull.sh)
