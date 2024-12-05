#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <sstream>

// Define the functions
int getDistance(const std::vector<int>& list1, const std::vector<int>& list2) {
    int result = 0;
    std::vector<int> sorted_list1 = list1;
    std::vector<int> sorted_list2 = list2;
    std::sort(sorted_list1.begin(), sorted_list1.end());
    std::sort(sorted_list2.begin(), sorted_list2.end());

    for (size_t i = 0; i < list1.size(); i++) {
        result += std::abs(sorted_list1[i] - sorted_list2[i]);
    }
    return result;
}

int getSimilarity(const std::vector<int>& list1, const std::vector<int>& list2) {
    int result = 0;
    for (int val : list1) {
        result += val * std::count(list2.begin(), list2.end(), val);
    }
    return result;
}

int main() {
    const bool TESTING = true;
    std::vector<int> left_list;
    std::vector<int> right_list;

    std::ifstream file(TESTING ? "test.txt" : "input.txt");
    std::string line;

    while (std::getline(file, line)) {
        int x, y;
        std::istringstream iss(line);
        iss >> x >> y;
        left_list.push_back(x);
        right_list.push_back(y);
    }
    file.close();

    int total_distance = getDistance(left_list, right_list);
    int similarity_score = getSimilarity(left_list, right_list);
    std::cout << "Part One Answer: " << total_distance << std::endl;
    std::cout << "Part Two Answer: " << similarity_score << std::endl;

    return 0;
}