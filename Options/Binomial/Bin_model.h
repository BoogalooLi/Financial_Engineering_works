#ifndef BIN_MODEL_H
#define BIN_MODEL_H

#include "Bin_lattice.h"

namespace binomial {

enum class state { no_break = 0, have_break = 1 };

class Bin_model {
    public:
        const double risk_neut_prob() ;
        const double stock_price(const int&, const int&) ;
        const double get_interest_rate() const ;
        state input_data();
    private:
        double s0_;
        double u_;
        double d_;
        double r_;
    };

} // namespace binomial

#endif