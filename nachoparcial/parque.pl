%% BASE DE CONOCIMIENTO %% 

persona(nina,joven,22,160).
persona(marcos,ninio,8,132).
persona(osvaldo,adolescente,13,129).

atraccion(parqueDeLaCosta, trenFantasma).
atraccion(parqueDeLaCosta, montaniaRusa).
atraccion(parqueDeLaCosta, maquinaTiquetera).

atraccion(parqueAcuatico, toboganGigante).
atraccion(parqueAcuatico, rioLento).
atraccion(parqueAcuatico, piscinaDeOlas).

%%% PUNTO 1 %%%

% puedeSubir(Atraccion,Persona).
puedeSubir(trenFantasma, Persona):- persona(Persona,_, Edad, _), Edad >= 12.
puedeSubir(montaniaRusa, Persona):- persona(Persona,_, _, Altura), Altura > (130).
puedeSubir(maquinaTiquetera, Persona):- persona(Persona,_,_,_).

puedeSubir(toboganGigante, Persona):- persona(Persona,_, _, Altura), Altura > (1,50).
puedeSubir(rioLento, Persona):- persona(Persona,_,_,_).
puedeSubir(piscinaDeOlas, Persona):- persona(Persona,_, Edad, _) , Edad >= 5.

%%% PUNTO 2 %%% 

% esParaAquel(Parque, Persona)
esParaAquel(Parque, Persona):-
    persona(Persona,_, _, _),
    atraccion(Parque, _),
    forall(atraccion(Parque, Atracciones), puedeSubir(Persona, Atracciones)).

%%% PUNTO 3 %%% 

malaIdea(Grupo, Parque):-
    persona(_, Grupo, _, _),
    atraccion(Parque, _),
    not(sePuedenSubirTodos(Grupo, Parque)).

sePuedenSubirTodos(Grupo, Parque):- forall(persona(Persona, Grupo, _,_), esParaAquel(Parque,Persona)).

%%% PROGRAMAS %%%

programaLogico(Programa):-
    sonJuegosDelMismoParque(Programa),
    noHayJuegosRepetidos(Programa).

sonJuegosDelMismoParque([Atraccion | Atracciones]):-
    atraccion(Parque, Atraccion),
    forall(member(OtraAtraccion, Atracciones), atraccion(Parque, Atracciones)).

noHayJuegosRepetidos(Programa):- list_to_set(Programa, Programa).

hastaAca(_, [],[]). %% CASO BASE
hastaAca(Persona, [Atraccion | _], []):- %% CASO NEGATIVO
    not((puedeSubir(Persona, Atraccion))).
hastaAca(Persona, [Atraccion | RestoAtracciones], [Atraccion | RestoOtrasAtracciones]):-
    puedeSubir(Persona, Atraccion),
    hastaAca(Persona, RestoAtracciones, RestoOtrasAtracciones).

%%% PASAPORTES %%% 

% juego(nombre, costo). Basico
% juego(nombre, pasaporte(basico(costo))) pasaporte bascio
% juego(nombre, pasaporte(flex(costo)))
% juego(toboganGigante, pasaporte(flex(_))).
% juego(_, pasaporte(premium)).

