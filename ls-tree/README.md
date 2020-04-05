# ls-tree
Build a CLI program that takes a folder as argument and prints a tree representation of it.
## Spec

``` sh
command-name [OPTIONS] path
```
## Folder structure
Any folder structure that makes sense for the project can be used, but it should
containt at least:
- An optional build.sh script that builds the project if it is necessary.
- A mandatory run.sh script. If the project needs to be built first, this
  script should take care of that also.
- An optional `README.md` file explaining limitations or requierements.

## Rules 
- Any number of dependencies can be used, but the less dependencies required the better the solution will be considered because that means the language used is better for the task.
- The progam must take the folder to list as a parammeter.
- Options are not required to implement, but will be positive points.
  - There is no restriction on where options should be provided. Is it ok if the
    program accepts only before or only after the path or both.
  - Any number of options is allowed, but only if they are easy to implement
  - Flexibility on options parsing will be considered positively. Eg, being able
    to putting them in any order after or before the path is considered a big advantage.
- There will be another task that will be coloring the output, but should not be
  implemented here.
