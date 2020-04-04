package main

import (
	"flag"
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

var space = " "
var pipe = "│"
var tube = "├"
var last = "└"
var showDepth = false

func prefixStr(size int, belowDepths depthInfo) string {
	var res s.Builder
	for i := 0; i < size; i++ {
		if belowDepths[i] {
			fmt.Fprintf(&res, pipe)
		} else {
			fmt.Fprintf(&res, space)
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
	symbol := tube
	if n.isLast {
		symbol = last
	}
	if showDepth {
		return fmt.Sprintf("%s%s %s %d", prefix, symbol, n.Name, n.Depth)
	}
	return fmt.Sprintf("%s%s %s ", prefix, symbol, n.Name)
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
	spacing := flag.Int("s", 4, "spacing")
	flag.BoolVar(&showDepth, "debug", false, "Shows debug info (eg, depth)")
	root := "./"
	flag.Parse()
	padding := s.Repeat(" ", *spacing)
	if flag.NArg() > 0 {
		root = flag.Arg(0)
	}
	pipe = padding + pipe
	last = padding + last
	tube = padding + tube
	space = padding
	fmt.Println(root)
	scanDir(root)
}
