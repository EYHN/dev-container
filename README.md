demo docker-compose.yml file

``` yaml
version: "3.7"

services:
  dev:
    image: ghcr.io/eyhn/dev-container-ssh-dind:latest
    hostname: devcontainer
    environment: 
      - PUBLIC_KEY_FILE=/authorized_keys
    volumes:
      - ./authorized_keys:/authorized_keys
      - ./ssh_host_key:/home/eyhn/.ssh_host_keys
    privileged: true
    network_mode: bridge
    ports:
      - 2222:2222
```