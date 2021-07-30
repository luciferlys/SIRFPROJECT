#pragma once 
#include "DataContainer.h"
#include <iostream>

namespace sirf

{

    class MathClass : public DataContainer
    {
    public:

        double a;

        virtual unsigned int items();

        virtual void multiply(const DataContainer& x, const DataContainer& y);

        virtual void divide(const DataContainer& x, const DataContainer& y);

        virtual void maximum(const DataContainer& x, const DataContainer& y);

        virtual void minimum(const DataContainer& x, const DataContainer& y);
    };
}