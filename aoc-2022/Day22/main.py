import sys
import re

#region parameters
TESTING = False
DIRECTION = [(0, 1), (1, 0), (0, -1), (-1, 0)]
#endregion

#region functions

#endregion

#region main

# Open both files using with statement
with open('test.txt', 'r') as test_file, open('input.txt', 'r') as input_file:
    data = input_file.readlines() if not TESTING else test_file.readlines()

# Extract data using list comprehension
data_lines = [line.strip('\n') for line in data]

data_rows = 2 + next(i for i in range(len(data_lines)) if not data_lines[i])
data_cols = 2 + max(len(data_lines[i]) for i in range(data_rows - 2))

graph = [[' '] * data_cols for _ in range(data_rows)]
for i in range(data_rows - 2):
    graph[i+1][1:data_cols] = list(f"{data_lines[i]: <{data_cols-1}}")
directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]

rows = []
for r in range(data_rows):
    start = next((c for c in range(data_cols) if graph[r][c] != ' '), None)
    end = next((c for c in range(data_cols-1,-1,-1) if graph[r][c] != ' '), None)
    rows.append((start, end))

cols = []
for c in range(data_cols):
    start = next((r for r in range(data_rows) if graph[r][c] != ' '), None)
    end = next((r for r in range(data_rows-1, -1, -1) if graph[r][c] != ' '), None)
    cols.append((start, end))
path = [s if s.isalpha() else int(s) for s in re.findall("(\d+|R|L)", data_lines[-1])]

def move(pos, dr):
    r, c = tuple(sum(x) for x in zip(pos, directions[dr]))
    if graph[r][c] == ' ':
        if dr % 2: r = cols[c][0 if dr == 1 else 1]
        else: c = rows[r][0 if dr == 0 else 1]
    return (r, c) if graph[r][c] == '.' else False

curr, dir = (1, next(c for c in range(data_cols) if graph[1][c] == '.')), 0
for p in path:
    if isinstance(p, str): dir = (dir + (1 if p == 'R' else -1)) % len(directions)
    else:
        for _ in range(p):
            step = move(curr, dir)
            if not step: break
            curr = step

print(curr[0], curr[1], dir)
print(1000 * curr[0] + 4 * curr[1] + dir)
#endregion 