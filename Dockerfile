FROM debian:10

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# apt换本地源
RUN sed -i 's#deb http://deb.debian.org/debian#deb http://nexus.nas.local/repository/debian-buster#g' /etc/apt/sources.list && \
    apt-get update -y

RUN apt-get install -y git nano wget python3-pip pkg-config libnl-route-3-dev
RUN pip3 install ethtool

# Install Wok Dependencies
RUN apt install -y gcc make autoconf automake git python3-pip python3-requests python3-mock gettext pkgconf xsltproc python3-dev pep8 pyflakes python3-yaml
RUN apt install -y systemd logrotate python3-psutil python3-ldap python3-lxml python3-websockify python3-jsonschema openssl nginx python3-cherrypy3 python3-cheetah python3-pampy python-m2crypto gettext python3-openssl apt-utils

# Install Kimchi Dependencies
RUN apt install -y gcc make autoconf automake git python3-pip python3-requests python3-mock gettext pkgconf xsltproc python3-dev pep8 pyflakes python3-yaml
RUN pip3 install -i http://devpi.nas.local/root/aliyun --trusted-host devpi.nas.local cython libsass pre-commit

RUN apt-get install -y python3-configobj python3-lxml python3-magic python3-paramiko python3-ldap spice-html5 novnc qemu-kvm python3-libvirt python3-parted python3-guestfs python3-pil python3-cherrypy3 libvirt0 libvirt-daemon-system libvirt-clients nfs-common sosreport open-iscsi libguestfs-tools libnl-route-3-dev

RUN mkdir -p /usr/src

RUN git clone https://github.com/kimchi-project/wok /usr/src/wok
WORKDIR /usr/src/wok

RUN ./autogen.sh --system && \
    make && \
    make install

# Download, compile, and install Kimchi
RUN git clone https://github.com/kimchi-project/kimchi /usr/src/kimchi
WORKDIR /usr/src/kimchi

RUN ./autogen.sh --system && \
    make && \
    make install

COPY --chmod=744 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
