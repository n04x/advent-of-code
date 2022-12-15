from collections import defaultdict, deque


def bfs(graph, start, end):
    queue = deque([(0, start)])

    explored = set()
    explored.add(start)

    while len(queue) > 0:
        dist, current = queue.popleft()

        if current == end:
            return dist

        for neighbor in graph[current]:
            if neighbor not in explored:
                explored.add(neighbor)
                queue.append((dist + 1, neighbor))

    return float("infinity")


def get_elevation(letter):
    return ord("a") if letter == "S" else ord("z") if letter == "E" else ord(letter)


graph = defaultdict(list)

S = (0, 0)
E = (0, 0)

a_elevations = set()


with open("test.txt") as f:
    grid = {}

    for r, l in enumerate(f.readlines()):
        for c, letter in enumerate(l.strip()):
            grid[(r, c)] = letter

    ROWS = max(grid, key=lambda x: x[0])[0]
    COLS = max(grid, key=lambda x: x[1])[1]

    for r in range(ROWS + 1):
        for c in range(COLS + 1):
            coord = (r, c)

            if grid[coord] in ("S", "a"):
                a_elevations.add(coord)

            if grid[coord] == "S":
                S = coord
            elif grid[coord] == "E":
                E = coord

            for nr, nc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                if r + nr >= 0 and c + nc >= 0 and r + nr <= ROWS and c + nc <= COLS:
                    neighbor = (r + nr, c + nc)

                    elevation_current = get_elevation(grid[coord])
                    elevation_neighbor = get_elevation(grid[neighbor])

                    if (
                        elevation_neighbor <= elevation_current
                        or elevation_neighbor == elevation_current + 1
                    ):
                        graph[coord].append(neighbor)


p1 = bfs(graph, S, E)
print(p1)

p2 = float("infinity")

for a in a_elevations:
    min_dis = bfs(graph, a, E)

    if min_dis < p2:
        p2 = min_dis

print(p2)
