#!/usr/bin/sh bash

# Create some files and directories in the current folder
echo 'sigill' > user.txt
mkdir subdir
echo 'sigkill' > subdir/

# Add some symlinks (which we should dereference properly when archiving)
ln -s subdir subdir-link
ln -s user.txt my-dir
