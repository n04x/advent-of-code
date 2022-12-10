import sys
from collections import defaultdict
TESTING = False

#region functions
def MoveHead(start, end):
    step_row = 0
    step_col = 0

    diff_row = start[0] - end[0]
    diff_col = start[1] - end[1]
    
    if abs(diff_row) <= 1 and abs(diff_col) <= 1:
        return start

    if start[0] == end[0]:
        step_col = 1 if diff_col == -2 else -1
    elif start[1] == end[1]:
        step_row = 1 if diff_row == -2 else -1
    else:
        step_row = 1 if diff_row < 0 else -1
        step_col = 1 if diff_col < 0 else -1

    return (start[0] + step_row, start[1] + step_col)

def MoveTail(movement, knots):
    position = defaultdict(lambda: (0,0))
    moves = set()
    moves.add(position[0])

    for mdir, step in movement:
        for _ in range(step):
            position[0] = (position[0][0] + mdir[0], position[0][1] + mdir[1])
            for i in range(1, knots):
                position[i] = MoveHead(position[i], position[i-1])
                
                if i == knots - 1:
                    moves.add(position[i])
    
    result = len(moves)
    return result
#endregion

#region parameters
movement = []
movement_direction = {'U': (0,1), 'D': (0,-1), 'R': (1,0), 'L': (-1,0)}
#endregion

#region script
with open('test.txt' if TESTING else 'day09.txt') as f:
    for line in f.read().splitlines():
        direction, steps = line.split(' ')
        movement.append((movement_direction[direction], int(steps)))


visited = MoveTail(movement, knots=2)
print('Part One Answer: {}'.format(visited))

visited = MoveTail(movement, knots=10)
print('Part Two Answer: {}'.format(visited))

#endregion