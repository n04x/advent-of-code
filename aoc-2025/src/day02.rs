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

pub fn solve_part2(input: &str) -> u64 {
    let mut result: u64 = 0;

    for range_str in input.trim().split(',').map(|r| r.trim()).filter(|s| !s.is_empty()) {
        let (start, end) = parse_range(range_str);

        for id in start..=end {
            if is_multi_repeat(id) {
                result += id;
            }
        }
    }

    return result
}

// parse a range between two numbers that are separated by a dash
fn parse_range(s: &str) -> (u64, u64) {
    let parts: Vec<&str> = s.split('-').collect();
    if parts.len() != 2 {
        panic!("Invalid range string: {:?}", s);
    }
    let start: u64 = parts[0].trim().parse().expect("Invalid start of range");
    let end: u64 = parts[1].trim().parse().expect("Invalid end of range");

    if start > end {
        panic!("Start of range must be less than or equal to end.");
    }

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

fn is_multi_repeat(id: u64) -> bool {
    let s = id.to_string();
    let len = s.len();

    // Try every possible base pattern length
    for size in 1..=(len / 2) {
        if len % size != 0 {
            continue; // size must divide evenly into length
        }

        let base = &s[0..size];

        if base.starts_with('0') {
            continue; // leading zeros not allowed
        }

        let mut ok = true;
        let mut i = size;
        while i < len {
            if &s[i..i + size] != base {
                ok = false;
                break;
            }
            i += size;
        }

        if ok {
            return true;
        }
    }

    return false;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part1_example() {
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,\
1698522-1698528,446443-446449,38593856-38593862,565653-565659,\
824824821-824824827,2121212118-2121212124";

        assert_eq!(solve_part1(input), 1227775554);
    }

    #[test]
    fn test_part2_example() {
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,\
1698522-1698528,446443-446449,38593856-38593862,565653-565659,\
824824821-824824827,2121212118-2121212124";

        assert_eq!(solve_part2(input), 4174379265);
    }
}