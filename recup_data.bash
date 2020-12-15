#!/bin/bash

id=1 # pokemon identiant of national pokedex
gen=1 # number of the genertaion of the pokemon 
idGen=1 # pokemon identifiant of the current generation
pokemonByGen="151 100 135 107 156 72 88 89" # number of pokemons by generation

for nbPokemons in $pokemonByGen
do
    while [ $idGen -le $nbPokemons ]
    do
        name=`curl -Ls -o /dev/null -w %{url_effective} https://www.pokemon.com/us/pokedex/$id | cut -d'/' -f 6`;

        echo $id $name $gen
        ((id=id+1))
        ((idGen+=1))
    done
    ((idGen=1))
    ((gen+=1))
done