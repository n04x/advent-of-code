use colored::*;

pub fn run_day(day: u8, part: u8, input: &str) {
    let output = match (day, part) {
        (1, 1) => crate::day01::solve_part1(input),
        (1, 2) => crate::day01::solve_part2(input),
        (2, 1) => crate::day02::solve_part1(input),
        // (2, 2) => crate::day02::solve_part2(input),
        _ => panic!("Unsupported day/part combination."),
    };

    println!(
        "{} Day {:02} - Part {}: {}",
        "✔".green().bold(),
        day,
        part,
        output.to_string().yellow()
    );
}