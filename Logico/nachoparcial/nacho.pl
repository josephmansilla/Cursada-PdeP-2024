%Personas:
datosPersona(nina,joven,22,160).
datosPersona(marcos,ninio,8,132).
datosPersona(osvaldo,adolescente,13,129).

parque(parqueCosta).
parque(parqueAcuatico).

atraccion(parqueCosta,trenFantasma).
atraccion(parqueCosta,montaniaRusa).
atraccion(parqueCosta,maquinaTiquetera).

atraccion(parqueAcuatico,toboganGigante).
atraccion(parqueAcuatico,rioLento).
atraccion(parqueAcuatico,piscinaOlas).

%Punto 1:
puedeSubir(trenFantasma,Persona):- datosPersona(Persona,_,Edad,_), Edad>=12.
puedeSubir(montaniaRusa,Persona):- datosPersona(Persona,_,_,Altura), Altura>130.
puedeSubir(maquinaTiquetera,Persona):- persona(Persona).

puedeSubir(toboganGigante,Persona):- datosPersona(Persona,_,_,Altura), Altura>150.
puedeSubir(rioLento,Persona):- persona(Persona).
puedeSubir(piscinaOlas,Persona):- datosPersona(Persona,_,Edad,_), Edad>=5.

%Punto 2:
esParaElle(Persona,Parque):-
    persona(Persona),
    parque(Parque),
    forall(atraccion(Parque,Atraccion),puedeSubir(Atraccion,Persona)).

persona(Persona):-datosPersona(Persona,_,_,_).

%Punto 3:
malaIdea(Grupo,Parque):-
    rangoEtario(Grupo),
    parque(Parque),
    atraccion(Parque,Atraccion),
    not(puedenSubirTodos(Grupo,Atraccion)).

puedenSubirTodos(Grupo,Atraccion):-forall((datosPersona(Persona,Grupo,_,_)),puedeSubir(Atraccion,Persona)).

rangoEtario(Grupo):- datosPersona(_,Grupo,_,_).

%Programas:
%programa([toboganGigante,piscinaOlas,rioLento]).

programaLogico(Programa):- esBueno(Programa).

esBueno(Programa):-
    sonTodasDelMismoParque(Programa),
    noTieneRepetidos(Programa). 

sonTodasDelMismoParque(Programa):-
    nth0(0, Programa, Atraccion), %Agarro un elemento
    atraccion(Parque,Atraccion), %Verifico el parque
    forall(member(AtraccionX,Programa),atraccion(Parque,AtraccionX)).

noTieneRepetidos(Lista):-list_to_set(Lista,Lista). %Si no tiene repetidos entonces la consulta del list_to_set de la lista y la misma lista debe dar true.


hastaAca(_,[],[]). %Si el programa es una lista vacia, entonces el subprograma sera vacio
hastaAca(P,[Atraccion|_],[]):-
    not(puedeSubir(Atraccion,P)). %Caso de que no cumpla deja de generar lista

hastaAca(P,[Atraccion|Resto],[Atraccion]):-
    puedeSubir(Atraccion,P),
    not(hastaAca(P,[Resto],[Resto])). %Si cumplen todos

hastaAca(P,[Atraccion|Resto],[Atraccion|Restantes]):-
    puedeSubir(Atraccion,P),
    hastaAca(P,[Resto],[Restantes]).

%Definicion de Juegos:
%juegos(Atraccion,comun(Costo)).
%juegos(Atraccion,premium).

%Ejemplos:
juegos(trenFantasma,premium).
juegos(maquinaTiquetera,basico(10)).

%Definicion de Pasaportes
%pasaporte(Persona,basico(Creditos)). %NO PUEDE A JUEGOS PREMIUM
%pasaporte(Persona,flex(Creditos,AtraccionPremium)).
%pasaporte(Persona,premium).

%Ejemplos:
pasaporte(nina,premium).
pasaporte(marcos,flex(100,trenFantasma)).
pasaporte(osvaldo,basico(200)).

%Como puede ir:
puedeIrAJuego(Atraccion,Persona):-
    juegos(Atraccion,comun(Costo)),
    pasaporte(Persona,basico(Suyos)),
    Suyos>Costo.

puedeIrAJuego(Atraccion,Persona):-
    juegos(Atraccion,comun(Costo)),
    pasaporte(Persona,flex(Suyos,_)),
    Suyos>Costo.

puedeIrAJuego(Atraccion,Persona):-
    juegos(Atraccion,_),
    pasaporte(Persona,premium).

puedeIrAJuego(Atraccion,Persona):-
    juegos(Atraccion,premium),
    pasaporte(Persona,premium).

puedeIrAJuego(Atraccion,Persona):-
    juegos(Atraccion,premium),
    pasaporte(Persona,flex(_,Atraccion)).

puedeSubirM(trenFantasma,Persona):- datosPersona(Persona,_,Edad,_), Edad>=12, puedeIrAJuego(trenFantasma,Persona).
puedeSubirM(montaniaRusa,Persona):- datosPersona(Persona,_,_,Altura), Altura>130, puedeIrAJuego(montaniaRusa,Persona).
puedeSubirM(maquinaTiquetera,Persona):- persona(Persona), puedeIrAJuego(maquinaTiquetera,Persona).

puedeSubirM(toboganGigante,Persona):- datosPersona(Persona,_,_,Altura), Altura>150, puedeIrAJuego(toboganGigante,Persona).
puedeSubirM(rioLento,_):- persona(Persona), puedeIrAJuego(rioLento,Persona).
puedeSubirM(piscinaOlas,Persona):- datosPersona(Persona,_,Edad,_), Edad>=5, puedeIrAJuego(piscinaOlas,Persona).