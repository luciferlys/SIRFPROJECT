#include "test.h"
#include <iostream>
#include "DataContainer.h"


using namespace std;
double min(double value1, double value2)
{
    return(value1 <= value2 ? value1 : value2);
}
double max(double value1, double value2)
{
    return(value1 >= value2 ? value1 : value2);
}

unsigned int sirf::MathClass::items()
{
    return 1;

}

void sirf::MathClass::multiply(const DataContainer& x, const DataContainer& y)
{
    this->a = dynamic_cast<const MathClass&>(x).a * dynamic_cast<const MathClass&>(y).a;

    std::cout << "in multiply: a=" << a << std::endl;

}

void sirf::MathClass::divide(const DataContainer& x, const DataContainer& y)
{
    this->a = dynamic_cast<const MathClass&>(x).a / dynamic_cast<const MathClass&>(y).a;

    std::cout << "in divide: a=" << a << std::endl;

}

void sirf::MathClass::maximum(const DataContainer& x, const DataContainer& y)
{

    std::cout << "We have" << max(dynamic_cast<const MathClass&>(x).a, dynamic_cast<const MathClass&>(y).a) << std::endl;

}

void sirf::MathClass::minimum(const DataContainer& x, const DataContainer& y)
{

    std::cout << "We have" << min(dynamic_cast<const MathClass&>(x).a, dynamic_cast<const MathClass&>(y).a) << std::endl;

}

