# advent-of-code

## Introduction
Advent of Code is an Advent calendar of small programming puzzles for a variety of skill sets and skill levels that can be solved in any programming language you like. I chose **Python** version 3 as my weapon of choice.

## Advent of Code 2021
Below are my direct link to python code for 2021

## Notes for each Days

### Day 9
For the ninth day, I had to rework the code more than once when I reached part 2, especially that in my first iteration, I had nested for while and for loop which can take a considerable amount of time and CPU to perform this task. In the light of this assumption, the time complexity for this problem could increase drastically and cause potential failure if the data feed is getting too big. After few research, I found out that the **part 2** basin way to work is similar to BFS algorithm. The algorithm works that way:

1. Pick any node, visit the adjacent unvisited vertex, mark it as visited, display it, and insert it in a queue.
2. If there are no remaining adjacent vertices left, remove the first vertex from the queue.
3. Repeat step 1 and step 2 until the queue is empty or the desired node is found.

With that process in mind, I decided to rewrite the [day 9 code](day9.py) of Advent of Code entirely in order to optimize the performance. The theory for BFS can be found [here](https://www.educative.io/edpresso/how-to-implement-a-breadth-first-search-in-python)
