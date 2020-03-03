#ifndef OPTION_H
#define OPTION_H

#include "Bin_lattice.h"
#include "Bin_model.h"

namespace binomial {
    class Option {
        public:
            void set_steps(const int& n) { steps_ = n; }
            const int get_steps() const { return steps_; }
            virtual const double payoff(double price) = 0;
        private:
            int steps_;
    };

    class European_option : public virtual Option {
        public:
            const double price_by_crr(Bin_model model);

    };

    class American_option : public virtual Option {
        public:
        const double price_by_snell(Bin_model model, Bin_lattice<double>& price_tree,
            Bin_lattice<bool>& stopping_tree);

    };

    class Call : public European_option, public American_option {
        public:
            void set_strike(const double& k) { strike_ = k; }
            state input_data();
            const double payoff(double z) override ;
        private:
            double strike_;
    };

    class Put : public European_option, public American_option {
        public:
            void set_strike(const double& k) { strike_ = k; }
            state input_data();
            const double payoff(double z) override ;
        private:
            double strike_;
    };
    
} // namespace binomial

#endif
