#! /bin/sh
set -eo

if [ ! -d "/data/certs/wok/" ]; then
    mkdir -p /data/certs/wok/
fi

if [ ! -f "/data/certs/wok/dhparams.pem" ]; then
    rm -rf /data/certs/kimchi/*
    cp /data/certs/conf.template /tmp/wok.conf
    openssl req -x509 -newkey rsa:2048 -keyout /data/certs/wok/wok-key.pem -out /data/certs/wok/wok-cert.pem -days 720 -nodes -config /tmp/wok.conf
    openssl x509 -in /data/certs/wok/wok-cert.pem -out /data/certs/wok/dhparams.pem -outform PEM
    cp /data/certs/wok/wok-cert.pem /data/certs/kimchi/kimchi-cert.pem
    cp /data/certs/wok/wok-key.pem /data/certs/kimchi/kimchi-key.pem
fi

rm -rf /etc/wok/* /etc/kimchi/*
cp -r /data/certs/wok/* /etc/wok/
cp -r /data/certs/kimchi/* /etc/kimchi/


python3 /usr/bin/wokd