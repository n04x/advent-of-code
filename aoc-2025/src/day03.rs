pub fn solve_part1(input: &str) -> u64 {
    let mut result: u64 = 0;

    for line in input.lines().map(|l| l.trim()).filter(|l| !l.is_empty()) {
        let digits: Vec<u8> = line.chars().map(|c| c.to_digit(10).expect("Invalid digit") as u8).collect();

        let mut best: u64 = 0;

        for i in 0..digits.len() {
            for j in (i + 1)..digits.len() {
                let value = (digits[i] as u64) * 10 + (digits[j] as u64);
                if value > best {
                    best = value;
                }
            }
        }
        result += best;
    }
    return result;
}

pub fn solve_part2(input: &str) -> u64 {
    return 0;
}

#[cfg(test)]

mod tests {
    use super::*;

    #[test]
    fn test_part1_example() {
        let input = "\
987654321111111
811111111111119
234234234234278
818181911112111
";
        assert_eq!(super::solve_part1(input), 357);
    }
    
}