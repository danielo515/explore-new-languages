# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import os, sequtils, strutils

type 
  FileInfo = object
    name*: string
    depth*: int

proc traverse_dir(dir:string): seq[FileInfo] =
  for path in walkDirRec(dir):
    var depth = 0
    for _ in path.parentDirs: depth += 1
    result.add FileInfo(name:path.splitPath.tail, depth:depth) 

iterator items*[T](s: Slice[T]): T =
  for i in s.a .. s.b:
    yield i
  
proc printFile(file:FileInfo, idx: int, files: seq[FileInfo]) =
  var depth = file.depth
  var row = newSeqWith(depth, " ")
  for pos in idx..<files.len:
    let f = files[pos]
    if f.depth < depth:
      depth = f.depth
      row[depth] = "|"

  echo(row.join, "|-", file.name, file.depth)
  

when isMainModule:
  let dir = "../"
  echo(dir)
  let files = traverse_dir(dir)
  for idx, file in files:
    file.printFile(idx, files)