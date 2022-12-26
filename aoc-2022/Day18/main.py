import sys
sys.setrecursionlimit(100000)

#region parameters
TESTING = False
DIRECTIONS = [(-1,0,0), (1,0,0), (0,-1,0), (0,1,0), (0,0,-1), (0,0,1)]
outsides = set()
#endregion

#region functions
def createCubes(data):
    result = []
    for line in data:
        result += [tuple(map(int, line.strip().split(',')))]
    
    return result

def getSurfaceArea(cubes):
    cubes_set = set(cubes)
    result = sum(tuple(a + b for a, b in zip(cube, d)) not in cubes_set for d in DIRECTIONS for cube in cubes)   
    return result

def getExteriorSurfaceArea(cubes):
    cubes_set = set(cubes)

    minimum_3d = (min(cube[0] for cube in cubes) - 4, min(cube[1] for cube in cubes) - 4, min(cube[2] for cube in cubes) - 4)
    maximum_3d = (max(cube[0] for cube in cubes) + 4, max(cube[1] for cube in cubes) + 4, max(cube[2] for cube in cubes) + 4)
    
    floodFill(minimum_3d, minimum_3d, maximum_3d, cubes_set)
    result = sum(tuple(a + b for a, b in zip(cube, d)) in outsides for d in DIRECTIONS for cube in cubes)
    return result

def floodFill(val, minimum, maximum, cubes):
    if any(val[i] < minimum[i] for i in range(3)) or any(val[i] > maximum[i] for i in range(3)): return

    for d in DIRECTIONS:
        q = tuple(a + b for a, b in zip(val, d))
        if q not in outsides and q not in cubes:
            outsides.add(q)
            floodFill(q, minimum, maximum, cubes)


    
#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    data = f.readlines()

cubes = createCubes(data)
surface_area = getSurfaceArea(cubes)
exterior_surface_are = getExteriorSurfaceArea(cubes)
print('Part One Answer: {}'.format(surface_area))
print('Part Two Answer: {}'.format(exterior_surface_are))

#endregion