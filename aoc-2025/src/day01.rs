// #[cfg(test)]
// mod tests {
//     use super::*;
//     use std::fs;

//     #[test]
//     fn test_solve_part1() {
//         let input = fs::read_to_string("tests/day01.txt").expect("Failed to read test input file");
//         assert_eq!(solve_part1(&input), "Part 1 Answer: 3");
//     }
// }

pub fn solve_part1(input: &str) -> String {
    let mut position: i32 = 50;
    let mut hits = 0;

    for line in input.lines().filter(|l| !l.trim().is_empty()) {
        let direction = &line[0..1];
        let distance: i32 = line[1..].parse().expect("Invalid number");
        position = match direction {
            "L" => (position - distance).rem_euclid(100),
            "R" => (position + distance).rem_euclid(100),
            _ => panic!("Invalid direction"),
        };
        if position == 0 { 
            hits += 1;
        }
    }
    return format!("Part 1 Answer: {}", hits);
}

pub fn solve_part2(input: &str) -> i64 {
    0
}