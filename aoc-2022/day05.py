import sys

#region functions
def processCratesInput(crates):
    stacks = dict()
    for crate in crates:
        index = 1
        for i in range(0, len(crate) - 2, 4):
            if '[' in crate[i:i+3]:
                c = crate[i:i+3]
                if stacks.get(index) is None:
                    stacks[index] = [c]
                else:
                    stacks[index].append(c)
            index += 1

    for key in stacks:
        stacks[key].reverse()
    return stacks

def getAnswer(stacks):
    keys = list(stacks.keys())
    keys.sort()
    result = ''
    for k in keys:
        result += stacks[k].pop().removeprefix('[').removesuffix(']')
    return result

def CrateMover9000(moves):
    for move in moves:
        move = move.split(' ')
        quantity, crate_source, crate_destination = int(move[1]), int(move[3]), int(move[5])
        crates_to_move = [stacks_crates_move_9000[crate_source].pop() for _ in range(quantity)]
        stacks_crates_move_9000[crate_destination] += crates_to_move

    result = getAnswer(stacks_crates_move_9000)
    return result

def CrateMover9001(moves):
    for move in moves:
        move = move.split(' ')
        quantity, crate_source, crate_destination = int(move[1]) , int(move[3]), int(move[5])
        crates_to_move = [stacks_crates_move_9001[crate_source].pop() for _ in range(quantity)]
        crates_to_move.reverse()
        stacks_crates_move_9001[crate_destination] += crates_to_move

    result = getAnswer(stacks_crates_move_9001)
    return result
        
#endregion

#region Paramters
stacks_crates_move_9000 = dict()
stacks_crates_move_9001 = dict()
#endregion

#region Script
with open('inputs/day05.txt') as f:
    crates_input, moves_input = f.read().split('\n\n')
    crates_input = crates_input.splitlines()[:-1]
    moves_input = moves_input.splitlines()

stacks_crates_move_9000 = processCratesInput(crates_input)
stacks_crates_move_9001 = processCratesInput(crates_input)
crate_mover_9000 = CrateMover9000(moves_input)
#print(moves_input)
crate_mover_9001 = CrateMover9001(moves_input)

print('Part One Answer: {}'.format(crate_mover_9000))
print('Part Two Answer: {}'.format(crate_mover_9001))
#endregion