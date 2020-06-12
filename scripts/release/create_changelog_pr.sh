#!/bin/bash
# Copyright 2020 The OpenEBS Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

#print_help print the help message
print_help() {
cat << EOF
Usage:
    $0 <options> TAG-NAME

Example:
    $0 -r github-org/repo-name v1.1.0-RC1

TAG-NAME is required to execute this script.
Repo Name(-r) is required for github PR link. If it is not mentioned then generated PR link will not work.

Supported options are as below. Mandatory arguments to long options are mandatory for short options too:
    -h, --help                              Show this message and exit
    -r, --repo REPO                         Github repo, in org/repo format.
                                            To raise a PR, this option is mandatory.
                                            If mentioned PR will be created in this repo.
                                            Example:
                                              -r openebs/plugin
                                              --repo openebs/plugin
    -p, --production-branch BRANCH          Name of production branch.
                                            Option -r|--repo is required to use this option.
                                            PR for changelog will be created against this mentioned branch
                                            If options -p|--production-branch and -c|--release-branch, both are
                                            mentioned then two PR will be raised.
                                            Example:
                                              -p master
                                              --production-branch master
    -c, --release-branch RELEASEBRANCH      Name of release branch.
                                            Option -r|--repo is required to use this option.
                                            PR for changelog will be created against this mentioned branch
                                            If options -p|--production-branch and -c|--release-branch, both are
                                            mentioned then two PR will be raised.
                                            Example:
                                              -c v1.10.x
                                              --release-branch v1.10.x


This script expects following environment variable
- USERNAME
    This is your github username, configured through git config --global user.name
    This script doesn't print your USERNAME on output

- TOKEN
    This is github token. This script doesn't print your TOKEN on output.
    To create a new token,
    refer https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line

- EMAIL
    This is your email id, configured through git config --global user.email, to sign the commit
    This script doesn't print your EMAIL on output

How this script works?
- Generating changelog
    Script will use files from directory changelogs/unreleased to create a changelog
    It will create a new directory, named tag-name, under directory changelogs/released
    and move all the files from directory changelogs/unreleased to new directory.
    Once all the files are moved to new directory, it will create a temporary file
    in /tmp/ directory and copy the content of all files, under new directory to a
    temporary file.
    If tag is release tag, like v1.1.0, and there are existing directory for rc release,
    like v1.1.0-RC1, then script will copy the contents of all files, under this rc release
    directory, to a temporary file.
    After this, script will add the content of temporary file to root changelog file
    and delete the temporary file

- Creating a branch
    Script creates a new branch named changelog-timestamp, like changelog-20200512164456

- Creating a commit
    Script will create commit with following files using your USERNAME and EMAIL
    - repo-name/CHANGELOG.md (modified)
    - repo-name/changelogs/unreleased/* (deleted)
    - repo-name/changelogs/released/tag-name (new directory)

- Pushing branch to repo
    To push the changes to github, script will add new remote, named upstream,
    using your USERNAME and TOKEN

- Creating a pull request
    Script uses github API to create a pull request, using your USERNAME and TOKEN.
    Refer https://developer.github.com/v3/pulls/#create-a-pull-request for API
EOF
}

#is_stable_tag check if given tag=$1 is stable tag or not
#if tag is v1.1.0 then it will return 0
#if tag is v1.1.0-RC1 then it will return 1
is_stable_tag() {
    [[ "$(echo $1 | cut -d '-' -f1)" == "$1" ]] && echo 0 || echo 1
}

#is_rc_tag check if given tag=$1 is RC tag or not
# if tag is v1.1.0-RC1 then it will return 0
# if tag is v1.1.0-custom-RC1 then it will return 1
# if tag is v1.1.0-RC1A then it will return 2
is_rc_tag() {
    local suffix=$(echo $1 | cut -d '-' -f2-)
    local suffix_str=${suffix::2}
    local suffix_num=${suffix:2}

    [[ "$suffix_str" != "RC" ]] && echo 1 && return
    [[ "$suffix_num" == "" ]] && echo 2 && return
    [[ $suffix_num =~ ^[0-9]+$ ]] && (echo 0 && return) || echo 2
}

#is_tag_belongs_to_release check if tag=$2 is part of release=$1
# if tag is v1.1.0-RC1 and release is v1.1.0 then it will return 0
# if tag is v1.0.0-RC1 and release is v1.1.0 then it will return 1
# if tag is v1.1.0-custom-RC1 and release is v1.1.0 then it will return 1
is_tag_belongs_to_release() {
    release=$1
    tag=$2

    [[ -z $release ]] && echo 1 && return
    [[ -z $tag ]] && echo 1 && return

    [[ "$(echo $tag | cut -d '-' -f1)" == $release ]] && echo 0 || echo 1
}

#add_changelog add the changelog from files in folder=$1 to file=$2
add_changelog() {
    cl_dir=$1
    cl_file=$2

    [[ -d $cl_dir ]] || return
    [[ -f $cl_file ]] || return 

    echo "Adding changelog from $cl_dir"

    for i in `find $cl_dir -type f`; do
        pr_number=$(echo $i | cut -d  '/' -f4 |awk -F '-' '{print $1}')
        usr_name=$(echo $i | cut -d  '/' -f4 |awk -F '-' '{print $2}')
        msg=$(cat $i)

        url_usr=https://github.com/$usr_name
        url_pr=https://github.com/$GIT_REPO/pull/$pr_number
        echo "* $msg ([#$pr_number]($url_pr),[@$usr_name]($url_usr))" >> $cl_file
        echo -n "- $url_pr\r\n" >>  $pr_msg_file
    done
}

#update_release_date update RELEASE_DATE for the TAG
update_release_date() {
    [[ -d $GIT_REPO ]] || return 1

    echo "Getting release date for $TAG"

    req_url=https://api.github.com/repos/${GIT_REPO}/releases/tags/${TAG}

    local ofile=$(mktemp)
    local res

    res=$(curl --silent \
        -w "%{http_code}" \
        --output ${ofile} \
        --url ${req_url} \
        --request GET --header 'content-type: application/json'
    )

    if [ $res != "200" ]; then
        echo "Error: Unable to get release date for $TAG.. REST API output is as below"
        cat ${ofile}
        res=1
    else
        RELEASE_DATE=$(cat ${ofile} |jq  -r '.published_at' | cut -d 'T' -f 1)
        res=0
    fi

    rm ${ofile}
    return $res
}

#generate_changelog create the tag directory under $RELEASED_CHANGELOG_DIR
#and move all files from $UNRELEASED_CHANGELOG_DIR to new tag directory
#It also updates the $ROOT_CHANGELOG with tag changelog
generate_changelog() {
    echo "Generating Changelog for $TAG"
    local dest=$RELEASED_CHANGELOG_DIR/$TAG

    [[ -d $CHANGELOG_DIR ]] || return 3
    [[ -d $UNRELEASED_CHANGELOG_DIR ]] || mkdir $UNRELEASED_CHANGELOG_DIR
    [[ -d $RELEASED_CHANGELOG_DIR ]] || mkdir $RELEASED_CHANGELOG_DIR
    [[ -d $dest ]] || mkdir $dest

    ls $UNRELEASED_CHANGELOG_DIR/* > /dev/null 2>&1 && cp $UNRELEASED_CHANGELOG_DIR/* $dest

    cl=$(mktemp)
    echo "$TAG / $RELEASE_DATE" >> $cl
    echo "========================" >> $cl

    add_changelog $dest $cl

    if [ $(is_stable_tag $TAG) -eq 0 ]; then
        # We are creating a changelog for stable release
        # so we also need to append changelog of RC tag
        for i in `find $RELEASED_CHANGELOG_DIR  -maxdepth 1 -mindepth 1 -type d`; do
            local ltag=$(echo $i | cut -d '/' -f3)
            [[ $(is_rc_tag $ltag) -ne 0 ]] && continue
            [[ $(is_tag_belongs_to_release $TAG $ltag) -ne 0 ]] && continue
            add_changelog $i $cl
        done
    fi
    temp_file=$(mktemp)
    [[ -f $ROOT_CHANGELOG ]] && echo -e "\n" >> $cl || touch $ROOT_CHANGELOG
    cat <(cat $cl) $ROOT_CHANGELOG  > $temp_file && mv $temp_file $ROOT_CHANGELOG
    ls $UNRELEASED_CHANGELOG_DIR/* > /dev/null  2>&1 && rm $UNRELEASED_CHANGELOG_DIR/*
    rm -rf ${cl} ${temp_file} > /dev/null 2>&1
}

#create_changelog_commit creates new commit with updated $CHANGELOG_DIR and
#$ROOT_CHANGELOG
create_changelog_commit() {
    git add $CHANGELOG_DIR || return 1
    git add $ROOT_CHANGELOG || return 1
    git commit -s -m "Updating changelog for $TAG" || return 1
}

# update_git_remote adds new remote and configure git config
update_git_remote() {
    echo "Adding new remote=upstream"
    git config --global user.name ${USERNAME}
    git config --global user.email ${EMAIL}
    local repo_name=$(echo $GIT_REPO | cut -d '/' -f2)
    git remote add upstream https://${USERNAME}:${TOKEN}@github.com/$USERNAME/$repo_name.git > /dev/null 2>&1 || return $?
}

#push_branch push the given branch to remote upstream
push_branch() {
    local target_branch=$1

    [[ ! -z target_branch ]] || return 2

    echo "Pushing branch=$target_branch to upstream"
    git push upstream $target_branch || return 2
}

#cherry_pick will checkout to base branch=$1 and cherry-pick the commit=$COMMIT_ID
#and create new branch=$target_branch from given base branch=$1
cherry_pick() {
    local base_branch=$1
    local target_branch=$2
    [[ ! -z $base_branch ]] || return 1
    [[ ! -z $target_branch ]] || return 1
    [[ ! -z $COMMIT_ID ]] || return 1

    echo "Cherry-picking commit to branch=$base_branch"
    git checkout ${base_branch} || return 1
    git branch $target_branch || return 1
    git checkout $target_branch || return 1
    git cherry-pick $COMMIT_ID || return 1
    return $?
}

#raise_pr creates a PR to repo=$GIT_REPO against the given branch=$1
# from user branch=$2
raise_pr() {
    local target_branch=$1
    local from_branch=$2

    [[ ! -z $target_branch ]] || return 1
    [[ ! -z $from_branch ]] || return 1

    # file to store curl output
    local ofile=$(mktemp)
    local rc=0
    local head="$USERNAME:$from_branch"
    local _title_msg="$CHANGELOG_COMMIT_MSG in $target_branch"
    local pr_create_data='{
        "title": "'${_title_msg}'",
        "body": "'${CHANGELOG_PR_BODY}'",
        "head": "'${head}'",
        "base": "'${target_branch}'"
    }'

    res=$(curl -u ${USERNAME}:${TOKEN} --silent \
        -w "%{http_code}" \
        --output ${ofile} \
        --url ${GIT_URL} \
        --request POST --header 'content-type: application/json' \
        --data "$pr_create_data"
    )

    # if response value is 201 then PR is created successfully
    # Refer https://developer.github.com/v3/pulls/#response-2
    if [ $res != "201" ]; then
        echo "Error: Unable to create a PR for changelog.. REST API output is as below"
        cat ${ofile}
        rc=1
    else
        echo "Successfully raised a PR for changelog"
    fi

    rm -rf ${ofile}

    return $rc
}


#options followed by ':' needs an argument
# see `man getopt`
shortOpts=hr:p:c:
longOpts=help,repo,production-branch,release-branch

#store the output of getopt so that we can assign it to "$@" using set command
#since we are using "--options" in getopt, arguments are passed via -- "$@"
PARSED=$(getopt --options ${shortOpts} --longoptions ${longOpts} --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    echo "invalid arguments"
    exit 1
fi
#assign arguments to "$@"
eval set -- "${PARSED}"

while [[ $# -gt 0 ]]
do
    case "$1" in
        -h|--help)
            print_help
            exit 0
            ;;
        -r|--repo)
            shift
            GIT_REPO=$1
            ;;
        -p|--production-branch)
            shift
            GIT_PRODUCTION_BRANCH=$1
            ;;
        -c|--release-branch)
            shift
            GIT_RELEASE_BRANCH=$1
            ;;
        ## argument without options is mentioned after '--'
        --)
            shift
            TAG=$1
            break
    esac
    shift   # Expose the next argument
done

BRANCH=changelog-$(date +'%Y%m%d%H%M%S')
CHANGELOG_DIR=changelogs
UNRELEASED_CHANGELOG_DIR=changelogs/unreleased
RELEASED_CHANGELOG_DIR=changelogs/released
ROOT_CHANGELOG=CHANGELOG.md
COMMIT_ID=
RELEASE_DATE=

if [[ -z $TAG ]]; then
    print_help
    exit 1
fi

#if production/release branch is mentioned then environment variable should be set
# since we need to raise a PR against them
if [[ (! -z $GIT_PRODUCTION_BRANCH) ||  (! -z $GIT_RELEASE_BRANCH) ]] &&
    [[ (-z $USERNAME) || (-z $TOKEN) || (-z $EMAIL) ]]; then
    print_help
    exit 1
fi

#update release date variable RELEASE_DATE
update_release_date || rc =$?
if [[ $rc -ne 0 ]]; then
    echo "Failed to get release date for $TAG"
    exit 1
fi

git branch $BRANCH && git checkout $BRANCH
#pr_msg_file to store the list of PR added for changelog
pr_msg_file=$(mktemp)
rc=0
generate_changelog || rc=$?
if [[ $rc -eq 3 ]]; then
    echo "Failed to generate changelog"
    exit 1
fi

if [[ -z $GIT_PRODUCTION_BRANCH ]] && [[ -z $GIT_RELEASE_BRANCH ]]; then
    echo "Changelog generated in branch $BRANCH"
    echo -e "\nFollowing PR added for changelog"
    echo -e `cat $pr_msg_file`
    rm -rf $pr_msg_file
    exit 0
fi

echo "Changelog generated in branch $BRANCH, will raise a PR now"

update_git_remote || rc=$?
if [[ $? -ne 0 ]] && [[ $? -ne 128 ]] ; then
    echo "Failed to set git config to raise a PR"
    exit 1
fi

#PR title
CHANGELOG_COMMIT_MSG="docs(changelog): changelog for ${TAG}"
GIT_URL="https://api.github.com/repos/${GIT_REPO}/pulls"

#PR description
CHANGELOG_PR_BODY="List of the PR added in changelog:\r\n`cat $pr_msg_file`"

create_changelog_commit || rc=$?
if [[ $rc -eq 1 ]]; then
    echo "Failed to create commit"
    exit 1
fi

COMMIT_ID=$(git rev-parse HEAD)
for target_branch in $GIT_PRODUCTION_BRANCH $GIT_RELEASE_BRANCH; do
    #Since we need to raise a PR in specific branch
    #we need to make sure that there are no any other changes
    #then this changelog commit
    #to do that, we will create new branch from GIT_ branch and cherry-pick
    #the changelog commit and push it to remote

    new_branch=$BRANCH-$target_branch
    cherry_pick $target_branch $new_branch && push_branch $new_branch || rc=$?
    case "$rc" in
        1)
            echo "Failed to cherry-pick changelog commit for branch=$new_branch, target-branch=$target_branch"
            exit 1
            ;;
        2)
            echo "Failed to push branch=$new_branch"
            exit 1
            ;;
    esac
    raise_pr $target_branch $new_branch || exit 1
done

rm -rf $pr_msg_file
