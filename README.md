# advent-of-code

## Introduction
Advent of Code is an Advent calendar of small programming puzzles for a variety of skill sets and skill levels that can be solved in any programming language you like. I chose **Python** version 3 as my weapon of choice.

## Advent of Code 2021
Below are my direct link to python code for 2021

## Notes for each Days

### Day 8

Th ecode can be found [here](aoc-2021/day8.py)

For the eighth day, we need to split the data in two, inputs and outputs. The delimiter is the `|`. For the part one, we only wanted to find number of letter in the pattern that return a digit number that appear on the digital clock of the submarines:
- 7 is the only digit that uses 3 segments in the example, so `if len(segments) == 3 then 7`
- 4 is the only digit that uses 4 segments in the example, so `if len(segments) == 4 then 4`
- 1 is the only digit that uses 2 segments in the example, so `if len(segments) == 2 then 1`
- 8 is the only digit that uses 7 segments in the example, so `if len(segments) == 7 then 8`

so simply put, the uniques length that gives us a number are 3,4,2,7 then we add all the number of occurences of each uniques values. Basically: sum(uniques[3,4,2,7]).

For the second part, I decided to use an array to hold all possible digit from the digital clock which are 0-9. So basically each position in the array correspond to the digital number (arr[0]=0, arr[1]=1 and so on...) and then we loop through each patterns and stores in its matching position of the array `digits`. Then we loop through each output pattern to see if we have a match and if so, we store it as a string called values. It should end up with 4 values that looks like this: ####. Then we add each number of the values to get the sums of all output

### Day 9
For the ninth day, I had to rework the code more than once when I reached part 2, especially that in my first iteration, I had nested for while and for loop which can take a considerable amount of time and CPU to perform this task. In the light of this assumption, the time complexity for this problem could increase drastically and cause potential failure if the data feed is getting too big. After few research, I found out that the **part 2** basin way to work is similar to BFS algorithm. The algorithm works that way:

1. Pick any node, visit the adjacent unvisited vertex, mark it as visited, display it, and insert it in a queue.
2. If there are no remaining adjacent vertices left, remove the first vertex from the queue.
3. Repeat step 1 and step 2 until the queue is empty or the desired node is found.

With that process in mind, I decided to rewrite the [day 9 code](aoc-2021/day9.py) of Advent of Code entirely in order to optimize the performance. The theory for BFS can be found [here](https://www.educative.io/edpresso/how-to-implement-a-breadth-first-search-in-python)

At first I was using the numpy.prod() function and after quick googling to compare between `math.prod()` vs `numpy.prod()`, it seems that the `math.prod()` option is better, faster and easier to use since it's part of Python default librairies.

### Day 10
For the tenth day, we need to seperate the data by chunk. Here are the acceptable chunk `()[]{}<>` and each chunk could contains inner smaller chunk. So basically it would be something like that
```
for char in data {
    if (char contains('([{<')) {
        create new chunk
        push the char in it
    }
    if (car contains(')]}>')) {
        close the chunk
    }
}
```

However, we would also need to check for incomplete and corrupted lines as well. The corrupted line might have the incorrect closing character. And we have a syntax checker table to match the first illegal character:
- `)`: `3` points
- `]`: `57` points
- `}`: `1197` points
- `>`: `25137` points

For the second part, it's really similar but we now calulate the incomplete ones as well. which mean the ones that has a missing closing bracket, they also have their own checker table:
- `)`: `1` point.
- `]`: `2` points.
- `}`: `3` points.
- `>`: `4` points.

### Day 11
*Access the script [here](aoc-2021/day11.py)*

In order to propagate the flash we use recursive function called `flash` that take 3 parameters, the data, the row axis and the column axis. In order to perform every steps, we need to "update" the board in consequence, the function will create a temp board with all `False` value meaning that no flash occure. Once there is a flash, this board position will switch to `True` by performing the `flash` function. Then the `updateBoard` function will return a new updated board that contains the new iteration of value on it.

### Day 12
*Access the script [here](aoc-2021/day12.py)*

This is based on the graph system that is widely teached at school in CS program. I decided to go with depth-first search, commonly referred as DFS search whihc is an algorithm for traversing a tree or graph data structures. The algorithm start at root node named `start` in this exercice. We need some parameters for this algorithm, such as `last` which will stored the last visited node, a parameter called `visited` to stored visited nodes and lastly the `edges` to store the next one to visit.

For part #2, we need to add a revisit cave, basically if we have a capital letter, we can revisit it as many time as we want, a single small letter are visited once.