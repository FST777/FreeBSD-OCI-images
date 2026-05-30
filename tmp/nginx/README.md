NGINX (pronounced "engine x" or "en-jin-eks") is the world's most popular Web
Server, high performance Load Balancer, Reverse Proxy, API Gateway and Content
Cache.

# Image location
- View the available tags [here](https://github.com/FST777/FreeBSD-OCI-images/pkgs/container/nginx)
- Pull using `ghcr.io/fst777/nginx:latest`

# Image specific notes
This FreeBSD OCI container image packages follows the FreeBSD filesystem
hierarchy, meaning that:
- configuration goes under `/usr/local/etc/nginx/`
- the default web root is `/usr/local/www/nginx/`

You can use volumes to populate either path with your preferred content.

By default, nginx is configured to listen at port 80. This port is exposed by
the image.
