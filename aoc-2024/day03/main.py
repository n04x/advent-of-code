#include <iostream>
#include <fstream>
#include <vector>

int countTrees(const std::vector<std::string>& slope, int right, int down) {
    int row = 0;
    int col = 0;
    int trees = 0;
    int width = slope[0].length();
    
    while (row < slope.size()) {
        if (slope[row][col] == '#') {
            trees++;
        }
        col = (col + right) % width;
        row += down;
    }
    
    return trees;
}

int main() {
    std::ifstream file("input.txt");
    std::vector<std::string> slope;
    std::string line;
    
    while (std::getline(file, line)) {
        slope.push_back(line);
    }
    file.close();
    
    int part1 = countTrees(slope, 3, 1);
    std::cout << "Part One Answer: " << part1 << std::endl;
    
    int part2 = countTrees(slope, 1, 1) * countTrees(slope, 3, 1) * countTrees(slope, 5, 1) * countTrees(slope, 7, 1) * countTrees(slope, 1, 2);
    std::cout << "Part Two Answer: " << part2 << std::endl;
    
    return 0;
}