# docker-rails-bootstrap

An opinionated docker-compose setup for Rails apps. 

Currently includes ruby 3.1.1, postgres 14, redis 6, node 16, sidekiq, [mailhog][] and [pgweb][].

> This setup was created for development. 

## Requirements

- docker
- docker-compose

Due to conflicts in [user permissions][perms], you will need to add the following lines in you `~/.bashrc` or equivalent:

```bash
export UID=$(id -u) 2> /dev/null
export GID=$(id -g)
```

## Usage

### Creating new Rails applications

You don't need ruby installed in your local machine to create new applications. Create your next one using:

```bash
git clone https://github.com/jweslley/docker-rails-bootstrap myapp
cd myapp
./bootstrap.sh
docker-compose up
```

### Setting up existing Rails applications

For existing applications, you can to execute the following command after cloning your project:

```bash
docker-compose up --build
```

### Starting up your Rails applications

After creating or setting up an existing application, in all subsequent run you can do:

```bash
docker-compose up
```

### Stoping the application

To stop the application, hit `Ctrl+C` and wait the application's shutdown.

### Executing rails commands

To execute any rails command, you can do:

```bash
docker-compose run --rm web bundle exec rails <args>
```

Where `<args>` are the arguments for rails. For example, to generate an scaffold you can do:

```bash
docker-compose run --rm web bundle exec rails generate scaffold post title content:text
```

It's a lot of typing, this lead us to the next topic. =)

### Speeding up your docker-compose command using aliases

To avoid a lot of typing, I strongly recommend the use of the following aliases in your shell:

```bash
alias dc='docker-compose'
alias b='docker-compose run --rm web bundle'
alias be='docker-compose run --rm web bundle exec'
alias bundle='docker-compose run --rm web bundle'
alias rails='docker-compose run --rm web bundle exec rails'
alias webs='docker-compose run --rm web bin/setup' # web Setup
alias webx='docker-compose run --rm web'           # web eXecute
```

Using the `rails` alias above, you can generate a scaffold using:

```bash
rails generate scaffold post title content:text
```

### Resetting the database

All database's data are stored in a local docker volume that persits across application's restarts. To wipe out all data and reset the database, stop the application and remove the docker volume using the following command:

```bash
docker volume rm <volume>
```

Where `<volume>` is the database volume's name, which is a concatenation of application's directory name and `postgres`. For example, if your application is within `myapp` directory you can remove the volume `myapp_postgres`.

When you start up the application again, a new volume will be automatically created.


### Automatically restoring an database backup in you development environment

You can restore an database dump to use in your local environment, for this follow the steps below:

1. reset the database in your local environment like explained in [Resetting the database](#resetting-the-database)
2. copy your database dump to `docker/postgres/backup.dump`
3. start up your application

You need to reset the database because the dump only will be loaded in fresh installations to avoid overwriting of existing data.

### Customizing stack

Currently this setup includes ruby 3.1.1, postgres 14 and redis 6. However you can customize the version of any of them.

To customize ruby version, open the file `docker-compose.yml`, locate the following line and edit the version you would like to use.

```yaml
RUBY_VERSION: '3.1.1'
```

To customize postgres and/or redis, open `docker-compose.yml` file and change image version as you wish.

After editing, execute `docker-compose build` to rebuild the application's images.


## Bugs and Feedback

If you discover any bugs or have some idea, feel free to create an issue on GitHub:

    https://github.com/jweslley/docker-rails-bootstrap/issues

## License

MIT license. Copyright (c) 2020 Jonhnny Weslley <http://jonhnnyweslley.net>

See the LICENSE file provided with the source distribution for full details.


[mailhog]: https://github.com/mailhog/MailHog "Web and API based SMTP testing"
[pgweb]: https://sosedoff.github.io/pgweb     "Cross-platform client for PostgreSQL databases"
[perms]: https://github.com/docker/compose/issues/1532
