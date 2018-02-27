#!/bin/bash
##~---------------------------------------------------------------------------##
##                         ____                       _   _                   ##
##                  _ __ |___ \ ___  _ __ ___   __ _| |_| |_                  ##
##                 | '_ \  __) / _ \| '_ ` _ \ / _` | __| __|                 ##
##                 | | | |/ __/ (_) | | | | | | (_| | |_| |_                  ##
##                 |_| |_|_____\___/|_| |_| |_|\__,_|\__|\__|                 ##
##                              www.n2omatt.com                               ##
##  File      : n2osetter.sh                                                  ##
##  Project   : bash-status-line                                              ##
##  Date      : Apr 12, 2016                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : n2omatt <n2omatt@amazingcow.com>                              ##
##  Copyright : n2omatt - 2016 - 2018                                         ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/acow_shellscript_utils.sh


##----------------------------------------------------------------------------##
## Colors                                                                     ##
##----------------------------------------------------------------------------##
RESET="\033[0m"
# Foreground
FG_K="\033[030m"
FG_R="\033[031m"
FG_G="\033[032m"
FG_Y="\033[033m"
FG_B="\033[034m"
FG_M="\033[035m"
FG_C="\033[036m"
FG_W="\033[037m"
# Background
BG_K="\033[40m"
BG_R="\033[41m"
BG_G="\033[42m"
BG_Y="\033[43m"
BG_B="\033[44m"
BG_M="\033[45m"
BG_C="\033[46m"
BG_W="\033[47m"


##----------------------------------------------------------------------------##
## Find GIT Info Functions                                                    ##
##----------------------------------------------------------------------------##
n2o_find_repo_name()
{
    unset GIT_REPO_NAME;
    $(git rev-parse --show-toplevel > /dev/null 2>&1);

    test $? == 0 && GIT_REPO_NAME=$(basename $(git rev-parse --show-toplevel));
}

n2o_find_local_branch()
{
    unset GIT_LOCAL_BRANCH;

    ## Only set if we have a local branch.
    test -n "$GIT_REPO_NAME" && GIT_LOCAL_BRANCH=$(git rev-parse --abbrev-ref HEAD);
}

n2o_find_remote_branch()
{
    unset GIT_REMOTE_BRANCH;

    ## Only continues with we've a local branch.
    test -z "$GIT_LOCAL_BRANCH" && return;

    GIT_REMOTE_BRANCH=$(             \
        git rev-parse --abbrev-ref   \
        $GIT_LOCAL_BRANCH@{upstream} \
        2> /dev/null                 \
    );

    ## Ensure clean if don't have remote.
    test $? != 0 && GIT_REMOTE_BRANCH="";
}

n2o_find_number_commits()
{
    unset GIT_NUMBER_CHANGES;

    ## Only continues with we've a local branch.
    test -z "$GIT_LOCAL_BRANCH" && return;

    GIT_NUMBER_CHANGES=$(git status  -suno | wc -l);
}

n2o_find_last_tag()
{
    unset GIT_LAST_TAG;
    unset GIT_LAST_TAG_SYNCED_WITH_REMOTE;
    GIT_LAST_TAG_SYNCED_WITH_REMOTE=0;

    ## Only continues with we've a local branch.
    test -z "$GIT_LOCAL_BRANCH" && return;

    ## Get the last tag...
    GIT_LAST_TAG=$(git describe --abbrev=0 --tags 2> /dev/null);
    ## Ensure clean if don't have remote.
    test $? != 0 && GIT_LAST_TAG="";

    ## Get remotes that has the last tag
    ## and check if the current remote is contained.
    #REMOTES_WITH_TAG=$(git branch -r --contains $GIT_LAST_TAG);

    ##COWTODO(n2omatt): Implement this...

}

n2o_find_number_pushs()
{
    unset GIT_NUMBER_PUSHS;
    GIT_NUMBER_PUSHS=0;

    ## Only continues with we've a local and remote branch.
    test -z "$GIT_LOCAL_BRANCH"  && return;
    test -z "$GIT_REMOTE_BRANCH" && return;

    GIT_NUMBER_PUSHS=$(                                 \
        git log 2> /dev/null                            \
        $GIT_REMOTE_BRANCH..$GIT_LOCAL_BRANCH --oneline \
        | wc -l                                         \
    );

    ## We want the digit instead of a empty space...
    test -z $GIT_NUMBER_PUSHS && GIT_NUMBER_PUSHS=0;
}

