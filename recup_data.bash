#!/bin/bash

i=1

while [ $i -le 20 ]
do
    name=`curl -Ls -o /dev/null -w %{url_effective} https://www.pokemon.com/us/pokedex/$i | cut -d'/' -f 6`
    echo $i $name
    ((i=i+1))
done