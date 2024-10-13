from hyperon import *
from hyperon.ext import register_atoms
import re
import sys
import os
import random
import string
import time

from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom,\
    G, S,V, Atoms, get_string_value, GroundedObject, SymbolAtom
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp

def combine_lists_op(metta: MeTTa, var1, var2):
    
    input_str1 = str(var1)
    input_str2 = str(var2)
    
    list1 = parse_metta_structure(input_str1)
    list2 = parse_metta_structure(input_str2) 

    combinations = combine_lists(list1, list2)
    
    combined_pattern = " ".join(
        ["({})".format(" ".join(combo)) for combo in combinations]
    )

    combined_pattern_atoms = "(" + combined_pattern + ")"

    atoms = metta.parse_all(combined_pattern_atoms)
    return atoms

# def format_list(metta: MeTTa, list):
#     input_str = str(list)
#     parsed_structure = parse_metta_structure(input_str)

#     flat_list = flatten_list(parsed_structure)

#     grouped_list = []
#     current_group = []

#     for item in flat_list:
#         if item == "End":
#             if current_group:
#                 grouped_list.append(f"({' '.join(current_group)})")
#             current_group = []
#         else:
#             current_group.append(item)

#     formatted_list = " ".join(grouped_list)
#     formatted_list_ready = "(" + formatted_list + ")"

#     formatted_atom = metta.parse_all(formatted_list_ready)

#     return formatted_atom

def parse_metta_structure(input_str):
    """Convert a string like ($A $B $C) into a flat list ['$A', '$B', '$C']"""
    elements = []
    current = ""
    in_word = False
    
    for char in input_str:
        if char == '(':
            continue  # Skip parentheses and dollar signs
        elif char == ')':
            if in_word:
                elements.append(current.strip())
                current = ""
                in_word = False
        elif char.isspace():
            if in_word:
                elements.append(current.strip())
                current = ""
                in_word = False
        else:
            current += char
            in_word = True

    if in_word:
        elements.append(current.strip())
    
    return elements

def flatten_list(nested_list):
    flat_list = []
    stack = [nested_list]
    while stack:
        current = stack.pop()
        if isinstance(current, list):
            stack.extend(reversed(current))
        else:
            flat_list.append(current)
    return flat_list

# Permutations not implemented yet and also the conjunction vars must be returned with the
# generated combinations
def combine_lists_recursive(list1, list2, length, current_combination=None, index1=0, index2=0):
    if current_combination is None:
        current_combination = []
    
    if len(current_combination) == length:
        return [current_combination]
    
    combinations = []
    
    for i in range(index1, len(list1)):
        new_combination = current_combination + [list1[i]]
        combinations.extend(combine_lists_recursive(list1, list2, length, new_combination, i + 1, index2))

    for j in range(index2, len(list2)):
        new_combination = current_combination + [list2[j]]
        combinations.extend(combine_lists_recursive(list1, list2, length, new_combination, index1, j + 1))

    return (unique_combinations(combinations, list1, list2))

def combine_lists(list1, list2):
    length = len(list2)
    return combine_lists_recursive(list1, list2, length)


def unique_combinations(combinations, list1, list2):
    flat_list1 = flatten_list(list1)
    flat_list2 = flatten_list(list2)
    
    seen = set()
    unique_combos = []
    list1_set = set(str(item) for item in flat_list1)
    list2_set = set(str(item) for item in flat_list2)

    for combo in combinations:
        sorted_combo = tuple(sorted(str(item) for item in combo))
        combo_set = set(sorted_combo)
        if sorted_combo not in seen and combo_set != list1_set and combo_set != list2_set:
            seen.add(sorted_combo)
            unique_combos.append(combo)
    return unique_combos

@register_atoms(pass_metta=True)
def cnj_exp(metta):
    
    combineLists = OperationAtom(
        'combine_lists', 
        lambda var1, var2: combine_lists_op(metta, var1, var2), 
        ['Atom', 'Atom', 'Expression'], 
        unwrap=False)
    # formatList = OperationAtom(
    #     'format_list', 
    #     lambda list: format_list(metta, list), 
    #     ['Atom', 'Expression'], 
    #     unwrap=False)
    
    return {
        r"combine_lists": combineLists,
        # r"format_list": formatList
    }


@register_atoms(pass_metta=True)
def rand_str(run_context):
    """
    This function registers an operation atom `generateRandomVar` that dynamically generates a unique variable name.
    It ensures the generated variable name is not already used within the given context. The uniqueness is achieved by
    combining a random string with the current timestamp, and checking against existing variables in the atom.

    The operation atom `generateRandomVar` takes a single atom as input and generates a new variable that does not conflict
    with any existing variable names extracted from this atom.

    Parameters:
    - run_context: The context in which this function is run, provided by the caller.

    Returns:
    - A dictionary mapping the operation name to the OperationAtom instance.
    """

    def generate_random_string(length=1):
        """
        Generates a random string of specified length composed of uppercase letters and digits.

        Parameters:
        - length (int): The length of the random string to generate. Default is 1.

        Returns:
        - A random string of uppercase letters and digits.
        """
        return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))

    def generate_random_var(atom):
        """
        Generates a unique variable name based on the input atom.
        Assumes the input atom is a variable, like "$A".

        Parameters:
        - atom: The atom from which to generate a unique variable name.

        Returns:
        - A list containing the newly generated unique variable.
        """
        atom_str = str(atom)
        clean_str = atom_str.replace('$', '').replace('#', '')

        # Create a new unique variable name by appending random string and timestamp
        base_name = 'R-' + generate_random_string() + str(int(time.time()))
        new_var = V(base_name)

        return [new_var]

    # Define the operation atom with its parameters and function
    generateRandomVar = OperationAtom('generateRandomVar', lambda atom: generate_random_var(atom),
                                      ['Atom','Expression'], unwrap=False)

    return {
        r"generateRandomVar": generateRandomVar
    }
