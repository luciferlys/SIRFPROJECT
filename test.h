#pragma once 
#include "sirf/common/DataContainer.h"
#include <iostream>

namespace sirf

{

    class MathClass : public DataContainer
    {
    public:

        double a;
        /* example functions */
        virtual unsigned int items() const;

        virtual void multiply(const DataContainer& x, const DataContainer& y);

        virtual void divide(const DataContainer& x, const DataContainer& y);

        virtual void maximum(const DataContainer& x, const DataContainer& y);

        virtual void minimum(const DataContainer& x, const DataContainer& y);
    };
}