import sys
import logging
import numpy as np
import operator

TESTING = False

#region function
def createRocks(data):
    
    paths_list = [[tuple(int(item) for item in point.strip().split(',')) for point in line.split('->')] for line in data]
    result = {}

    for point in paths_list:
        result[point[0]] = '#'
        for i in range(1, len(point)):
            result[point[i]] = '#'
            vector = np.subtract(point[i], point[i - 1])
            direction = np.sign(vector)
            rock = point[i-1]
            while rock != point[i]:
                result[rock] = '#'
                rock = tuple(np.add(rock, direction))
    
    return result

def addSands(cavern:dict, part2=False):
    add_sand = True
    max_y = max(cavern.keys(), key=operator.itemgetter(1))[1]
    if part2:
        max_y += 2
    sand_pouring_pos = (500,0)
    while add_sand:
        sand_position = sand_pouring_pos
        stop_pouring = False
        while not stop_pouring:
            x, y = sand_position
            temp_position = (x, y + 1)
            if temp_position in cavern:
                temp_position = (x - 1, y + 1)
                if temp_position in cavern:
                    temp_position = (x+1, y+1)
                    if temp_position in cavern:
                        cavern[sand_position] = 'o'
                        stop_pouring = True
                        if sand_position == sand_pouring_pos:
                            add_sand = False
            
            sand_position = temp_position
            if part2:
                if sand_position[1] == max_y - 1:
                    cavern[sand_position] = 'o'
                    stop_pouring = True
            elif sand_position[1] > max_y:
                stop_pouring = True
                add_sand = False
    
    return len([key for key in cavern.keys() if cavern[key] == 'o'])

        

#endregion

#region parameter

#endregion

#region script
with open('test.txt' if TESTING else 'input.txt') as f:
    data = f.read().splitlines()

cavern = createRocks(data)
unit_of_sand = addSands(cavern)
unit_of_sand_pt2 = addSands(cavern, True)

print('Part One Answer: {}'.format(unit_of_sand))
print('Part Two Answer: {}'.format(unit_of_sand_pt2))
#endregion