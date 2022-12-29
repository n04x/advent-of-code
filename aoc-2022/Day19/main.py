import sys
import re
from math import prod
#region parameters
TESTING = False
PART2 = True
pattern = "Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."
#endregion

#region functions
def createBlueprints(DATA):
    result = {x[0]: (((x[1], 0, 0, 0), (1, 0, 0, 0)),((x[2], 0, 0, 0), (0, 1, 0, 0)),((x[3], x[4], 0, 0), (0, 0, 1, 0)),((x[5], 0, x[6], 0), (0, 0, 0, 1)),((0, 0, 0, 0), (0, 0, 0, 0))) for x in DATA}
    return result

def getQualityLevel(blueprints):
    quantities = [[[0,0,0,0], [1,0,0,0]]]
    timer = 32 if PART2 else 24
    for t in range(timer):
        temp = []
        for quantity, prod in quantities:
            for robot_cost, harvest in blueprints:
                quan_cost = [x - y for x, y in zip(quantity, robot_cost)]
                if all(x >= 0 for x in quan_cost):
                    prod_inc = [sum(x) for x in zip(prod, harvest)]
                    temp.append([[sum(x) for x in zip(quan_cost, prod)], prod_inc])

        temp.sort(key = lambda x: tuple((b,a) for a,b in zip(*map(reversed, x))), reverse=True)
        quantities = temp[:5000]
    
    return max(quan[3] for quan, prod in quantities)

#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    if PART2:
        data = [tuple(map(int, x)) for x in re.findall(pattern, f.read())][:3]
    else:
        data = [tuple(map(int, x)) for x in re.findall(pattern, f.read())]


blueprints = createBlueprints(data)
if PART2:
    quality_level = prod(getQualityLevel(blueprints[ID]) for ID in blueprints)
else:
    quality_level = sum(ID * getQualityLevel(blueprints[ID]) for ID in blueprints)

if PART2:
    print('Part Two Answer: {}'.format(quality_level))
else:
    print('Part One Answer: {}'.format(quality_level))
#endregion