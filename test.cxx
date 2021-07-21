#include "test.h"
#include <iostream>
unsigned int cpluscplus::MathClass::items()
{
    return 1;

}

void cpluscplus::MathClass::multiply()
{
    this->a = a * a;

    std::cout << "in multiply: a=" << a << std::endl;

}
