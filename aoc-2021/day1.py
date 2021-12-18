from os import link
import sys
INT_MIN = -sys.maxsize -1

# region Functions 

# Define the function for max sum
def maxSum(arr, n, k):

    # initialize result
    max_sum = INT_MIN
    count = 0
    # consider all blocks starting with i.
    for i in range(n - k + 1):
        curr_sum = 0
        for j in range(k):
            curr_sum = curr_sum + arr[i + j]

        # update result if required.
        if curr_sum > max_sum and max_sum != INT_MIN:
            count += 1
            max_sum = curr_sum
        else:
            max_sum = curr_sum
        # max_sum = max(curr_sum, max_sum)

    return count
 
# endregion

# region Parameters

file = open('./inputs/day1.txt', 'r')
lines = file.read().splitlines()
increase = 0
current_depth = 0

# convert str to int
ilines = [int(l) for l in lines]
k = 3
n = len(ilines)
# endregion

# Simple for loop for part 1
for depth in ilines:
    if depth > current_depth and current_depth != 0:
        increase += 1
        current_depth = depth
    elif current_depth == 0:
        current_depth = depth
    else:
        current_depth = depth
print('The number of time the depths increased are {}'.format(increase))

# Function used for part 2
print(maxSum(ilines, n, k))
