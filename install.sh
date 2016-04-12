#!/bin/bash

##COWTODO: Add license header....
##COWTODO: Make this script nicer...

if [ -e $HOME/.bashrc ]; then
    mkdir -p $HOME/.n2o/bash-status-line
    cp -f n2orc.sh n2osetter.sh $HOME/.n2o/bash-status-line/

    FILENAME=$HOME/.n2o/bash-status-line/n2orc.sh
    GREP_RESULT=$(cat $HOME/.bashrc | grep "$FILENAME");

    if [ -z  "$GREP_RESULT" ]; then
        echo "[[ -s \"$FILENAME\" ]] && source \"$FILENAME\"" >> $HOME/.bashrc;
    fi;

fi
