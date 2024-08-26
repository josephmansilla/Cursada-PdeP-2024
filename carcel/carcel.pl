%% BASE DE CONOCIMIENTO

% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).
% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).


%% PUNTO 1, DADO: 

% controla(Controlador, Controlado)
controla(piper, alex). %% esta consulta es totalmente inversible, no habrá problemas.
controla(bennett, dayanara). %% esta consulta también será inversible sin problemas.
controla(Guardia, Otro):- 
    prisionero(Otro,_), % esto pasa la variable de Otro para poder permitir hacerla inversible.
    % pero como pasamos Otro, debemos también pasar Guardia para hacerlo totalmente inversible.
    % entonces agregamos:
    guardia(Guardia),
    not(controla(Otro, Guardia)).


%% PUNTO 2

conflictoDeIntereses(UnaPersona, OtraPersona):-
    controla(UnaPersona, Tercera),
    controla(OtraPersona, Tercera),
    not(controla(UnaPersona, OtraPersona)),
    not(controla(OtraPersona, UnaPersona)),
    UnaPersona \= OtraPersona.

%% PUNTO 3

peligroso(Prisionero):-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), grave(Crimen)).

grave(homicidio(_)).
grave(narcotrafico(Drogas)):- length(Drogas, CantidadDrogas), CantidadDrogas >= 5.
grave(narcotrafico(Drogas)):- member(metanfetaminas, Drogas).

%% PUNTO 4

monto(robo(Monto), Monto).

ladronDeGuanteBlancoCorrecto(Preso):-
    prisionero(Preso, _),
    forall(prisionero(Preso, Crimen), (monto(Crimen, Total), Total >= 100000)).

ladronDeGuanteBlanco(Preso):-
    prisionero(Preso,_),
    findall(Robo, prisionero(Preso, robo(Robo)), Robos),
    sumlist(Robos, CantidadRobada),
    CantidadRobada >= 100000.

%% PUNTO 5

condena(Preso, Condena):-
    prisionero(Preso, _),
    findall(Anio, (prisionero(Preso, Crimen), calcularCrimen(Crimen, Anio)), Anios),
    sumlist(Anios, Condena).

calcularCrimen(robo(Cantidad), Anio):-
    Anio is Cantidad / 10000.
calcularCrimen(narcotrafico(Lista), Anio):-
    length(Lista, Longitud),
    Anios is Longitud * 2.
calcularCrimen(homicidio(Victima), 9):- guardia(Victima).
calcularCrimen(homicidio(Victima), 7):- not(guardia(Victima)).

%% PUNTO 6

persona(Persona):- guardia(Persona).
persona(Persona):- prisionero(Persona,_).

controlaDirectamenteEIndirectamente(Preso, Persona):- controla(Preso, Persona).
controlaDirectamenteEIndirectamente(Preso, Persona):- controla(Preso, OtraPersona), controla(OtraPersona, Persona).

capoDiTutiLiCapi(PresoCapo):-
    prisionero(PresoCapo, _),
    not(controla(_, PresoCapo)),
    forall(persona(Persona), controlaDirectamenteEIndirectamente(PresoCapo, Persona)).
