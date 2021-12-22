#region modules
from copy import deepcopy
from itertools import product
#endregion

#region functions
def get_neighbours(data, row, column):
    for dy, dx in product([-1,0,1], repeat=2):
        row_temp, col_temp = row + dy, column + dx
        if 0 <= row_temp < len(data)and 0 <= col_temp < len(data[0]):
            yield row_temp, col_temp

def flash(data, flashing, row, column):
    flashing[row][column] = True
    for temp_row, temp_col in get_neighbours(data, row, column):
        data[temp_row][temp_col] += 1
        if not flashing[temp_row][temp_col] and data[temp_row][temp_col] > 9:
            flash(data, flashing, temp_row, temp_col)

def updateBoard(data):
    new_board = [[0] * len(data[0]) for _ in range(len(data))]     # create a new board that will contains updated values
    flashing = [[False] * len(data[0]) for _ in range(len(data))]    # create a board with all values set to False for the flashes
    for row, column in product(range(len(data)), range(len(data[0]))):
        new_board[row][column] += data[row][column] + 1
        if new_board[row][column] > 9:
            flash(new_board, flashing, row, column)
    
    return [[0 if val > 9 else val for val in row] for row in new_board]
#endregion

#region main
with open('inputs/day11.txt', 'r') as file:
    data = [[int(value) for value in line.strip()] for line in file]

board = deepcopy(data)
total_flashes = 0
steps = 100
for _ in range(steps):
    board = updateBoard(board)
    total_flashes += sum(val == 0 for row in board for val in row)

print('Part #1 Answer: {}'.format(total_flashes))
#endregion