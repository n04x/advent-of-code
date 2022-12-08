import sys
import heapq

TESTING = False

#region function
def getNeighbours(data, w, h):
    for x, y in ((-1,0), (1,0), (0,-1), (0,1)):
        i, j = w + x, h + y
        if 0 <= i < len(data) and 0 <= j < len(data):
            yield i, j

def search(grid, width, height):
    pq = [(0, (0,0))]
    visited = {(0,0)}
    while pq:
        dist, (i,j) = heapq.heappop(pq)
        if i == height - 1 and j == width - 1:
            return dist
        for i1, j1 in getNeighbours(grid, i, j):
            if(i1, j1) not in visited:
                heapq.heappush(pq, (dist + grid[i1][j1], (i1,j1)))
                visited.add((i1,j1))

def NewMap(grid, width, height):
    new_grid = [line * 5 for line in grid * 5]
    for i in range(height * 5):
        for j in range(width * 5):
            new_grid[i][j] = (new_grid[i][j] + i // height + j // width - 1) % 9 + 1
    
    return new_grid
#endregion

#region script
with open('inputs/test.txt' if TESTING else 'inputs/day15.txt') as f:
    data = f.read().splitlines()
    data = [[int(x) for x in line] for line in data]

width = len(data[0])
height = len(data[0])
lowest_total_risk_part_one = search(data, width, height)
new_grid = NewMap(data, width, height)
lowest_total_risk_part_two = search(new_grid, width * 5, height *5)
print('Part One Answer: {}'.format(lowest_total_risk_part_one))
print('Part Two Answer: {}'.format(lowest_total_risk_part_two))
#endregion