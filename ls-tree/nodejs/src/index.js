const { traverseFolder, printFolder } = require('./ls-tree');
const main = async () => {
    const [_,__,path] = process.argv;
    if(!path) {
        console.error('No path provided');
        process.exit();
    }
    const res = await traverseFolder(0, [], path)
    printFolder(res)
}

main();