from os import link
from posixpath import split
import sys

#region functions
def createStartEnd(pairs):
    [start1, end1] = [int(x) for x in pairs[0].split('-')]
    [start2, end2] = [int(x) for x in pairs[1].split('-')]
    starts = start1, start2
    ends = end1, end2 
    return starts, ends


def fullyOverlapPairs(starts, ends):
    if starts[0] >= starts[1] and ends[0] <= ends[1]: 
        return 1
    elif starts[1] >= starts[0] and ends[1] <=ends[0]:
        return 1
    else:
        return 0

def everyOverlapPairs(starts, ends):
    if max(starts[0], starts[1]) <= min(ends[0], ends[1]):
        return 1
    else:
        return 0
#endregion

#region Parameters
fully_overlaps_pairs = 0
every_overlaps_pairs = 0
#endregion

#region script
with open('inputs/day04.txt') as f:
    assignments = f.read().splitlines()

for pair in assignments:
    pair = pair.split(',')
    start_pos, end_pos = createStartEnd(pair)
   
    fully_overlaps_pairs += fullyOverlapPairs(start_pos, end_pos)
    every_overlaps_pairs += everyOverlapPairs(start_pos, end_pos)
print('Part One Answer: {}'.format(fully_overlaps_pairs))
print('Part Two Answer: {}'.format(every_overlaps_pairs))
#endregion