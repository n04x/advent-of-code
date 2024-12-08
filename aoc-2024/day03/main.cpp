#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <sstream>

using namespace std;

// Function to extract and sum all the multiplications (Part 1)
long long extract_multiplications(const string& memory) {
    // Regex pattern for mul(a, b) format
    regex mulPattern(R"(mul\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\))");
    smatch matches;
    long long total = 0;

    // Iterating over the memory to find all matches
    string::const_iterator searchStart(memory.cbegin());
    while (regex_search(searchStart, memory.cend(), matches, mulPattern)) {
        // Extract and sum the multiplication
        int x = stoi(matches[1].str());
        int y = stoi(matches[2].str());
        total += static_cast<long long>(x) * y;
        searchStart = matches.suffix().first; // Move past the current match
    }

    return total;
}

// Function to handle the do() and don't() logic with multiplications (Part 2)
long long extract_do_dont_mul(const string& memory) {
    // Define regex patterns
    regex mulPattern(R"(mul\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\))");
    regex doPattern(R"(do\(\))");
    regex dontPattern(R"(don't\(\))");

    bool multiply = true;  // Initially, mul() is enabled
    long long total = 0;
    size_t pos = 0;

    while (pos < memory.length()) {
        // Check for do()
        smatch doMatch;
        if (regex_search(memory.begin() + pos, memory.end(), doMatch, doPattern)) {
            multiply = true;
            pos += doMatch.position() + doMatch.length(); // Move past the match
            continue;
        }

        // Check for don't()
        smatch dontMatch;
        if (regex_search(memory.begin() + pos, memory.end(), dontMatch, dontPattern)) {
            multiply = false;
            pos += dontMatch.position() + dontMatch.length(); // Move past the match
            continue;
        }

        // Check for mul(X, Y)
        smatch mulMatch;
        if (regex_search(memory.begin() + pos, memory.end(), mulMatch, mulPattern)) {
            if (multiply) {
                int x = stoi(mulMatch[1].str());
                int y = stoi(mulMatch[2].str());
                total += static_cast<long long>(x) * y;
            }
            pos += mulMatch.position() + mulMatch.length(); // Move past the match
            continue;
        }

        // No match, move to the next character
        pos++;
    }

    return total;
}

int main() {
    // Open the file and read its contents
    ifstream file("test.txt");
    if (!file.is_open()) {
        cerr << "Error opening file!" << endl;
        return 1;
    }

    stringstream buffer;
    buffer << file.rdbuf();
    string memory = buffer.str();

    // Part 1: Sum of all multiplications
    cout << "Part 1, sum of multiplications is: " << extract_multiplications(memory) << endl;

    // Part 2: Sum of multiplications with do() and don't() logic
    cout << "Part 2, sum of multiplications is: " << extract_do_dont_mul(memory) << endl;

    return 0;
}
