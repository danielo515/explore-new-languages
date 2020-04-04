package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path"
	s "strings"
)

type Node struct {
	Depth  int
	Name   string
	isLast bool
}

type depthInfo map[int]bool

func prefixStr(size int, belowDepths depthInfo) string {
	var res s.Builder
	for i := 0; i < size; i++ {
		if belowDepths[i] {
			fmt.Fprintf(&res, " │")
		} else {
			fmt.Fprintf(&res, "  ")
		}
	}
	return res.String()
}

func (n Node) LowerNodeDepths(belowNodes []Node) depthInfo {
	res := make(depthInfo)
	depth := n.Depth
  // fmt.Println(n, belowNodes)
	for _, node := range belowNodes {
		if depth > node.Depth {
			depth = node.Depth
      res[depth] = true
		}
		if depth == 0 {
			break
		}
	}
	return res
}

func (n Node) Format(belowNodes []Node) string {
	belowDepths := n.LowerNodeDepths(belowNodes)
	prefix := prefixStr(n.Depth, belowDepths)
	symbol := " ├"
	if n.isLast {
		symbol = " └"
	}
	return fmt.Sprintf("%s%s %s %d", prefix, symbol, n.Name, n.Depth)
}

func readDir(dir string) []os.FileInfo {

	files, err := ioutil.ReadDir(dir)
	if err != nil {
		log.Fatal("woopsss ", err)
	}
	return files
}

func recScan(dirname string, depth int) []Node {

	files := readDir(dirname)
	res := make([]Node, 0)

	for i, file := range files {
		res = append(res, Node{depth, file.Name(), i == len(files)-1})
		if file.IsDir() {
			res = append(res, recScan(path.Join(dirname, file.Name()), depth+1)...)
		}
	}
	return res
}

func scanDir(dirname string) {

	tree := recScan(dirname, 0)
	for i, n := range tree {
		fmt.Println(n.Format(tree[i:]))
	}
}

func main() {
	root := "../../"
	fmt.Println(root)
	scanDir(root)
}
