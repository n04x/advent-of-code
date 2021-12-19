#region modules
from bisect import insort
#endregion

#region functions
def findMismatches(data):
    brackets_dict = {'(': ')', '[': ']', '<': '>', '{': '}'}
    chunk_stack = []

    for index, char in enumerate(data):
        if char in brackets_dict:
            chunk_stack.append(index)
        if char in brackets_dict.values():
            if brackets_dict[data[chunk_stack.pop()]] != char:
                return [char]
    return [brackets_dict[data[index]] for index in reversed(chunk_stack)]

#endregion

#region main
with open('inputs/day10.txt', 'r') as file:
    data = file.readlines()

syntax_error_weights = {')':3, ']':57, '}':1197, '>':25137}
closing_weights = {')':1, ']':2, '}':3, '>':4}
syntax_error_score = 0
missing_bracket_score = []

for row in data:
    mismatches = findMismatches(row)
    # print(mismatches)
    if len(mismatches) == 1:
        syntax_error_score += syntax_error_weights[mismatches[0]]
    else:
        partial_bracket = 0
        for bracket in mismatches:
            partial_bracket = partial_bracket * 5 + closing_weights[bracket]
        
        insort(missing_bracket_score, partial_bracket)

print('Part #1 Answer: {}'.format(syntax_error_score))
print('Part #2 Answer: {}'.format(missing_bracket_score[len(missing_bracket_score) // 2]))
#endregion