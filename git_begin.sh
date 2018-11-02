#!/bin/bash
# $1 = Project Name

# Get variables
USER=$(git config --global user.name)
PROJECT=$1

# Create and enter git directory
mkdir $PROJECT 
cd $PROJECT

# Create beginning files
# README
touch README
echo "This is the README for $PROJECT
Template_v0:
Name:
Number:
Hi:" >> README

# .gitignore
touch .gitignore
echo "main
*.swp
*.swo
*.o" >> .gitignore

# Makefile
touch Makefile
echo "CC = g++
CFLAGS = -Wall
LDFLAGS = 
OBJFILES = 
TARGET = main

all: \$(TARGET)

\$(TARGET): \$(OBJFILES)
	\$(CC) \$(CFLAGS) -o \$(TARGET) \$(OBJFILES) \$(LDFLAGS)

clean:
	rm -f \$(OBJFILES) \$(TARGET) *~" >> Makefile

# Create object files
COUNT=0
for item in "$@"; do
	if [ $COUNT -ne 0 ]; then
		# Header
		touch $item.h
		echo "#ifndef $item.H
#define $item.H

class $item {
	public:
		$item();
		~$item();

	private:
};

#endif" >> $item.h

		# Source
		touch $item.cc
		echo "#include \"$item.h\"
$item::$item() {
}

$item::~$item() {
}" >> $item.cc

		#	Add object to makefile
		sed -i "/^OBJFILES/ s/$/$item.o /" Makefile

		# Increase Count
		let COUNT=COUNT+1
	else	
		# Skip first item (project name)
		let COUNT=COUNT+1
	fi
done

#	Add main to makefile
sed -i "/^OBJFILES/ s/$/main.o /" Makefile

# Make first commit
git init
git add .
git commit -m "First commit of $PROJECT"
git remote add origin git@github.com/$USER/$PROJECT.git
