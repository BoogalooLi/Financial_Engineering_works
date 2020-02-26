#include "Option.h"
#include "Bin_model.h"
#include "Bin_lattice.h"
#include <iostream>
#include <cmath>

using std::endl;
using std::cout;
using std::cout;
using std::cin;

namespace binomial{
    const double European_option::price_by_crr(Bin_model model) {
        double p = model.risk_neut_prob();
        const int steps = get_steps();
        vector<double> price(steps+1);
        for (auto i = 0; i <= steps; ++i) {
            price[i] = payoff(model.stock_price(steps, 1));
        }
        for (auto i = steps-1; i >= 0; --i) {
            for (auto j = 0; j <= i; ++j) {
                price[j] = (p*price[j+1] + (1-p)*price[j]) / (1+model.get_interest_rate());
            }
        }
        return price[0];
    }

    const double American_option::price_by_snell(Bin_model model, Bin_lattice<double>& pricing_tree, Bin_lattice<bool>& stopping_tree) {
        double p = model.risk_neut_prob();
        const int steps = get_steps();
        pricing_tree.set_steps(steps);
        stopping_tree.set_steps(steps);
        double contval = 0.0;
        for (int i = 0; i < steps; i++) {
            pricing_tree.set_node(steps, i, payoff(model.stock_price(steps, i)));
            stopping_tree.set_node(steps, i, 1);
        }
        for (auto n = steps - 1; n >= 0; --n) {
            for (auto i = 0; i <=n; ++i) {
                contval = (p*pricing_tree.get_node(n+1, i+1)+(1-p)*(pricing_tree.get_node(n+1, i))) / (1+model.get_interest_rate());
                pricing_tree.set_node(n, i, payoff(model.stock_price(n, i)));
                stopping_tree.set_node(n, i, 1);
                if (contval > pricing_tree.get_node(n, i)) {
                    pricing_tree.set_node(n, i, contval);
                    stopping_tree.set_node(n, i, 0);
                }
                else if (pricing_tree.get_node(n, i) == 0.0) {
                    stopping_tree.set_node(n, i, 0);
                }
            }
        }
        return pricing_tree.get_node(0, 0);
    }

    state Call::input_data() {
        cout << "Enter call option data" << endl;
        int steps;
        cout << "Enter steps to expiry :" << endl;
        cin >> steps;
        set_steps(steps);
        cout << "Enter strike price :" << endl;
        cin >> strike_;
        return state::no_break;
    }

    const double Call::payoff(double z) {
        if (z > strike_)
            return z - strike_;
        return 0;
    }

        state Put::input_data() {
        cout << "Enter put option data" << endl;
        int steps;
        cout << "Enter steps to expiry :" << endl;
        cin >> steps;
        set_steps(steps);
        cout << "Enter strike price :" << endl;
        cin >> strike_;
        return state::no_break;
    }

    const double Put::payoff(double z) {
        if (z < strike_)
            return strike_ - z;
        return 0;
    }
}