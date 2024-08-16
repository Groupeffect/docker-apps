#!/bin/sh

write_env_file(){
    cp .env .env-backup
    echo "
GITEA_INSTANCE_URL=http://$(hostname -I | cut -d ' ' -f 1):3000
GITEA__database__DB_TYPE=postgres
GITEA__database__HOST=gitea_db:5432
GITEA__database__NAME=gitea
GITEA__database__USER=gitea
GITEA__database__PASSWD=gitea
GITEA_RUNNER_REGISTRATION_TOKEN=j18TwcTSbhswGlnQp8zB6ktnRn6sLbgcNw4D5zuf
POSTGRES_USER=gitea
POSTGRES_PASSWORD=gitea
POSTGRES_DB=gitea
# USER_UID=1000
# USER_GID=1000
" > .env && cat env
}