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
submarine_pos = Direction(0,0,0)
for line in lines:
    data = line.split(' ')
    if data[0] == 'forward':
        submarine_pos.MoveForward(int(data[1]))
    elif data[0] == 'up':
        submarine_pos.SetAim(-abs(int(data[1])))
    elif data[0] == 'down':
        submarine_pos.SetAim(int(data[1]))

submarine_pos.CurrentPosition()
print('Multiplying forward position and current depth, we get {}'.format(submarine_pos.Answer()))