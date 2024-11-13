from hyperon import *
from hyperon.ext import register_atoms
import re
import random
import string
import sys
import os
import time

from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom,\
    G, S,V, Atoms, get_string_value, GroundedObject, SymbolAtom
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
    run_str = f'!(match &shabspace (ShallowAbstractionOf $c $d) (ShallowAbstractionOf $c $d))'

    patterns = metta.run(run_str)

    data = [str(item) for sublist in patterns for item in sublist]

    def extract_structure(expression):
        return re.sub(r'\$\w+#\d+', '$var', expression)

    structure_dict = {}
    for expr in data:
        structure = extract_structure(expr)
        if structure not in structure_dict:
            structure_dict[structure] = expr  

    def generate_random_var():
        return '$' + ''.join(random.choices(string.ascii_lowercase, k=1)) + ''.join(random.choices(string.digits, k=6))

    unique_patterns = []
    for structure in structure_dict.keys():
        unique_structure = structure
        var_count = len(re.findall(r'\$var', structure))

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

@register_atoms(pass_metta=True)
def redundancy(metta):
    # redundancyFreeAtom = OperationAtom('redunpat', lambda patterns: call_python_process(metta, patterns), unwrap=False)
    redundancyFreeAtom = OperationAtom('redunpat', lambda: call_python_process(metta),['Expression'], unwrap=False)
    return {
        r"redunpat": redundancyFreeAtom,
    }
