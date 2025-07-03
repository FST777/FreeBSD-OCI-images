The Apache HTTP Server Project is an effort to develop and maintain an
open-source HTTP server for modern operating systems including UNIX and
Windows. The goal of this project is to provide a secure, efficient and
extensible server that provides HTTP services in sync with the current HTTP
standards.

The Apache HTTP Server ("httpd") was launched in 1995 and it has been the most
popular web server on the Internet since April 1996. It has celebrated its 25th
birthday as a project in February 2020.

# Image location
- View the available tags [here](https://github.com/FST777/FreeBSD-OCI-images/pkgs/container/httpd)
- Pull using `ghcr.io/fst777/httpd:latest`

# Image specific notes
This FreeBSD OCI container image packages follows the FreeBSD filesystem
hierarchy, meaning that:
- configuration goes under `/usr/local/etc/apache24/`
- the default web root is `/usr/local/www/apache24/data/`

You can use volumes to populate either path with your preferred content.

By default, httpd is configured to listen at port 80. This port is exposed by
the image.
