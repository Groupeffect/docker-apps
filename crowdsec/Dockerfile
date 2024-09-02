
FROM docker.io/crowdsecurity/crowdsec
WORKDIR /app
COPY ./app /app
EXPOSE 8005

# Alternative
# FROM docker.io/ubuntu:24.04 as base_ubuntu
# RUN apt update && apt -y upgrade && apt install -y python3
# WORKDIR /app
# COPY ./app /app
# RUN . /app/cli.sh && cmd_install_crowdsec