# test-my-tests

Tests [moiatgit jda daw m03](https://moiatgit.github.io/jda.daw.m03/) exercises

## Version
2.2.0

### FIXED ISSUES
* 2.1.0 Now compiles java files itself
* 2.2.0 Fixed a bug where the test said [OK] when the output was a junit error plus the message "ha passat totes les proves". Now says [FAILED].

### Features
* Run a specific group of exercises example: `bash test_my_tests.sh -g 02` runs group 02
* Limit number of tests: example: `bash test_my_tests.sh -l 10` limit set to 10
* Run in reverse mode: example `bash test_my_tests.sh -r`
* Check help by using `bash test_my_tests.sh -h`

## How to Install

### Get the script directly
```bash
cd introprg
wget -r --tries=10 https://raw.githubusercontent.com/daniel-dominguez-daw/test-my-tests/master/test_my_tests.sh -O test_my_tests.sh
```

## You can execute it by using
```bash
bash test_my_tests.sh
```
OR making it executable then running it direcly
```bash
chmod +x test_my_tests.sh
./test_my_tests.sh
```

Rename the script if you want. `mv test_my_tests.sh yourname.sh`

## Recommendations
Use alias with preconfigured options. For example:
`alias tests='bash test_my_tests.sh -rl 10'`

![Sample](https://raw.githubusercontent.com/daniel-dominguez-daw/test-my-tests/master/rPqLdQmkZb.gif)

<<<<<<< HEAD
## Know Issues
It relies on having junit in your $CLASSPATH variable. You should edit your ~/.bashrc and add this to the end:
```bash
export CLASSPATH=.
CLASSPATH=$CLASSPATH:$HOME/lib/junit-platform-console-standalone-X.X.X.jar
# X.X.X is the version of your junit standalone file
# make sure you source your ~/.bashrc or open a new terminal
```

It may break if two py files are in the same folder.

Every exercise has to be in a folder starting with a number following the documentation. examples: `00_01_name` `02_25_name`
