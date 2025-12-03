pub fn solve_part1(input: &str) -> u64 {
    let mut position: i64 = 50;
    let mut hits = 0;

    for line in input.lines().filter(|l| !l.trim().is_empty()) {
        let direction = &line[0..1];
        let distance: i64 = line[1..].parse().expect("Invalid number");
        position = match direction {
            "L" => (position - distance).rem_euclid(100),
            "R" => (position + distance).rem_euclid(100),
            _ => panic!("Invalid direction"),
        };
        if position == 0 { 
            hits += 1;
        }
    }
    return hits
}

pub fn solve_part2(input: &str) -> u64 {
    let mut position: i64 = 50;
    let mut hits: u64 = 0;
    let dial_size: i64 = 100;

    for line in input.lines().filter(|l| !l.trim().is_empty()) {
        let direction = &line[0..1];
        let distance: i64 = line[1..].parse().expect("Invalid number");

        // Determine signed delta
        let delta = match direction {
            "L" => -distance,
            "R" => distance,
            _ => panic!("Invalid direction"),
        };
        let position_modulo = position.rem_euclid(dial_size);
        
        // Distance to next zero going in the direction of movement.
        let offset = if delta >= 0 {
            (dial_size - position_modulo) % dial_size
        } else {
            position_modulo % dial_size
        };

        // Count the zero crossings
        let d = delta.abs();
        let crosses = if d <= offset {
            0
        } else {
            // subtract offset, then every 100 more is another crossing
            (d - offset - 1) / dial_size + 1
        };
        
        hits += crosses as u64;
        position += delta;
    }
    return hits
}