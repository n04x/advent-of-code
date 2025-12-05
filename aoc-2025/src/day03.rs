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

pub fn solve_part2(input: &str) -> u128 {
    const K: usize = 12;
    let mut result: u128 = 0;

    for line in input.lines().map(|l| l.trim()).filter(|l| !l.is_empty()) {
        let digits: Vec<u8> = line
            .chars()
            .map(|c| c.to_digit(10).expect("Invalid digit") as u8)
            .collect();

        let n = digits.len();

        if n < K {
            panic!("Bank has fewer than {} batteries", K);
        }

        let mut stack: Vec<u8> = Vec::with_capacity(K);
        let mut to_remove = n - K;

        for &d in &digits {
            while to_remove > 0 && !stack.is_empty() && *stack.last().unwrap() < d {
                stack.pop();
                to_remove -= 1;
            }

            stack.push(d);
        }

        // if we still have to remove some digits, remove them from the end
        stack.truncate(K);

        // convert stack to number
        let mut value: u128 = 0;
        for d in stack {
            value = value * 10 + (d as u128);
        }

        result += value;
    }

    return result
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

    fn test_part2_example() {
        let input = "\
            987654321111111
            811111111111119
            234234234234278
            818181911112111
            ";
        assert_eq!(solve_part2(input), 3121910778619);
    }
}