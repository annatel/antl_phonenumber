#include<iostream>
#include "phonenumbers/phonenumberutil.h"

using namespace std;
using namespace i18n::phonenumbers;

string format(string number, string format, string ref_country_code);
string get_type(string number, string ref_country_code);
int get_country_prefix(string number, string ref_country_code);
string to_country_code(int country_prefix);
bool is_valid(string number, string ref_country_code);
bool is_possible(string number, string ref_country_code);
string get_plus_e164_example(string country_code, string type);