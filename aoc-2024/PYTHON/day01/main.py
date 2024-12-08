
#region Parameters 
TESTING = False
left_list = []
right_list = []
#endregion

#region Functions
def getDistance(list1, list2):
    result = 0
    for val1, val2 in zip(sorted(list1), sorted(list2)):
        result += abs(val1 - val2)
    return result

def getSimilarity(list1, list2):
    result = 0
    for val in list1:
        result += val * list2.count(val)
    return result
#endregion

#region Main
with open("test.txt" if  TESTING else 'input.txt') as file:
    lines = file.readlines()


for l in lines:
    x, y = l.split()
    left_list.append(int(x))
    right_list.append(int(y))

total_distance = getDistance(left_list, right_list)
similarity_score = getSimilarity(left_list, right_list)
print("Part One Answer: {}".format(total_distance))
print("Part Two Answer: {}".format(similarity_score))
#endregion