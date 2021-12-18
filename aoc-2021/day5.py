#region modules
import re
#endregion

#region functions
def sign(val):
    return (val > 0) - (val < 0)

def count_overlaps(values, horizontal: bool = False):
    coords_freq = {}
    for(x1, y1), (x2, y2) in values:
        if x1 == x2 or y1 == y2 or horizontal:
            x_inc, y_inc = sign(x2 - x1), sign(y2 - y1)
            while(x1, y1) != (x2 + x_inc, y2 + y_inc):
                coords_freq[(x1,y1)] = coords_freq.get((x1, y1), 0) + 1
                x1 += x_inc
                y1 += y_inc
    return sum(freq > 1 for freq in coords_freq.values())
#endregion

#region main
with open('./inputs/day5.txt') as file:
    lines = [re.findall(r'(\d*),(\d*)', line) for line in file.readlines()]
    lines = [[(int(x), int(y)) for x, y in line] for line in lines]

print('Part 1: There is {} points that two lines overlap'.format(count_overlaps(lines)))
print('Part 2: There is {} points that two lines overlap'.format(count_overlaps(lines, horizontal=True)))
#endregion
