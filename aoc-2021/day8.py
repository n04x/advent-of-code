#region modules
import re
#endregion

#region functions
def partOne(data, uniques):
    out_total = 0
    for d in data:
        out_total += sum(map(lambda x: 1 if len(x) in uniques else 0, d[1]))   
    return out_total

def partTwo(data):

    outputs_sums = 0
    for d in data:
        patterns, outputs, digits = d

        for p in patterns:
            if len(p) == 2:
                digits[1] = p
            if len(p) == 3:
                digits[7] = p
            if len(p) == 4:
                digits[4] = p
            elif len(p) == 7:
                digits[8] = p

        for x in (1,4,7,8):
            patterns.remove(digits[x])
        
        # 6 is a 6 letter pattern that has none of 3 letters pattern found in the 7 and it creates a c-shaped segment
        segments_c = None
        for p in patterns:
            if len(p) == 6:
                diff_to_seven = digits[7].difference(p)
                if diff_to_seven:
                    digits[6] = p
                    patterns.remove(p)
                    segments_c = diff_to_seven.pop()
                    break
        
        # 3 is a 5 letter signal that contains all of 7
        for p in patterns:
            if len(p) == 5 and len(digits[7].intersection(p)) == 3:
                digits[3] = p
                patterns.remove(p)
                break

        # 2 and 5 are 5 letters pattern but different in the 'c' patterns
        for p in patterns:
            if len(p) == 5:
                if segments_c in p:
                    digits[2] = p
                else:
                    digits[5] = p
        patterns.remove(digits[2])
        patterns.remove(digits[5])

        # 9 is a 5 but with a 'c' patterns
        digits[9] = digits[5].copy()
        digits[9].add(segments_c)
        patterns.remove(digits[9])

        # 0 is the last one left in the available patterns list
        digits[0] = patterns.pop()

        values = ''
        for out in outputs:
            for digit, p in digits.items():
                if p == out:
                    values += str(digit)
    
        outputs_sums += int(values)
    
    return outputs_sums
#endregion

#region main
with open('./input/day8.txt', 'r') as file:
    data = []
    for f in file.readlines():
        patterns, outputs = f.split('|')
        patterns = [set(p) for p in patterns.strip().split(' ')]
        outputs = [set(o) for o in outputs.strip().split(' ')]
        data.append((patterns, outputs, {}))

uniques = (2,3,4,7)
print("Part #1 Answer: {}".format(partOne(data, uniques)))
print("Part #2 Answer: {}".format(partTwo(data)))
#endregion