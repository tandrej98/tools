# tools
Some handy tools (Bash scripts for now)
___
## project_cleaner
A simple script that checks the first level of subfolders in the provided path. If the subdirectory is a maven or a gradle project with the respective wrapper available it cleans the project up using the build tool. If the folder is a git project it runs the default garbage collector on it. 

### Requirements
git

### Arguments
positional: paths to the project directories
___