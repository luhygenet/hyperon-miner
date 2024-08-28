from hyperon import *
from hyperon.ext import register_atoms

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
        [AtomType.ATOM, "Expression"],
        unwrap=False
    )


    return {
        r"rm_q": removeQuote,
        r"mp_var": mapVariables
    }