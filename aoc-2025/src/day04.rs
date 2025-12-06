pub fn solve_part1(input: &str) -> u64 {
    let grid: Vec<Vec<char>> = input
        .lines()
        .map(|l| l.trim().chars().collect())
        .filter(|row: &Vec<char>| !row.is_empty())
        .collect();    
    
    let rows = grid.len();
    let cols = grid[0].len();

    let mut accessible = 0;

    for r in 0..rows {
        for c in 0..cols {
            if grid[r][c] == '@' {
                let neighbours = count_adjacent_rolls(&grid, r as i32, c as i32);
                if neighbours < 4 {
                    accessible += 1;
                }
            }
        }
    }
    return accessible;
}

fn count_adjacent_rolls(grid: &[Vec<char>], r: i32, c: i32) -> usize {
    let direction = [
        (-1, -1), (-1, 0), (-1, 1),
        (0, -1),           (0, 1),
        (1, -1),  (1, 0),  (1, 1),
    ];

    let mut count = 0;
    for (dr, dc) in &direction {
        let nr = r + dr;
        let nc = c + dc;

        if nr >= 0 && nc >= 0 && (nr as usize) < grid.len() && (nc as usize) < grid[0].len() {
            if grid[nr as usize][nc as usize] == '@' {
                count += 1;
            }
        }
    }
    return count;
}

pub fn solve_part2(input: &str) -> u64 {
    // TODO: your solution here
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "\
        ..@@.@@@@.
        @@@.@.@.@@
        @@@@@.@.@@
        @.@@@@..@.
        @@.@@@@.@@
        .@@@@@@@.@
        .@.@.@.@@@
        @.@@@.@@@@
        .@@@@@@@@.
        @.@.@@@.@.
";

    #[test]
    fn test_part1_example() {
        assert_eq!(solve_part1(EXAMPLE), 13);
    }

    #[test]
    fn test_part2_example() {
        assert_eq!(solve_part2(EXAMPLE), 0);
    }
}