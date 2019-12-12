/**
 * This is the javascript implementation of ls-tree
 * */

const { readdir, stat: st } = require('fs');
const Path = require('path');
const { promisify } = require('util');
const readDir = promisify(readdir);
const stat = promisify(st);

const concat = (a, b) => a.concat(b)

const traverseFolder = async (depth, parents, file, siblings = 0, position = 0) => {
    const path = Path.join(...parents, file);
    const nextParents = parents.concat(file);
    const isDir = (await stat(path)).isDirectory();
    const current = { depth, parents, file, isLast: position >= siblings };
    if (isDir) {
        files = await readDir(path)
        const allOtherFiles = await Promise.all(
            files.map((f,i) => traverseFolder(depth + 1, nextParents, f, files.length, i+1))
        )
        return [current, ...(allOtherFiles.reduce(concat))]
    }
    return [current]
}

const stringOf = (size, char = " ") => Array(size).fill(char).join('')

const shareParent = ({ parents: pa }) => ({ parents: pb }) =>
    pa.some((p,i) => pb.slice(i).includes(p))

    const findSmallerDepths = ({ depth }, others) => {
        const depths = []
        const ln = others.length;
        for (let i = 0; i < ln && depth; i++) {
            const { depth: currDepth } = others[i];
            if (currDepth < depth) {
                depths.push(currDepth);
                depth--;
            }
        }
        return depths;
    }

const insertAt = (char, positions, [...where]) => {
    positions.forEach(pos => {
        where[pos] = char;
    });
    return where.join('');
}

const scale = 2;
const fileSymbol        = '├'
const pipeSymbol        = '│'
const lastElementSymbol = '└'

const printFolder = ([head, ...files]) => {
    const lessDeep = findSmallerDepths(
        head,
        files.filter(shareParent(head))
    ).map(x=>x*scale);
    const symbol = !head.isLast ? fileSymbol : lastElementSymbol;
    const padding = insertAt(pipeSymbol, lessDeep, stringOf(head.depth*scale));
    console.log(`${padding}${symbol} ${head.file}`)
    if(!files.length) return
    printFolder(files);
}

module.exports = {printFolder, traverseFolder};