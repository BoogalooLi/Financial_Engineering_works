#ifndef BIN_LATTICE_H
#define BIN_LATTICE_H

#include <iostream>
#include <iomanip>
#include <vector>
using std::vector;
using std::cout;
using std::endl;

namespace binomial {

template<typename T>
    class Bin_lattice {
        public:
            void set_steps(const int&);
            void set_node(const int& row, const int& column, T t) { lattice_[row][column] = t; }
            const T get_node(const int& row, const int& column) const { return lattice_[row][column]; }
            void print();
        private:
            int n_;
            vector<vector<T>> lattice_;
    };

    template <typename T> 
    void Bin_lattice<T>::set_steps(const int& n) {
        n_ = n;
        lattice_.resize(n_+1);
        for(auto& array : lattice_) 
            array.resize(n_+1);
    }

    template <typename T>
    void Bin_lattice<T>::print() {
        for (auto row = 0; row <= n_; ++row) {
            for (auto column = 0; column <= row; ++column)
                cout << get_node(row, column);
            cout << endl;
        }
        cout << endl;
    }
} // namespace binomial

#endif

