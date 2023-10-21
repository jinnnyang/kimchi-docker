#! /bin/sh
set -eo

if [ ! -d "/data/certs/wok/" ]; then
    mkdir -p /data/certs/wok/
fi

if [ ! -f "/data/certs/wok/dhparams.pem" ]; then
    rm -rf /data/certs/kimchi/*
    openssl dhparam -out /data/certs/wok/dhparam.pem 2048
    openssl req -nodes -newkey rsa:2048 -keyout /data/certs/wok/wok-key.pem -out /data/certs/wok/wok.csr -subj "/C=US/ST=California/L=San Francisco/O=Wok/OU=IT Department/CN=wok.local"
    openssl x509 -signkey /data/certs/wok/wok-key.pem -in /data/certs/wok/wok.csr -req -days 730 -out /data/certs/wok/wok-cert.pem
    cp /data/certs/wok/wok-key.pem  /etc/kimchi/kimchi-key.pem
    cp /data/certs/wok/wok-cert.pem /data/certs/kimchi/kimchi-cert.pem
fi

rm -rf /etc/wok/* /etc/kimchi/*
cp -r /data/certs/wok/* /etc/wok/
cp -r /data/certs/kimchi/* /etc/kimchi/


python3 /usr/bin/wokd