#!/bin/bash

sync_slink6400() {
    # TODO: make 20y sql dump in cronjob on sermel
    # TODO: mount 20y via sshfs
    # Sync $HOME
    rsync -a /home/gabor /media/slinkpassport/slink6400
    # Sync webroot
    sudo rsync -a /var/www/html /media/slinkpassport/slink6400
}

sync_git_repos() {
    
    GIT_REPOS=("/home/gabor/dev/webma/" "/home/gabor/slink/" "/home/gabor/")

    # GNOME keyring daemon doesn't read SSH config for the proper key path
    if [ `/sbin/pidof gnome-keyring-daemon | wc -c` -gt 1 ] ; then
        killall gnome-keyring-daemon
    fi

    # First pull off changes from repository, then push local commits
    for ((i = 1; i <= ${#GIT_REPOS[@]}; i++ )) {
        cd ${GIT_REPOS[$i]}
        echo Pulling of changes from master to ${GIT_REPOS[$i]}...
        git pull origin master
        nr=`git diff --raw | wc -l`
        if [ $nr -eq 0 ]; then
            echo Pushing commits from ${GIT_REPOS[$i]}...
            git push
        else
            echo -n $nr "uncommited changes, continue? (y/n) "
            read yes_or_no
            if [ "${yes_or_no}" = "y" ] ; then
                git push
            fi
        fi
        cd -
    }

}

export -f sync_slink6400
export -f sync_git_repos
