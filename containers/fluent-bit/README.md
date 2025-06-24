Fluent Bit is a fast Log, Metrics and Traces Processor and Forwarder for Linux,
Windows, Embedded Linux, MacOS and BSD family operating systems. It's part of
the Graduated Fluentd Ecosystem and a CNCF sub-project.

# Image location
- View the available tags [here](https://github.com/FST777/FreeBSD-OCI-images/pkgs/container/fluent-bit)
- Pull using `ghcr.io/fst777/fluent-bit:latest`

# Image specific notes
Configuration is stored at `/etc/fluent-bit/`. The binary is `/bin/fluent-bit`.

When the metrics endpoint is enabled, fluent-bit listens on port 2020. This
port is exposed by the image.
