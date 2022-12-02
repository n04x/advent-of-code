from os import link
import sys
INT_MIN = -sys.maxsize -1

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
    
#endregion

#region parameters

#endregion

#region main
with open('inputs/day01.txt') as f:
    calories = f.read().split("\n")

maxCal = maxCalories(calories)

print('Part One Answer: {}'.format(maxCal))
#endregion