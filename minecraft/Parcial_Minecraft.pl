% BASE DE CONOCIMIENTOS
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

% 1A)
tieneItem(Jugador, Item):-
    jugador(Jugador, Items, _),
    member(Item, Items).
% 1B)
sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador, Items, _),
    member(Item, Items),
    comestible(Item),
    member(OtroItem, Items),
    comestible(OtroItem),
    Item \= OtroItem.
% 1C)
existeItem(Item):-
    tieneItem(_, Item).

cantidadDelItem(Jugador, Item, Cantidad):-
    jugador(Jugador, _, _),
    existeItem(Item),
    findall(Item, (jugador(Jugador, ItemsJugador, _), member(Item, ItemsJugador)), Items),
    length(Items, Cantidad).
% 1D)
tieneMasDe(Jugador, Item):-
    cantidadDelItem(Jugador, Item, Cantidad),
    cantidadDelItem(OtroJugador, Item, OtraCantidad),
    Cantidad > OtraCantidad, 
    Jugador \= OtroJugador.

% 2A)
hayMonstruos(Lugar):-
    lugar(Lugar, _, NivelOscuridad),
    NivelOscuridad > 6.
% 2B)
tieneItemsComestibles(Jugador):-
    jugador(Jugador, Items, _),
    member(Item, Items),
    comestible(Item).


correPeligro(Jugador):-
    lugar(Lugar, JugadoresEnElLugar, _),
    member(Jugador, JugadoresEnElLugar),
    hayMonstruos(Lugar).
correPeligro(Jugador):-
    jugador(Jugador, Items, Hambre),
    Hambre < 4,
    not(tieneItemsComestibles(Jugador)).
% 2C)
listaVacia([]).

porcentajeDeHambrientos(Lugar, PorcentajeDeHambrientos):-
    lugar(Lugar, Poblacion, _),
    findall(Hambriento, (member(Hambriento, Poblacion), jugador(Hambriento, _, Hambre),
    Hambre < 4), Hambrientos),
    length(Hambrientos, TotalHambrientos),
    length(Poblacion, TotalPoblacion),
    PorcentajeDeHambrientos is TotalHambrientos / TotalPoblacion * 100.
nivelPeligrosidad(Lugar, Peligrosidad):-
    not(hayMonstruos(Lugar)),
    porcentajeDeHambrientos(Lugar, Peligrosidad).
nivelPeligrosidad(Lugar, 100):-
    hayMonstruos(Lugar).
nivelPeligrosidad(Lugar, Peligrosidad):-
    lugar(Lugar, Poblacion, NivelOscuridad),
    listaVacia(Poblacion),
    Peligrosidad is NivelOscuridad * 10.

item(horno, [itemSimple(piedra, 8)]).
item(placaDeMadera, [itemSimple(madera, 1)]).
item(palo, [itemCompuesto(placaDeMadera)]).
item(antorcha, [itemCompuesto(palo), itemSimple(carbon, 1)]).

% 3)
tieneItemNecesario(Jugador, itemSimple(Item, Cantidad)):-
    jugador(Jugador, Items, _),
    member(Item, Items),
    cantidadDelItem(Jugador, Item, CantidadJugador),
    CantidadJugador >= Cantidad.
tieneItemNecesario(Jugador, itemCompuesto(Item)):-
    puedeConstruir(Jugador, Item).
tieneLosItems(Jugador, ItemsNecesarios):-
    forall(member(Item, ItemsNecesarios), tieneItemNecesario(Jugador, Item)).

puedeConstruir(Jugador, ItemAConstruir):-
    item(ItemAConstruir, ItemsNecesarios),
    tieneLosItems(Jugador, ItemsNecesarios).
