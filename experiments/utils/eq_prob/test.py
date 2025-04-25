import itertools
from hyperon import *
from hyperon.ext import register_atoms
import re
import sys
import os
import random
import string
import time

from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom, \
    G, S, V, Atoms, get_string_value, GroundedObject, SymbolAtom
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp
from collections import defaultdict
import re
from functools import cmp_to_key


metta = MeTTa()
with open('../../data/ugly_man_sodaDrinker.metta') as file:
   metta.run(file.read())

result= metta.run(f"! (get-atoms &self)")
print("result", result)
