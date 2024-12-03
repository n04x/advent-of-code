#region Parameters
TESTING = False
reports = []
safe_reports = 0
dampened_reports = 0
#endregion

#region Functions
def calculateDifference(data):
    rep_diff = []
    for i in range(len(data) - 1):
        rep_diff.append(data[i+1] - data[i])
    
    if all(diff > 0 and diff < 4 for diff in rep_diff) or all(diff < 0 and diff > -4 for diff in rep_diff):
        return True
    return False

def problemDampener(data):
    for i in range(len(data)):
        if calculateDifference(data[:i] + data[i+1:]):
            return True
    return False
#endregion

#region Main
with open("test.txt" if  TESTING else 'input.txt') as file:
    lines = file.readlines()

for l in lines:
    report = []
    for v in l.split():
        report.append(int(v))
    if calculateDifference(report):
        safe_reports += 1
    elif problemDampener(report):
        dampened_reports += 1
    

print("Part One Answer: {}".format(safe_reports))
print("Dampened reports: {}".format(dampened_reports))
print("Part Two Answer: {}".format(safe_reports + dampened_reports))
#endregion