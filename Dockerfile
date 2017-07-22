FROM php:7-fpm

RUN echo "\
deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main #Something\
deb-src http://ppa.launchpad.net/ondrej/php/ubuntu trusty main #Something\
" >> /etc/apt/sources.list

RUN apt-get update

# Install PECL and RPM installation packages
RUN apt-get install -y --force-yes libaio1 rpm2cpio cpio php-dev php-pear

# Install OCI
ENV BASIC /downloads/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
ENV DEVEL /downloads/oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm

COPY ./downloads /downloads
RUN cd / && rpm2cpio $BASIC | cpio -i -d -v
RUN cd / && rpm2cpio $DEVEL | cpio -i -d -v

# Install OCI8 extension to PHP
RUN pecl install oci8
RUN cp /usr/local/lib/php/extensions/no-debug-non-zts-20160303/oci8.so /usr/lib/php/20160303/oci8.so
RUN echo "extension=oci8.so" >> /usr/local/etc/php.ini

#RUN rm -rf /var/lib/apt/lists/* 
#RUN apt-get purge -y --auto-remove rpm2cpio cpio

CMD ["php-fpm", "-c", "/usr/local/etc/php.ini", "--fpm-config", "/usr/local/etc/php-fpm.conf"]
