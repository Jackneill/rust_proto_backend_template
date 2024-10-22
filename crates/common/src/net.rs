use std::net::{
	SocketAddr,
	ToSocketAddrs,
};

use anyhow::Result;

/// Resolves a host[:port] to a socket address.
///
/// If multiple addresses are found, the first one is returned.
/// This is useful when eg. you are starting your service in a docker container.
pub fn resolve_host<A>(addr: A) -> Result<SocketAddr>
where
	A: AsRef<str>,
{
	match addr.as_ref().parse::<SocketAddr>() {
		Ok(socketaddr) => Ok(socketaddr),
		Err(_) => {
			let socketaddr =
				addr.as_ref().to_socket_addrs()?.next().ok_or_else(|| {
					anyhow::anyhow!("failed to resolve host: {}", addr.as_ref())
				})?;
			Ok(socketaddr)
		},
	}
}
