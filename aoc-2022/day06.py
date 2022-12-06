import sys
TESTING = False

#region functions
def getMarker(ds, o):
    for i in range(len(ds)):
        if len(set(ds[i:i+o])) == o:
            return i + o
    return 0
#endregion

#region script
with open('inputs/test.txt' if TESTING else 'inputs/day06.txt') as f:
    datastream = f.read()

start_of_packet_marker = getMarker(datastream, 4)
start_of_message_marker = getMarker(datastream, 14)

print('Part One Answer: {}'.format(start_of_packet_marker))
print('Part Two Answer: {}'.format(start_of_message_marker))
#endregion