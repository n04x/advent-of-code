# Day 07
## Problem Breakdown
### Initial Setup:

There is a disk map (my inpuit) that uses a dense format to represent the layout of **files** and **free space** on the disk.

So for example a disk map of `[1][2][3][4][5]` will have the following structure:
```
[1] [3] [5] == Block file
[2] [4] == Free space
```
Each file on disk has an **ID number** starting with 0 so it the `123455` example would looks like this:
```
[1] which is a file block that start with ID 0 --> 0
[2] which is a free space which translate to this --> 0..
[3] which is a file block which translate to this --> 0..111
[4] which is a free space which translate to this --> 0..111....
[5] which is a file block which translate to this --> 0..111....22222
```
Then move file block one at a time from the end of the dist to the leftmost free space block until there's no gap. For `12345` it would looks like this:
```
0..111....22222
02.111....2222
022111....222
0221112...22
02211122..2
022111222
```
Then finally update the filesystem checksum to calculate the checksum. which is multiplying the position by the value at that position.