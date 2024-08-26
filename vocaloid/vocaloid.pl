% vocaloid(NombreVocaloid, cancion(NombreCancion, Minutos)).

vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).

vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).

vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).

vocaloid(seeU, cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).

%% PUNTO 1

cantanteNovedoso(Cantante):-
    sabeDosCanciones(Cantante),
    tiempoTotalCanciones(Cantante, 15).

sabeDosCanciones(Cantante):-
    vocaloid(NombreCantante, UnaCancion),
    vocaloid(NombreCantante, OtraCancion),
    UnaCancion \= OtraCancion.

tiempoTotalCanciones(Cantante, TotalTiempo):-
    vocaloid(Cantante, _),
    findall(TiempoCancion, vocaloid(Cantante, cancion(_, TiempoCancion)), Tiempos),
    sum_list(Tiempos, TotalTiempo).

%% PUNTO 2

cantanteAcelerado(Cantante):-
    vocaloid(Cantante, _),
    forall(vocaloid(Cantante, cancion(_, TiempoCancion)), TiempoCancion < 4).

% concierto(Nombre, Pais, Fama, Tipo).

concierto(mikuExpo, eeuu, 2000, gigante(2,6)).
concierto(magicalMirai, jpn, 3000, gigante(3, 10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, arg, 100, pequenio(4)).

puedeParticipar(hatsuneMiku, _).

cantidadCancionesQueSabe(Cantante, CancionesPedidas):-
    vocaloid(Cantante, _),
    findall(NombreCancion, vocaloid(Cantante, cancion(NombreCancion, _)), Nombres),
    length(Nombres, CancionesPedidas).


puedeParticipar(NombreArtista, NombreConcierto):-
    concierto(NombreConcierto, _, _, gigante(CantidadCancionesPedidas, TiempoMinimo)),
    cantidadCancionesQueSabe(NombreArtista, NumeroDeCanciones),
    NumeroDeCanciones >= CantidadCancionesPedidas,
    tiempoTotalCanciones(NombreArtista, TiempoTotal),
    TiempoTotal >= TiempoMinimo.

puedeParticipar(NombreArtista, NombreConcierto):-
    concierto(NombreConcierto, _, _, mediano(TiempoMaximo)),
    tiempoTotalCanciones(NombreArtista, TiempoTotalCanciones),
    TiempoTotalCanciones =< TiempoMaximo.

puedeParticipar(NombreArtista, NombreConcierto):-
    concierto(NombreConcierto, _, _, pequenio(TiempoMinimo)),
    vocaloid(NombreArtista, cancion(_, TiempoCancion)),
    TiempoCancion >= TiempoMinimo.

%% PUNTO 3

famaTotalDelVocaloid(NombreCantante, NivelFama):-
    famaTotal(NombreCantante, SumaFama),
    cantidadCancionesQueSabe(NombreCantante, CantidadCanciones),
    NivelFama is SumaFama * CantidadCanciones.

famaTotal(NombreCantante, SumaFama):-
    vocaloid(NombreCantante, _),
    findall(Fama, famaDeConcierto(NombreCantante, Fama), FamaTotal),
    sum_list(FamaTotal, SumaFama).

famaDeConcierto(NombreCantante, Fama):-
    concierto(NombreConcierto, _, Fama, _), 
    puedeParticipar(NombreCantante, NombreConcierto).

vocaloidMasFamoso(NombreCantante):-
    famaTotalDelVocaloid(NombreCantante, NivelMasFamoso),
    forall(famaTotalDelVocaloid(_, Nivel), NivelMasFamoso >= Nivel).

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).

conoce(gumi, seeU).
conoce(seeU, kaito).

seConocen(UnArtista, OtroArtista):- %%directo
    conoce(UnArtista, OtroArtista),
    conoce(OtroArtista, UnArtista),
    UnArtista \= OtroArtista.

seConocen(UnArtista, OtroArtista):- %%indirecto
    conoce(UnArtista, TercerArtista),
    seConocen(TercerArtista, OtroArtista).

unicoEnParticiparEnUnConcierto(Artista, Concierto):-
    puedeParticipar(Artista, Concierto),
    not((seConocen(Artista, OtroArtista), puedeParticipar(OtroArtista, Concierto))).

%% PUNTO 5 

% EN EL CASO DE LA APARICION DE UN NUEVO CONCIERTO, UNICAMENTE DEBEMOS MODIFICAR LA FUNCION PUEDE PARTICIPAR...
% ESTA SE ENCARGA DE CHEQUEAR POR CADA CASO DE CONCIERTO SU DETERMINADA CONDICION, ENTONCES SI O SI ES NECESARIO.
% EL CONCEPTO QUE FACILITÓ ESTO ES EL DE FUNCTORES