#region modules
import re
from collections import Counter, defaultdict
#endregion

#region Functions
def execute(n, template, rules):
    chars = defaultdict(int, Counter(template))
    template = Counter(zip(template, template[1:]))

    for _ in range(n):
        temp = defaultdict(int)
        for pair, count in template.items():
            chars[rules[pair]] += count
            temp[pair[0], rules[pair]] += count
            temp[rules[pair], pair[1]] += count
        template = temp
    return max(chars.values()) - min(chars.values())
#endregion

#region main
with open('inputs/day14.txt') as f:
    template, rules = f.read().split('\n\n')

rules = re.findall(r'(\w+) -> (\w+)', rules)
rules = {tuple(pair): value for pair, value in rules}

answer1 = execute(10, template, rules)
answer2 = execute(40, template, rules)
print('Part #1 Answer: {}'.format(answer1))
print('Part #2 Answer: {}'.format(answer2))
#endregion