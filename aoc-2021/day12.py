#region modules
import re
from collections import defaultdict
#endregion

#region functions

# DFS function created for part #1
def dfs(last, visited, edges):
    if last == 'end':
        return 1
    
    paths = 0
    for edge in edges[last]:
        if not(edge.islower() and edge in visited):
            paths += dfs(edge, visited | {edge}, edges)
    return paths

# DFS function created for part #2
def dfs2(last, visited, edges, repeats):
    if last == 'end':
        return 1
    paths = 0
    for edge in edges[last]:
        if not(edge.islower() and edge in visited):
            paths += dfs2(edge, visited | {edge}, edges, repeats)
        elif edge.islower() and edge in visited and repeats:
            paths += dfs2(edge, visited, edges, False)
    return paths


#endregion

#region main
with open('inputs/day12.txt', 'r') as file:
    graph = re.findall(r'(.*)-(.*)\n', file.read())

# print(graph)
edges = defaultdict(list)
for v1, v2 in graph:
    if v2 != 'start':
        edges[v1].append(v2)
    if v1 != 'start':
        edges[v2].append(v1)

visited = set()
result = dfs('start', visited, edges)
print('Part #1 Answer: {}'.format(result))
result = dfs2('start', visited, edges, True)
print('Part #2 Answer: {}'.format(result))
#endregion