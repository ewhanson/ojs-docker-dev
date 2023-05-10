# OJS Docker Development Environment

A Docker-based development environment for OJS/OMP/OPS.

The purpose of this repository is to provide an easy and convenient solution for completing development work, testing, and debugging within PKP applications, regardless of the version/tech stack required.

## Features

- PHP
- Apache
- MariaDB
- XDebug

## Setup

All instructions will assume you are setting up an existing OJS installation for development work.

1) `docker` and `docker-compose` must be installed and configured on the host machine.
2) Copy all the files from the OJS install directory into the `app/www` directory.
3) Remove all `node_modules` and `vendor` directories. Because the Docker environment may be running a different operating system than the host machine, all npm and composer dependencies must be installed from within the container (more on that below).
4) Copy the installation's files directory into `app/files`.
5) Make a copy of `.env.example` called `.env` and add any relevant configuration settings.
6) Start the containers with `docker-compose up`. Optionally use the `-d` flag to run in detached mode. The first time `docker-compose up` is run for an installation, the npm and composer dependencies will be automatically installed. See `app/entrypoint.sh` for more details.
7) Once the containers are up and running, import the database dump with `TODO: Confirm syntax for import`


