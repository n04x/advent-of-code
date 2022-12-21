import sys
import re
from collections import defaultdict

#region parameters
TESTING = False
PART1_TIMER = 30
PART2_TIMER = 26
pattern = "Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z]+[, [A-Z]+]*)"
DATA = []
inf = 0x3f3f3f3f
distance = defaultdict(lambda: defaultdict(lambda: inf))

vertices = []
paths = []
feasible = []
#endregion

#region functions
def getVertices(data):
    for valve, flowrate, tunnels in DATA:
        distance[valve][valve] = 0
        for tunnel in tunnels:
            distance[valve][tunnel] = 1
        if flowrate > 0:
            vertices.append(valve)
    

def DFS(current, timer, PART2):
    result = 0
    ignore = set(current)
    if PART2:
        paths.append(current)

    for valve in filter(lambda x: x not in ignore, vertices):
        rem = timer - (1 + distance[current[-1]][valve])
        if rem >= 0 and not PART2:
            result = max(result, rem*valves[valve] + DFS((*current, valve), rem, False))
        elif rem >= 0 and PART2:
            DFS((*current, valve), rem, True)

    return result

def getBestFeasiblePaths():
    for path in paths:
        valve, timer, amount = path[0], PART2_TIMER, 0
        for u in path[1::]:
            timer -= 1 + distance[valve][u]
            amount += timer * valves[u]
            valve = u
        feasible.append((amount, set(path[1::])))

    feasible.sort(reverse=True)
    result = 0
    for i in range(len(feasible) - 1):
        if feasible[i][0] + feasible[i + 1][0] < result:
            break
        mx = next((feasible[j][0]for j in range(i + 1, len(paths)) if feasible[i][1].isdisjoint(feasible[j][1])), 0)
        result = max(result, feasible[i][0] + mx)
    
    return result

#endregion

#region script
with open('test.txt' if TESTING else 'input.txt') as f:
    for valve, rate, tunnels in re.findall(pattern, f.read()):
        DATA += [(valve, int(rate), set(map(lambda x: x.strip(), tunnels.split(','))))]


valves = {valve:int(rate) for valve, rate, tunnels in DATA}
getVertices(DATA)

for k in valves:
    for i in valves:
        for j in valves:
            distance[i][j] = min(distance[i][j], distance[i][k] + distance[k][j])

part_one_ans = DFS(('AA',), PART1_TIMER, False)
part_two_ans = DFS(('AA',), PART2_TIMER, True)
part_two_ans = getBestFeasiblePaths()
print('Part One Answer: {}'.format(part_one_ans))
print('Part Two Answer: {}'.format(part_two_ans))
#endregion