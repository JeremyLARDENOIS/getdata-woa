from pprint import pprint
import re

# nbpokemons = 898
nbpokemons = 100

def get_categories():
    '''
        Get all categories name
        Return an array of objects
    '''
    categories = []
    # for i in range (1,nbpokemons+1):
    for i in range (1,nbpokemons+1):
        with open("data/" + str(i) ) as f:
            content = f.read().splitlines()
            if (re.search("\d \d \d \d \d",content[1])):
                categories.append(content[7])
            else :
                nbforms = 2
                while not (re.search("\d \d \d \d \d",content[nbforms])):
                    nbforms += 1
                categories.append(content[4+nbforms])
    categories = list(dict.fromkeys(categories)) # delete duplicatas
    categories.sort()
    result= []
    for i in range(len(categories)):
        result.append({"id": i, "name" : categories[i] })
    return result

def get_abilities(types):
    '''
        Get all abilities name
        Return an array of objects
    '''
    abilities = []
    for i in range (1,nbpokemons):
        with open("data/" + str(i) ) as f:
            content = f.read().splitlines()
            if (re.search("\d \d \d \d \d",content[1])):
                abilities.append(content[8])
    abilities = list(dict.fromkeys(abilities)) # delete duplicatas
    abilities.sort()
    result= []
    for i in range(len(abilities)):
        result.append({"id": i, "name" : abilities[i] })
    return result

def get_stats (types, categories, abilities):
    with open("data/1") as f:
        content = f.read().splitlines()

        if (re.search("\d \d \d \d \d",content[1])):
            pokemon = {
                "id" : content[0].split(" ")[0],
                "nom" : content[0].split(" ")[1],
                "gen" : content[0].split(" ")[2],
                "description1" : content[3],
                "description2" : content[4],
            }
            evolution = content[10:]
        else:
            pass
    return pokemon

def get_evolutions ():
    '''
        Get all evolutions
        Return an array of arrays
    '''
    evolutions = []
    for i in range (1,nbpokemons):
        with open("data/" + str(i) ) as f:
            content = f.read().splitlines()
            if (re.search("\d \d \d \d \d",content[1])):
                # Fix when pokemons have more than one abilities
                # We use the fact that type of pokemon begin by a maj whereas pokemons's name not
                if ( "A" <= content[10][0] <= "Z"):
                    especes = content[11:]
                else:
                    especes = content[10:]
            else :
                nbforms = 2
                while not (re.search("\d \d \d \d \d",content[nbforms])):
                    nbforms += 1
                especes=content[10*nbforms:]
            if not (especes in evolutions):
                evolutions.append(especes)
    return evolutions

types = [
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
evolutions = get_evolutions()
categories = get_categories()
abilities = get_abilities(types)

compteur = 0
for especes in evolutions:
    compteur += len(especes)

# if compteur == nbpokemons:
#     print("evolutions ok")
# else :
#     print (compteur)

# pprint(evolutions)
# pprint(types)
# pprint(categories)
# pprint(abilities)

