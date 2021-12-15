#region modules
import re
#endregion

#region functions
def markBingoCards(cards, number):
    for c in cards:
        for i, row in enumerate(c):
            c[i] = [x if x != number else None for x in row]   
    return cards

def checkWinningCondition(cards):
    winning_numbers = []
    # check if we a winning row
    for value, c in enumerate(cards):
        winner = False
        for row in c:
            if len(set(row)) == 1:
                winning_numbers.append(value)
                winner = True
                break

        if winner:
            continue

        for i in range(len(c[0])):
            column = []
            for row in c:
                column.append(row[i])

            if len(set(column)) == 1:
                winning_numbers.append(value)
                break
    
    return winning_numbers

#endregion

#region main
with open('./input/day4.txt') as file:
    bingo_cards_file = file.read().strip().split('\n\n')

drawn_numbers = [int(x) for x in bingo_cards_file[0].split(',')]

bingo_cards = []
for card in bingo_cards_file[1:]:
    bingo_cards.append([])
    for row in card.split('\n'):
        bingo_cards[-1].append([int(x) for x in re.findall(r'\d\d?',row)])

completed_bingo_cards = []

for n in drawn_numbers:
    bingo_cards = markBingoCards(bingo_cards, n)

    winners_numbers = checkWinningCondition(bingo_cards)
    if winners_numbers:
        for i in reversed(winners_numbers):
            completed_bingo_cards.append((bingo_cards[i], n))
            del bingo_cards[i]

        if len(bingo_cards) == 0:
            break

winning_bingo_card, last_drawn_number = completed_bingo_cards[0]
winning_bingo_card_sum = sum([sum([x for x in row if x != None]) for row in winning_bingo_card])

losing_bingo_card, losing_drawn_number = completed_bingo_cards[-1]
losing_bingo_card_sum = sum([sum([x for x in row if x != None]) for row in losing_bingo_card])

print('Answer for Part #1 of the challenge: {}'.format(winning_bingo_card_sum * last_drawn_number))
print('Answer for Part #2 of the challenge: {}'.format(losing_bingo_card_sum * losing_drawn_number))
#endregion