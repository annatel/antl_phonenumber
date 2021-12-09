#include <iostream>
#include "antl_phonenumber.h"

int main(int argc, char * argv[])
{
    // std::cout << format("028063230", "e164", "IL") << std::endl;
    std::cout << to_country_code(972) << std::endl;
    return 0;
}