

def gen_random_subsample(db, subsize):
    if size_db(db) == subsize:
        return db

    if subsize == 0:
        return []
    subsample = []
    for _ in range(subsize):
        index = randint(subsize)
        subsample.append(db[index])
    return subsample


(=(emp-tv-subsmp $pattern $db $subsize)(
    emp-tv $pattern(gen-random-subsample $db $subsize)
))
