#region imports
import re
import math
#endregion

#region parameters
TESTING = True
#endregion

#region Functions
def calibrations(data):
    values = []
    for d in data:
        values.append(re.sub(r'[a-zA-Z\n]', "", d))
    print(values)
    return values

def calculateInteger(intList):
    
#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    data = f.read().splitlines()

calibrations(data)
#endregion

