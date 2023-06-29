#!/bin/bash

# Check if the path argument is provided
if [ -z "$1" ]; then
  echo "Please provide a path as an argument."
  exit 1
fi

# Check if git command is available
if command -v git &> /dev/null; then
  git_installed=true
else
  git_installed=false
fi

# Check if the path exists
if [ -e "$1" ]; then
  # Get the full path to the directory
  full_path=$(realpath "$1")
else
  echo "The path does not exist: $1"
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