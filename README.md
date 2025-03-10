# dnscrypt-proxy-docker

This project provides a Docker container for running [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy), a flexible DNS proxy supporting DNSCrypt and DoH (DNS-over-HTTPS).

## Usage

To run the dnscrypt-proxy Docker container, use the following command:

```sh
docker run -d --name dnscrypt-proxy -p 53:53/udp -p 53:53/tcp your-docker-image
```

## Configuration

You can customize the configuration by mounting your own `dnscrypt-proxy.toml` file:

```sh
docker run -d --name dnscrypt-proxy -p 53:53/udp -p 53:53/tcp -v /path/to/your/dnscrypt-proxy.toml:/etc/dnscrypt-proxy/dnscrypt-proxy.toml your-docker-image
```

## Docker Compose

You can also use `docker-compose` to run the dnscrypt-proxy container. Create a `docker-compose.yml` file with the following content:

```yaml
version: '3.8'

services:
  dnscrypt-proxy:
    image: your-docker-image
    container_name: dnscrypt-proxy
    ports:
      - "53:53/udp"
      - "53:53/tcp"
    volumes:
      - /path/to/your/dnscrypt-proxy.toml:/etc/dnscrypt-proxy/dnscrypt-proxy.toml
```

Then run the following command to start the container:

```sh
docker-compose up -d
```

## Related Project

For more information about dnscrypt-proxy, visit the [upstream project](https://github.com/DNSCrypt/dnscrypt-proxy) on GitHub.

Test to ensure we have a good signature.