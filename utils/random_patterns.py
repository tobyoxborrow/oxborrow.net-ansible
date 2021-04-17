#!/usr/bin/env python

import random


def is_valid_word(word) -> bool:
    if len(word) < 4 or len(word) > 8:
        return False
    if word.isalpha():
        return True
    return False


def is_adj(word) -> bool:
    if word.istitle():
        return False
    if word.endswith('ing') or word.endswith('est') or word.endswith('y'):
        return True
    return False

def pick_pattern(adjs, nouns):
    adj = random.choice(list(adjs))
    noun = random.choice([n for n in nouns if n.startswith(adj[0])])
    return f'{adj}-{noun}'


def main():
    adjs = set()
    nouns = set()
    with open('/usr/share/dict/words', 'r') as hdl:
        for line in (l[:-1] for l in hdl.readlines() if is_valid_word(l[:-1])):
            if is_adj(line):
                adjs.add(line)
            else:
                nouns.add(line)

    pattern_root = pick_pattern(adjs, nouns)
    candidates = set()
    while len(candidates) < 10:
        suffix = random.randint(0, 99)
        candidate = f'{pattern_root}{suffix:02d}'
        if candidate in candidates:
            continue
        candidates.add(candidate)

    for c in sorted(candidates):
        print(f'  - pattern: {c.lower()}')


if __name__ == '__main__':
    main()
