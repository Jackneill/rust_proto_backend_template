use anyhow::{
	Context,
	Result,
};
use clap::Parser;
use generated_proto_samplecontext::generated::samplecontext::samplecomponent::sampleservice::v1::
	sample_server::
		SampleServer

;
use service::SampleService;
use tonic::transport::Server;

mod service;

#[derive(Parser, Debug)]
struct Cli
{
	#[arg(short, long, env, default_value = "127.0.0.1:20001")]
	listen_addr: String,
}

#[tokio::main]
async fn main() -> Result<()>
{
	common::tracing::init_tracing()?;

	let args = Cli::try_parse()?;

	let (mut health_reporter, health_server) = tonic_health::server::health_reporter();

	let addr = common::net::resolve_host(args.listen_addr)
		.with_context(|| "unable to resolve the listen address to a socket address")?;
	let srv = SampleService::new();
	let server = SampleServer::new(srv);

	health_reporter
		.set_serving::<SampleServer<SampleService>>()
		.await;

	Server::builder()
		.add_service(server)
		.add_service(health_server)
		.serve(addr)
		.await?;

	Ok(())
}
