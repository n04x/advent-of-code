#region modules
from itertools import product
from collections import deque
#endregion

#region functions

def lowPoints(data, part2: bool = False):
    result = 0
    low_points = []
    neighbours = ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1))

    for coordinates, height in height_map.items():
        x, y = coordinates
        lowest_value = True
        for n in neighbours:
            if height_map.get(n, 10) <= height:
                lowest_value = False
                break
        
        if lowest_value:
            low_points.append(coordinates)
            result += height + 1

    if part2:
        for low_point in low_points:
            part_of_basin = set(low_point) # we know that each low point is part of a basin
            coordinate = [low_point] # we grab the coordinate of the low point
            while coordinate:
                x,y = coordinate.pop()
                for n in neighbours:
                    print(n)
    return result

def basinSizes(data, low_points, basin_size):
    for lp in low_points:
        # we know that each low point is part of a basin
        part_of_basin = set([lp])
        # we store each coordinate associate to the low point
        coords_to_check = [lp]
        # we check every neightbors of the coordinate until we hit a 9
        while coords_to_check:
            x,y = coords_to_check.pop()
            neighbours = ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1))

# need a function that check neighbours
def get_neighbours(data, row, column):
    result = []
    neighbours_positions = (-1, 0), (1, 0), (0, -1), (0, 1)
    for dy,dx in neighbours_positions:
        row_temp, col_temp = row + dy, column + dx
        if 0 <= row_temp <len(data) and 0 <= col_temp < len(data[0]):
            result.append((row_temp, col_temp))
    
    return result

# this is copy-pasted from the source website (link can be found in the README.md)
def bfs(visited, graph, node):
    visited.append(node)
    queue.append(node)

    while queue:
        s = queue.pop(0)
        print(s, end = ' ')

        for neighbour in graph[s]:
            if neighbour not in visited:
                visited.append(neighbour)
                queue.append(neighbour)

#endregion

#region main
with open('./inputs/test.txt', 'r') as file:
    height_map = [[int(val) for val in line.strip()] for line in file.readlines()]

for row in height_map:
    print(row)


risk_levels = []    # array that contains all low points + 1.
basins = []

# create a graph of all data, basically the i,j are now position in the graph and each point in the map is now a value
for row,column in product(range(len(height_map)), range(len(height_map[0]))):
    neighbours = get_neighbours(height_map, row, column)
    if all(height_map[row][column] < height_map[row1][col1] for (row1, col1) in neighbours):
        risk_levels.append(height_map[row][column] + 1)



print("Part #1 Answer: {}".format(sum(risk_levels)))
#print("Part #1 Answer: {}".format(lowPoints(height_map, True)))
#endregion