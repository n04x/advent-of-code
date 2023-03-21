import sys
import re
import operator

#region parameters
TESTING = False
VALUES = {}
OPERATOR_MAPPING = {'+': operator.add, '*': operator.mul, '-': operator.sub, '/': operator.floordiv}
value_pattern = re.compile(r"([a-z]{4}): (\d+)")
calc_pattern = re.compile(r"([a-z]{4}): ([a-z]{4}) (.){1,2} ([a-z]{4})")
#endregion

#region functions
def createMonkeys(data):
    monkeys_value = {} #monkey: value
    row_to_skip = []
    for row, line in enumerate(data):
        if match := value_pattern.match(line):
            monkeys_value[match.groups()[0]] = int(match.groups()[1])
            row_to_skip.append(row)
    
    calcs = [line for row, line in enumerate(data) if row not in row_to_skip]
    monkeys_calcs = {}
        
    for line in calcs:
        monkey_name, monkey1, op, monkey2 = calc_pattern.findall(line)[0]
        monkeys_calcs[monkey_name] = (monkey1, op, monkey2)

    return monkeys_value, monkeys_calcs
    
def evaluateHumanAnswer(data, monkeys_calcs):
    monkeys_value = {}
    for row, line in enumerate(data):
        if match := value_pattern.match(line):
            monkeys_value[match.groups()[0]] = int(match.groups()[1])
    
    monkeys_calcs['root'] = (monkeys_calcs['root'][0], '-', monkeys_calcs['root'][2])
    human_answer = binarySearch(0, 0, 1e16, testCandidateValue, monkeys_calcs, monkeys_value)
    if human_answer is None:
        human_answer = binarySearch(0, 0, 1e16, testCandidateValue, monkeys_calcs, monkeys_value, reverse_search=True)

    return human_answer

def binarySearch(target, low, high, func, *func_args, reverse_search=False):
    res = None
    candidate = 0

    while low < high:
        candidate = int((low + high) // 2)
        res = func(candidate, *func_args)
        if res == target:
            return candidate
        
        comp = operator.gt if not reverse_search else operator.lt
        if comp(res, target):
            low = candidate
        else:
            high = candidate

def testCandidateValue(candidate, calcs, monkeys):
    monkeys_try = monkeys.copy()
    monkeys_try['humn'] = candidate
    res = evaluateMonkeys("root", calcs, monkeys_try)
    return res


def evaluateMonkeys(monkey_name: str, monkeys_calcs, monkeys_value):
    current_calcs = monkeys_calcs[monkey_name]
    monkey1, monkey2 = current_calcs[0], current_calcs[2]
    op = current_calcs[1]

    if monkey1 not in monkeys_value:
        evaluateMonkeys(monkey1, monkeys_calcs, monkeys_value)
    if monkey2 not in monkeys_value:
        evaluateMonkeys(monkey2, monkeys_calcs, monkeys_value)

    monkeys_value[monkey_name] = OPERATOR_MAPPING[op](monkeys_value[monkey1], monkeys_value[monkey2])

    return monkeys_value[monkey_name]

#endregion

#region main
with open('test.txt' if TESTING else 'input.txt') as f:
    data = f.read().splitlines()

monkeys_value, monkeys_calcs = createMonkeys(data)
evaluateMonkeys('root', monkeys_calcs, monkeys_value)
humn = evaluateHumanAnswer(data, monkeys_calcs)
print('Part One Answer: {}'.format(monkeys_value['root']))
print('Part Two Answer: {}'.format(humn))
#endregion