from collections import defaultdict
from itertools import product
import copy

#region parameters
TESTING = False
rock_types = [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 1]],     # Straight horizontal line
         [[0, 0, 0, 0], [0, 1, 0, 0], [1, 1, 1, 0], [0, 1, 0, 0]],          # Plus
         [[0, 0, 0, 0], [0, 0, 1, 0], [0, 0, 1, 0], [1, 1, 1, 0]],          # Reversed L
         [[1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]],          # Straight vertical line
         [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 0, 0], [1, 1, 0, 0]]]          # Square


#endregion

#region functions
def resetParameters():
    height, jet_index, inc = [0] * 3
    i = -1
    return height, jet_index, inc, i

def resetDictionary():
    rs = defaultdict(set)
    states = defaultdict(int)
    graph = defaultdict(int)

    return graph, rs, states

def canMove(graph, index, x, y, dx, dy):
    x = x + dx
    y = y + dy
    for row, column in product(range(4), repeat=2):
        if rock_types[index][row][column]:
            temp_x = x + column
            temp_y = y + (3 - row)
            if temp_y <= 0 or temp_x <= 0 or temp_x > 7 or graph[temp_x, temp_y]:
                return False
    
    return (x,y)


def getTowerHeight(jets, PART2=False):
    cycle_found = False
    result, jet_index, inc, i = resetParameters()
    graph, rows_set, states = resetDictionary()
    total_rocks = 1000000000000 if PART2 else 2022

    while(i := i + 1) < total_rocks:
        x = 3
        y = result + 4
        ticks = 0

        while True:
            if ticks % 2:
                if canMove(graph, i % len(rock_types), x, y, 0, -1):
                    y -= 1
                else:
                    break
            else:
                jet_dir = (1,0) if jets[jet_index % len(jets)] == '>' else (-1,0)
                can_move = canMove(graph, i % len(rock_types), x, y, *jet_dir)
                
                if can_move:
                    x, y = can_move
                
                jet_index += 1
            
            ticks += 1
    
        for row, column in product(range(4), repeat = 2):
            if rock_types[i % len(rock_types)][row][column]:
                temp_x = x + column
                temp_y = y + (3 - row)
                graph[temp_x, temp_y] = 1
                rows_set[temp_y].add(temp_x)
                result = max(result, temp_y)

        if PART2:
            hashes = (tuple(tuple(sorted(rows_set[result - i])) for i in range(32) if result - i >= 0), i % len(rock_types), jet_index % len(jets))
            if not cycle_found:
                if hashes in states:
                    amount_rocks = i - states[hashes][0]
                    cycles_number = (total_rocks - i) // amount_rocks
                    total_rocks -= amount_rocks * cycles_number
                    inc = (result - states[hashes][1]) * cycles_number
                    cycle_found = True
                else:
                    states[hashes] = (i, result)
    
    if PART2:
        return result + inc
    else:
        return result
#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    jets_jet_dir = f.read()

tower_height_p1 = getTowerHeight(jets_jet_dir)
print('Part One Answer: {}'.format(tower_height_p1))
tower_height_p2 = getTowerHeight(jets_jet_dir, True)
print('Part Two Answer: {}'.format(tower_height_p2))
#endregion