%% Parte 1

%% Pokemones

pokemon(pikachu, electrico).
pokemon(charizard, fuego).
pokemon(venusaur, planta).
pokemon(blastoise, agua).
pokemon(totodile, agua).
pokemon(snorlax, normal).
pokemon(rayquaza, dragon).
pokemon(rayquaza, volador).
pokemon(penguin, hielo).

%% Entrenadores

entrenador(ash,pikachu).
entrenador(ash,charizard).
entrenador(brock,snorlax).
entrenador(misty,blastoise).
entrenador(misty,venusaur).
entrenador(misty,arceus).


%% Punto 1
esMultiple(PokemonElegido):-
    pokemon(PokemonElegido, Tipo1),
    pokemon(PokemonElegido, Tipo2),
    Tipo1 \= Tipo2.

%% Punto 2
nadieLoTiene(Entrenador, PokemonElegido):- pokemon(PokemonElegido, _), not(entrenador(Entrenador, PokemonElegido)).

esLegendario(PokemonElegido):- esMultiple(PokemonElegido), nadieLoTiene(_,PokemonElegido).

%% Punto 3
esMisterioso(PokemonElegido):- nadieLoTiene(Entrenador,PokemonElegido).

esMisterioso(PokemonElegido):- unicoTipo(PokemonElegido).

unicoTipo(PokemonElegido):-
    pokemon(PokemonElegido, Tipo),
    not((pokemon(PokemonElegido, Tipo), pokemon(OtroPokemonElegido, Tipo), OtroPokemonElegido \= PokemonElegido)).


%% Parte 2 
movimiento(pikachu, fisico(mordida, 95)).
movimiento(pikachu, especial(impactrueno, 40, electrico)).

movimiento(charizard, especial(garraDragon, 100, dragon)).
movimiento(charizard, fisico(mordida, 95)).

movimiento(blastoise, defensivo(proteccion, 0.1)).
movimiento(blastoise, fisico(placaje, 50)).

movimiento(arceus, defensivo(alivio, 1.0)).
movimiento(arceus, especial(impactrueno, 40, electrico)).
movimiento(arceus, defensivo(proteccion, 0.1)).
movimiento(arceus, fisico(placaje, 50)).
movimiento(arceus, especial(garraDragon, 100, dragon)).

%% Punto 1
danoAtaque(fisico(_,Potencia), Potencia).
danoAtaque(defensivo(_,_), 0).
danoAtaque(especial(_, Potencia, Tipo), DanoHecho):-
    multiplicadorTipo(Multiplicador, Tipo),
    DanoHecho is Potencia * Multiplicador.

tipoBasico(normal).
tipoBasico(agua).
tipoBasico(fuego).
tipoBasico(planta).

multiplicadorTipo(1.5, Tipo):- tipoBasico(Tipo).
multiplicadorTipo(3, dragon).
multiplicadorTipo(1, Tipo):- not(tipoBasico(Tipo)), Tipo \= dragon.

%% Punto 2
capacidadOfensiva(PokemonElegido, CapacidadOfensiva):-
    pokemon(PokemonElegido,_),
    findall(Ataque,(movimiento(PokemonElegido, Movimiento), danoAtaque(Movimiento, Ataque)), Ataques),
    sumlist(Ataques, CapacidadOfensiva).

%% Punto 3

entrenadorPicante(Entrenador):-
    entrenador(Entrenador, _).
    forall((entrenador(Entrenador, PokemonElegido), capacidadOfensiva(PokemonElegido, Ofensivatotal), Ofensivatotal > 200)).
entrenadorPicante(Entrenador):-
    entrenador(Entrenador, _),
    forall((entrenador(Entrenador, PokemonElegido), esMisterioso(PokemonElegido))).
