from os import link
import sys
import re
from itertools import zip_longest

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

def processCratesMovement(moves):
    for move in moves:
        move = move.split(' ')
        quantity, crate_source, crate_destination = int(move[1]), int(move[3]), int(move[5])
        crates_to_move = []
        for i in range(quantity):
            crates_to_move.append(stacks_crates[crate_source].pop())
        
        stacks_crates[crate_destination] += crates_to_move

    keys = list(stacks_crates.keys())
    keys.sort()
    result = ''

    for k in keys:
        result += stacks_crates[k].pop().removeprefix('[').removesuffix(']')
    
    return result
#endregion

#region Paramters
stacks_crates = dict()
#endregion

#region Script
with open('inputs/day05.txt') as f:
    crates_input, moves_input = f.read().split('\n\n')
    crates_input = crates_input.splitlines()[:-1]
    moves_input = moves_input.splitlines()

stacks_crates = processCratesInput(crates_input)
result = processCratesMovement(moves_input)

print('Part One Answer: {}'.format(result))
#endregion