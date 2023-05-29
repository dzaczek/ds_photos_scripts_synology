#!/bin/bash
#Sometimes copy files from personal space to shared space main directory creating  trash of media . So this script sort media year and moveing them  to subdir year directories 
# Define the lock file path
lock_file="/var/run/my_script.lock"

# Function to display the help message
print_help() {
  echo "Usage: $0 [options]"
  echo "Move image, movie, and video files created between the specified year and 1990 to their respective directories."
  echo "Options:"
  echo "  -d, --directory <path>   Specify the directory path"
  echo "  -h, --help               Display this help message"
  echo "  -x, --debug              Print first 100 files to transfer from each year"
  echo "  -y, --yearnow <year>     Specify the current year (default: current year - 1)"
  echo "  -n, --now                Start processing from the current year"
  echo  -ne "Example: \n \t\t sudo bash  /volume2/photo/copyfiles.sh  -d /volume2/photo  -n \n \n  or run as root in synlogy task for selected dir dir "
}

# Check if script is already running
if [[ -f "$lock_file" ]]; then
  echo "Error: The script is already running."
  exit 1
fi

# Create the lock file
echo "$$" > "$lock_file"

# Function to clean up the lock file
cleanup() {
  rm "$lock_file"
}

# Trap the exit signals to ensure the lock file is removed
trap cleanup EXIT

# Default values
yearnow=$(($(date +'%Y') - 1))
directory=""

# Function to check if the given year is valid
check_year() {
  if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid year specified: $1"
    print_help
    exit 1
  fi
}

# Process command-line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--directory)
      if [[ -z "$2" ]]; then
        echo "Error: Directory path not specified."
        print_help
        exit 1
      fi
      directory="$2"
      shift 2
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    -x|--debug)
      debug=true
      shift
      ;;
    -y|--yearnow)
      if [[ -z "$2" ]]; then
        echo "Error: Year not specified."
        print_help
        exit 1
      fi
      check_year "$2"
      yearnow="$2"
      shift 2
      ;;
    -n|--now)
      yearnow=$(date +'%Y')
      shift
      ;;
    *)
      echo "Error: Unknown option: $1"
      print_help
      exit 1
      ;;
  esac
done


if [[ -z "$directory" ]]; then
  echo "Error: Directory path not specified."
  print_help
  exit 1
fi

# Check if the directory exists
if [[ ! -d "$directory" ]]; then
  echo "Error: Directory not found: $directory"
  exit 1
fi

current_year=$(date +'%Y')
total_files=0
total_size=0

shopt -s nocaseglob  # Enable case-insensitive globbing

for ((year = yearnow; year >= 1990; year--)); do
  year_directory="$directory/$year"

  # Skip the year if the directory already exists
  if [[ ! -d "$year_directory" ]]; then

  mkdir -p "$year_directory"
  fi


  if [[ "$debug" == true ]]; then
  echo $year
  echo $year_directory
    find "$directory" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.tiff" -o -iname "*.heic" -o -iname "*.mp4" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.mkv" \) -newermt "$year-01-01" ! -newermt $((year + 1))-01-01 | head -n 100
  else
    find "$directory" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.tiff" -o -iname "*.heic" -o -iname "*.mp4" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.mkv" \) -newermt "$year-01-01" ! -newermt $((year + 1))-01-01 -exec rsync -a {} "$year_directory/" \;
 find "$directory" -type d -empty -delete
 fi
done




