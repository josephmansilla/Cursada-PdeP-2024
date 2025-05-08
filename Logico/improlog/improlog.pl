%% BASE DE CONOCIMIENTO %%

% integrante/3 relaciona a un grupo, con una persona que toca
% en ese grupo y el instrumento que toca en ese grupo.

integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

% nivelQueTiene/3 relaciona a una persona con un instrumento que toca 
% y qué tan bien puede improvisar con dicho instrumento 
% (que representaremos con un número del 1 al 5).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).
nivelQueTiene(joseph, bateria, 0).

% instrumento/2 que relaciona el nombre de un instrumento con el rol que cumple el mismo al tocar 
% en un grupo. Todos los instrumentos se considerarán rítmicos, armónicos o melódicos. Para los 
% melódicos se incluye información adicional del tipo de instrumento (si es de cuerdas, viento, etc).

instrumento(violin, (melodico(cuerdas))).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, (melodico(viento))).
instrumento(trompeta, (melodico(viento))).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, (melodico(vocal))).

%% PUNTO 1 %%

tieneUnaBuenaBase(Grupo):-
    integrante(Grupo, Persona, Instrumento),
    integrante(Grupo, OtraPersona, OtroInstrumento),
    Persona \= OtraPersona,
    Instrumento \= OtroInstrumento,
    instrumento(Instrumento, ritmico),
    instrumento(OtroInstrumento, armonico).

%% PUNTO 2 %%

tocaMultiplesInstrumentos(Grupo, Persona):-
    integrante(Grupo, Persona, Instrumento),
    integrante(Grupo, Persona, OtroInstrumento),
    Instrumento \= OtroInstrumento.

nivelMasAltoInstrumento(Grupo, Persona, NivelMaximo):-
    integrante(Grupo,Persona, _),
    tocaMultiplesInstrumentos(Grupo, Persona),
    findall(NivelDado, (integrante(Grupo, Persona, Instrumento), nivelQueTiene(Persona, Instrumento, NivelDado)), ListaNiveles),
    max_member(NivelMaximo, ListaNiveles).

nivelMasAltoInstrumento(Grupo, Persona, Nivel):-
    integrante(Grupo, Persona, Instrumento),
    not(tocaMultiplesInstrumentos(Grupo, Persona)),
    nivelQueTiene(Persona, Instrumento, Nivel).

condicionDeDestacar(Persona, OtraPersona):-
    nivelMasAltoInstrumento(Grupo, Persona, UnNivel),
    nivelMasAltoInstrumento(Grupo, OtraPersona, OtroNivel),
    (UnNivel - OtroNivel >= 2).

seDestacaEnGrupo(Persona, Grupo):-
    integrante(Grupo,Persona,_),
    forall((integrante(Grupo, OtraPersona, _), Persona \= OtraPersona), condicionDeDestacar(Persona, OtraPersona)). 
    
seDestacaEnGrupo(Persona, Grupo):-
    integrante(Grupo, Persona, _),
    not(integrante(Grupo, OtraPersona,_)),
    Persona \= OtraPersona.

%% PUNTO 3 %%

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, contrabajo).
grupo(sophieTrio, guitarra).
grupo(sophieTrio, violin).
grupo(jazzmin, contrabajo).
grupo(jazzmin, bateria).
grupo(jazzmin, bajo).
grupo(jazzmin, trompeta).
grupo(jazzmin, piano).
grupo(jazzmin, guitarra).

%% PUNTO 4 %%

hayCupo(Grupo, Instrumento):-
    grupo(Grupo, bigBand),
    puedeEntrarABigBand(Instrumento).

hayCupo(Grupo, Instrumento):-
    nadieTocaInstrumento(Grupo, Instrumento),
    grupo(Grupo, Instrumento).

puedeEntrarABigBand(Instrumento):- instrumento(Instrumento, melodico(viento)).
puedeEntrarABigBand(bateria).
puedeEntrarABigBand(bajo).
puedeEntrarABigBand(piano).

leSirve(formacion(InstrumentosBuscado), Instrumento):-
    member(Instrumento, InstrumentosBuscado).
leSirve(bigBand, bateria).
leSirve(bigBand, bajo).
leSirve(bigBand, piano).

nadieTocaInstrumento(Grupo, Instrumento):-
    grupo(Grupo,_),
    instrumento(Instrumento, _),
    forall(grupo(Grupo, _), not(integrante(Grupo, _, Instrumento))).

%% PUNTO 5 %% 

puedeIncorporarse(Grupo, Persona, Instrumento):-
    noFormaParteBanda(Grupo, Persona),
    hayCupo(Grupo, Instrumento),
    tieneNivelMinimo(Grupo, Persona, Instrumento).

noFormaParteBanda(Grupo, Persona):-
    nivelQueTiene(Persona, _,_),
    integrante(Grupo, _,_),
    not(integrante(Grupo, Persona, _)).

tieneNivelMinimo(Grupo, Persona, Instrumento):-
    nivelQueTiene(Persona, Instrumento, NivelDado),
    cumpleRequisitosGrupo(Grupo, NivelDado).

cumpleRequisitosGrupo(Grupo, NivelDado):-
    grupo(Grupo, bigBand),
    NivelDado >= 1.

cumpleRequisitosGrupo(Grupo, NivelDado):-
    grupo(Grupo, _),
    findall(InstrumentoBuscado, grupo(Grupo, InstrumentoBuscado), ListaInstrumentosBuscados),
    length(ListaInstrumentosBuscados, CantidadDeInstrumentosBuscados),
    NivelDado >= (7 - CantidadDeInstrumentosBuscados).

%% PUNTO 6 %% 

seQuedoEnBanda(Persona):-
    noFormaParteBanda(_, Persona),
    forall((grupo(Grupo, _), nivelQueTiene(Persona, Instrumento, _)), not(puedeIncorporarse(Grupo, Persona, Instrumento))).

%% PUNTO 7 %% 

puedeTocar(Grupo):-
    grupo(Grupo, bigBand),
    tieneUnaBuenaBase(Grupo),
    personasQueTocanInstrumentosDeViento(Grupo, 5).

personasQueTocanInstrumentosDeViento(Grupo, Cantidad):-
    grupo(Grupo,_),
    findall(Integrante, alguienTocaInstrumentoDeViento(Grupo), Integrantes),
    length(Integrantes, Cantidad).

alguienTocaInstrumentoDeViento(Grupo):-
    integrante(Grupo, Integrante, InstrumentoViento),
    instrumento(InstrumentoViento, melodico(viento)).

puedeTocar(Grupo):-
    grupo(Grupo, _),
    forall(grupo(Grupo, Instrumento), integrante(Grupo, _, Instrumento)).

%% PUNTO 8 %%

grupo(estudio1, ensamble(3)).

leSirve(ensamble(_),_).

cumpleRequisitosGrupo(Grupo, NivelDado):-
    grupo(Grupo, ensamble(NivelMinimo)),
    NivelDado >= NivelMinimo.

puedeTocar(Grupo):-
    grupo(Grupo, ensamble(_)),
    tieneUnaBuenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).