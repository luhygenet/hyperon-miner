from hyperon import *
from hyperon.ext import register_atoms
import regex as re
import random
import string
import sys
import os
import time

from hyperon.atoms import (
    ExpressionAtom,
    E,
    GroundedAtom,
    OperationAtom,
    ValueAtom,
    NoReduceError,
    AtomType,
    MatchableObject,
    VariableAtom,
    G,
    S,
    V,
    Atoms,
    get_string_value,
    GroundedObject,
    SymbolAtom,
)
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp


# def call_python_process(metta: MeTTa, pattern):
def call_python_process(metta: MeTTa):
    # metta.run('''
    # (= (abstract-recursive $p)
    #     (if (not (== (get-metatype $p) Expression))
    #         $p
    #         (let* (
    #                 ( ($link $x $y) $p)
    #                 ( $nx (abstract-recursive $x))
    #                 ( $ny (abstract-recursive $y))
    #             )
    #         (superpose (
    #                     ($link $nx $w)
    #                     ($link $z $ny)
    #                     ($link $x $u)
    #                     ($link $k $y)
    #                     $d
    #                     ($link $g $o)
    #                     ($link $nx $ny)
    #                 )
    #         )
    # )

    # )
    # )
    # ''')

    # run_str = f'!(abstract-recursive {pattern})'
    run_str = (
        f"!(match &specredspace (SpecializationOf $c $d) (SpecializationOf $c $d))"
    )

    patterns = metta.run(run_str)

    data = [str(item) for sublist in patterns for item in sublist]

    def clean_reserved_vars(expression):
        expression = re.sub(r"\$x#\d+", "$x", expression)
        expression = re.sub(r"\$y#\d+", "$y", expression)
        expression = re.sub(r"\$link#\d+", "$link", expression)
        return expression

    # Extract structure while ignoring specific variables
    def extract_structure(expression):
        # Replace all other variables except $x, $y, and $link with a placeholder
        expression = clean_reserved_vars(expression)
        return re.sub(r"\$\w+#\d+", "$var", expression)

    structure_dict = {}
    for expr in data:
        structure = extract_structure(expr)
        if structure not in structure_dict:
            structure_dict[structure] = expr

    def generate_random_var():
        return (
            "$"
            + "".join(random.choices(string.ascii_lowercase, k=1))
            + "".join(random.choices(string.digits, k=6))
        )

    unique_patterns = []
    for structure in structure_dict.keys():
        unique_structure = structure
        var_count = len(re.findall(r"\$var", structure))

        for _ in range(var_count):
            unique_var = generate_random_var()
            unique_structure = unique_structure.replace("$var", unique_var, 1)

        # unique_patterns.append(unique_structure)
        # unique_patterns.append(ValueAtom(metta.parse_single(unique_structure), 'Expression'))
        unique_patterns.append(metta.parse_single(unique_structure))
    # uni_patterns = ' '.join(unique_patterns)
    # atoms = metta.parse_single(uni_patterns)
    # return [ValueAtom(atoms, 'Expression')]

    return unique_patterns


def replace_with_de_bruijn(metta: MeTTa, pattern):
    str_pattern = str(pattern)

    def get_de_bruijn(index):
        if index == 0:
            return "Z"
        return f"(S {get_de_bruijn(index - 1)})"

    index = 0
    var_count = len(re.findall(r"\$\w+(?:#\w+)?", str_pattern))
    for _ in range(var_count):
        str_pattern = re.sub(
            r"\$\w+(?:#\w+)?", f"{get_de_bruijn(index)}", str_pattern, count=1
        )
        index += 1

    return [metta.parse_single(str_pattern)]


def replace_with_variable(metta: MeTTa, pattern):
    str_pattern = str(pattern)

    def match_de_bruijn_indices(string):
        stack = []
        for char in string:
            if char == "(":
                stack.append(char)
            elif char == ")":
                stack.pop()
        for i in stack:
            string += ")"
        return string

    def generate_random_var():
        return (
            "$"
            + "".join(random.choices(string.ascii_lowercase, k=1))
            + "".join(random.choices(string.digits, k=2))
        )

    matches = re.findall(r"(Z|\(S(.*?)\))", str_pattern)
    for match in matches:
        str_pattern = re.sub(
            re.escape(match_de_bruijn_indices(match[0])),
            f"{generate_random_var()}",
            str_pattern,
            count=1,
        )

    return [metta.parse_single(str_pattern)]


@register_atoms(pass_metta=True)
def redundancy(metta):
    # redundancyFreeAtom = OperationAtom('redunpat', lambda patterns: call_python_process(metta, patterns), unwrap=False)
    redundancyFreeAtom = OperationAtom(
        "redunpat", lambda: call_python_process(metta), ["Expression"], unwrap=False
    )
    replace = OperationAtom(
        "replace", lambda pattern: replace_with_de_bruijn(metta, pattern), unwrap=False
    )
    replacev = OperationAtom(
        "replacev", lambda pattern: replace_with_variable(metta, pattern), unwrap=False
    )
    return {r"redunpat": redundancyFreeAtom, r"replace": replace, r"replacev": replacev}
