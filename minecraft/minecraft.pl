jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


%% PUNTO 1

tieneItem(Jugador, Item):-
    jugador(Jugador, Inventario, _),
    member(Item, Inventario).

sePreocupaPorSuSalud(Jugador):-

    
%% PUNTO 2


correPeligro(Jugador):-
    jugador(Jugador, _, _),
    lugar(NombreLugar, JugadorEnLugar, _),
    member(Jugador, JugadorEnLugar),
    hayMonstruos(NombreLugar).

correPeligro(Jugador):-
    jugador(Jugador, Inventario, NivelDeHambre),
    NivelDeHambre < 4,
    not(comestible(Inventario)).