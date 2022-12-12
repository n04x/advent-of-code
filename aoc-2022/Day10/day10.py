import sys

TESTING = False

#region functions
def calculateCycles(data):
    cycle_count = 0
    X = 1
    next_instruction = False
    result = []
    instruction = data.pop(0)
    while len(data) > 0:
        if instruction[0] == 'noop' and cycle_count == 1:
            next_instruction = True
        elif instruction[0] == 'addx' and cycle_count == 2:
            X += int(instruction[1])
            next_instruction = True
        
        if next_instruction:
            instruction = data.pop(0)
            next_instruction = False
            cycle_count = 0
        
        cycle_count += 1
        result.append(X)
    return result

def calculateSignalStrength(cycles, incr):
    result = 0
    for i in range(20, len(cycles), incr):
        result += cycles[i - 1] * i
    
    return result

def displayCRT(cycles):
    result = ""
    for pixel_index in range(len(cycles)):
        result += "#" if pixel_index % 40 in (cycles[pixel_index] -1, cycles[pixel_index], cycles[pixel_index] + 1) else " "
        result += "\n" if pixel_index % 40 == 39 else ""
    
    return result
#endregion

#region parameters
cycles = []
#endregion

#region script
with open('test.txt' if TESTING else 'day10.txt') as f:
    data = [line.split(" ") for line in f.read().splitlines()]

cycles = calculateCycles(data)
signal_strength = calculateSignalStrength(cycles, 40)
crt_display= displayCRT(cycles)
print('Part One Answer: {}'.format(signal_strength))
print('Part Two Answer: \n{}'.format(crt_display))
#endregion