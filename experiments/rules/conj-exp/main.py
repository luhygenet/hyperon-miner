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


def remove_quotes_op(metta: MeTTa, *args):  

    text = " ".join(str(atom) for atom in args)

    unquoted_text = text.replace('"', '')

    atoms = metta.parse_all(unquoted_text)
    return [ValueAtom(atoms, 'Expression')]

def map_variables(metta: MeTTa, *args):
    cnj_var = args[0]
    pat_var = args[1]
    
    cnj_str = str(cnj_var)
    pat_str = str(pat_var)

    #TODO implement mapping logic here
    mapped_pattern = "(It is working)"

    atoms = metta.parse_all(mapped_pattern)
    return [ValueAtom(atoms, 'Expression')]

@register_atoms(pass_metta=True)
def cnj_exp(metta):
    removeQuote = OperationAtom(
        'rm_q', 
        lambda *args: remove_quotes_op(metta, *args), 
        [AtomType.ATOM, "Expression"], 
        unwrap=False)
    mapVariables = OperationAtom(
        'mp_var',
        lambda *args: map_variables(metta, *args),
        [AtomType.ATOM, AtomType.ATOM, "Expression"],
        unwrap=False
    )


    return {
        r"rm_q": removeQuote,
        r"mp_var": mapVariables
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


