file = open('./inputs/day2.txt', 'r')
lines = file.read().splitlines()

class Direction:
    def __init__(self, forward, depth, aim):
        self.forward = forward
        self.depth = depth
        self.aim = aim
    
    # Move the sumbarine forward (either deeper or higher)
    def MoveForward(self, forward):
        self.forward += forward
        self.depth += forward * self.aim
    
    # Set the angle of submarine
    def SetAim(self, aim):
        self.aim += aim

    def CurrentPosition(self):
        print('Submarine current position are {} units horizontal, {} units depth.'.format(self.forward,self.depth))

    def Answer(self):
        return self.forward * self.depth


# Initialize submarine position
submarine_pos1 = Direction(0, 0, 0)
submarine_pos2 = Direction(0,0,0)
# Part 1
for l in lines:
    data = l.split(' ')
    if data[0] == 'forward':
        submarine_pos1.forward += int(data[1])
    elif data[0] == 'up':
        submarine_pos1.depth -= int(data[1])
    elif data[0] == 'down':
        submarine_pos1.depth += int(data[1])

# Part 2
for line in lines:
    data = line.split(' ')
    if data[0] == 'forward':
        submarine_pos2.MoveForward(int(data[1]))
    elif data[0] == 'up':
        submarine_pos2.SetAim(-abs(int(data[1])))
    elif data[0] == 'down':
        submarine_pos2.SetAim(int(data[1]))

print('Part #1 Answer: {}'.format(submarine_pos1.Answer()))
print('Part #2 Answer: {}'.format(submarine_pos2.Answer()))