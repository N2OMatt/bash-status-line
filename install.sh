#!/bin/bash
##~---------------------------------------------------------------------------##
##                         ____                       _   _                   ##
##                  _ __ |___ \ ___  _ __ ___   __ _| |_| |_                  ##
##                 | '_ \  __) / _ \| '_ ` _ \ / _` | __| __|                 ##
##                 | | | |/ __/ (_) | | | | | | (_| | |_| |_                  ##
##                 |_| |_|_____\___/|_| |_| |_|\__,_|\__|\__|                 ##
##                              www.n2omatt.com                               ##
##  File      : install.sh                                                    ##
##  Project   : bash-status-line                                              ##
##  Date      : Apr 12, 2016                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : n2omatt <n2omatt@amazingcow.com>                              ##
##  Copyright : n2omatt - 2016, 2017                                          ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##COWTODO: Make this script nicer...

if [ -e $HOME/.bashrc ]; then
    mkdir -p $HOME/.n2o/bash-status-line
    cp -f n2orc.sh n2osetter.sh $HOME/.n2o/bash-status-line/

    FILENAME=$HOME/.n2o/bash-status-line/n2orc.sh
    GREP_RESULT=$(cat $HOME/.bashrc | grep "$FILENAME");

    if [ -z  "$GREP_RESULT" ]; then
        echo "[[ -s \"$FILENAME\" ]] && source \"$FILENAME\"" >> $HOME/.bashrc;
    fi;

    echo "Installed...";
fi
