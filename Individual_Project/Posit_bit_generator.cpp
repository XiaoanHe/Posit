#include <iostream>
#include <fstream>
#include <random>

using namespace std;

int main() 
{
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dis(0, 1);

    ofstream outfile("k=0.txt");

    for (int i = 0; i < 100; i++) {
        // Generate the first n bits as "xxxxxx"
        string bit_pattern = "010";

        // Generate the remaining  bits randomly
        for (int j = 0; j < 29; j++) {
            bit_pattern += to_string(dis(gen));
        }
        outfile << bit_pattern << endl;
    }
    outfile.close();
    return 0;
}