from os import link
import sys

#region functions
def maxCalories(cal):
    result = 0
    tempSum = 0
    for c in cal:
        if c == "":
            tempSum = 0
        else:
            tempSum += int(c)
        
        result = max(result, tempSum)
    return result

def topThree(cal):
    sums = []
    tempSum = 0
    for c in cal:
        if c == "":
            sums.append(tempSum)
            tempSum = 0
        else:
            tempSum += int(c)
    
    sums.append(tempSum)
    sums.sort()
    return sums[-1], sums[-2], sums[-3]

#endregion

#region main
with open('inputs/day01.txt') as f:
    calories = f.read().splitlines()

topThreeArray = []
maxCal = maxCalories(calories)
topThreeArray = topThree(calories)

print('Part One Answer: {}'.format(maxCal))
print('The top three array are {}'.format(topThreeArray))
print('Part Two Answer: {}'.format(sum(topThreeArray)))
#endregion