#region modules
#endregion

#region functions
def findMismatches(data):
    brackets_dict = {'(':')', '[':']','{':'}','<':'>'}
    chunk_stack = []

    for index, char in enumerate(data):
        if char in brackets_dict:
            chunk_stack.append(char)
        if char in brackets_dict.values():
            if brackets_dict[data[chunk_stack.pop()]] != char:
                return [char]
    
    return [brackets_dict[data[index]] for index in reversed(chunk_stack)]

#endregion

#region main
with open('inputs/test.txt', 'r') as file:
    data = file.readlines()

for row in data:
    mismatches = findMismatches(data)
syntax_error_weights = {')': 3, ']': 57, '}':1197, '>': 25137}
syntax_error_score = 0
findMismatches(data)
#endregion