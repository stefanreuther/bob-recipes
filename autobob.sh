#!/bin/bash
#
#  bob auto builder
#
#  Configure SCM to create a file "/tmp/cvs_commit_marker" on every commit.
#  This will start a rebuild after every commit.
#

MARKER=/tmp/cvs_commit_marker

list() {
    find links -type l -printf "%p -> %l\\n" | sort
}

log() {
    echo "[$(date +"%Y/%m/%d %H:%M:%S")] $@"
}

if test -z "$BASH_VERSION"; then
    echo "Please run me with bash."
    exit 1
fi

while true; do
    # Wait for marker to disappear
    log 'Got trigger, waiting for it to settle...'

    # Remove the marker and wait until it remains gone
    while test -f $MARKER; do
        rm $MARKER
        sleep 5
    done
    log 'Done, building...'

    # OK, build time!
    # - make room for log file
    test -d builds || mkdir builds

    # - set time variables (in one 'date' invocation to get the same value in both)
    eval $(date +"name=%Y%m%d.%H%M%S start=%s")

    # - remember previous state of link farm
    links=/tmp/__$$_$start.txt
    list >$links

    # - build
    pkg=$(bob ls --sandbox -p "ci::*"; bob ls --sandbox -d "ci::*")
    bob dev --sandbox $pkg >builds/$name.log 2>builds/$name.err
    state=$?

    # - rebuild the link farm
    test -d links || mkdir links
    bob query-path --sandbox $pkg | while read a b; do
                              n=${a//\//_}
                              n=${n//::/_}
                              ln -nsf "../$b" "links/$n"
                          done

    # - generate summary
    eval $(date +"end=%s")
    (
        if test $state = 0; then
            echo "=== Build $name succeeded ==="
        else
            echo "=== Build $name FAILED with status $state ==="
            kdialog --passivepopup "Build $name FAILED with status $state"
        fi
        echo "Time taken: $((end - start)) seconds"
        if list | diff -q $links - >/dev/null; then
            echo "No location changes."
        else
            echo "Location changes:"
            list | comm -13 $links -
        fi
        rm -f $links
    ) | tee builds/$name.sum | sed "s/^/  /"

    # Wait for next iteration
    log 'Ready.'
    while test \! -f $MARKER; do sleep 5; done
done
