# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import os, sequtils, strutils

type 
  FileInfo = object
    name*: string
    depth*: int
    isLast*: bool
type
  Config = object
    space*: string
    middle*: string
    pipe*: string
    last*: string

proc traverse_dir(dir:string, depth=0): seq[FileInfo] =
  for kind, path in walkDir(dir):
    result.add FileInfo(name:path.splitPath.tail, depth:depth) 
    if kind == pcDir:
      result = result.concat traverse_dir(path, depth+1)
  result[^1].isLast = true


iterator items*[T](s: Slice[T]): T =
  for i in s.a .. s.b:
    yield i
  
proc printFile(file:FileInfo, idx: int, files: seq[FileInfo], conf: Config) =
  var depth = file.depth
  var row = newSeqWith(depth, conf.space)
  for pos in idx..<files.len:
    let f = files[pos]
    if f.depth < depth:
      depth = f.depth
      row[depth] = conf.pipe

  let pipe = if file.isLast: conf.last else: conf.middle
  echo(row.join, pipe, file.name)
  

when isMainModule:
  let dir = "../"
  echo(dir)
  let files = traverse_dir(dir)
  let spacing = 4
  let conf = Config(
    space: " ".repeat(spacing),
    middle: "├ ".indent(spacing),
    pipe: "│ ".indent(spacing),
    last: "└ ".indent(spacing))

  for idx, file in files:
    file.printFile(idx, files,conf)