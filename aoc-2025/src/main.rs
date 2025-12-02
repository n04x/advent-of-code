mod cli;
mod dispatch;

mod day01;

use std::fs;

fn main() {
    let args = cli::Cli::parse_args();
    let input = if let Some(path) = args.file {
        fs::read_to_string(&path).unwrap_or_else(|e| panic!("Failed to read input file {}: {}", path.display(), e))
    } else {
        let filename = format!("inputs/day{:02}.txt", args.day);
        fs::read_to_string(&filename).unwrap_or_else(|_| panic!("Failed to read input file: {}", filename))
    };

    dispatch::run_day(args.day, args.part, &input);
    
}