#!/bin/bash

for b in minimize maximize restore close 'help' keepbelow keepabove shade alldesktops
do
    cp buttons.svg $b.svg

    for i in minimize maximize restore close 'help' keepbelow keepabove shade alldesktops delete
    do
        if [ $i != $b ] ; then
            sed -i "/<\!-- $i -->/,/<\!-- \/$i -->/d" $b.svg
        fi
    done
    sed -i "s/-$b//g" $b.svg
    gzip $b.svg
    mv $b.svg.gz $b.svgz
done