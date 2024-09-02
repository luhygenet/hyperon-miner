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
    #($Y ($X ())) ($a  ($b ($c ())))
    input_str1 = str(var1)
    input_str2 = str(var2)
    
    list1 = parse_list_structure(input_str1.replace('"', ''))
    list2 = parse_list_structure(input_str2.replace('"', ''))

    combinations = combine_lists(list1, list2)
    
    unique_combos = unique_combinations(combinations, list1, list2)
    
    combined_pattern = " ".join(["({} {} {})".format(combo[0], combo[1], combo[2]) for combo in unique_combos])
    combined_pattern_atoms = "(" + combined_pattern + ")"

    atoms = metta.parse_all(combined_pattern_atoms)
    return atoms

def parse_list_structure(input_str):
    """Convert a string with parentheses into a nested list structure."""
    elements = []
    current = ""
    in_word = False
    
    for char in input_str:
        if char == '(':
            if in_word:
                elements.append(f'"{current.strip()}", ')
                current = ""
                in_word = False
            elements.append('[')
        elif char == ')':
            if in_word:
                elements.append(f'"{current.strip()}"')
                current = ""
                in_word = False
            elements.append('], ')
        elif char.isspace():
            if in_word:
                elements.append(f'"{current.strip()}", ')
                current = ""
                in_word = False
        else:
            current += char
            in_word = True
    
    if in_word:
        elements.append(f'"{current.strip()}"')
    
    parsed_str = ''.join(elements)
    
    parsed_str = parsed_str.replace(', ]', ']')
    parsed_str = parsed_str.rstrip(', ')
    
    return eval(parsed_str)

def flatten_list(nested_list):
    """Flatten a nested list structure into a flat list of elements."""
    if isinstance(nested_list, list):
        flat_list = []
        for item in nested_list:
            flat_list.extend(flatten_list(item))
        return flat_list
    else:
        return [nested_list]

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

    return combinations

def combine_lists(list1, list2):
    flat_list1 = flatten_list(list1)
    flat_list2 = flatten_list(list2)
    length = max(len(flat_list1), len(flat_list2))
    return combine_lists_recursive(flat_list1, flat_list2, length)

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
    
    return {
        r"combine_lists": combineLists
    }


@register_atoms(pass_metta=True)
def rand_str(run_context):
    """
    This function registers an operation atom `generateRandomVar` that dynamically generates a unique variable name.
    It ensures the generated variable name is not already used within the given context. The uniqueness is achieved by
    combining a random string with the current timestamp, and checking against existing variables in the atom.

    The operation atom `generateRandomVar` takes two atoms as input and generates a new variable that does not conflict
    with any existing variable names extracted from these atoms.

    

    Parameters:
    - run_context: The context in which this function is run, provided by the caller.

    Returns:
    - A dictionary mapping the operation name to the OperationAtom instance.
    """

    # Mapping to store generated variables to ensure uniqueness
    mapping = {}
    
    def generate_random_string(length=1):
        """
        Generates a random string of specified length composed of uppercase letters and digits.

        Parameters:
        - length (int): The length of the random string to generate. Default is 1.

        Returns:
        - A random string of uppercase letters and digits.
        """
        return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))

    def extract_variables_from_atom(atom):
        """
        Extracts variable names from a given atom. Variables are identified by a leading '$' symbol.
        Variables containing '#' are ignored as they are considered invalid.

        Parameters:
        - atom: The atom from which to extract variable names.

        Returns:
        - A list of valid variable names extracted from the atom.
        """
        atom_str = str(atom)
        pattern = r"\$[^\s\(\)]+"
        variables = re.findall(pattern, atom_str)
        return [var for var in variables if "#" not in var]

    def generate_random_var(a, b):
        """
        Generates a unique variable name based on the variables extracted from two atoms.
        If a variable name for 'b' is already generated and stored in the mapping, it returns that variable.
        Otherwise, it generates a new unique variable name, stores it in the mapping, and returns it.

        Parameters:
        - a: The first atom from which to extract variables.
        - b: The second atom from which to extract variables and for which to generate a unique variable name.

        Returns:
        - A list containing the newly generated unique variable.
        """
        variables = extract_variables_from_atom(a)
        variables_set = set(var[1:] for var in variables)
        base_name = "rn" + generate_random_string() + str(int(time.time()))

        if base_name in variables_set:
            i = 1
            while f"{base_name}{i}" in variables_set:
                i += 1
            base_name = f"{base_name}{i}"

        new_var = V(base_name)
        mapping[str(b)] = new_var
        return [new_var]

    # Define the operation atom with its parameters and function
    generateRandomVar = OperationAtom('generateRandomVar', lambda a, b: generate_random_var(a, b),
                                      ['Atom', 'Atom', 'Variable'], unwrap=False)

    return {
        r"generateRandomVar": generateRandomVar
    }


