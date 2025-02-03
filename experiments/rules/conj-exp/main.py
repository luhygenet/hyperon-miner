from hyperon import *
from hyperon.ext import register_atoms
import random
import string
import time
from hyperon.atoms import OperationAtom, V
from hyperon.ext import register_atoms
import itertools
from itertools import combinations

def combine_lists_op(metta: MeTTa, var1, var2):
    input_str1 = str(var1)
    input_str2 = str(var2)

    list1 = parse_metta_structure(input_str1)
    list2 = parse_metta_structure(input_str2) 

    combinations = range_combinations(list1, list2)
    combined_pattern = " ".join(
        ["({})".format(" ".join(combo)) for combo in combinations]
    )

    combined_pattern_atoms = "(" + combined_pattern + ")"
    atoms = metta.parse_all(combined_pattern_atoms)
    return atoms

def range_combinations(list1, list2):
    merged_list = list1 + list2
    i, j = len(list2), len(list2)
    res = []
    for sub in range(j):
        if sub >= (i - 1):
            res.extend(combinations(merged_list, sub + 1))
    
    res = [combo for combo in res if not set(combo).issubset(set(list2))]

    all_permutations = []
    for combo in res:
        perms = [list(p) for p in itertools.permutations(combo)]
        all_permutations.extend(perms)
    return all_permutations

def parse_metta_structure(input_str):
    """Convert a string like ($A $B $C) into a flat list ['$A', '$B', '$C']"""
    elements = []
    current = ""
    in_word = False
    
    for char in input_str:
        if char == '(':
            continue
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
    # return combinations

def combine_lists(list1, list2):
    length = len(list2)
    return combine_lists_recursive(list1, list2, length)


def unique_combinations(combinations, list1, list2):
    # print(list1)
    # print(list2)
    flat_list1 = flatten_list(list1)
    flat_list2 = flatten_list(list2)
    # print(flat_list1)
    # print(flat_list2)
    
    seen = set()
    unique_combos = []
    list1_set = set(str(item) for item in flat_list1)
    list2_set = set(str(item) for item in flat_list2)
    # print(list1_set)
    # print(list2_set)
    for combo in combinations:
        # sorted_combo = tuple(sorted(str(item) for item in combo))
        sorted_combo = tuple(str(item) for item in combo)
        combo_set = set(sorted_combo)
        if sorted_combo not in seen and combo_set != list1_set and combo_set != list2_set:
        # if combo_set != list1_set and combo_set != list2_set:
            seen.add(sorted_combo)
            unique_combos.append(combo)
    return unique_combos
    # return seen
def generate_random_string(length=1):
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))

def generate_random_var():
    base_name = 'R-' + generate_random_string() + str(int(time.time()))
    new_var = V(base_name)

    return [new_var]

@register_atoms(pass_metta=True)
def cnj_exp(metta):
    combineLists = OperationAtom('combine_lists', lambda var1, var2: combine_lists_op(metta, var1, var2), 
                                 ['Atom', 'Atom', 'Expression'],unwrap=False)
    generateRandomVar = OperationAtom('generateRandomVar', lambda: generate_random_var(),
                                      ['Expression'], unwrap=False)
    return {
        r"combine_lists": combineLists,
        r"generateRandomVar": generateRandomVar
    }


# print(combine_lists_op(MeTTa(), "($X $Y $X $B)", "($R-D1737102179 $A)"))
