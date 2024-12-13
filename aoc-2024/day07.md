# Day 07
## Problem Breakdown
### Initial Setup:
- The guard starts at a specific position (denoted by `^, <, v, or >`).
- The map contains obstacles marked as `#`.
- The guard follows a strict protocol:
  - If there's an **obstacle** directly in front, the guard turns **right** (90 degrees).
  - If there's **no obstacle** directly ahead, the guard moves **forward**.

### Movement Directions:
- The guard moves in `4` possible directions: **up (^)**, **right (>)**, **down (v)**, and **left (<)**.
- A turn right means the guard changes direction **clockwise** (`up → right → down → left → up`).
- The guard's movement should **stop** once they exit the map's boundaries.

### Objective:
Track all the distinct positions visited by the guard, including the starting position and any subsequent positions, until the guard exits the map.

Solution Approach:
1. Parse the input to convert it into a 2D grid (map).
2. Track the guard's position and direction.
3. Simulate the movement based on the given rules.
4. Mark visited positions.
5. Stop when the guard exits the map.