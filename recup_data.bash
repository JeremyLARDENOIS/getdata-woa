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

    get_type(){
        # Arg : pokeId (int)
        # return : 0 if ok, else if other
        # Detail : Get type of a pokeId
        pokeId=$1

        nblines=$(cat html-base/$pokeId | wc -l)

        for i in $(seq 1 $nblines)
        do 
            line=$(head -n $i html-base/$pokeId | tail -n 1)

            isTypeDiv=$(echo $line | grep '<div class="dtm-type">' | wc -l) # O = no; 1 = yes

            if [ $isTypeDiv -eq 1 ]
            then
                res=""
                for i in $(seq $i $nblines)
                do
                    line=$(head -n $i html-base/$pokeId | tail -n 1)
                    isEndDiv=$(echo $line | grep '</div>' | wc -l) # O = no; 1 = yes
                    
                    if [ $isEndDiv -eq 1 ]
                    then
                        break
                    else
                        isType=$(echo $line | grep '<a href="/us/pokedex/?type=.*">.*</a>' | wc -l) # O = no; 1 = yes
                        if [ $isType -eq 1 ]
                        then
                            res+=$(echo $line | grep '<a href="/us/pokedex/?type=.*">.*</a>' | sed -E 's/^[^<]*<a href="\/us\/pokedex\/\?type=[[:alpha:]]+">([^<]+)<\/a>/\1/g' )
                            res+=" " 
                        fi
                    fi
                done
                echo $res
            fi
        done
    }

    for pokeId in $(seq 1 $(ls -w 1 html-base | wc -l))
    do
        if [ ! -f data/$pokeId ]
        then
            echo create data/$pokeId - $(head -n $pokeId data.txt | tail -n 1 | cut -d' ' -f2)
            head -n $pokeId data.txt |tail -n  1 > data/$pokeId

            # Correct a bug of end of file of data.txt
            if [ $pokeId -eq 898 ]
            then
                echo '' >> data/898
            fi

            # If there is only one forme :
            if [ $(cat html-base/$pokeId | grep '<select id="formes" name="formes" >' | wc -l) -eq 0 ]
            then
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
            
             else
                # Pokemons Specials - Multi-forms             
                nb_forms=$(cat html-base/$pokeId | grep -E "(img).*https://assets.pokemon.com/assets/cms2/img/pokedex/full.*png" | wc -l)

                echo data/$pokeId have $nb_forms forms

                # Names
                cat html-base/$pokeId | grep '<img src="https://assets.pokemon.com/assets/cms2/img/pokedex/full/' | sed -E 's/^.*alt="([^"]+).*$/\1/g' >> data/$pokeId

                for num_form in $(seq 1 $nb_forms)
                do
                    # Fight Stats 
                    # hp | attack | defense | special attack | special defense | speed
                    echo $(cat html-base/3 | grep 'data-value' | sed -E 's/.*([[:digit:]]).*/\1/' | head -n $((5*num_form)) | tail -n 5) >> data/$pokeId

                    # Image
                    cat html-base/$pokeId | grep -E "(img).*https://assets.pokemon.com/assets/cms2/img/pokedex/full.*png" | sed -E 's/^.*src="([^"]+).*/\1/g' | head -n $num_form | tail -n 1 >> data/$pokeId

                    # Carecteristics
                        ## Height
                        ## Weight
                        ## Category
                        ## Abilities
                    cat html-base/3 | grep -E '<span class="attribute-value">.*<' | sed -E 's/ *<span class="attribute-value">([^<]+)<\/span>/\1/'| head -n $((4*num_form)) | tail -n 4 >> data/$pokeId

                done
                
                # Types
                get_type $pokeId >> data/$pokeId

                # Description
                for i in $(seq 1 $nbline)
                do
                    line=$(head -n $i html-base/$pokeId | tail -n 1)
                    if [[ ! -z $(echo $line | grep '<p class="version-[yx]') ]]
                    then
                        ((i=i+2))
                        line=$(head -n $i html-base/$pokeId | tail -n 1)
                        echo $line >> data/$pokeId
                    fi
                done
            fi
            # Evolution 

            cat html-base/$pokeId | grep -E '<a href="/us/pokedex/[[:alpha:]]*">' | sed -E 's/<a href="\/us\/pokedex\/([[:alpha:]]*)">$/\1/g' >> data/$pokeId
        fi
    done
}

get_img(){
    for pokeId in $(seq 1 $(ls -w 1 html-base | wc -l))
    do
        for url in $(cat data/$pokeId | grep '.*\.png')
        do
            echo img/$(basename $url)
            if [ ! -f img/$(basename $url) ]
            then
                wget $url -O img/$(basename $url) -nv
            fi
        done
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
get_html

if [ -d data ]
then
    echo html-base exists
else
    mkdir data
fi

get_data

if [ -d img ]
then
    echo img exists
else
    mkdir img
fi
get_img

echo 'node send_datas.js'
node send_datas.js
