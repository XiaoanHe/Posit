#include <iostream>
#include <cmath>
#include <cfloat>
#include <iomanip>
#include <math.h>

using namespace std;

const char* show_classification(float x) {
    switch(std::fpclassify(x)) {
        case FP_INFINITE:  return "Inf";
        case FP_NAN:       return "NaN";
        case FP_NORMAL:    return "normal";
        case FP_SUBNORMAL: return "subnormal";
        case FP_ZERO:      return "zero";
        default:           return "unknown";
    }
}

int main()
{
    // float In = 3.40282346638_528859811704183484516925440*(1e38); // the realmax
    float pos_max_in = 3.40282346638528859811704183484516925440e38;
    float pos_min_normal_in = 1.1754943508222875079687365372222456778186655567720875215087517062784172594547271728515625e-38;
    float pos_max_subnormal_in = 1.175494210692441075487029444849287348827052428745893333857174530571588870475618904265502351336181163787841796875e-38;
    
    // negative input
    float neg_min_in = -3.40282346638528859811704183484516925440e38;
    float in_1 = 0.1;
    float in_2 = 0.2;

    float in_3 = 4e-23;
    float in_4 = 3e-23;

    float x =  3.2e7;
    float y = -3.2e7;
    float z = 1;

    cout << setprecision(40) << (x+z)+y << '\n';
    cout << setprecision(40) << (x+y)+z << '\n';
    // cout << setprecision(40) <<in_3 * in_4 << " is " << show_classification(in_3 * in_4) << '\n';
    // // +max_real + +max_real = inf
    // cout << (pos_max_in + pos_max_in) << " is " << show_classification(pos_max_in + pos_max_in) << '\n';

    // // neg_min_real + neg_min_real;
    // cout << (neg_min_in + neg_min_in) << " is " << show_classification(neg_min_in + neg_min_in) << '\n';

    // // pos_max_real + pos_max_real
    // cout << (pos_max_in + neg_min_in) << " is " << show_classification(pos_max_in + neg_min_in) << '\n';
    // // cout << (pos_max_subnormal_in) << " is " << show_classification(pos_max_subnormal_in) <<'\n';


    // cout <<  subnormal_in2 << " is " << show_classification(subnormal_in2) << '\n';
    // float In2 = 0.9*(1e308); // the realmax
    // cout << In2+In2 <<" is " << show_classification(In) << '\n';
}