import collections
import functools

with open("./src/05/in_test.txt") as f:
    s = f.read()

ss = s.split("\n")
ss.pop()

i = ss.index("")
ri, ui = ss[:i], ss[i + 1 :]

rs = [tuple(int(i) for i in s.split("|")) for s in ri]
us = [[int(i) for i in s.split(",")] for s in ui]

rd = collections.defaultdict[int, set[int]](set)
for rl, ru in rs:
    rd[ru].add(rl)


def g(u: list[int]):
    for i, c in enumerate(u):
        r = rd[c]

        if c == 47:
            print(c, u, r)

        for k in range(i):
            if u[k] not in r:
                return 0
    return u[len(u) // 2]


def h(u: list[int]) -> int:
    if g(u) != 0:
        return 0
    su = sorted(u, key=functools.cmp_to_key(compare))
    return su[len(u) // 2]


def compare(i: int, j: int) -> int:
    if j in rd[i]:
        return -1
    if i in rd[j]:
        return 1
    return 0


a = 0
for u in us:
    a += g(u)
    # a += h(u)

print(a)
