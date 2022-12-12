import sys
import re
import operator
import copy
from collections import Counter

TESTING = False
#region function
def generateMonkeysInfo(data):
    monkeys = {}
    monkey_id = 0
    for d in data:
        monkey_info = d.splitlines()
        monkey_items = list(map(int, re.findall(r"(\d+)", monkey_info[1])))
        monkey_op = monkey_info[2].split("=")[-1].strip()
        monkey_div = int(re.findall(r"\d+", monkey_info[3])[0])
        monkey_throw_true = int(re.findall(r"\d+", monkey_info[4])[0])
        monkey_throw_false = int(re.findall(r"\d+", monkey_info[5])[0])
        monkey = Monkey(monkey_id, monkey_items, monkey_op, monkey_div, [monkey_throw_true,monkey_throw_false])
        monkeys[monkey_id] = monkey
        monkey_id += 1
    
    return monkeys

def monkeyBusiness(monkeys, rounds, relief=True):
    for _ in range(rounds):
        for monkey in monkeys.values():
            while monkey.starting_items:
                target_monkey = monkeys[monkey.inspectItem(relief)]
                monkey.throwTo(target_monkey)
    
    monkey_inspect = Counter({monkey.id: monkey.inspect_counter for monkey in monkeys.values()})
    common_two = monkey_inspect.most_common(2)
    result = common_two[0][1] * common_two[1][1]
    return result 
#endregion

#region class
class Monkey:
    def __init__(self, id, items, ops, div, throw):
        self.id = id
        self.starting_items = items
        self.operations = ops
        self.divisor = div
        self.throw = throw
        self.inspect_counter = 0

    def addItem(self, item):
        self.starting_items.append(item)

    def inspectItem(self, relief=True, lcm=None):
        self.inspect_counter += 1
        operations = self.operations.replace('old', str(self.starting_items[0]))
        first, the_op, second = re.findall(r"(\w+) (.) (\w+)", operations)[0]
        ops_dict = {
            "+": operator.add,
            "*": operator.mul
        }

        self.starting_items[0] = ops_dict[the_op](int(first), int(second))

        if relief:
            self.starting_items[0] //= 3
                
        return self.throw[0] if self.starting_items[0] % self.divisor == 0 else self.throw[1]
    
    def throwTo(self, target):
        target.addItem(self.starting_items.pop(0))

    def __repr__(self):
        return f"Monkey:(id={self.id}, items={self.starting_items}, " + f"inspect_counter={self.inspect_counter})"


#endregion

#region script
with open('test.txt' if TESTING else 'day11.txt') as f:
    data = f.read().split("\n\n")

monkeys = generateMonkeysInfo(data)
monkey_busines = monkeyBusiness(copy.deepcopy(monkeys), 20)
print('Part One Answer: {}'.format(monkey_busines))
#endregion