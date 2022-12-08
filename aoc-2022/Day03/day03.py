from os import link
from string import ascii_letters
import sys

#region functions
def getCompartments(r):
    size = len(r) // 2
    result = r[:size], r[size:]
    return result

def getPriorityValue(value):
    result = ascii_letters.index(value) + 1
    return result

def grouping(rs):
    result = [rs[i: i+3] for i in range(0, len(rs), 3)]
    return result

def getBadges(group):
    result = set(group[0]).intersection(set(group[1])).intersection(group[2])
    return result
#endregion

#region parameters
priorities_part_one = 0
priorities_part_two = 0
#endregion

#region script
with open('day03.txt') as f:
    rumsacks = f.read().splitlines()

for rumsack in rumsacks:
    c1, c2 = getCompartments(rumsack)
    error = set(c1).intersection(set(c2))
    priorities_part_one += getPriorityValue(error.pop())

groups = grouping(rumsacks)
for g in groups:
    badge = getBadges(g)
    priorities_part_two += getPriorityValue(badge.pop())
print('Part One Answer: {}'.format(priorities_part_one))
print('Part Two Answer: {}'.format(priorities_part_two))
#endregion