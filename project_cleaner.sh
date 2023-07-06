#!/bin/bash

POSITIONAL=()
GIT_INSTALLED=false
GIT_ENABLED=true
VERBOSE_PARAM="--quiet"

# check if git is installed
check_git() {
  # Check if git command is available
  if command -v git &> /dev/null; then
    GIT_INSTALLED=true
  else
    GIT_INSTALLED=false
  fi
}

# Help message function
print_help() {
    echo "Usage: project_cleaner.sh [OPTIONS] [PATHS]"
    echo "Options:"
    echo "  -v, --verbose      Enable verbose output"
    echo "  -h, --help         Display this help message"
    echo "  --disable-git      Disable usage of git gc"
}

# parse named and positional arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
      -v|--verbose)
      VERBOSE_PARAM=""
      shift
      ;;
      --disable-git)
      GIT_ENABLED=false
      shift
      ;;
      -h|--help)
      print_help
      exit 0
      ;;
      *)    # unknown option
      echo "Unknown option $key, using as path."
      POSITIONAL+=("$1")
      shift
      ;;
    esac
  done
}

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
      echo "./gradlew clean $VERBOSE_PARAM"
      ./gradlew clean $VERBOSE_PARAM
    elif [ -f "mvnw" ]; then
      echo "Cleaning maven project: $dir"
      echo "./mvnw clean $VERBOSE_PARAM"
      ./mvnw clean $VERBOSE_PARAM
    else
      echo "The directory does not contain any gradle/maven wrappers: $dir"
    fi

    if [ "$GIT_ENABLED" = true ]; then
      if [ "$GIT_INSTALLED" = true ] && [ -d ".git" ]; then
        echo "Runing git garbage collector: $dir"
        git gc
      else
        echo "Either Git is not installed or the folder is not a git repository. Skipping 'git gc'..."
      fi
    fi

    cd "$full_path"
  done
}

# Check if no arguments are provided
if [ $# -eq 0 ]; then
    echo "No paths provided. Usage: $0 <path1> <path2> ..."
    exit 1
fi

parse_args "$@"
if [ "$GIT_ENABLED" = true ]; then
  check_git
fi

# Process each provided path
for path in "$POSITIONAL"; do
    echo "Cleaning path: $path"
    process_path "$path"
done

echo "Cleaned all provided paths."
