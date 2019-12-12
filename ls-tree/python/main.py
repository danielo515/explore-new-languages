import os
from os import listdir
from os.path import isdir,join

middle  = '-'
pipe    = '|'
last    = '`'

def traverse(path, parents=''):
    tree = [path]
    realPath = join(parents,path)
    files = listdir(realPath)
    maxFiles = len(files)
    for idx,file in enumerate(files):
        curPath = join(realPath,file)
        isLast = idx == maxFiles -1
        if isdir(curPath):
            tree.append(traverse(file,realPath))
        else:
            tree.append(file)
    return tree

print(traverse("."))