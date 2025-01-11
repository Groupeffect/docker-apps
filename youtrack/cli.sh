#!/bin/sh
# source cli.sh to use the functions
# docker pull jetbrains/youtrack:<version>

YOUTRACK_data="./youtrack-data"
YOUTRACK_conf="./youtrack-conf"
YOUTRACK_logs="./youtrack-logs"
YOUTRACK_back="./youtrack-backups"
TAG="2024.3.55417" # <version>

setup_directories(){
    # https://www.jetbrains.com/help/youtrack/server/youtrack-docker-installation.html#create-and-configure-directories
    # try to run as sudo if you have no operation is not permitted

    # mkdir -p -m 777 $YOUTRACK_data if you have permission problems but keep in mind that this is not best solution
    mkdir -p -m 750 $YOUTRACK_data \
        $YOUTRACK_conf \
        $YOUTRACK_logs \
        $YOUTRACK_back

    chown -R 13001:13001 $YOUTRACK_data \
        $YOUTRACK_conf \
        $YOUTRACK_logs \
        $YOUTRACK_back
}

docker_run(){
    PORT="8080"
    docker run -it --name youtrack-server \
        -v "$YOUTRACK_data:/opt/youtrack/data" \
        -v "$YOUTRACK_logs:/opt/youtrack/logs" \
        -v "$YOUTRACK_back:/opt/youtrack/backups" \
        -v "$YOUTRACK_conf:/opt/youtrack/conf" \
        -p $PORT:8080 \
        jetbrains/youtrack:$TAG
}