Container for CI/CD
====

This container is intended to use with CI/CD.
Be carefule, this container is not for production.

# BUILD

run these commands:

~~~bash
docker build -t shirasagi/cibase .
~~~

If you want tag, run these commands:

~~~bash
docker build -t shirasagi/cibase:ruby-xxx-chrome-yy .
~~~

# RUN

run these commands to launch `irb`:

~~~bash
docker run --rm -t -i shirasagi/cibase
~~~

Or if you want to access OS natively, run these commands:

~~~bash
docker run --rm -t -i shirasagi/cibase /bin/bash
~~~

# UPLOAD

run these commands to upload the new container image to [docker hub](https://hub.docker.com/):

~~~bash
docker login
docker push shirasagi/cibase
~~~

If you want to push container image with tag, run these commands:

~~~bash
docker login
docker push shirasagi/cibase:ruby-xxx-chrome-yy
~~~
