#!/usr/bin/env bash

# Verbs.
declare -A A_verbs;
declare -A A_verbs_oddballs;

# Nouns by gender
declare -A A_m_nouns;
declare -A A_f_nouns;
declare -A A_n_nouns;

# Monosyllables by gender.
declare -A A_m_monosyllables;
declare -A A_f_monosyllables;
declare -A A_n_monosyllables;

# Loanwords by gender
declare -A A_loanwords_english;
declare -A A_loanwords_french;

# Intuitive gender.
declare -A A_m_intuitive;
declare -A A_f_intuitive;
declare -A A_n_intuitive;

# Exceptions by gender.
declare -A A_m_exceptions;
declare -A A_f_exceptions;
declare -A A_n_exceptions;

# Used for looking up the user input single word.
declare -A A_lookup_matches;

# Source all the array files.
for file in arrays/*; do
    if [[ -f "${file}" ]]; then
        source "${file}";
    fi;
done;

# Source all the function files.
for file in functions/*; do
    if [[ -f "${file}" ]]; then
        source "${file}";
    fi;
done;

# Activate display formatting.
f_display_colors;

printf "%s\n" "Valid input options:"
printf "%s\n" " - A single word:        an English or German noun/verb."
printf "%s\n" " - Nouns by gender:      'masc_nouns', 'fem_nouns', 'neut_nouns'"
printf "%s\n" " - All nouns or verbs:   'all_nouns', 'all_verbs'"

read -p "Enter your selection: " input

# Convert input to lowercase.
input=${input,,};

# -------------------------------------------
# Noun lists.

if [[ "${input}" == "masc_nouns" ]]; then
    for n in ${!A_m_nouns[@]};do
        f_display_nouns "masculine" "${n}";
    done;
elif [[ "${input}" == "fem_nouns" ]]; then
    for n in ${!A_f_nouns[@]};do
        f_display_nouns "feminine" "${n}";
    done;
elif [[ "${input}" == "neut_nouns" ]]; then
    for n in ${!A_n_nouns[@]};do
        f_display_nouns "neuter" "${n}";
    done;
elif [[ "${input}" == "all_nouns" ]]; then
    for n in ${!A_n_nouns[@]};do
        f_display_nouns "masculine" "${n}";
        f_display_nouns "feminine" "${n}";
        f_display_nouns "neuter" "${n}";
    done;    

# -------------------------------------------
# Verb lists.

elif [[ "${input}" == "all_verbs" ]]; then
    for v in ${!A_verbs[@]};do
        f_display_verbs $v;
    done;

# -------------------------------------------
# Single noun/verb lookup.

else    
    f_check_verb "$input";
    if [[ ${#A_lookup_matches[@]} -gt 0 ]]; then 
        is_verb="true"; 
    else
        f_check_noun "$input" A_m_nouns;
        f_check_noun "$input" A_m_monosyllables;
        gender="masculine";
        if [[ ${#A_lookup_matches[@]} -eq 0 ]]; then 
            f_check_noun "$input" A_f_nouns;
            f_check_noun "$input" A_f_monosyllables;
            gender="feminine";
            if [[ ${#A_lookup_matches[@]} -eq 0 ]]; then 
                f_check_noun "$input" A_n_nouns;
                f_check_noun "$input" A_n_monosyllables;
                gender="neuter";
                if [[ ${#A_lookup_matches[@]} -eq 0 ]]; then 
                    echo "Word not found."
                    exit;
                fi;
            fi;
        fi;
    fi;
fi;

if [[ "${is_verb}" == true ]]; then
    for match in "${!A_lookup_matches[@]}"; do
        f_display_verbs ${match};    
    done;
else
    for match in "${!A_lookup_matches[@]}"; do
        f_display_nouns "${gender}" "${match}";    
    done;
fi;
