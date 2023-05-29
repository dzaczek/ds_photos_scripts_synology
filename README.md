# Sort Media Files in Synology Photos Space

This script helps you organize media files in a Synology Photos Space by sorting them into yearly subdirectories. 

## Description

At times, copying files from personal to shared space creates an unorganized cluster of media files. This script takes a directory and moves the images, movies, and videos created between a specified year and 1990 to their respective directories based on their creation year.

## Getting Started

### Prerequisites
- Ensure that you have `bash` installed on your system. This script requires a bash shell to run.
- The script should be run as `root` or with `sudo` privileges to ensure it has the required permissions to move files around.
- The script uses the `rsync` command to move files. Ensure you have `rsync` installed on your system.

### Usage

You can use the script by running the following command:

```bash
sudo bash /volume2/photo/copyfiles.sh  -d /volume2/photo  -n
```

Alternatively, you can set up a Synology task to automatically run the script for selected directories.

### Script Options

Here are the options you can use with the script:

- `-d, --directory <path>`: Specify the directory path.
- `-h, --help`: Display help message.
- `-x, --debug`: Print the first 100 files to be transferred from each year.
- `-y, --yearnow <year>`: Specify the current year (default: current year - 1).
- `-n, --now`: Start processing from the current year.

For example:

```bash
sudo bash /volume2/photo/copyfiles.sh -d /volume2/photo -n
```

In this example, the script will sort the media files located examaple: in `/volume2/photo` from the current year down to 1990.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
