#!/usr/bin/env bash
# author: <cf19daniel.dominguez@iesjoandaustria.org>

VERSION='2.0.0'
REVERSE=false
LIMIT=0
GROUP=0
# relative route to the bash test file
BASH_TEST_FILE=test/test.sh

function help_mode () {
    echo -e 'Available options:'
    echo -e "\t-v\n\tVersion. See the current version"
    echo -e "\t-h\n\tHelp. See this message"
    echo -e "\t-r\n\tReverse mode. Run the tests in reverse order"
    echo -e "\t-l [NUMBER]\n\tLimit number of exercises"
    echo -e "\t-g [NUMBER]\n\tSelect group of exercises. example 02"
}

while getopts ":l:g: vhr" opt; do

    case "$opt" in
        r)
            REVERSE=true
            ;;
        v)
            echo "Version $VERSION"
            exit 1
            ;;
        l)
            num=$OPTARG

            if ! [[ $num =~ ^[0-9]+$ ]] ; then
                echo 'error: -l [NUMBER] must be a number'
                exit 2
            fi

            LIMIT=$OPTARG
            ;;
        g)
            num=$OPTARG

            if ! [[ $num =~ ^[0-9]{2}$ ]] ; then
                echo 'error: -g [NUMBER] must be 2 numbers example: -g 02'
                exit 2
            fi
            GROUP=$num
            ;;
        h|\?|:)
            help_mode
            exit 1
            ;;
    esac
done

if [ "$REVERSE" == true ]; then
    MOD_REVERSE='--reverse'
else
    MOD_REVERSE=''
fi

if [ "$LIMIT" != 0 ]; then
    MOD_LIMIT="| head -n $LIMIT"
else
    MOD_LIMIT=''
fi

# for each directory (d) in the command `ls -d [0-9]*_*` (starts with numbers followed by the _ character) 
if [ "$GROUP" != 0 ]; then
    LS_CMD="ls $MOD_REVERSE | egrep '^${GROUP}_[0-9]{2}_*' $MOD_LIMIT"

else
    LS_CMD="ls $MOD_REVERSE | egrep '^[0-9]{2}_[0-9]{2}_*' $MOD_LIMIT"
fi

for d in $( eval $LS_CMD ); do
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
    HAS_DOCTEST=$(cat *.py 2>/dev/null | grep ">>>")

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

