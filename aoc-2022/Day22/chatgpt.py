import re
TESTING = False
def wrapAround(board, row, col):
    num_rows, num_cols = len(board), len(board[0])
    return (row % num_rows, col % num_cols)

def solve(lines):
    board = [list(line) for line in lines[:-1]]
    instructions = lines[:-1]

    row, col = 0, 0
    while board[row][col] == '#':
        c += 1

    d = 0   # Start by facing right

    for m in re.findall('(\d+|[LR])', instructions):
        if m.isnumeric():
            for _ in range(int(m)):
                dr, dc = [(0,1), (1,0), (0,-1), (-1,0)][d]
                new_row, new_col = row + dr, col + dc
                if board[new_row][new_col] == '#':
                    break # Just hit a wall, stop moving
                row, col = wrapAround(board, new_row, new_col)
        elif m == 'L':
            d = (d + 3) % 4 # Turn counterclockwise
        elif m == 'R':
            d = (d + 1) % 4 # Turn clockwise

    # compute the password
    return 1000 * (row + 1) + 4 * (col + 1) + d

with open('test.txt' if TESTING else 'input.txt') as f:
    data = f.strip().split('\n')

solve(data)