n2o_find_number_pulls()
{
    unset GIT_NUMBER_PULLS;
    GIT_NUMBER_PULLS=0;

    ## Only continues with we've a local and remote branch.
    test -z "$GIT_LOCAL_BRANCH"  && return;
    test -z "$GIT_REMOTE_BRANCH" && return;

    GIT_NUMBER_PULLS=$(                                 \
        git log 2> /dev/null                            \
        $GIT_LOCAL_BRANCH..$GIT_REMOTE_BRANCH --oneline \
        | wc -l                                         \
    );

    ## We want the digit instead of a empty space...
    test -z $GIT_NUMBER_PULLS && GIT_NUMBER_PULLS=0;
}

check_something_todo()
{
    unset GIT_HAS_SOMETHING_TODO;
    GIT_HAS_SOMETHING_TODO="false";

    ## Not in a git repo...
    test -z "$GIT_REPO_NAME" && return;

    test "$GIT_LAST_TAG_SYNCED_WITH_REMOTE" != "0" && GIT_HAS_SOMETHING_TODO="true";
    test "$GIT_NUMBER_CHANGES"              != "0" && GIT_HAS_SOMETHING_TODO="true";
    test "$GIT_NUMBER_PUSHS"                != "0" && GIT_HAS_SOMETHING_TODO="true";
    test "$GIT_NUMBER_PULLS"                != "0" && GIT_HAS_SOMETHING_TODO="true";
}


##----------------------------------------------------------------------------##
## GIT String Functions                                                       ##
##----------------------------------------------------------------------------##
build_str_number_changes()
{
    unset STR_NUMBER_CHANGES;

    ## Green -> No changes
    ## Red   -> With changes.
    STR_NUMBER_CHANGES=${FG_G};
    test $GIT_NUMBER_CHANGES != 0 && STR_NUMBER_CHANGES=${FG_R};

    STR_NUMBER_CHANGES+="$GIT_NUMBER_CHANGES${RESET}";
}

build_str_number_pulls()
{
    unset STR_NUMBER_PULLS;

    ## Green -> No changes
    ## Red   -> With changes.
    STR_NUMBER_PULLS=${FG_G};
    test $GIT_NUMBER_PULLS != 0 && STR_NUMBER_PULLS=${FG_R};

    STR_NUMBER_PULLS+="$GIT_NUMBER_PULLS${RESET}";
}

build_str_number_pushs()
{
    unset STR_NUMBER_PUSHS;

    ## Green -> No changes
    ## Red   -> With changes.
    STR_NUMBER_PUSHS=${FG_G};
    test $GIT_NUMBER_PUSHS != 0 && STR_NUMBER_PUSHS=${FG_R};

    STR_NUMBER_PUSHS+="$GIT_NUMBER_PUSHS${RESET}";
}

build_str_last_tag()
{
    unset STR_LAST_TAG;
    test -z $GIT_LAST_TAG && return;

    ## When tag is not syncronized show it in red background.
    STR_LAST_TAG=${FG_Y};
    test $GIT_LAST_TAG_SYNCED_WITH_REMOTE != 0 && STR_LAST_TAG=${BG_R};

    STR_LAST_TAG+="$GIT_LAST_TAG${RESET}";
}

