file = open('./input/day2.txt', 'r')
lines = file.read().splitlines()

class Direction:
    def __init__(self, forward, depth):
        self.forward = forward
        self.depth = depth
    
    def CurrentPosition(self):
        print('Submarine current position are {} units horizontal and {} units depth'.format(self.forward,self.depth))
    
    def Answer(self):
        return self.forward * self.depth

# Initialize submarine position
submarine_pos = Direction(0,0)

for l in lines:
    data = l.split(' ')
    if data[0] == 'forward':
        submarine_pos.forward += int(data[1])
    elif data[0] == 'up':
        submarine_pos.depth -= int(data[1])
    elif data[0] == 'down':
        submarine_pos.depth += int(data[1])

submarine_pos.CurrentPosition()
print('The result is {} by multiplying your final horizontal position by your final depth'.format(submarine_pos.Answer()))