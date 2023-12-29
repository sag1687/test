# Scegli un'immagine di base (puoi sostituire questa con l'immagine di PHP 8.1 se preferisci)
FROM ubuntu:latest

# Imposta la modalità non interattiva per apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Aggiorna il sistema e installa le dipendenze di base
RUN apt-get update && apt-get upgrade -y && apt-get -y full-upgrade && \
    apt-get install -y apache2 xvfb libapache2-mod-php && \
    apt-get install -y php-gd php-mysql php-curl php-mbstring && \
    apt-get install -y libsqlite3-0 libsqlite3-dev && \
    apt-get install -y php-sqlite3 php-xml curl && \
    apt-get install -y php-intl php-gmp php-bcmath php-imagick php-zip && \
    apt-get install -y python-software-properties && \
    add-apt-repository ppa:ubuntugis/ubuntugis-unstable && \
    apt-get install -y unzip wget qgis-server* libapache2-mod-fcgid && \
    a2enmod fcgid && a2enconf serve-cgi-bin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copia il file di configurazione di Apache2 sostitutivo
COPY ./apache2.conf /etc/apache2/sites-available/000-default.conf

# Copia il file di configurazione di fcgid
COPY ./fcgid.conf /etc/apache2/mods-available/fcgid.conf

# Esegui i comandi per installare Lizmap
ARG LIZMAP_VERSION=3.6.4
RUN mkdir /var/www/lizmap && \
    cd /var/www/lizmap && \
    wget https://github.com/3liz/lizmap-web-client/releases/download/$LIZMAP_VERSION/lizmap-web-client-$LIZMAP_VERSION.zip && \
    unzip lizmap-web-client-$LIZMAP_VERSION.zip && \
    mv lizmap-web-client-$LIZMAP_VERSION lizmap-web-client && \
    cd /var/www/lizmap/lizmap-web-client/lizmap/install && \
    cp /var/www/lizmap/lizmap-web-client/lizmap/var/config/lizmapConfig.ini.php.dist /var/www/lizmap/lizmap-web-client/lizmap/var/config/lizmapConfig.ini.php && \
    cp /var/www/lizmap/lizmap-web-client/lizmap/var/config/localconfig.ini.php.dist /var/www/lizmap/lizmap-web-client/lizmap/var/config/localconfig.ini.php && \
    cp /var/www/lizmap/lizmap-web-client/lizmap/var/config/profiles.ini.php.dist /var/www/lizmap/lizmap-web-client/lizmap/var/config/profiles.ini.php && \
    php ./installer.php && \
    chown -R www-data:www-data /var/www/lizmap

# Altri comandi specifici possono essere aggiunti qui

# Esegui il comando iniziale (esempio: echo "Hello, World!")
CMD ["/bin/bash"]
