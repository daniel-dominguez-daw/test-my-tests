#!/usr/bin/env bash
# author: <cf19daniel.dominguez@iesjoandaustria.org>

BASH_TEST_FILE=test/test.sh

for d in `ls -d [0-9]*_*` ; do
    cd "$d"
    DIR=$(echo $d | cut -c1-12)~
    if [ -f $BASH_TEST_FILE ]; then
        TEST_BASHTEST=$(bash $BASH_TEST_FILE)
        if [[ "$TEST_BASHTEST" =~ ha\ passat\ totes ]]; then
            echo -e "\e[92m$DIR:\t bashtest: [OK]"
        else
            echo -e "\e[91m$DIR:\t bashtest: [FAILED]"
        fi
    else
        echo -e "\e[37m$DIR:\t bashtest: [MISSING]"
    fi
    
    HAS_DOCTEST=$(cat *.py | grep ">>>") 
    if [[ '' != $HAS_DOCTEST ]]; then
        TEST_DOCTEST=$(python3 -m doctest *.py)
        if [[ "$TEST_DOCTEST" == '' ]]; then
            echo -e "\e[92m$DIR:\t  doctest: [OK]"
        else
            echo -e "\e[91m$DIR:\t  doctest: [FAILED]"
        fi
    fi

    cd "../"
done
