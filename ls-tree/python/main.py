import os
from os import listdir
from os.path import isdir,join

middle  = '├'
pipe    = '│'
last    = '└'
scale = 2

def traverse(path, parents='', depth=0, isLast=True):
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
            tree.append((file, parents, depth+1, isLast))
    return tree

def addDepth(depth,connections,spacer=" "):
    return "".join([pipe if x in connections else spacer for x in range(0, depth)])

def findConnections(depth, below):
    depths = []
    for (_,_,curDepth,_) in below:
        if curDepth < depth: 
            depths.append(curDepth)
            depth=curDepth
    return depths

def prettyPrint(treeInfo):
    for idx,node in enumerate(treeInfo):
        (name, parents, depth, isLast) = node
        prefix = last if isLast else middle
        connections = [x*scale for x in findConnections(depth,treeInfo[idx:])]
        print("%s%s %s"%(addDepth(depth*scale,connections), prefix, name))

folderInfo = traverse(".")
print(prettyPrint(folderInfo))
