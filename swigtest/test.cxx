#include "test.h"
#include <iostream>
#include "sirf/common/DataContainer.h"
/* Define maximum & minimum functions */
using namespace std;
double min(double value1, double value2)
{
    return(value1 <= value2 ? value1 : value2);
}
double max(double value1, double value2)
{
    return(value1 >= value2 ? value1 : value2);
}

/* example functions */
unsigned int sirf::MathClass::items() const
{
    return 1;
}

void sirf::MathClass::multiply(const DataContainer& x, const DataContainer& y)
{
    this->a = dynamic_cast<const MathClass&>(x).a * dynamic_cast<const MathClass&>(y).a;
    std::cout << "In multiply: a=" << a << std::endl;
}

void sirf::MathClass::divide(const DataContainer& x, const DataContainer& y)
{
    this->a = dynamic_cast<const MathClass&>(x).a / dynamic_cast<const MathClass&>(y).a;
    std::cout << "In divide: a=" << a << std::endl;
}

void sirf::MathClass::maximum(const DataContainer& x, const DataContainer& y)
{
    std::cout << "We have" << max(dynamic_cast<const MathClass&>(x).a, dynamic_cast<const MathClass&>(y).a) << "as the maximum." << std::endl;
}

void sirf::MathClass::minimum(const DataContainer& x, const DataContainer& y)
{
    std::cout << "We have" << min(dynamic_cast<const MathClass&>(x).a, dynamic_cast<const MathClass&>(y).a) << "as the minimum." << std::endl;
}

