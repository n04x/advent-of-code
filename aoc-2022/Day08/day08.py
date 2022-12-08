import sys
from unittest import result

TESTING = False

#region functions
def IsTreeVisible(position, value, los):
    result = max(los[:position]) < value or value > max(los[position+1:])
    return result

def calculateVisibleTree(trees):
    result = (len(trees) + len(trees[1:-1])) * 2 # All edges are visible by default so we get perimiter P = (W+H) x 2 for rectangle/square
    for row in range(1, len(trees) - 1):
        for col in range(1, len(trees[0]) -1):
            tree_height = trees[row][col]
            if IsTreeVisible(col, tree_height, trees[row]) or IsTreeVisible(row, tree_height, [t[col] for t in trees]):
                result += 1
    return result

def calculateScenicScore(trees):
    result = 0
    for row in range(1, len(trees) - 1):
        for col in range(1, len(trees[0]) -1):
            tree_height = trees[row][col]
            
            row_scenic_score = GetScenicScore(col, tree_height, trees[row])
            col_scenic_score = GetScenicScore(row, tree_height, [t[col] for t in trees])
            result = max(result, row_scenic_score * col_scenic_score)
            
    return result

def GetScenicScore(position, value, los):
    first, second = list(reversed(los[:position])), los[position+1:]
    count_first = len(first)
    for i in range(len(first)):
        if first[i] >= value:
            count_first = i + 1
            break
    
    count_second = len(second)
    for i in range(len(second)):
        if second[i] >= value:
            count_second = i + 1
            break

    return count_first * count_second
    
    
#endregion

#region parameters
score = 0
scenic_score = 0
trees = []
#endregion

#region script
with open('test.txt' if TESTING else 'day08.txt') as f:
    for line in f.readlines():
        trees.append(list(map(int, list(line.strip()))))

visible_trees = calculateVisibleTree(trees)
scenic_score = calculateScenicScore(trees)
print('Part One Answer: {}'.format(visible_trees))
print('Part Two Answer: {}'.format(scenic_score))

# calculate the number of True element to get the number of tree visible. 

#endregion