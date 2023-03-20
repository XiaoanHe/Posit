#include <iostream>
#include <string>
#include <bitset>
#include <fstream>
#include <math.h>

using namespace std;

int main() {
    string bitPatterns[100];
    ifstream inputFile("IN1_k=1.txt");  // Open the input file for reading
    
    // Read the bit patterns from the input file and store them in the array
    for (int i = 0; i < 100; i++) {
        inputFile >> bitPatterns[i];
    }
    
    // Close the input file
    inputFile.close();

    string FP;
    ofstream outfile("IN1_k=1_FP.txt");
    for (int i = 0; i < 100; i++) 
    {
        cout << "Bit pattern " << i+1 << ": " << bitPatterns[i] << endl;
        
        int k  = 16;    //  regime value 
        
        string exp = bitPatterns[i].substr(4, 4);   //  extract the exponent part
        uint32_t E = bitset<32>(exp).to_ulong();    //  convert them into decimal
        cout << "Binary value: " << exp << endl;
        cout << "Decimal value: " << E << endl;
        
        int Exponent = k + E + 127;
        bitset<8> exponent_bits(Exponent);
        cout << "Exponent: " << Exponent << endl;
        cout << "Exponent bits: " << exponent_bits << endl;

        bitset<1>zeros;
        // FP = bitPatterns[i][0] + exponent_bits.to_string() + bitPatterns[i].substr(10,22) +zeros.to_string() ;
        FP = bitPatterns[i][0] + exponent_bits.to_string() + bitPatterns[i].substr(9,23);
        cout << "FP bits        : " << FP << endl;
        outfile << FP << endl;
    }
    outfile.close();
    return 0;
}

