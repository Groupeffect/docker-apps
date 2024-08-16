#!/bin/sh

cmd_install_crowdsec(){
    # curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
    # sudo apt-get update && sudo apt-get install -y crowdsec

    curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | bash
    apt-get update && apt-get install -y crowdsec
    apt install crowdsec-firewall-bouncer-iptables
}

cmd_create_env_file(){
    cp .env .env-backup
    echo "
HOST_MACHINE_IP=$(hostname -I | cut -d ' ' -f 1)   
" > .env
}

cmd_crowdsec_dashboard_setup(){
    cscli dashboard setup --password 1212tree
}

cmd_crowdsec_groups(){
    groupadd crowdsec
    groupadd docker
    sudo gpasswd -a $USER docker
    usermod -aG docker $USER
    usermod -aG crowdsec $USER
}

cmd_info(){
    stat -c "%a" /var/lib/crowdsec/data/
}

cmd_podman_crowdsec_dashboard(){
    sudo systemctl enable --now podman.socket
    sudo env DOCKER_HOST=unix:///run/podman/podman.sock cscli dashboard setup
}