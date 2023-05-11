# OJS Docker Development Environment

A Docker-based development environment for OJS/OMP/OPS.

The purpose of this repository is to provide an easy and convenient solution for completing development work, testing, and debugging within PKP applications, regardless of the version/tech stack required.

## Features included

- PHP
- Node
- Apache
- MariaDB
- XDebug

## Setup

All instructions will assume you are setting up an existing OJS installation for development work.

1) `docker` and `docker-compose` must be installed and configured on the host machine.
2) Copy all the files from the OJS install directory into the `app/www` directory, e.g.

```bash
git clone https://github.com/pkp/ojs tmp && mv tmp/* app/www && rm -rf tmp
```

3) If present, remove all `node_modules` and `vendor` directories. Because the Docker environment may be running a different operating system than the host machine, all npm and composer dependencies must be installed from within the container (more on that below). For OJS this includes the following:
    - `node_modules` in root directory
    - `vendor` in `lib/pkp/lib`
    - `vendor` in `plugins/generic/citationStyleLanguage`
    - `vendor` in `plugins/paymethod/paypal`
4) Copy the installation's files directory into `app/files`.
5) Make a copy of `.env.example` called `.env` and add any relevant configuration settings.
6) Start the containers with `docker-compose up`. Optionally use the `-d` flag to run in detached mode. The first time `docker-compose up` is run for an installation, the npm and composer dependencies will be automatically installed. See `app/entrypoint.sh` for more details.
7) Once the containers are up and running, import the database dump:

```bash
docker-compose exec -iT database mysql {{db_name}} -u {{db_username}} -p < {{backup.sql}}
```

8) Edit/hack as needed!

## Tips and tricks

A note on when to work from within the container, and when to work on the host machine directly. You can work on the host machine directly when:
- Performing git operations
- Editing source code files
- Adding additional files/installing plugins
- Copying/editing external `files` directory

You should work within the container when:
- Accessing the database (performing queries, importing database dumps, etc.)
- Updating/installing `npm` or `composer` dependencies

Commands can be run in the container without shelling in first by using the `docker-compose exec` functionality. In general, it looks something like:

```bash
docker-compose exec -it {{service_name}} {{command_to_run}}
```

This is also how you can get shell access inside the container. Assuming the php-apache service is called `pkp_app`, you can run:

```bash
docker-compose exec -it pkp_app bash
```

## TODOs

There are probably a lot of ways this approach can be improved. Some current issues/pain points include:
- [ ] Having the "empty" `app/www` directory with a `.gitkeep` file and cloning OJS into it can be awkward. Hoping to strike a balance between having a ready to use environment when downloading this setup and making it easy to switch between apps used/install data.
- [ ] Currently, the entire `pkp_app` container process fails if any of the `entrypoint.sh` steps fail.
- [ ] The images are quite large as well as the database volume (~200MB fresh). It's worth exploring way to reduce the size while maintaining all the development features (For reference, the images aren't wildly bigger than the Laravel Sail container images, which these are loosely based on).
- [ ] The setup currently assumes one OJS install per single set of PHP/Apache/MySQL containers. Not sure if this is a problem, but it's worth noting.
