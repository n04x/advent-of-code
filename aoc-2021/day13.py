#region modules
import re
#endregion

#region functions
def fold(axis, coordinate, dots):
    new_pts = set()
    for x,y in dots:
        if axis == 'x' and x > coordinate:
            new_pts.add((coordinate * 2 - x, y))
        elif axis == 'y'and y > coordinate:
            new_pts.add((x, coordinate * 2 - y))
        else:
            new_pts.add((x,y))
    return new_pts

def print_grid(pts):
    max_x = max(x for x, _ in pts) + 1
    max_y = max(y for _, y in pts) + 1
    for y in range(max_y):
        row = ('#' if (x,y) in pts else ' ' for x in range(max_x))
        print(' '.join(row))
#endregion

#region main
with open('inputs/day13.txt', 'r') as file:
    dots, folds = file.read().split('\n\n')

dots = re.findall(r'(\d+),(\d+)', dots)
dots = {(int(x), int(y)) for x ,y in dots}

folds = re.findall(r'fold along ([xy])=(\d+)', folds)
folds = [(axis, int(coordinate)) for axis, coordinate in folds]

result1 = fold(*folds[0], dots)
print('Part #1 Answer: {}'.format(len(result1)))

for axis, coordinate in folds:
    dots = fold(axis, coordinate, dots)

print('Part #2 Answer:')
print_grid(dots)
#endregion