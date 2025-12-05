use colored::*;

pub fn run_day(day: u8, part: Option<u8>, input: &str) {
    match part {
        Some(1) => {
            let output = match day {
                1 => crate::day01::solve_part1(input),
                2 => crate::day02::solve_part1(input),
                3 => crate::day03::solve_part1(input),
                4 => crate::day04::solve_part1(input),
                _ => panic!("Unsupported day/part combination."),
            };
            println!(
                "{} Day {:02} - Part 1: {}",
                "✔".green().bold(),
                day,
                output.to_string().yellow()
            );
        }
        Some(2) => {
            let output = match day {
                1 => crate::day01::solve_part2(input),
                2 => crate::day02::solve_part2(input),
                3 => crate::day03::solve_part2(input).try_into().unwrap(),
                4 => crate::day04::solve_part2(input),
                _ => panic!("Unsupported day/part combination."),
            };
            println!(
                "{} Day {:02} - Part 2: {}",
                "✔".green().bold(),
                day,
                output.to_string().yellow()
            );
        }
        Some(other) => {
            panic!(
                "Invalid part specified: {}. Only --part 1 or --part 2 are allowed.",
                other
            );
        }
        // Run both parts if no specific part is specified
        None => {
            let p1 = match day {
                1 => crate::day01::solve_part1(input),
                2 => crate::day02::solve_part1(input),
                3 => crate::day03::solve_part1(input).try_into().unwrap(),
                4 => crate::day04::solve_part1(input),
                _ => panic!("Unsupported day/part combination."),
            };

            let p2 = match day {
                1 => crate::day01::solve_part2(input),
                2 => crate::day02::solve_part2(input),
                3 => crate::day03::solve_part2(input).try_into().unwrap(),
                4 => crate::day04::solve_part2(input),
                _ => panic!("Unsupported day/part combination."),
            };

            println!(
                "{} Day {:02} - Part 1: {}",
                "✔".green().bold(),
                day,
                p1.to_string().yellow()
            );

            println!(
                "{} Day {:02} - Part 2: {}",
                "✔".green().bold(),
                day,
                p2.to_string().yellow()
            );
        }
    }
}