from collections import defaultdict
from itertools import product

#region parameters
TESTING = False
rock_types = [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 1]],     # Straight horizontal line
         [[0, 0, 0, 0], [0, 1, 0, 0], [1, 1, 1, 0], [0, 1, 0, 0]],          # Plus
         [[0, 0, 0, 0], [0, 0, 1, 0], [0, 0, 1, 0], [1, 1, 1, 0]],          # Reversed L
         [[1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]],          # Straight vertical line
         [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 0, 0], [1, 1, 0, 0]]]          # Square

graph = defaultdict(int)
#endregion

#region functions
def canMove(index, x, y, dx, dy):
    x = x + dx
    y = y + dy
    for row, column in product(range(4), repeat=2):
        if rock_types[index][row][column]:
            temp_x = x + column
            temp_y = y + (3 - row)
            if temp_y <= 0 or temp_x <= 0 or temp_x > 7 or graph[temp_x, temp_y]:
                return False
    
    return (x,y)


def getTowerHeight(jets):
    result = 0
    jet_index = 0

    for i in range(2022):
        x = 3
        y = result + 4
        ticks = 0

        while True:
            if ticks % 2:
                if canMove(i % len(rock_types), x, y, 0, -1):
                    y -= 1
                else:
                    break
            else:
                direction = (1,0) if jets[jet_index % len(jets)] == '>' else (-1,0)
                can_move = canMove(i % len(rock_types), x, y, *direction)
                
                if can_move:
                    x, y = can_move
                
                jet_index += 1
            
            ticks += 1
    
        for row, column in product(range(4), repeat = 2):
            if rock_types[i % len(rock_types)][row][column]:
                temp_x = x + column
                temp_y = y + (3 - row)
                graph[temp_x, temp_y] = 1
                result = max(result, temp_y)
    
    return result
#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    jets_direction = f.read()

tower_height = getTowerHeight(jets_direction)
print('Part One Answer: {}'.format(tower_height))
#endregion