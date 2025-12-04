use clap::Parser;
use std::path::PathBuf;

#[derive(Parser)]
pub struct Cli {
    #[arg(short, long)]
    pub day: u8,

    #[arg(short, long)]
    pub part: Option<u8>,

    #[arg(short = 'f', long, value_name = "FILE", help = "Path to input file; overrides default input selection")]
    pub file: Option<PathBuf>,
}

impl Cli {
    pub fn parse_args() -> Self {
        Cli::parse()
    }
}