#!/usr/bin/env bash
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

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/acow_shellscript_utils.sh


##----------------------------------------------------------------------------##
## Script                                                                     ##
##----------------------------------------------------------------------------##
center_text " [bash-status-line installer] ";

REAL_USER_HOME=$(find_real_user_home);
if [ -e "$REAL_USER_HOME/.bashrc" ]; then
    mkdir -vp "$REAL_USER_HOME/.n2o/bash-status-line";

    cp -vf n2orc.sh n2osetter.sh $REAL_USER_HOME/.n2o/bash-status-line/

    FILENAME="$REAL_USER_HOME/.n2o/bash-status-line/n2orc.sh";
    GREP_RESULT=$(cat "$REAL_USER_HOME/.bashrc" | grep "$FILENAME");

    ## Debug...
    # echo "FILENAME   : $FILENAME";
    # echo "GREPRESULT : $GREP_RESULT";

    if [ -z "$GREP_RESULT" ]; then
        echo "[[ -s \"$FILENAME\" ]] && source \"$FILENAME\"" >> $REAL_USER_HOME/.bashrc;
    fi;
fi

echo -e "\n Installed...";
center_text "";
echo -e "\n";
