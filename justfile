just := "just"
cargo := "cargo"
docker := "docker"

export DOCKER_BUILDKIT := "1"

default:
	{{just}} --list

test:
	RUST_BACKTRACE=full {{cargo}} test \
		-vv \
		--all-features \
		--bins \
		--examples \
		--tests \
		--benches \
		--all-targets \
		--workspace
	#-- --nocapture

lint: (buf "lint")
	RUST_BACKTRACE=full {{cargo}} fmt --check
	RUST_BACKTRACE=full {{cargo}} clippy
	RUST_BACKTRACE=full {{cargo}} deny check

bench:
	RUST_BACKTRACE=full {{cargo}} bench \
		-vv \
		--profile release \
		--all-features \
		--bins \
		--examples \
		--tests \
		--benches \
		--all-targets \
		--workspace

build-release: lint test
	{{cargo}} build --release

build:
	{{cargo}} build

run app_name *args: build
	RUST_BACKTRACE=full ./target/debug/{{app_name}} {{args}}

rund container *args:
	{{docker}} run --rm -d \
		{{container}} {{args}}

docker-build-images:
	{{docker}} build \
		-t samplecontext-samplecomponent-sampleservice-v1:latest \
		--build-arg APP=samplecontext-samplecomponent-sampleservice-v1 \
		.

docker-rm:
	{{docker}} rm samplecontext-samplecomponent-sampleservice-v1

compose-up:
	{{docker}} compose \
		-f docker-compose.yml \
		up -d --remove-orphans

compose-down:
	{{docker}} compose \
		-f docker-compose.yml \
		down --remove-orphans

clean:
	rm -rf ./target

buf *cmd:
	{{docker}} run \
		--volume "$(pwd):/workspace" \
		--workdir /workspace \
		bufbuild/buf:latest \
		{{cmd}}

genproto:
	{{just}} buf generate

docker-logs:
	{{docker}} compose logs --follow --tail 100

grpcurl proto addr rpc data:
	{{docker}} run \
		--network host \
		--volume "$(pwd)/proto:/protos" \
		fullstorydev/grpcurl:latest \
		--plaintext \
		-import-path proto \
		-proto {{proto}} \
		{{addr}} {{rpc}} -d {{data}}
