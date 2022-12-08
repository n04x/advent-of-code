from os import link
import sys

#region functions

#region Part I
def calculateHandShape(opp, you):
    s = 0
    if you == 'X':
        s += 1
    elif you == 'Y':
        s += 2
    elif you == 'Z':
        s += 3
    else:
        s += 0
    return s

def calculateRoundOutcome(opp, you):
    s = 0
    if you == 'X':
        if opp == 'A':
            s += 3
        elif opp == 'B':
            s += 0
        elif opp == 'C':
            s += 6
    elif you == 'Y':
        if opp == 'A':
            s += 6
        elif opp == 'B':
            s += 3
        elif opp == 'C':
            s += 0
    elif you == 'Z':
        if opp == 'A':
            s += 0
        elif opp == 'B':
            s += 6
        elif opp == 'C':
            s += 3
    return s

#endregion 

#region Part II

def calculateScore(opp, you):
    score = 0
    # X means you need to lose
    if you == 'X':
        if opp == 'A':
            score += 3
        elif opp == 'B':
            score += 1
        elif opp == 'C':
            score += 2
        score += 0

    # Y means you need to draw
    if you == 'Y':
        if opp == 'A':
            score += 1
        elif opp == 'B':
            score += 2
        elif opp == 'C':
            score += 3
        score += 3
    
    # Z means you need to win
    if you == 'Z':
        if opp == 'A':
            score += 2
        elif opp == 'B':
            score += 3
        elif opp == 'C':
            score += 1
        score += 6
    
    return score

#endregion
#endregion

#region main
with open('day02.txt') as f:
    outcomes = f.read().splitlines()
    outcomes = [line.split() for line in outcomes]

totalScorePartOne = 0
totalScorePartTwo = 0
for opponent, you in outcomes:
    roundScore = 0
    roundScore += calculateHandShape(opponent, you)
    roundScore += calculateRoundOutcome(opponent, you)
    totalScorePartOne += roundScore

for opponent, you in outcomes:
    totalScorePartTwo += calculateScore(opponent, you)
print('Part One Answer: {}'.format(totalScorePartOne))
print('Part Two Answer: {}'.format(totalScorePartTwo))
#endregion