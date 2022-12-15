import sys
import functools
TESTING = False

#region functions
def createPairs(data):
    result = []
    for line in data:
        if line != '':
            result.append(eval(line))
    
    return result

def compareValues(value1, value2):
    if isinstance(value1, int) and isinstance(value2, int):
        return value2 - value1

    if isinstance(value1, list) and isinstance(value2, int):
        return compareValues(value1, [value2])
    
    if isinstance(value1, int) and isinstance(value2, list):
        return compareValues([value1], value2)
    
    for pair in zip(value1, value2):
        temp = compareValues(*pair)
        if temp != 0:
            return temp

    return len(value2) - len(value1)
    

#endregion


#region script
with open('test.txt' if TESTING else 'input.txt') as f:
    data = f.read().splitlines()

pair_index = 1
sum_pair_indices = 0
pairs = createPairs(data)
for i in range(0, len(pairs), 2):
    if compareValues(pairs[i], pairs[i+1]) > 0:
        sum_pair_indices += pair_index
    pair_index += 1

pairs.append([[2]])
pairs.append([[6]])
pairs.sort(key=functools.cmp_to_key(compareValues), reverse=True)
decoder_key = (pairs.index([[2]]) + 1) * (pairs.index([[6]]) + 1)

print('Part One Answer: {}'.format(sum_pair_indices))
print('Part Two Answer: {}'.format(decoder_key))
#endregion