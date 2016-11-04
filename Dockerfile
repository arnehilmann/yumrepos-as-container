FROM centos:7
MAINTAINER "Arne Hilmann" <arne.hilmann@gmail.com>
ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; \
     for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/anaconda.target.wants/*
VOLUME [ "/sys/fs/cgroup" ]
RUN echo "root:root" | chpasswd

CMD ["/usr/sbin/init"]

RUN yum-config-manager --add-repo https://arnehilmann.github.io/yumrepos/yumrepos.repo
RUN yum -y install epel-release \
    && yum -y install nginx uwsgi openssh-server \
    && yum clean all
COPY fs_root/etc/sysconfig/* /etc/sysconfig/
COPY fs_root/usr/bin/* /usr/bin/
EXPOSE 80 443
