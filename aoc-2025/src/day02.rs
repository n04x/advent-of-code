pub fn solve_part1(input: &str) -> u64 {
    let mut result: u64 = 0;
    for range_str in input.trim().split(',').filter(|s| !s.is_empty()) {
        let (start, end) = parse_range(range_str);

        for id in start..=end {
            if is_double_repeat(id) {
                result += id as u64;
            }
        }
    }
    
    return result;
}

pub fn solve_part2(input: &str) -> i64 {
    return 0
}

// parse a range between two numbers that are separated by a dash
fn parse_range(s: &str) -> (u64, u64) {
    let parts: Vec<&str> = s.split('-').collect();
    let start: u64 = parts[0].parse().expect("Invalid start of range");
    let end: u64 = parts[1].parse().expect("Invalid end of range");
    return (start, end)
}

// check if a number has a double repeat, e.g. 1122 or 1223
fn is_double_repeat(id: u64) -> bool {
    let s = id.to_string();
    let len = s.len();

    // must have even number of digits
    if len % 2 != 0 {
        return false;
    }

    let half = len / 2;
    let first_half = &s[0..half];
    let second_half = &s[half..];

    return first_half == second_half;
} 
