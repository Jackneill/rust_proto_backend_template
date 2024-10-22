use generated_proto_samplecontext::generated::samplecontext::samplecomponent::sampleservice::v1::{
	RpcRequest,
	RpcResponse,
	sample_server::Sample,
};
use tokio_stream::wrappers::ReceiverStream;
use tonic::{
	Request,
	Response,
	Status,
};

#[derive(Debug, Clone)]
pub struct SampleService {}

impl SampleService
{
	pub fn new() -> Self
	{
		Self {}
	}
}

#[tonic::async_trait]
impl Sample for SampleService
{
	#[tracing::instrument]
	async fn rpc(&self, _req: Request<RpcRequest>) -> Result<Response<RpcResponse>, Status>
	{
		Ok(Response::new(RpcResponse {}))
	}
}