calculate_git_line_length()
{
    unset GIT_LINE_LENGTH;
    GIT_LINE_LENGTH=${#GIT_CLEAN_LINE};
}


##----------------------------------------------------------------------------##
## Set functions                                                              ##
##----------------------------------------------------------------------------##
n2o_set_git_info()
{
    unset GIT_COLOR_LINE;
    unset GIT_HAS_SOMETHING_TODO;

    GIT_COLOR_LINE="";
    GIT_CLEAN_LINE=""
    GIT_LINE_LENGTH=0;

    ## Assume that we're in git dir and get the local branch name.
    n2o_find_repo_name;

    ## Only continues with we have the local branch...
    test -z "$GIT_REPO_NAME" && return;

    n2o_find_local_branch;
    n2o_find_number_commits;
    n2o_find_remote_branch;
    n2o_find_last_tag;
    n2o_find_number_pushs;
    n2o_find_number_pulls;

    build_str_last_tag;
    build_str_number_changes;
    build_str_number_pulls;
    build_str_number_pushs;

    ## Last tag.
    if [ -n "$GIT_LAST_TAG" ]; then
         GIT_CLEAN_LINE="[$GIT_LAST_TAG]";
         GIT_COLOR_LINE="[$STR_LAST_TAG]";
    fi;

    ## Number of changes.
    GIT_CLEAN_LINE+="[$GIT_NUMBER_CHANGES]";
    GIT_COLOR_LINE+="[$STR_NUMBER_CHANGES]";

    ## Local branch.
    GIT_CLEAN_LINE+="[${GIT_REPO_NAME}:${GIT_LOCAL_BRANCH}]";
    GIT_COLOR_LINE+="[${GIT_REPO_NAME}:${GIT_LOCAL_BRANCH}]";

    ## Remote info...
    if [ -n "$GIT_REMOTE_BRANCH" ]; then
        GIT_CLEAN_LINE+="[$GIT_REMOTE_BRANCH]";
        GIT_COLOR_LINE+="[$GIT_REMOTE_BRANCH]";

        GIT_CLEAN_LINE+="($GIT_NUMBER_PUSHS/$GIT_NUMBER_PULLS)";
        GIT_COLOR_LINE+="($STR_NUMBER_PUSHS/$STR_NUMBER_PULLS)";
    fi;

    calculate_git_line_length;
    check_something_todo;
}

n2o_set_dir_info()
{
    unset DIR_LINE;
    unset DIR_LINE_LENGTH;

    ##--------------------------------------------------------------------------
    ## If we are / or one level below / (ex: /usr, /bin)
    ## take more care to not print extra slashes.
    local head_path=$(basename "$(dirname "$PWD")");
    local tail_path=$(basename "$PWD");
    local separator="/";

    if [ "$head_path" == "/" ]; then
        separator="";
        if [ "$tail_path" == "/" ]; then
            tail_path="";
        fi;
    fi;

    DIR_LINE="$head_path$separator$tail_path";

    local dir_info_size=${#DIR_LINE};
    local max_dir_info_size=$(( $COLUMNS - ($GIT_LINE_LENGTH + 2) ));
                                            #2 is for [ ] in the dir info.

    if [ "$dir_info_size" -gt "$max_dir_info_size" ]; then
                                                #3 is for the ellipsis ...
        local chars_to_cut=$(( (dir_info_size - max_dir_info_size) + 3 ));
        DIR_LINE="..."${DIR_LINE:$chars_to_cut:$dir_info_size }
    fi;


    local SC=${BG_W};
    local EC=${RESET};

    if [ -n "$GIT_REPO_NAME" ]; then
        SC=${BG_G}

        if [ "$GIT_HAS_SOMETHING_TODO" != "false" ]; then
            SC=${BG_R};
        fi;
    fi

    SC+=${FG_K};

    DIR_LINE="[$DIR_LINE]";
    DIR_LINE_LENGTH=${#DIR_LINE};

    DIR_LINE="${SC}$DIR_LINE${EC}";
}

n2o_set_status_line()
{
    local spaces_len=$(( COLUMNS - (DIR_LINE_LENGTH + GIT_LINE_LENGTH) ));
    local line_max=$(( LINES ));

    ##--------------------------------------------------------------------------
    ## \e[ introduces most of the special commands
    ## \e[s saves the current cursor position
    ## \e[L,CH positions the cursor at row line, column column
    ## \e[K clears to end of line
    ## \e[u restores the cursor position
    echo -en "\033[s\033[$line_max;1H"
    echo -en "\033[K"

    echo -en "$DIR_LINE";
    for i in $(seq 1 $spaces_len); do
        echo -en " ";
    done

    echo -en $GIT_COLOR_LINE;

    echo -en "\033[u";
}


n2o_update_status_line()
{
    n2o_set_git_info
    n2o_set_dir_info
    n2o_set_status_line
}

n2o_update_status_line;
