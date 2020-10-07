FROM ubuntu:latest
MAINTAINER Name grupo90pr@gmail.com
ENV DEBIAN_FRONTEND noninteractive
# Install basics
RUN apt-get update
RUN apt-get install -y software-properties-common && \add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y curl
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y xmlsec1
# Install PHP 5.6
RUN apt-get install -y  php5.6 php5.6-mysql php5.6-mcrypt php5.6-cli php5.6-gd php5.6-curl php5.6-soap
# Enable apache mods.
RUN a2enmod php5.6
RUN apt install -y apt-utils
RUN a2enmod rewrite
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/;soap.wsdl_cache_enabled=1/soap.wsdl_cache_enabled=1/" /etc/php/5.6/apache2/php.ini
#RUN sed -i "s/;soap.wsdl_cache_dir="/tmp"/soap.wsdl_cache_dir="/tmp"/" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/;soap.wsdl_cache_ttl=86400/soap.wsdl_cache_ttl=86400/" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/;soap.wsdl_cache_limit = 5/soap.wsdl_cache_limit = 5/" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/5.6/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
# Expose apache.


EXPOSE 80
EXPOSE 443
EXPOSE 3306
# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf


# By default start up apache in the foreground, override with /bin/bash for interative.

CMD /usr/sbin/apache2ctl -D FOREGROUND
#COPY /var/www/html/ /var/www/html
#COPY /home/lolo/disco/contenedores/apache5.6/apache2/php.ini /etc/php/5.6/apache2/php.ini
#COPY /home/lolo/disco/contenedores/apache5.6/apachecli/php.ini /etc/php/5.6/cli/php.ini


