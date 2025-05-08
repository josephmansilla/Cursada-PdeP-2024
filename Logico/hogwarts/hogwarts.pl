%% PARTE 1
%% PUNTO 1

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

casaPermiteEntrar(Mago, slytherin):-
    sangre(Mago, TipoDeSangre),
    TipoDeSangre \= impura.

mago(harry).
mago(draco).
mago(hermione).

mago(Mago):-
    sangre(Mago, _).

casaPermiteEntrar(Mago, Casa):-
    casa(Casa),
    sangre(Mago, _),
    Casa \= slytherin.

%% PUNTO 2

caracteristicaCasa(gryffindor, coraje).
caracteristicaCasa(slytherin, orgullo).
caracteristicaCasa(slytherin, inteligencia).
caracteristicaCasa(ravenclaw, inteligencia).
caracteristicaCasa(ravenclaw, responsabilidad).
caracteristicaCasa(hufflepuff, amistad).

caracteristicaMago(harry, coraje).
caracteristicaMago(harry, amistad).
caracteristicaMago(harry, orgullo).
caracteristicaMago(harry, inteligencia).
caracteristicaMago(draco, inteligencia).
caracteristicaMago(draco, orgullo).
caracteristicaMago(hermione, inteligencia).
caracteristicaMago(hermione, orgullo).
caracteristicaMago(hermione, responsabilidad).
caracteristicaMago(hermione, amistad).
caracteristicaMago(larry, amistad).


caracterApropiado(Mago, Casa):-
    casa(Casa),
    mago(Mago),
    forall(caracteristicaCasa(Casa, CaracteristicaComun), caracteristicaMago(Mago, CaracteristicaComun)).

odia(harry, slytherin).
odia(draco, hufflepuff).

puedeEntrar(hermione, gryffindor).

puedeEntrar(Mago, Casa):-
    mago(Mago),
    casa(Casa),
    caracterApropiado(Mago, Casa),
    casaPermiteEntrar(Mago, Casa),
    not(odia(Mago, Casa)).

cadenaDeAmistades(Lista):-
    todosAmistosos(Lista),
    cadenaCasas(Lista).

todosAmistosos(ListaAmigos):-
    forall(member(Mago, Magos), caracteristicaMago(Mago, amistad)).

cadenaCasas([Mago1, Mago2 | OtrosMagos]):-
    puedeEntrar(Mago1, Casa),
    puedeEntrar(Mago2, Casa),
    cadenaDeAmistades([Mago2 | OtrosMagos]).

cadenaCasas([_]).
cadenaCasas([]).


%% PARTE 2

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).