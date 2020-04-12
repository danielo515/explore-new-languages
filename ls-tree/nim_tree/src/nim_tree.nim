# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import os, sequtils, strutils, parseopt

type 
  FileInfo = object
    name: string
    depth: int
    isLast: bool
type
  Config = object
    space*: string
    middle*: string
    pipe*: string
    last*: string

proc traverse_dir(dir:string, depth=0): seq[FileInfo] =
  let files = toSeq walkDir(dir)
  let last = files.len-1
  for idx, (kind, path ) in files:
    result.add FileInfo(name:path.splitPath.tail, depth:depth, isLast: idx == last)
    if kind == pcDir:
      result = result.concat traverse_dir(path, depth+1)

proc printFile(file:FileInfo, idx: int, files: seq[FileInfo], conf: Config) =
  var depth = file.depth
  var row = newSeqWith(depth, conf.space)
  for pos in idx..<files.len:
    let f = files[pos]
    if f.depth < depth:
      depth = f.depth
      row[depth] = conf.pipe
    if depth == 0: break

  let pipe = if file.isLast: conf.last else: conf.middle
  echo(row.join, pipe, file.name)
  
proc createConfig(spacing=2): Config =
  result = Config(
    space: " ".repeat(spacing),
    middle: "├ ".indent(spacing),
    pipe: "│ ".indent(spacing),
    last: "└ ".indent(spacing))

proc help() = 
  echo "Renders a folder as a tree"
  echo "Usage:"
  echo ""
  echo "\tnim-tree [OPTIONS] PATH"
  echo ""
  echo "Options:"
  echo "  --spacing=N  The separation to apply. N must be a positive number"
  echo "  -h, --help   Displays this help message"
  echo ""
  echo "Arguments:"
  echo "  PATH         Must be a valid directory"
  quit 0

proc getArguments(): ( string, Config ) =
  var dir= "./"
  var conf= createConfig()
  for kind, key, val in getopt(longNoVal = @["bla"]):
    case kind
    of cmdEnd: assert(false) # cannot happen
    of cmdArgument: dir = key 
    of cmdLongOption, cmdShortOption:
      case key
      of "spacing": 
        try:
          conf = createConfig parseInt(val)
        except:
          quit("--spacing requires a numeric value")
      of "help", "h": help()
      # of "version", "v": writeVersion()

  result = (dir, conf)

when isMainModule:
  let (dir,conf) = getArguments()
  let files = traverse_dir(dir)
  echo(dir)
  for idx, file in files:
    file.printFile(idx, files,conf)