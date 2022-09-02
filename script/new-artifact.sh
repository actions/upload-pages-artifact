#!/usr/bin/env sh

# Create some files and directories in the current folder
echo 'hello' > hello.txt
mkdir subdir
echo 'world' > subdir/world.txt
mkdir excludeddir
echo 'excluded' > excludeddir/excluded.txt

# Add some symlinks (which we should dereference properly when archiving)
ln -s subdir subdir-link
ln -s hello.txt bonjour.txt
