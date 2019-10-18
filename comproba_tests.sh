#!/usr/bin/env bash
# author: <cf19daniel.dominguez@iesjoandaustria.org>

# relative route to the bash test file
BASH_TEST_FILE=test/test.sh

# for each directory (d) in the command `ls -d [0-9]*_*` (starts with numbers followed by the _ character) 
for d in `ls -d [0-9]*_*` ; do
    # change dir to the task directory d
    cd "$d"
    # DIR equals to the task directory name after a cut of 1-12 characters, followed by ~
    DIR=$(echo $d | cut -c1-12)~

    # If the bash test exists, then
    if [ -f $BASH_TEST_FILE ]; then
        # execution of the bash test and the ouput is saved into TEST_BASHTEST
        TEST_BASHTEST=$(bash $BASH_TEST_FILE)

        # if TEST_BASHTEST has the words "ha passat totes" then...
        if [[ "$TEST_BASHTEST" =~ ha\ passat\ totes ]]; then
            # Print with a color green the value of DIR, tabbed, then bashtest: [OK]
            echo -e "\e[92m$DIR:\t bashtest: [OK]"
        else
            # Print with a color red the value of DIT, tabbed, then bashtest: [FAILED]
            echo -e "\e[91m$DIR:\t bashtest: [FAILED]"
        fi
    else
        # bash test file don't exist, say that is missing with a color gray
        echo -e "\e[37m$DIR:\t bashtest: [MISSING]"
    fi
    
    # HAS_DOCTEST holds the value of a `cat *.py | grep ">>>"` so if the code has >>> then maybe has a doctest
    HAS_DOCTEST=$(cat *.py | grep ">>>") 

    # if the py file has doctest because HAS_DOCTEST is not empty then
    if [[ '' != $HAS_DOCTEST ]]; then
        # executes the py file with doctest support and saves the output into TEST_DOCTEST
        TEST_DOCTEST=$(python3 -m doctest *.py)
        # if the doctest execution is empty then it should be OK
        if [[ "$TEST_DOCTEST" == '' ]]; then
            # prints OK with a green color
            echo -e "\e[92m$DIR:\t  doctest: [OK]"
        else
            # print FAILED otherwise
            echo -e "\e[91m$DIR:\t  doctest: [FAILED]"
        fi
    fi

    # changes dir back to the root of introprg
    cd "../"
done
