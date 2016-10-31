##COWTODO: Add license header....

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
