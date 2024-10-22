# Tmpl

Opinionated Rust proto backend service[s] template using buf.

## Pre-Requisites

* Install [docker](https://docs.docker.com/install/)
* Install [just](https://github.com/casey/just)

For non-docker build capability only:

* Install [mold](https://github.com/rui314/mold)
* Install [rust](https://rustup.rs/)

## General Workflow

Use `just -l` to see pre-defined available _just recipes_.

## Build

```sh
# Build debug binaries locally:
just build
# Build release binaries locally:
just build-release
# Build docker images locally:
just docker-build-images
```

## Run

### Local binaries

* The run commands automatically build the debug versions if they don't exist.
* The default host is `127.0.0.1`, thus the services will find each other with the default config.

```sh
# General format:
# just run <service> {args}

# Run the samplecontext-samplecomponent-sampleservice service locally:
just run samplecontext-samplecomponent-sampleservice-v1 --help
```

### via Docker Containers

```sh
# General format:
# just rund <container[:version]> {args}

# Run the samplecontext-samplecomponent-sampleservice service via docker container:
just rund samplecontext-samplecomponent-sampleservice-v1 --help
```

### via Docker Compose

```sh
just docker-build-images

# Start all the services:
just compose-up
# Stop all the services:
just compose-down
```

## Development

* See running docker containers with: `docker ps`
* Remove the running containers with: `just docker-rm`
* Proto files are [re-]generated using: `just genproto`
 	* The generated code is located in the `generated-proto-samplecontext` crate.

### GRPCurl

Sample grpcurl command:

```sh
just grpcurl \
	samplecontext/samplecomponent/sampleservice/v1/sampleservice.proto \
	127.0.0.1:20001 \
	samplecontext.samplecomponent.sampleservice.v1.Sample/RPC \
	'{}'
```
