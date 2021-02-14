#!/bin/bash

pokeId=20

rm data/$pokeId

nb_forms=$(cat html-base/$pokeId | grep -E "(img).*https://assets.pokemon.com/assets/cms2/img/pokedex/full.*png" | wc -l)
num_form=1

echo data/$pokeId have $nb_forms forms

nblines=$(cat html-base/$pokeId | wc -l)

i_form=1 # count form in loop
for i in $(seq 1 $nblines)
do
    line=$(head -n $i html-base/$pokeId | tail -n 1)
    if [ ! -z "$(echo $line | grep '<span class="attribute-title">Abilities</span>'  )" ]
    then
        if [ $i_form -eq $num_form ]
        then
            while [ -z "$(echo $line | grep '</ul>'  )" ]
            do
                if [ ! -z "$(echo $line | grep '<span class="attribute-value">')" ] 
                then
                    echo $line | sed -E "s/^<span.*>(.*)<\/span>$/\1/g"
                fi
                ((i=i+1))
                line=$(head -n $i html-base/$pokeId | tail -n 1)
            done
        fi
        ((i_form=i_form+1))
    fi
done


