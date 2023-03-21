import sys
from collections import deque

#region parameters
TESTING = False
DECRYPT_KEY = 811589153
#endregion

#region functions
def buildQueue(f, decrypt_key=1):
    data = [(i, value * decrypt_key) for i, value in enumerate(map(int, f.readlines()))]
    queue = deque(data)
    element = next(i for i in data if not i[1])
    return data, queue, element

def mixing(data, queue, mix=1):
    for x in range(mix):
        for i in data:
            queue.rotate(len(queue) - queue.index(i) - 1)
            queue.pop()
            queue.rotate(-i[1] % len(queue))
            queue.append(i)

def getGroveCoordinate(idx, queue):
    result = 0
    for i in [1000, 2000, 3000]:
        result += queue[(idx + i) % len(queue)][1]
    
    return result

#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    data_p1, queue_p1, element_p1 = buildQueue(f)

with open('test.txt' if TESTING else 'input.txt') as f:
    data_p2, queue_p2, element_p2 = buildQueue(f, DECRYPT_KEY)

# Part one stuff
mixing(data_p1, queue_p1)
index_p1 = queue_p1.index(element_p1)
grove_coordinate_p1 = getGroveCoordinate(index_p1, queue_p1)

# Part two stuff
mixing(data_p2, queue_p2, 10)
index_p2 = queue_p2.index(element_p2)
grove_coordinate_p2 = getGroveCoordinate(index_p2, queue_p2)

print('Part One Answer: {}'.format(grove_coordinate_p1))
print('Part Two Answer: {}'.format(grove_coordinate_p2))
#endregion