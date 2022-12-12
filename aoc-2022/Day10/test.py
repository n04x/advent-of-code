with open("day10.txt") as f:
    instructions = [l.split(" ") for l in f.read().splitlines()]

cycles = []
X = 1

p1 = 0
p2 = ""

inst = instructions.pop(0)

next_inst = False
cycle_count = 0

while len(instructions) > 0:
    pixel_position = len(cycles)
    if inst[0] == "noop":
        if cycle_count == 1:
            next_inst = True
    elif inst[0] == "addx":
        if cycle_count == 2:
            X += int(inst[1])

            next_inst = True

    p2 += "#" if pixel_position % 40 in (X - 1, X, X + 1) else " "
    print(X - 1, X, X + 1)
    p2 += "\n" if pixel_position % 40 == 39 else ""
    if next_inst:
        inst = instructions.pop(0)

        next_inst = False
        cycle_count = 0

    cycle_count += 1
    cycles.append(X)

for i in range(20, 221, 40):
    p1 += cycles[i - 1] * i

print(p1)
print(p2)