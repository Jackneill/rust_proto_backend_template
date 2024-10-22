use anyhow::Result;
use tracing::Level;

pub fn init_tracing() -> Result<()>
{
	let subscriber = tracing_subscriber::fmt()
		.with_max_level(Level::DEBUG)
		.with_file(true)
		.with_line_number(true)
		.with_thread_ids(true)
		.with_thread_names(true)
		.with_target(false)
		//.with_span_events(FmtSpan::ENTER | FmtSpan::CLOSE | FmtSpan::EXIT)
		.pretty()
		.compact()
		.finish();
	tracing::subscriber::set_global_default(subscriber).map_err(anyhow::Error::from)
}
