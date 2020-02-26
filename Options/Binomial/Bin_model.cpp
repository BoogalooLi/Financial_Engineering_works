#include "Bin_model.h"
#include <iostream>
#include <cmath>

using std::cin;
using std::endl;
using std::cout;
using std::pow;

namespace binomial {
    const double Bin_model::risk_neut_prob() {
        return (r_-d_) / (u_-d_);
    }

    const double Bin_model::stock_price(const int& total_times, const int& up_times) {
        return s0_ * pow(1+u_, up_times) * pow(1+d_, total_times);
    }

    const double Bin_model::get_interest_rate() const {
        return r_;
    }

    state Bin_model::input_data() {
        cout << "input S0 :";   cin >> s0_;
        cout << "input U :";   cin >> u_;
        cout << "input D :";   cin >> d_;
        cout << "input R :";   cin >> r_;

        if (s0_ <= 0 || u_ <= 0 || d_ <= 0 || u_ <= d_ || r_ <= 0) {
            cout << "Illegal data ranges" << endl;
            cout << "Terminating program now" << endl;
            return state::have_break;
//            return -1;
        }
        if (r_ >= u_ || r_ <= d_) {
            cout << "Arbitrage exists" << endl;
            cout << "Terminating program now" << endl;
            return state::have_break;
//            return -1;
        }
        cout << "Input data checked" << endl;
        cout << "There is no arbitrage" << endl;
        return state::no_break;
//        return 1;
    }

} // namespace binomial
