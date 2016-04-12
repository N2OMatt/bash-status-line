##COWTODO: Add license header....

source ~/.n2o/bash-status-line/n2osetter.sh

if [ -n "$PROMPT_COMMAND" ] ; then
    WRAPPED_PROMPT_COMMAND=${PROMPT_COMMAND}
fi

n2o_update_prompt()
{
    if [ -n "$WRAPPED_PROMPT_COMMAND" ]; then
        ${WRAPPED_PROMPT_COMMAND}
    fi

    n2o_update_status_line
}

PROMPT_COMMAND=n2o_update_prompt

# bind -x '"\C-l":clear; $PROMPT_COMMAND';
