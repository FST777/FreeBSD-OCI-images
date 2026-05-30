For developers, who are building real-time data-driven applications, Redis is
the preferred, fastest, and most feature-rich cache, data structure server, and
document and vector query engine.

# Image location
- View the available tags [here](https://github.com/FST777/FreeBSD-OCI-images/pkgs/container/redis)
- Pull using `ghcr.io/fst777/redis:latest`

# Image specific notes
Configuration resides here:
- `/usr/local/etc/redis.conf` for use with `redis-server`
- `/usr/local/etc/sentinel.conf` for use with `redis-sentinel`

When no command is issues, `redis-server` will start with the above
configuration file as the sole argument.

The default data path is `/data`, which is configured to be a volume.

By default, redis listens on port 6379. This port is exposed by the image.
