#!/bin/sh

cmd_info(){
    sudo lsof -i -P -n | grep LISTEN
    # https://wiki.ubuntuusers.de/Dnsmasq/
    cat /etc/resolv.conf
    # cat /etc/dnsmasq.conf
    cat /etc/NetworkManager/NetworkManager.conf
    cat /etc/systemd/resolved.conf 
    cat /etc/resolvconf/resolv.conf.d/tail # add namserver 127.0.01
}

cmd_resolver(){
    # echo "DNSStubListener=no" >> /etc/systemd/resolved.conf
    # service systemd-resolved restart
    # echo "#[main] dns=default" >> /etc/NetworkManager/NetworkManager.conf
    sudo service systemd-resolved stop
    cp /etc/resolv.conf resolv.conf
    sudo rm /etc/resolv.conf
    sudo service network-manager restart

}

cmd_write_env(){
PW=1234wert
STATIC_IP_GUEST=192.168.179.81
STATIC_IP_MAIN=192.168.178.80
    # create .env file at current path 
    # HOST_IP=$(hostname -I | cut -d " " -f 1)
    HOST_IP=127.0.0.1
    echo "# Automated .env file created by cmd_write_env bash function." > .env
    echo "WEBPASSWORD=$PW" >> .env
    echo "#" >> .env
    echo "TZ=Europe/Berlin" >> .env
    echo "#" >> .env
    echo "FTLCONF_LOCAL_IPV4=$HOST_IP" >> .env
    echo "#" >> .env
    echo "STATIC_IP_GUEST=$STATIC_IP_GUEST" >> .env
    echo "#" >> .env
    echo "STATIC_IP_MAIN=$STATIC_IP_MAIN" >> .env
    echo "#" >> .env
    WIFI_DEVICE_NAME=$(nmcli d show | grep wlp | cut -d ':' -f 2) 
    WIFI_DEVICE_NAME=$(echo $WIFI_DEVICE_NAME)
    echo "WIFI_DEVICE_NAME="$WIFI_DEVICE_NAME >> .env
    echo "#" >> .env
    echo "DNSMASQ_LISTENING=all" >> .env
    echo "#" >> .env
    echo "VIRTUAL_HOST=pi.hole" >> .env
    echo "#" >> .env
    echo PROXY_LOCATION="pi.hole" >> .env
    echo "#" >> .env
    LOCALHOST_IP=$(hostname -I | cut -d " " -f 1)
    echo LOCALHOST_IP=$LOCALHOST_IP >> .env
}
cmd_get_env(){
    # .env file required
    x=$(cat .env | grep $1 | cut -d '=' -f 2)
    echo "$x"
}
cmd_source_env(){
    export "$1=$(cmd_get_env $1)"
}
cmd_assig_ip(){
    # write .env and assing wifi devices to static ip's
    cmd_write_env
    WIFI_DEVICE_NAME=$(cmd_get_env WIFI_DEVICE_NAME)
    ip addr show dev $WIFI_DEVICE_NAME
    cmd_source_env WIFI_DEVICE_NAME
    cmd_source_env FTLCONF_LOCAL_IPV4
    cmd_source_env STATIC_IP_MAIN
    cmd_source_env STATIC_IP_GUEST

    env | grep STATIC_IP_MAIN
    env | grep STATIC_IP_GUEST

    sudo ip addr add $STATIC_IP_MAIN/24 dev $WIFI_DEVICE_NAME
    ip addr show dev $WIFI_DEVICE_NAME
    sudo ip addr add $STATIC_IP_GUEST/24 dev $WIFI_DEVICE_NAME
    ip addr show dev $WIFI_DEVICE_NAME
}

# dudummesau1234
# wlan pw wieder ändern