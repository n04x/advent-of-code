#region modules
#endregion

#region functions
def testMap(data):
    for y,r in enumerate(data):
        print('This is the y: {}, with the current row: {}'.format(y,r))
    for x, h in enumerate(r):
        print('this is the x: {} with the current height: {}'.format(x,h))

def createHeightMap(data):
    result = {}
    for y, row in enumerate(data):
        for x, height in enumerate(row):
            result[(x,y)] = int(height)
    return result

def lowPoints(data):
    low_points = []
    result = 0
    for coordinates, height in height_map.items():
        x, y = coordinates
        neighbours = ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1))
        lowest_value = True
        for n in neighbours:
            if height_map.get(n, 10) <= height:
                lowest_value = False
                break
        
        if lowest_value:
            low_points.append(coordinates)
            result += height + 1
    return result
#endregion

#region main
with open('./input/day9.txt', 'r') as file:
    data = [line.strip() for line in file.readlines()]

#testMap(data)
height_map = {}
height_map = createHeightMap(data)

print("Part #1 Answer: {}".format(lowPoints(height_map)))
#endregion