import sys
from collections import defaultdict, deque
TESTING = False
#region functions
def createGraph(grid):
    result = defaultdict(list)
    ROWS = max(grid, key=lambda x: x[0])[0]
    COLS = max(grid, key=lambda x: x[1])[1]
    for row in range(ROWS + 1):
        for col in range(COLS + 1):
            coordinate = (row,col)

            if grid[coordinate] in ("S", "a"):
                a_elevations_set.add(coordinate)
            
            if grid[coordinate] == "S":
                start = coordinate
            elif grid[coordinate] == "E":
                end = coordinate
            
            for neighbour_row, neighbour_col in [(-1,0), (1,0), (0,-1), (0,1)]:
                
                if row + neighbour_row >= 0 and col + neighbour_col >= 0 and row + neighbour_row <= ROWS and col + neighbour_col <= COLS:
                    neighbour = (row + neighbour_row, col + neighbour_col)

                    current_elevation = getElevation(grid[coordinate])
                    neighbour_elevation = getElevation(grid[neighbour])

                    if(neighbour_elevation <= current_elevation or neighbour_elevation == current_elevation + 1):
                        result[coordinate].append(neighbour)
    
    return result, start, end

def BFS(graph, start, end):
    queue = deque([(0, start)])
    visited = set()
    visited.add(start)

    while len(queue) > 0:
        distance, current = queue.popleft()
        if current == end:
            return distance

        for neighbour in graph[current]:
            if neighbour not in visited:
                visited.add(neighbour)
                queue.append((distance + 1, neighbour))
        
    return float("infinity")

def getElevation(character):
    return ord("a") if character == "S" else ord("z") if character == "E" else ord(character)

def getMinDistance(graph, aset, end):
    result = float('Infinity')
    for a in aset:
        distance = BFS(graph, a, end)
        if distance < result:
            result = distance
    
    return result
#enegion

#region parameter
graph = defaultdict(list)
START = (0,0)
END = (0,0)
a_elevations_set = set()
#endegion

#region script

with open('test.txt' if TESTING else 'input.txt') as f:
    grid = {}
    for row,line in enumerate(f.readlines()):
        for col, character  in enumerate(line.strip()):
            grid[(row,col)] = character
    
graph, START, END = createGraph(grid)

steps_required = BFS(graph, START, END)
minimum_distance = getMinDistance(graph, a_elevations_set, END)


print('Part One Answer: {}'.format(steps_required))
print('Part Two Answer:{}'.format(minimum_distance))
#endegion