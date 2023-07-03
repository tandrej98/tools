#!/bin/bash

# Check if git command is available
if command -v git &> /dev/null; then
  git_installed=true
else
  git_installed=false
fi

# Function to process a single path
process_path() {
  local arg_path=$1
  # Check if the path exists
  if [ -e "$arg_path" ]; then
    # Get the full path to the directory
    full_path=$(realpath "$arg_path")
  else
    echo "The path does not exist: $arg_path"
    exit 1
  fi

  # Iterate over all the level one  subdirectories in the provided path
  for dir in "$full_path"/*; do
    cd "$dir"
    # Check each directory if maven or gradle wrapper present
    if [ -f "gradlew" ]; then
      echo "Cleaning gradle project: $dir"
      ./gradlew clean
    elif [ -f "mvnw" ]; then
      echo "Cleaning maven project: $dir"
      ./mvnw clean
    else
      echo "The directory does not contain any gradle/maven wrappers: $dir"
    fi

    if [ "$git_installed" = true ] && [ -d ".git" ]; then
      echo "Runing git garbage collector: $dir"
      git gc
    else
      echo "Either Git is not installed or the folder is not a git repository. Skipping 'git gc'..."
    fi

    cd "$full_path"
  done
}

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    echo "No paths provided. Usage: $0 <path1> <path2> ..."
    exit 1
fi

# Process each provided path
for path in "$@"; do
    echo "Cleaning path: $path"
    process_path "$path"
done

echo "Cleaned all provided paths."
