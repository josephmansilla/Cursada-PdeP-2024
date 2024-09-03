menorForAll(Lista, Menor):-
    member(Menor, Lista),
    forall(member(Elemento, Lista), Menor =< Elemento).

menorNot(Lista, Menor):-
    member(Menor, Lista),
    not((member(Elemento,Lista), Elemento < Menor)).


programaEn(juan, haskell).
programaEn(juan, prolog).
programaEn(caro, prolog).
programaEn(valen, prolog).
programaEn(rocio, wollok).
programaEn(nahuel, wollok).
programaEn(nahuel, javascript).
programaEn(nahuel, haskell).

leGusta(rocio, wollok).
leGusta(nahuel, wollok).
leGusta(juan, haskell).
leGusta(nahuel, haskell).
leGusta(caro, prolog).

lenguaje(Lenguaje):- distinct(Lenguaje, programaEn(_, Lenguaje)).

lenguajeShipeadoForAll(Lenguaje):-
    lenguaje(Lenguaje),
    forall(programaEn(Persona,Lenguaje), leGusta(Persona, Lenguaje)).

lenguajeShipeadoNot(Lenguaje):-
    lenguaje(Lenguaje),
    not((programaEn(Persona, Lenguaje), not(leGusta(Persona, Lenguaje)))).

lenguajeToleradoForAll(Lenguaje):-
    lenguaje(Lenguaje),
    forall(programaEn(Persona, Lenguaje), not(leGusta(Persona, Lenguaje))).

lenguajeToleradoNot(Lenguaje):-
    lenguaje(Lenguaje),
    not((programaEn(Persona, Lenguaje), leGusta(Persona, Lenguaje))).

lenguajeEclecticoForAll(Lenguaje):-
    lenguaje(Lenguaje),
    not(forall(programaEn(Persona, Lenguaje), leGusta(Persona, Lenguaje))).

lenguajeEclecticoNot(Lenguaje):-
    lenguaje(Lenguaje),
    programaEn(Persona, Lenguaje),
    not(leGusta(Persona, Lenguaje)).