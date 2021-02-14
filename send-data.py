#!/usr/bin/python3

from pprint import pprint
import re
import os.path

nbpokemons = 898

def get_categories():
    '''
        Get all categories name
        Return an array of objects
    '''
    categories = []
    for i in range (1,nbpokemons+1):
        with open("data/" + str(i) ) as f:
            content = f.read().splitlines()
            if (re.search("\d \d \d \d \d",content[1])):
                categories.append(content[5])
            else :
                for i in range (len(content)):
                    if (re.search("\d \d \d \d \d",content[i])):
                        categories.append(content[i+4])
    categories = list(dict.fromkeys(categories)) # delete duplicatas
    categories.sort()
    result= []
    for i in range(len(categories)):
        result.append({"id": i, "name" : categories[i] })
    return result

def get_abilities():
    '''
        Get all abilities name
        Return an array of objects
    '''
    abilities = []
    for i in range (1,nbpokemons+1):
        with open("data/" + str(i) ) as f:
            content = f.read().splitlines()
            if (re.search("\d \d \d \d \d",content[1])):
                abilities.append(content[6])
            else :
                for i in range (len(content)):
                    if (re.search("\d \d \d \d \d",content[i])):
                        nb_abilities = 0
                        while (not re.search("\d \d \d \d \d",content[i+5+nb_abilities])) and (i + 5 + nb_abilities < len(content) - 1) and (len(content[i+5+nb_abilities]) < 15 ):
                            abilities.append(content[i+5+nb_abilities])
                            nb_abilities+=1
    abilities = list(dict.fromkeys(abilities)) # delete duplicatas
    abilities.sort()
    result= []
    for i in range(len(abilities)):
        result.append({"id": i, "name" : abilities[i] })
    return result

def get_evolutions ():
    '''
        Get all evolutions
        Return an array of arrays
    '''
    especes = []
    for i in range (1,nbpokemons+1):
        with open("data/" + str(i) ) as f:
            content = f.read().splitlines()
            name = content[0].split(" ")[1]
            for i in range(len(content)):
                line = content[i]
                if ("a" <= line[0] <= "z") and (not (line.startswith("https"))):
                    if name == line :
                        especes.append(content[i:])
                    break
    evolutions = []
    for i in range(len(especes)):
        evolutions.append({ "id" : i+1, "pokemons" : especes[i]})
    return evolutions

def get_stats (types, evolutions, categories, abilities):
    pokemons = []
    for i in range (1,nbpokemons+1):
        with open("data/" + str(i) ) as f:
            content = f.read().splitlines()

            pokemon = {}

            if (re.search("\d \d \d \d \d",content[1])):
                pokemon = {
                    "id" : int(content[0].split(" ")[0]),
                    "name" : content[0].split(" ")[1],
                    "generation" : int(content[0].split(" ")[2]),
                    "image" : os.path.basename(content[2])
                }
                # Evolutions
                for evolution in evolutions:
                    for espece in evolution["pokemons"]:
                        if pokemon["name"] == espece:
                            pokemon["evolutionsId"] =  evolution["id"]
                            break
                    if 'evolutionsId' in pokemon.keys():
                        break
                # Types
                for i in range(len(content[7].split(" "))):
                    for j in types:
                        if content[7].split(" ")[i] == j["name"]:
                            pokemon["idType_"+str(i)] = j["id"]
                # Catégories
                for categorie in categories:
                    if categorie["name"] == content[5] :
                        pokemon["categorieId"] = categorie["id"]
                #Stats
                stats = content[1].split(" ")
                pokemon["stats"] = {
                    "HP" : int(stats[0]),
                    "Attack" : int(stats[1]),
                    "Defense" : int(stats[2]),
                    "SpecialAttack" : int(stats[3]),
                    "SpecialDefense" : int(stats[4]),
                    "Speed" : int(stats[5]),
                }
            else:
                pokemon = {
                    "id" : int(content[0].split(" ")[0]),
                    "name" : content[0].split(" ")[1],
                    "generation" : int(content[0].split(" ")[2])
                }
                nbform = 1
                while not re.search("\d \d \d \d \d",content[nbform+1]):
                    nbform+=1
                    pokemon["form_"+str(nbform)] = { "name" : content[nbform]}   
                stats = content[nbform+1].split(" ")
                pokemon["stats"] = {
                    "HP" : int(stats[0]),
                    "Attack" : int(stats[1]),
                    "Defense" : int(stats[2]),
                    "SpecialAttack" : int(stats[3]),
                    "SpecialDefense" : int(stats[4]),
                    #"Speed" : int(stats[5]),
                }
                pokemon["image"] = os.path.basename(content[nbform+2]) 
            pokemons.append(pokemon)
    return pokemons

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
abilities = get_abilities()
pokemons = get_stats(types, evolutions, categories, abilities)

# pprint(evolutions) # there is 902 pokemons ! (whereas only 898 exists)
# pprint(types) Ok
# pprint(categories) # Ok
# pprint(abilities) #Ok
# pprint(pokemons) # ~

####### Debug for evolutions
# compteur = 0
# for especes in evolutions:
#     compteur += len(especes["pokemons"])

# if compteur == nbpokemons:
#     print("evolutions ok")
# else :
#     print(compteur)
#     for i in range (1,nbpokemons+1):
#         with open("data/" + str(i) ) as f:
#             content = f.read().splitlines()
#             name = content[0].split(" ")[1]
#             isPresent = False
#             for especes in evolutions:
#                 if name in especes["pokemons"]:
#                     isPresent = True
#                     break
#             if not isPresent:
#                 print(name, i)
####################

# Send to db
from pymongo import MongoClient
client = MongoClient('mongodb://162.38.112.117:27017/')
db = client['woa-pokemon']

collection = db['pokemons']
collection.drop()
collection.insert_many(pokemons)
print("pokemons :",collection.count_documents({}))

collection = db['types']
collection.drop()
collection.insert_many(types)
print("types :",collection.count_documents({}))

collection = db['evolutions']
collection.drop()
collection.insert_many(evolutions)
print("evolutions :",collection.count_documents({}))

collection = db['categories']
collection.drop()
collection.insert_many(categories)
print("categories :",collection.count_documents({}))

collection = db['abilities']
collection.drop()
collection.insert_many(abilities)
print("abilities :",collection.count_documents({}))



