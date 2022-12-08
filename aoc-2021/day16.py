import sys
TESTING = True

#region functions
#endregion

#region script
with open('inputs/test.txt' if TESTING else 'inputs/day15.txt') as f:
    data = f.read()

init = ''
for i in data:
    init += bin(int(i,16))[2:].zfill(4)
    print(init)
#endregion