import sys
from parse import parse
from shapely import LineString, MultiPolygon, Polygon, box, unary_union

TESTING = False
#region function
def countInvalid(y_row, sensors, beacons):
    sensor_shape = unary_union(sensors)
    row = LineString([(sensor_shape.bounds[0], y_row), (sensor_shape.bounds[2], y_row)])
    beacons_count = len([beacon for beacon in beacons if beacon[1] == y_row])
    result = row.intersection(sensor_shape).length + 1 - beacons_count
    return int(result)

def findDistressBeacon(sensors, distress_beacon_bounds):
    sensor_shape = unary_union(sensors)
    search_zone = box(*distress_beacon_bounds)
    accepted_zone = search_zone.difference(search_zone.intersection(sensor_shape))

    if isinstance(accepted_zone, MultiPolygon):
        result = accepted_zone.geoms[0].centroid
        return result
    else:
        result = accepted_zone.centroid
        return result
    

def findTuningFrequency(distress_beacon_loc):
    x_int = int(distress_beacon_loc.x)
    y_int = int(distress_beacon_loc.y)
    multiplier = 4000000
    result = x_int * multiplier + y_int
    return result

#endregion

#region parameters
sensors = []
beacons = set()
MIN_XY = 0
MAX_XY = 4000000
#endregion

#region script
with open('test.txt' if TESTING else 'input.txt') as f:
    for line in f.read().splitlines():
        x_sensor, y_sensor, x_beacon, y_beacon = parse('Sensor at x={:d}, y={:d}: closest beacon is at x={:d}, y={:d}', line).fixed
        distance = abs(x_sensor - x_beacon) + abs(y_sensor - y_beacon)
        beacons.add((x_beacon, y_beacon))
        sensors.append(Polygon([(x_sensor - distance, y_sensor),(x_sensor, y_sensor - distance),(x_sensor + distance, y_sensor),(x_sensor, y_sensor + distance),]))

invalid_in_row = countInvalid(10 if TESTING else 2000000, sensors, beacons)
distress_beacon_location = findDistressBeacon(sensors, (MIN_XY,MIN_XY, 20 if TESTING else MAX_XY, 20 if TESTING else MAX_XY))
tuning_frequency = findTuningFrequency(distress_beacon_location)
print('Part One Answer: {}'.format(invalid_in_row))
print('Part Two Answer: {}'.format(tuning_frequency))
#endregion