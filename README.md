# explore-new-languages
A repository of simple but significant exercises to test the capabilities of languages I want to learn.

## Exercises requirements
Each exercise (AKA kata) will be on it's own folder, with a readme that explains the requirements of the exercise to be considered complete,
some extra features that will be nice to have but  are not mandatory and a table comparing some objective and some subjective key points of the implementation
on each language

## Solution requirements
Each solution to each exercise will be on it's own subfolder inside the folder's exercise.
The name of each implementation will be the language that has been used to implement the solution and any necessary suffixes.
On each subfolder there must be a readme explaining how to run or compile the solution including:
- Required dependencies on the host system
- Command to execute to get the solution run
- Any note or limitation that can be considered important

### Folder structure
On each implementation folder there must be:
- Any manifest that takes care of dependencies or libraries. Everything must be managed by this kind of package systems whenever possible
- An src folder including the code of the solution
- A shell script to ease the execution of the solution
- A readme as explained above
- A `.gitignore` file according to the standards of the language being used