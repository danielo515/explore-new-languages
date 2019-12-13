import os
from os import listdir
from os.path import isdir,join

middle  = '|-'
pipe    = '|'
last    = '` '

def traverse(path, parents='', depth=0, isLast=False):
    tree = [(path, parents, depth, isLast)]
    realPath = join(parents,path)
    files = listdir(realPath)
    maxFiles = len(files)
    for idx,file in enumerate(files):
        curPath = join(realPath,file)
        isLast = idx == maxFiles -1
        if isdir(curPath):
            tree = tree + (traverse(file,realPath, depth+1, isLast))
        else:
            tree.append((file, parents, depth, isLast))
    return tree

def addDepth(depth,spacer=" "):
    return "".join([spacer for x in range(0, depth)])

def prettyPrint(treeInfo):
    for node in treeInfo:
        (name, parents, depth, isLast) = node
        prefix = last if isLast else middle
        print("%s %s %s"%(addDepth(depth), prefix, name))

folderInfo = traverse(".")
print(prettyPrint(folderInfo))
