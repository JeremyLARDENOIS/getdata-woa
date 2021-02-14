const fs = require('fs')

function getPokemons(){
  let file=1
  let pokemons= []
  //for (let file = 1; file <= 898; file++ ){
    fs.readFile('data/' + file, 'utf8' , (err, result) => {
      if (err) {
        console.error(err)
        return
      }

      let datas=result.split('\n')
      let id=datas[0].split(" ")[0]
      let nom=datas[0].split(" ")[1]
      let gen=datas[0].split(" ")[2]
      let stats, image, description1, description2, caracteristics, elements, evolutions
      if (true) { //if it's a pokemon with only one form
        stats= {
            "hp" : datas[1].split(" ")[0],
            "attack" : datas[1].split(" ")[1],
            "defense" : datas[1].split(" ")[2],
            "special_attack" : datas[1].split(" ")[3],
            "special_defense" : datas[1].split(" ")[4],
            "speed" : datas[1].split(" ")[5]
        }
        image=datas[2]
        description1=datas[3]
        description2=datas[4]
        /*## Height
          ## Weight
          ## Category
          ## Abilities
        */
        caracteristics={
            "height" : datas[5],
            "weight" : datas[6],
            "category" : datas[7],
            "ability" : datas[8]
        }
        elements = datas[9].split(" ")
        evolutions = []
        for (const pokemon of datas.slice(10, datas.length-1)){
            evolutions.push(pokemon)
        }
      } else {
          pass
      }
      let pokemon={
        "id" : id,
        "nom" : nom,
        "gen" : gen,
        "stats" : stats,
        "image" : image,
        "description1" : description1,
        "description2" : description2,
        "caracteristics" : caracteristics,
        "types" : elements,
        "evolutions" : evolutions
      }
      await pokemons.push(pokemon)
      //console.log(pokemons)
      })
      console.log(pokemons)
      return [pokemons, evolutions]
  //}
}

const types = [
  { "id" : 1, "name": "Bug"},
  { "id" : 2, "name": "Dragon"},
  { "id" : 3, "name": "Fairy"},
  { "id" : 4, "name": "Fire"},
  { "id" : 5, "name": "Ghost"},
  { "id" : 6, "name": "Ground"},
  { "id" : 7, "name": "Normal"},
  { "id" : 8, "name": "Psychic"},
  { "id" : 9, "name": "Steel"},
  { "id" : 10, "name": "Dark"},
  { "id" : 11, "name": "Electric"},
  { "id" : 12, "name": "Fighting"},
  { "id" : 13, "name": "Flying"},
  { "id" : 14, "name": "Grass"},
  { "id" : 15, "name": "Ice"},
  { "id" : 16, "name": "Poison"},
  { "id" : 17, "name": "Rock"},
  { "id" : 18, "name": "Water"}
]
let pokemons, evolutions
[pokemons, evolutions] = getPokemons()

console.log(pokemons)
// console.log(evolutions)
// console.log(types)



