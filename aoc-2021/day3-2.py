with open('./input/day3.txt') as file:
    lines = [line.strip() for line in file.readlines()]

def swapToColumn(data):
    results = []
    for row in range(len(data[0])):
        results.append('')
        for col in range(len(data)):
            results[-1] += data[col][row]

    return results

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

# oxygen generator rating
oxygen_data = lines
oxygen_columns = swapToColumn(lines)
oxygen_data = findOxygenRatings(oxygen_data, oxygen_columns)

# CO2 scrubber rating
co2_data = lines
co2_columns = swapToColumn(lines)
co2_data = findCO2Ratings(co2_data, co2_columns)
print('Oxygen Ratings {}'.format(int(oxygen_data[0],2)))
print('CO2 Ratings {}'.format(int(co2_data[0],2)))
print('Current life support rating of the submarine: {}'.format(int(oxygen_data[0],2) * int(co2_data[0],2)))