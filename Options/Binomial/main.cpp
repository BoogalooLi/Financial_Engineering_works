#include "Option.h"
#include "Option.cpp"
#include "Bin_model.h"
#include "Bin_model.cpp"
#include "Bin_lattice.h"

#include <iostream>

using namespace std;
using namespace binomial;
int main() {
     Bin_model bm;
     if (bm.input_data() == state::no_break)
         cout << "bm.input_data" << endl;

     Put p;
     p.input_data();
     Bin_lattice<double> price_tree;
     Bin_lattice<bool> stopping_tree;
     cout << "American put price :" <<endl;
     price_tree.print();
     cout << "American put exercise condition :"<<endl;
     stopping_tree.print();
     return 0;
}