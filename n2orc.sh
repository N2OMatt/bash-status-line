##~---------------------------------------------------------------------------##
##                         ____                       _   _                   ##
##                  _ __ |___ \ ___  _ __ ___   __ _| |_| |_                  ##
##                 | '_ \  __) / _ \| '_ ` _ \ / _` | __| __|                 ##
##                 | | | |/ __/ (_) | | | | | | (_| | |_| |_                  ##
##                 |_| |_|_____\___/|_| |_| |_|\__,_|\__|\__|                 ##
##                              www.n2omatt.com                               ##
##  File      : n2orc.sh                                                      ##
##  Project   : bash-status-line                                              ##
##  Date      : Apr 12, 2016                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : n2omatt <n2omatt@amazingcow.com>                              ##
##  Copyright : n2omatt - 2016, 2017                                          ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

source ~/.n2o/bash-status-line/n2osetter.sh

if [ -n "$PROMPT_COMMAND" ] ; then
    WRAPPED_PROMPT_COMMAND=${PROMPT_COMMAND}
fi;

n2o_update_prompt()
{
    if [ "$BASH_STATUS_LINE" != "disabled" ]; then

        if [ -n "$WRAPPED_PROMPT_COMMAND" ]; then
            ${WRAPPED_PROMPT_COMMAND}
        fi;

        n2o_update_status_line
    fi;
}

PROMPT_COMMAND=n2o_update_prompt

# bind -x '"\C-l":clear; $PROMPT_COMMAND';
