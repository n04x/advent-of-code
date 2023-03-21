import sys
import re

#region parameters
TESTING = False
DIRECTION = [(0, 1), (1, 0), (0, -1), (-1, 0)]
#endregion

#region functions
def createGrid(data):
    global DATA_ROWS
    global DATA_COLS

    new_data_stripped = [l.strip('\n') for l in data]
    line = 1

    # Get the number of rows_tiles and columns from the input file.
    DATA_ROWS = 2 + next(i for i in range(len(new_data_stripped)) if not new_data_stripped[i])
    DATA_COLS = 2 + max(len(new_data_stripped[i]) for i in range(DATA_ROWS - 2))

    # Create a grid
    grid = [[' '] * DATA_COLS]
    for i in range(DATA_ROWS - 2):
        row = [' '] + list(f"{new_data_stripped[i]: <{DATA_COLS-1}}")
        grid.append(row)
    grid.append([' '] * DATA_COLS)
    
    rtiles = []
    for r in range(DATA_ROWS):
        start_col = next((c for c in range(DATA_COLS) if grid[r][c] != ' '), None)
        end_col = next((c for c in range(DATA_COLS-1, -1, -1) if grid[r][c] != ' '), None)
        rtiles.append((start_col, end_col))

    ctiles = []
    for c in range(DATA_COLS):
        start_row = next((r for r in range(DATA_ROWS) if grid[r][c] != ' '), None)
        end_row = next((r for r in range(DATA_ROWS-1, -1, -1) if grid[r][c] != ' '), None)
        ctiles.append((start_row, end_row))

    path = [
        s if s.isalpha() else int(s)
        for s in re.findall("(\d+|R|L)", new_data_stripped[-1])
    ]

    return grid, rtiles, ctiles, path

def movement(pos, dr, G, R, C):
    r, c = tuple(sum(x) for x in zip(pos, DIRECTION[dr])) 
    if G[r][c] == ' ':
        if dr % 2:
            for x in range(len(C[c])):
                if G[C[c][x]][c] == '.':
                    r = C[c][x]
                    break
        else:
            for x in range(len(R[r])):
                if G[r][R[r][x]] == '.':
                    c = R[r][x]
                    break
    return (r, c) if G[r][c] == '.' else False
#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    lines = f.readlines()
    data = [l.strip('\n') for l in lines]

GRID, RTILES, CTILES, PATH = createGrid(data)

for c in range(DATA_COLS):
    if GRID[1][c] == '.':
        curr = (1, c)
        dir = 0
        break

for p in PATH:
    if isinstance(p, str): dir = (dir + (1 if p == 'R' else -1)) % len(DIRECTION)
    else:
        for _ in range(p):
            step = movement(curr, dir, GRID, RTILES, CTILES)
            if not step: break
            curr = step
part1 = 1000 * curr[0] + 4 * curr[1] + dir
print('Part One Answer: {}'.format(part1))
#endregion