#include<iostream>
#include <erl_nif.h>
#include "antl_phonenumber.h"

#define MAXBUFLEN 1024

using namespace std;

static ERL_NIF_TERM format_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char number[MAXBUFLEN];
    char format_name[MAXBUFLEN];
    char ref_iso_country_code[MAXBUFLEN];
    string res;
    
    if (!enif_get_string(env, argv[0], number, MAXBUFLEN, ERL_NIF_LATIN1) 
      || !enif_get_string(env, argv[1], format_name, MAXBUFLEN, ERL_NIF_LATIN1) 
      || !enif_get_string(env, argv[2], ref_iso_country_code, MAXBUFLEN, ERL_NIF_LATIN1)) {
      return enif_make_badarg(env);
    }
    res = format(number, format_name, ref_iso_country_code);
    if(res == "parsing error") {
      return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_string(env, res.c_str(), ERL_NIF_LATIN1));
    } else {
      return enif_make_tuple2(env, enif_make_atom(env, "ok"), enif_make_string(env, res.c_str(), ERL_NIF_LATIN1));
    }   
}

static ERL_NIF_TERM get_type_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char number[MAXBUFLEN];
    char ref_iso_country_code[MAXBUFLEN];
    string res;
    
    if (!enif_get_string(env, argv[0], number, MAXBUFLEN, ERL_NIF_LATIN1) || !enif_get_string(env, argv[1], ref_iso_country_code, MAXBUFLEN, ERL_NIF_LATIN1)) {
      return enif_make_badarg(env);
    }

    res = get_type(number, ref_iso_country_code);
    if(res == "parsing error") {
      return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_string(env, res.c_str(), ERL_NIF_LATIN1));
    } else {
      return enif_make_tuple2(env, enif_make_atom(env, "ok"), enif_make_string(env, res.c_str(), ERL_NIF_LATIN1));
    }  
}

static ERL_NIF_TERM get_country_code_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char number[MAXBUFLEN];
    char ref_iso_country_code[MAXBUFLEN];
    int res;
    
    if (!enif_get_string(env, argv[0], number, MAXBUFLEN, ERL_NIF_LATIN1) || !enif_get_string(env, argv[1], ref_iso_country_code, MAXBUFLEN, ERL_NIF_LATIN1)) {
      return enif_make_badarg(env);
    }
    res = get_country_code(number, ref_iso_country_code);
    if(res == 0) {
      return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_string(env, "parsing_error", ERL_NIF_LATIN1));
    } else {
      return enif_make_tuple2(env, enif_make_atom(env, "ok"), enif_make_int(env, res));
    } 
}
static ERL_NIF_TERM to_iso_country_code_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    int country_code;
    string iso_country_code;
    
    if (!enif_get_int(env, argv[0], &country_code)) {
      return enif_make_badarg(env);
    }
    iso_country_code = to_iso_country_code(country_code);
    return enif_make_string(env, iso_country_code.c_str(), ERL_NIF_LATIN1);
}

static ERL_NIF_TERM is_valid_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char number[MAXBUFLEN];
    char ref_iso_country_code[MAXBUFLEN];
    
    if (!enif_get_string(env, argv[0], number, MAXBUFLEN, ERL_NIF_LATIN1) || !enif_get_string(env, argv[1], ref_iso_country_code, MAXBUFLEN, ERL_NIF_LATIN1)) {
      return enif_make_badarg(env);
    }
    bool valid = is_valid(number, ref_iso_country_code);
    return enif_make_atom(env, valid ? "true" : "false");
}

static ERL_NIF_TERM is_possible_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char number[MAXBUFLEN];
    char ref_iso_country_code[MAXBUFLEN];
    
    if (!enif_get_string(env, argv[0], number, MAXBUFLEN, ERL_NIF_LATIN1) || !enif_get_string(env, argv[1], ref_iso_country_code, MAXBUFLEN, ERL_NIF_LATIN1)) {
      return enif_make_badarg(env);
    }
    bool possible = is_possible(number, ref_iso_country_code);
    return enif_make_atom(env, possible? "true" : "false");
}


static ERL_NIF_TERM get_plus_e164_example_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    char iso_country_code[MAXBUFLEN];
    char type[MAXBUFLEN];
    string example_number;
    
    if (!enif_get_string(env, argv[0], iso_country_code, MAXBUFLEN, ERL_NIF_LATIN1) || !enif_get_string(env, argv[1], type, MAXBUFLEN, ERL_NIF_LATIN1)) {
      return enif_make_badarg(env);
    }
    example_number = get_plus_e164_example(iso_country_code, type);

    return enif_make_string(env, example_number.c_str(), ERL_NIF_LATIN1);
}

static ErlNifFunc nif_funcs[] = {
    {"format", 3, format_nif},
    {"get_type", 2, get_type_nif},
    {"get_country_code", 2, get_country_code_nif},
    {"to_iso_country_code", 1, to_iso_country_code_nif},
    {"is_valid", 2, is_valid_nif},
    {"is_possible", 2, is_possible_nif},
    {"get_plus_e164_example", 2, get_plus_e164_example_nif}
};

ERL_NIF_INIT(Elixir.AntlPhonenumber.Nif, nif_funcs, NULL, NULL, NULL, NULL)