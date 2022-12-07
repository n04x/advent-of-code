import sys
import re

TESTING = True

#region functions
def getDirectorySize(data, stack):
    while stack:
        line = next(data, '$ cd ..')
        if line == '$ cd ..':
            top = stack.pop()
            if stack:
                sizes.append(top)
                stack[-1] += top       
        elif cd_line := re.match(r"\$ cd .+", line):
            stack.append(0)
        elif file_line := re.match(r"(\d+) .+", line):
            stack[-1] += int(file_line.group(1))
    return sizes

def calculateSize(data, size):
    result = 0
    for x in data:
        if x <= size:
            result += x
    
    return result

def deleteDirectory(data, space):
    space_needed = space - (70000000 - data[-1])
    for x in data:
        if x >= space_needed:
            result = x
            break
    return result
#endregion

#region parameter
sizes = []
stack = [0]
TOTAL_SIZE = 100000
SPACE_REQUIRED = 30000000
#endregion

#region script
with open('inputs/test.txt' if TESTING else 'inputs/day07.txt') as f:
    data = f.read().splitlines()
    data = iter(data)

sizes = getDirectorySize(data, stack)
answer_part_one = calculateSize(sizes, TOTAL_SIZE)
answer_part_two = deleteDirectory(sorted(sizes), SPACE_REQUIRED)
print('Part One Answer: {}'.format(answer_part_one))
print('Part Two Answer: {}'.format(answer_part_two))
#endregion