#!/bin/bash

get_html() {

    id=1 # pokemon identiant of national pokedex
    gen=1 # number of the genertaion of the pokemon 
    idGen=1 # pokemon identifiant of the current generation
    pokemonByGen="151 100 135 107 156 72 88 89" # number of pokemons by generation
    
    have_data=$(test -f data.txt; echo $?)
        
    for nbPokemons in $pokemonByGen
    do
        while [ $idGen -le $nbPokemons ]
        do            
            if [ ! $have_data -eq 0 ]
            then
                echo get name of pokemon $id
                name=`curl -Ls -o /dev/null -w %{url_effective} https://www.pokemon.com/us/pokedex/$id | cut -d'/' -f 6`;
                echo $id $name $gen >> data.txt
            fi
            
            if [ ! -f html-base/$id ]
            then
                    echo get https://www.pokemon.com/us/pokedex/$id
                    wget -O html-base/$id https://www.pokemon.com/us/pokedex/$id
            fi

            ((id=id+1))
            ((idGen+=1))
        done
        echo end gen $gen
        ((idGen=1))
        ((gen+=1))
    done
}

get_data (){
    # Arg : pokeId (int)
    # return : 0 if ok, else if other
    # Detail : Get datas of a pokeId

    for pokeId in $(seq 1 $(ls -w 1 html-base | wc -l))
    do
        if [ ! -f data/$pokeId ]
        then
            # If there is only one forme :
            if [ $(cat html-base/$pokeId | grep '<select id="formes" name="formes" >' | wc -l) -eq 0 ]
            then
                echo create data/$pokeId
                head -n 3 data.txt |tail -n  1 > data/$pokeId

                nbline=$(wc -l html-base/$pokeId | cut -d ' ' -f 1)

                # Fight Stats 
                # hp | attack | defense | special attack | special defense | speed
                echo $(cat html-base/$pokeId | grep 'data-value' | sed -E 's/.*([[:digit:]]).*/\1/') >> data/$pokeId

                # Image 
                cat html-base/$pokeId | grep -E "(img).*https://assets.pokemon.com/assets/cms2/img/pokedex/full.*png" | cut -d'"' -f 4 >> data/$pokeId

                # Description
                for i in $(seq 1 $nbline)
                do
                    line=$(head -n $i html-base/$pokeId | tail -n 1)
                    if [[ ! -z $(echo $line | grep '<p class="version-[yx]') ]]
                    then
                        ((i=i+2))
                        line=$(head -n $i html-base/$pokeId | tail -n 1)
                        echo $line >> data/$pokeId
                        break
                    fi
                done

                # Carecteristics
                ## Height
                ## Weight
                ## Category
                ## Abilities

                cat html-base/$pokeId | grep -E '<span class="attribute-value">.*<' | sed -E 's/ *<span class="attribute-value">([^<]+)<\/span>/\1/' >> data/$pokeId

                # Types

                echo $(cat html-base/$pokeId | grep '<a href="/us/pokedex/?type=.*">.*</a>' | sed -E 's/^[^<]*<a href="\/us\/pokedex\/\?type=[[:alpha:]]+">([^<]+)<\/a>/\1/g') >> data/$pokeId

                # Evolution

                echo $(cat html-base/$pokeId | grep -E '^ +([[:alpha:]]+)$' | head -n 4 | tail -n 3 | sed 's/^ *//g') >> data/$pokeId
            fi
        fi
    done
}

### MAIN ###

if [ -d html-base ]
then
    echo html-base exists
else
    echo create html-base
    mkdir html-base
    get_html
fi

rm -rf data
mkdir data

get_html
get_data


