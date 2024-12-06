#include <iostream>
#include <regex>
#include <vector>
#include <sstream>

int main() {
    std::string line;
    std::regex mul_regex("mul\\((\\d{1,3}),(\\d{1,3})\\)");
    std::regex all_regex("don't\\(\\)|do\\(\\)|mul\\((\\d+),(\\d+)\\)");

    int result1 = 0;
    int result2 = 0;
    bool enabled = true;

    while (std::getline(std::cin, line)) {
        std::vector<std::string> matches;

        std::smatch match;
        if (std::regex_search(line, match, mul_regex)) {
            std::string instr = match.str(0);
            std::istringstream iss(instr.substr(4, instr.length() - 5));
            std::string n1, n2;
            std::getline(iss, n1, ',');
            std::getline(iss, n2, ',');
            result1 += std::stoi(n1) * std::stoi(n2);
        }

        std::sregex_iterator iter(line.begin(), line.end(), all_regex);
        std::sregex_iterator end;
        for (; iter != end; ++iter) {
            std::string instr = (*iter).str();
            if (instr == "don't()") {
                enabled = false;
            }
            else if (instr == "do()") {
                enabled = true;
            }
            else if (enabled) {
                std::istringstream iss(instr.substr(4, instr.length() - 5));
                std::string n1, n2;
                std::getline(iss, n1, ',');
                std::getline(iss, n2, ',');
                result2 += std::stoi(n1) * std::stoi(n2);
            }
        }
    }

    std::cout << "Result 1: " << result1 << std::endl;
    std::cout << "Result 2: " << result2 << std::endl;

    return 0;
}