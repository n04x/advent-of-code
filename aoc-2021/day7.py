#region modules
#endregion

#region functions
def calculateDistance(positions, part1: bool = True):
    fuel_cost = [0] * len(positions)
    for i in range(len(positions)):
        for position in positions:
            move = abs(i - position)
            if part1:
                fuel_cost[i] += move
            else:
                fuel_cost[i] += move * (move + 1) // 2   
    return fuel_cost

#endregion

#region main
with open('./inputs/day7.txt') as file:
    crabs = [int(x) for x in file.read().split(',')]
print('Part #1 Answer: {}'.format(min(calculateDistance(crabs))))
print('Part #2 Answer: {}'.format(min(calculateDistance(crabs, False))))
#endregion