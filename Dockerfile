FROM micktwomey/python3.4:latest
MAINTAINER Michael Twomey <mick@twomeylee.name>

EXPOSE 8000

# Any config is read from here
VOLUME ["/gamecraft/config"]

# This is exposed first on the python path, so vagrant builds can use
# your checkout to run the server.
VOLUME ["/gamecraft/src/development"]

# Logs written to here
VOLUME ["/gamecraft/logs"]

# Uploaded files stored here
VOLUME ["/gamecraft/uploads"]

# Backup data into here
VOLUME ["/gamecraft/backups"]


ENV DJANGO_SETTINGS_MODULE gamecraft.settings_docker

RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu trusty main " > /etc/apt/sources.list.d/nodejs.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12

RUN apt-get -y update && \
    apt-get -y install \
        libfreetype6-dev \
        libjpeg8-dev \
        liblcms2-dev \
        libtiff4-dev \
        libwebp-dev \
        nodejs \
        zlib1g-dev

RUN npm install -g less@1.7.0
RUN npm install -g yuglify@0.1.4
RUN npm install -g uglify-js@1.3.5

RUN mkdir -p /gamecraft/src
WORKDIR /gamecraft/src

# Currently it speeds up development to store requirements with the
# dockerfile, since the layer is cached. In future it'll probably make
# sense to move back into the django project itself.
ADD requirements.txt /gamecraft/src/requirements.txt
RUN pip install -r requirements.txt

# Replace the following with the latest hash or tag, docker caches this
# so you need to use a new tag to force a rebuild.
RUN git clone https://github.com/micktwomey/gamecraft-mk-iii.git gamecraft && \
    cd gamecraft && \
    git checkout 0.0.11

# Add the dev version to the python path
RUN echo /gamecraft/src/development > /usr/local/lib/python3.4/dist-packages/gamecraft.pth

# Add the real version to the python path
RUN echo /gamecraft/src/gamecraft >> /usr/local/lib/python3.4/dist-packages/gamecraft.pth

RUN mkdir -p /gamecraft/static
RUN django-admin collectstatic --clear --noinput

# Setup uwsgi to run the django app + serve static files
ADD uwsgi.ini /gamecraft/uwsgi.ini
CMD ["/gamecraft/uwsgi.ini"]
ENTRYPOINT ["/usr/local/bin/uwsgi"]
