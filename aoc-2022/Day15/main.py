from heapq import merge
from sqlite3 import Row
import sys
import re
from collections import defaultdict
from unittest import result

from numpy import sort
from pandas import Interval

TESTING = True
#region functions
def getSensors(data):
    pattern = 'Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)'
    result = [tuple(map(int, x)) for x in re.findall(pattern, data)]
    return result

def partOneIntervals(sensors):
    ROW = 10 if TESTING else 2000000
    intersection = defaultdict(list)
    result = 0
    for sx, sy, bx, by in sensors:
        rem = abs(bx - sx) + abs(by - sy) - abs(sy - ROW)
        if rem >= 0:
            intersection[ROW].append((sx - rem, sx + rem))

    for x1, x2 in getBeaconPosition(intersection[ROW]):
        result += (x2-x1)   

    return result


def getBeaconPosition(sensors):
    index, result = 0, sorted(sensors)
    for sensor in result:
        if result[index][1] >=sensor[0]:
            result[index] = (result[index][0], max(result[index][1], sensor[1]))
        else:
            result[index] = sensor
            index += 1

     
    return result[:index + 1]


#endregion

#region script
with open('test.txt' if TESTING else 'input.txt') as f:
    data = f.read()

sensors = getSensors(data)
ROW = 10 if TESTING else 2000000
intersection = defaultdict(list)

part_one_answer = partOneIntervals(sensors)
print('Part One Answer: {}'.format(part_one_answer))
#endregion