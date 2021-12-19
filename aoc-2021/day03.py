#region modules
#endregion

#region functions
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

def findOxygenRatings(data, columns):
    i = 0
    temp_col = columns
    result = ''   
    while len(data) > 1:
        if temp_col[i].count('1') >= len(temp_col[i]) / 2:
            result += '1'
        else:
            result += '0'
        
        data = list(filter(lambda binary: binary.startswith(result), data))
        temp_col = swapToColumn(data)

        i += 1
    
    return data

def findCO2Ratings(data, columns):
    i = 0
    temp_col = columns
    result = ''   
    while len(data) > 1:
        if temp_col[i].count('1') >= len(temp_col[i]) / 2:
            result += '0'
        else:
            result += '1'
        
        data = list(filter(lambda binary: binary.startswith(result), data))
        temp_col = swapToColumn(data)

        i += 1
    
    return data


#endregion

#region main
with open('./inputs/day3.txt') as file:
    lines = [line.strip() for line in file.readlines()]

# Set datas
data_column = swapToColumn(lines)

# oxygen generator rating
oxygen_data = lines
oxygen_columns = swapToColumn(lines)
oxygen_data = findOxygenRatings(oxygen_data, oxygen_columns)

# CO2 scrubber rating
co2_data = lines
co2_columns = swapToColumn(lines)
co2_data = findCO2Ratings(co2_data, co2_columns)

# Set empty gamma and epsilion
gamma = epsilion = ''

# Find gamma and epsilion
gamma = findGamma(data_column)
epsilion = ''.join(map(lambda bit: '1' if bit == '0' else '0', gamma))
print('Part #1 Answer: {}'.format(int(gamma, 2) * int(epsilion, 2)))
print('Part #2 Answer: {}'.format(int(oxygen_data[0],2) * int(co2_data[0],2)))
#endregion
