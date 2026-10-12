#!/usr/bin/env python3
from subprocess import run, PIPE
from sys import argv

args = ['df', '-H']
args.extend(argv[1:])
out = run(args, check=True, stdout=PIPE).stdout.decode()
res = []
lines = out.split('\n')[1:-1]
for line in lines:
    line = line.strip()
    fs, size, used, avail, percent, mounted_on = line.split()
    tmp = [mounted_on.split('/')[-1] if mounted_on != '/' else 'root']
    tmp.append(' ')
    tmp.append(used)
    tmp.append('/')
    tmp.append(size)
    res.append(''.join(tmp))

print('   \u258E'.join(res))
