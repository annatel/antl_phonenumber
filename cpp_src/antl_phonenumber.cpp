
#include<iostream>
#include "phonenumbers/phonenumberutil.h"

using namespace std;
using namespace i18n::phonenumbers;

const char *locale = "IL";

PhoneNumberUtil::PhoneNumberFormat format_from_string(string format) {
  std::map<std::string, PhoneNumberUtil::PhoneNumberFormat> formats;

	formats["e164"] = PhoneNumberUtil::E164;
	formats["international"] = PhoneNumberUtil::INTERNATIONAL;
	formats["national"] = PhoneNumberUtil::NATIONAL;
	formats["rfc3966"] = PhoneNumberUtil::RFC3966;

  auto it = formats.find(format);
  if (it != formats.end()) {
    return it->second;
  } else {
    throw std::invalid_argument("format is not valid");
  }
}

string type_to_string(PhoneNumberUtil::PhoneNumberType type) {
  switch (type) {
    case PhoneNumberUtil::PREMIUM_RATE:
      return "premium_rate";
    case PhoneNumberUtil::TOLL_FREE:
      return "toll_free";
    case PhoneNumberUtil::MOBILE:
      return "mobile";
    case PhoneNumberUtil::FIXED_LINE:
    case PhoneNumberUtil::FIXED_LINE_OR_MOBILE:
      return "fixed_line";
    case PhoneNumberUtil::SHARED_COST:
      return "shared_cost";
    case PhoneNumberUtil::VOIP:
      return "voip";
    case PhoneNumberUtil::PERSONAL_NUMBER:
      return "personal_number";
    case PhoneNumberUtil::PAGER:
      return "pager";
    case PhoneNumberUtil::UAN:
      return "uan";
    case PhoneNumberUtil::VOICEMAIL:
      return "voicemail";
    default:
      return "general_desc";
  }
}

PhoneNumberUtil::PhoneNumberType type_from_string(string type) {
  std::map<std::string, PhoneNumberUtil::PhoneNumberType> types;

  types["premium_rate"] = PhoneNumberUtil::PREMIUM_RATE;
  types["toll_free"] = PhoneNumberUtil::TOLL_FREE;
  types["mobile"] = PhoneNumberUtil::MOBILE;
  types["fixed_line"] = PhoneNumberUtil::FIXED_LINE;
  types["shared_cost"] = PhoneNumberUtil::SHARED_COST;
  types["voip"] = PhoneNumberUtil::VOIP;
  types["personal_number"] = PhoneNumberUtil::PERSONAL_NUMBER;
  types["pager"] = PhoneNumberUtil::PAGER;
  types["uan"] = PhoneNumberUtil::UAN;
  types["voicemail"] = PhoneNumberUtil::VOICEMAIL;

  auto it = types.find(type);
  if (it != types.end()) {
    return it->second;
  } else {
    throw std::invalid_argument("type is not valid");
  }
}



string format(string number, string format, string ref_iso_country_code) {
    PhoneNumber phone_number;
    std::string formatted_number;

    const PhoneNumberUtil& phone_util(*PhoneNumberUtil::GetInstance());
    if(phone_util.Parse(number, ref_iso_country_code, &phone_number) == PhoneNumberUtil::NO_PARSING_ERROR) {
        phone_util.Format(phone_number, format_from_string(format), &formatted_number);
        return formatted_number; 
    } else {
      return "parsing error";
    }
}

string get_type(string number, string ref_iso_country_code) {
    PhoneNumber phone_number;
    PhoneNumberUtil::PhoneNumberType type;

    const PhoneNumberUtil& phone_util(*PhoneNumberUtil::GetInstance());
    if(phone_util.Parse(number, ref_iso_country_code, &phone_number) == PhoneNumberUtil::NO_PARSING_ERROR) {
      type = phone_util.GetNumberType(phone_number);
      return type_to_string(type);
    } else {
      return "parsing error";
    }
}

int get_country_code(string number, string ref_iso_country_code) {
    PhoneNumber phone_number;
    int country_code;

    const PhoneNumberUtil& phone_util(*PhoneNumberUtil::GetInstance());
    if(phone_util.Parse(number, ref_iso_country_code, &phone_number) == PhoneNumberUtil::NO_PARSING_ERROR) {
      country_code = phone_number.country_code();
      return country_code;
    } else {
      return 0;
    }
}

string to_iso_country_code(int country_code) {
    string iso_country_code;

    const PhoneNumberUtil& phone_util(*PhoneNumberUtil::GetInstance());
    phone_util.GetRegionCodeForCountryCode(country_code, &iso_country_code);
    return iso_country_code;
}

bool is_valid(string number, string ref_iso_country_code) {
    PhoneNumber phone_number;

    const PhoneNumberUtil& phone_util(*PhoneNumberUtil::GetInstance());
    if(phone_util.Parse(number, ref_iso_country_code, &phone_number) == PhoneNumberUtil::NO_PARSING_ERROR) {
      return phone_util.IsValidNumber(phone_number);
    } else {
      return false;
    }
}

bool is_possible(string number, string ref_iso_country_code) {
    PhoneNumber phone_number;

    const PhoneNumberUtil& phone_util(*PhoneNumberUtil::GetInstance());
    if(phone_util.Parse(number, ref_iso_country_code, &phone_number) == PhoneNumberUtil::NO_PARSING_ERROR) {
      return phone_util.IsPossibleNumber(phone_number);
    } else {
      return false;
    }
}

string get_plus_e164_example(string iso_country_code, string type) {
  PhoneNumber phone_number;
  string example_number;

  const PhoneNumberUtil& phone_util(*PhoneNumberUtil::GetInstance());
  bool success = phone_util.GetExampleNumberForType(iso_country_code, type_from_string(type), &phone_number);
  if(success) {
    phone_util.Format(phone_number, format_from_string("e164"), &example_number);
    return example_number;
  } else {
    return "error";
  }
}

