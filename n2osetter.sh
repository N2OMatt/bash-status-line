##COWTODO: Add license header....
################################################################################
## COLORS                                                                     ##
################################################################################
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


################################################################################
## Find GIT Info Functions                                                    ##
################################################################################
n2o_find_local_branch()
{
    unset GIT_LOCAL_BRANCH;
    GIT_LOCAL_BRANCH=$(git branch 2> /dev/null                  \
                       | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /' \
                       | sed s/$" "/""/g); #Remove the trailing spaces.
    echo $GIT_LOCAL_BRANCH;
}

n2o_find_remote_branch()
{
    unset GIT_REMOTE_BRANCH;
    GIT_REMOTE_BRANCH=$(git branch -r | cut -d">" -f2 | sort -r | head -n1 \
                        | sed s/^" "*/""/g); #Remove the leading spaces.
    echo $GIT_REMOTE_BRANCH;
}

n2o_find_number_commits()
{
    unset GIT_NUMBER_COMMITS;
    GIT_NUMBER_COMMITS="0";

    GIT_NUMBER_COMMITS=$(git status 2> /dev/null -suno | wc -l);

    if [ "$GIT_NUMBER_COMMITS" != "0" ]; then
        GIT_HAS_SOMETHING_TODO="true";
    fi;

    echo $GIT_NUMBER_COMMITS;
}

n2o_find_last_tag()
{
    unset GIT_LAST_TAG;
    unset GIT_LAST_TAG_SYNCED_WITH_REMOTE;

    #[1] Find all tags and sort by date.
    #[2] Get the newer entries - Make multiline - Remove the ()
    #[3] Get lines with "tag" and remove it from them.
    GIT_LAST_TAG=$(git log --tags --simplify-by-decoration --pretty="format:%d" \
                   | head -n1 | sed s/","/"\n"/g | sed s/"[(|)]"/""/g           \
                   | grep tag | sed s/" tag: "/""/g);

    #Check if we have more than one tag...
    local real_last_tag=$(echo $GIT_LAST_TAG | sed s/" "/"\n"/g | head -n1);
    if [ "$real_last_tag" != "$GIT_LAST_TAG" ]; then
        GIT_LAST_TAG="$real_last_tag+"; #Append a + sign to indicate this.
    fi;


    # 1 - Get all log with tags - refs and remotes
    # 2 - Get all commit [SHA] lines only
    # 3 - Remote the commit [SHA] stuff.
    # 4 - Just add numbers...
    # 5 - Get the line that has the info about our current remote.
    # 6 - Get the number added in step #4.
    local remote_commit=$(git log --decorate=full                 | \
                          egrep  "commit [[:alnum:]]{40} .*"      | \
                          sed -r s/"commit [[:alnum:]]{40} "/""/g | \
                          egrep -n "*"                            | \
                          egrep "refs/remotes/$GIT_REMOTE_BRANCH" | \
                          cut -d":" -f1);

    #Same from remote_commit, but the the our current tag info.
    local tag_commit=$(git log --decorate=full                 | \
                       egrep  "commit [[:alnum:]]{40} .*"      | \
                       sed -r s/"commit [[:alnum:]]{40} "/""/g | \
                       egrep -n "*"                            | \
                       egrep "refs/tags/$GIT_LAST_TAG"         | \
                       cut -d":" -f1);

    #Check if them are equal...
    if [ "$remote_commit" = "$tag_commit" ]; then
        GIT_LAST_TAG_SYNCED_WITH_REMOTE="true";
    else
        GIT_LAST_TAG_SYNCED_WITH_REMOTE="false";
        GIT_HAS_SOMETHING_TODO="true";
    fi;

    echo $GIT_LAST_TAG;
}

n2o_find_number_pushs()
{
    unset GIT_NUMBER_PUSHS;
    GIT_NUMBER_PUSHS="0";

    #We must have local and remote to do this.
    if [ -n "$GIT_LOCAL_BRANCH" -a -n "$GIT_REMOTE_BRANCH" ]; then
        GIT_NUMBER_PUSHS=$(git log 2> /dev/null \
                           $GIT_REMOTE_BRANCH..$GIT_LOCAL_BRANCH --oneline \
                           | wc -l);
    fi;

    if [ "$GIT_NUMBER_PUSHS" != "0" ]; then
        GIT_HAS_SOMETHING_TODO="true";
    fi;

    echo $GIT_NUMBER_PUSHS;
}

n2o_find_number_pulls()
{
    unset GIT_NUMBER_PULLS;
    GIT_NUMBER_PULLS="0";

    #We must have local and remote to do this.
    if [ -n "$GIT_LOCAL_BRANCH" -a -n "$GIT_REMOTE_BRANCH" ]; then
        GIT_NUMBER_PULLS=$(git log 2> /dev/null \
                           $GIT_LOCAL_BRANCH..$GIT_REMOTE_BRANCH --oneline \
                           | wc -l);
    fi;

    if [ "$GIT_NUMBER_PULLS" != "0" ]; then
        GIT_HAS_SOMETHING_TODO="true";
    fi;

    echo $GIT_NUMBER_PULLS;
}

################################################################################
## Build GIT Info String Functions                                            ##
################################################################################
n2o_build_str_git_local_branch()
{
    GIT_INFO+="[$GIT_LOCAL_BRANCH]";
    GIT_TOTAL_CHARS=$(( GIT_TOTAL_CHARS + ${#GIT_LOCAL_BRANCH} + 2 ));
}

n2o_build_str_git_remote_branch()
{
    if [ -z "$GIT_REMOTE_BRANCH" ]; then
        return;
    fi;

    GIT_INFO+="[$GIT_REMOTE_BRANCH]";
    GIT_TOTAL_CHARS=$(( GIT_TOTAL_CHARS + ${#GIT_REMOTE_BRANCH} + 2 ));
}

n2o_build_str_git_number_commits()
{
    local SC="${FG_R}";
    local EC="${RESET}";

    if [ "$GIT_NUMBER_COMMITS" = "0" ]; then
        SC="${FG_G}";
    fi;

    GIT_INFO+="[${SC}$GIT_NUMBER_COMMITS${EC}]";
    GIT_TOTAL_CHARS=$(( GIT_TOTAL_CHARS + ${#GIT_NUMBER_COMMITS} + 2 ));
}

n2o_build_str_git_last_tag()
{
    if [ -z "$GIT_LAST_TAG" ]; then
        return;
    fi;

    local SC="${FG_R}";
    local EC="${RESET}";

    if [ "$GIT_LAST_TAG_SYNCED_WITH_REMOTE" == "true" ]; then
        SC="${FG_G}";
    fi

    GIT_INFO+="(${SC}$GIT_LAST_TAG${EC})";
    GIT_TOTAL_CHARS=$(( GIT_TOTAL_CHARS + ${#GIT_LAST_TAG} + 2 ));
}

n2o_build_str_git_number_pushs()
{
    if [ -z "$GIT_REMOTE_BRANCH" ]; then
        return;
    fi;

    local SC="${FG_R}";
    local EC="${RESET}";

    if [ "$GIT_NUMBER_PUSHS" = "0" ]; then
        SC="${FG_G}";
    fi;

    GIT_INFO+="(${SC}$GIT_NUMBER_PUSHS${EC}/";
    GIT_TOTAL_CHARS=$(( GIT_TOTAL_CHARS + ${#GIT_NUMBER_PUSHS} + 2 ));
}

n2o_build_str_git_number_pulls()
{
    if [ -z "$GIT_REMOTE_BRANCH" ]; then
        return;
    fi;

    local SC="${FG_R}";
    local EC="${RESET}";

    if [ "$GIT_NUMBER_PULLS" = "0" ]; then
        SC="${FG_G}";
    fi;

    GIT_INFO+="${SC}$GIT_NUMBER_PULLS${EC})";
    GIT_TOTAL_CHARS=$(( GIT_TOTAL_CHARS + ${#GIT_NUMBER_PULL} + 2 ));
}


################################################################################
## Set functions                                                              ##
################################################################################
n2o_set_git_info()
{
    unset GIT_INFO;
    unset GIT_TOTAL_CHARS;
    unset GIT_HAS_SOMETHING_TODO;

    GIT_TOTAL_CHARS=0;
    GIT_HAS_SOMETHING_TODO="false";

    ##Assume that we're in git dir and get the local branch name.
    n2o_find_local_branch > /dev/null;

    #Not in a git repo - Nothing to do anymore...
    if [ -z $GIT_LOCAL_BRANCH ]; then
        return;
    fi

    n2o_find_last_tag       > /dev/null;
    n2o_find_number_commits > /dev/null;
    n2o_find_remote_branch  > /dev/null;
    n2o_find_number_pushs   > /dev/null;
    n2o_find_number_pulls   > /dev/null;

    n2o_build_str_git_last_tag;
    n2o_build_str_git_local_branch;
    n2o_build_str_git_number_commits;
    n2o_build_str_git_remote_branch;
    n2o_build_str_git_number_pushs;
    n2o_build_str_git_number_pulls;
}

n2o_set_dir_info()
{
    unset DIR_INFO;
    unset DIR_TOTAL_CHARS;

    #COWTODO: We must handle the root.
    DIR_INFO=$(basename $(dirname "$PWD"))/$(basename "$PWD")

    DIR_INFO_SIZE=${#DIR_INFO};
    CHARS_TO_CUT=$(( ($COLUMNS - (${#DIR_INFO} + $GIT_TOTAL_CHARS)) * -1 ));

    if [ $CHARS_TO_CUT -gt 0 ]; then
        CHARS_TO_CUT=$(( CHARS_TO_CUT + 6 ));
        DIR_INFO="..."${DIR_INFO:$CHARS_TO_CUT:$DIR_INFO_SIZE }
    fi;

    SC=${BG_G};
    EC=${RESET};

    if [ "$GIT_HAS_SOMETHING_TODO" = "true" ]; then
        SC=${BG_R};
    fi;

    SC+=${FG_K};

    DIR_INFO="[$DIR_INFO]";
    DIR_TOTAL_CHARS=${#DIR_INFO};

    DIR_INFO="${SC}$DIR_INFO${EC}";
}

n2o_set_status_line()
{
    local lines=`tput lines`

    tput sc #Save the cursor.

    non_scroll_line=$(($lines - 1))
    scroll_region="0 $(($lines - 2))"

    tput csr $scroll_region

    # Clear out the status line
    tput cup $non_scroll_line 0
    tput rc

    # Reprint the status line
    tput cup $non_scroll_line 0

    local spaces_len=$(( COLUMNS - (DIR_TOTAL_CHARS + GIT_TOTAL_CHARS) ));

    echo -en $DIR_INFO;
    for i in $(seq 1 $spaces_len); do
        echo -en " ";
    done
    echo -en $GIT_INFO;

    tput rc
}


n2o_update_status_line()
{
    n2o_set_git_info
    n2o_set_dir_info
    n2o_set_status_line
}
