with open('./input/day3.txt') as file:
    lines = [line.strip() for line in file.readlines()]

def swapToColumn(data):
    results = []
    for row in range(len(data[0])):
        results.append('')
        for col in range(len(data)):
            results[-1] += data[col][row]

    return results

def findGamma(data):
    result = ''
    for col in data:
        if col.count('1') > len(col) / 2:
            result += '1'
        else:
            result += '0'
    return result

# Set datas
data_column = swapToColumn(lines)

# Set empty gamma and epsilion
gamma = epsilion = ''

# Find gamma and epsilion
gamma = findGamma(data_column)
epsilion = ''.join(map(lambda bit: '1' if bit == '0' else '0', gamma))

print('the power consumption of the submarine is {}'.format(int(gamma, 2) * int(epsilion, 2)))