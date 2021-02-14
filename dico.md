# idée

## Dictionnaire de donnée

champ | description | type
- | - | -
idPokemon | numéro pokémon national | int
type | type du pokémon | string
region | région | string
nom | nom du pokemon | string
generation | génération du pokémon | int

date_premiere_parution | date de la premère parution | date
 
## Liste des pokémons

https://en.wikipedia.org/wiki/List_of_Pok%C3%A9mon#List_of_species
document.getElementsByClassName("wikitable")[2].innerHTML

https://www.pokemon.com/us/pokedex/

https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_element_nextelementsibling
<!DOCTYPE html>
<html>
<body>

<p>Example list:</p>

<ul>
  <li id="item1">Coffee (first li)</li>
  <li id="item2">Tea (second li)</li>
    <li id="item2">Tea (szazadecond li)</li>
</ul>

<p>Click the button to get the HTML content of the next sibling of the first list item.</p>

<button onclick="myFunction()">Try it</button>

<p><strong>Note:</strong> The nextElementSibling property is not supported in IE8 and earlier versions.</p>

<p id="demo"></p>

<script>
var a = document.getElementById("item1")
function myFunction() {
  a = a.nextElementSibling
  var x = a.innerHTML; 
  document.getElementById("demo").innerHTML = x;
}
</script>

</body>
</html>


## Chosir sa base de donnée

Théorème CAP

## recup data

data in class pokedex-pokemon-details in page [https://www.pokemon.com/us/pokedex/<name_of_the_pokemon>]()

image cat pokemon/1 | grep -E "(img).*https://assets.pokemon.com/assets/cms2/img/pokedex/full.*png" | cut -d'"' -f 4

stats cat pokemon/1 | grep 'data-value' | sed -E 's/.*([[:digit:]]).*/\1/'
hp | attack | defense | special attack | special defense | speed

cat pokemon/1 | grep -E '<span class="attribute-value">.*<' | sed -E 's/ *<span class="attribute-value">([^<]+)<\/span>/\1/'

type
cat pokemon/1 | grep '<a href="/us/pokedex/?type=.*">.*</a>' | sed -E 's/^[^<]*<a href="\/us\/pokedex\/\?type=[[:alpha:]]+">([^<]+)<\/a>/\1/g' 

evolve

cat pokemon/1 | grep -E '^ +([[:alpha:]]+)$' | head -n 4 | tail -n 3 | sed 's/^ *//g'

wget -O

Si le pokemon a plusieurs formes : cat html-base/3 | grep '<select id="formes" name="formes" >'