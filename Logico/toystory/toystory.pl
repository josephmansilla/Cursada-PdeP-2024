%% BASE DE CONOCIMIENTO %% 

% Relaciona al dueño con el nombre del juguete
% y la cantidad de años que lo ha tenido.
dueno(andy, woody, 8).
dueno(sam, jessie, 3).

% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa, caraDePapa([original(pieIzquierdo),original(pieDerecho),repuesto(nariz) ])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).
esRaro(deAccion(espacial, [original(casco)])).

% Dice si una persona es coleccionista
esColeccionista(sam).

esDeAccion(NombreJuguete):-
    juguete(NombreJuguete, deAccion(_,_)).
esDeTrapo(NombreJuguete):-
    juguete(NombreJuguete, deTrapo(_)).

%% PUNTO 1 A %% 
tematica(NombreJuguete, Tematica):-
    juguete(NombreJuguete, deTrapo(Tematica)).
tematica(NombreJuguete, Tematica):-
    juguete(NombreJuguete, deAccion(Tematica, _)).
tematica(NombreJuguete, Tematica):-
    juguete(NombreJuguete, miniFiguras(Tematica, _)).
tematica(NombreJuguete, caraDePapa):-
    juguete(NombreJuguete, caraDePapa(_)).

%% PUNTO 1 B %% 

esDePlastico(NombreJuguete):- juguete(NombreJuguete, miniFiguras(_,_)).
esDePlastico(NombreJuguete):- juguete(NombreJuguete, caraDePapa(_)).

%% PUNTO 1 C %% 

esDeColeccion(NombreJuguete):- esDeTrapo(NombreJuguete).
esDeColeccion(NombreJuguete):-
    juguete(NombreJuguete, JugueteRaro),
    esRaro(JugueteRaro).

%% PUNTO 2 %% 

amigoFiel(NombreDuenio, UnJuguete):-
    dueno(NombreDuenio, UnJuguete, Anios),
    juguete(UnJuguete, _),
    not(esDePlastico(UnJuguete)),
    forall((dueno(NombreDuenio, OtroNombreJuguete, OtroAnio), UnJuguete \= OtroNombreJuguete), Anios > OtroAnio).


%% PUNTO 3 %%

superValioso(JuguetesColeccion):-
    findall(JugueteColeccion, (esDeColeccion(JugueteColeccion),tienePiezasOriginales(JugueteColeccion), not(loTieneAlguien(JugueteColeccion))), JuguetesColeccion).

tienePiezasOriginales(NombreJuguete):- esDeTrapo(NombreJuguete).
tienePiezasOriginales(NombreJuguete):- juguete(NombreJuguete, deAccion(_, ListaPiezas)), chequearPiezas(ListaPiezas).
tienePiezasOriginales(NombreJuguete):- juguete(NombreJuguete, caraDePapa(ListaPiezas)), chequearPiezas(ListaPiezas).

chequearPiezas([original(_) | RestoLista]):- chequearPiezas(RestoLista). %% caso de que haya algo original
chequearPiezas([]). %% caso final

loTieneAlguien(Juguete):-
    dueno(_, Juguete, _), 
    juguete(Juguete,_).

%% PUNTO 4 %% 

duoDinamico(NombreDuenio, UnJuguete, OtroJuguete):- 
    dueno(NombreDuenio, UnJuguete,_),
    dueno(NombreDuenio, OtroJuguete, _),
    hacenBuenaPareja(UnJuguete, OtroJuguete),
    UnJuguete \= OtroJuguete.

hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(buzz, woody).
hacenBuenaPareja(UnJuguete, OtroJuguete):-
    tematica(UnJuguete, Tematica),
    tematica(OtroJuguete, Tematica).

%% PUNTO 5 %%

felicidad(NombreDuenio, CantidadFelicidad):-
    dueno(NombreDuenio,_,_),
    findall(FelicidadDeJuguete, (dueno(NombreDuenio, JugueteElegido, _), generarFelicidad(NombreDuenio, JugueteElegido, FelicidadDeJuguete)), FelicidadTotal),
    sum_list(FelicidadTotal, CantidadFelicidad).

generarFelicidad(_, NombreJuguete, 100):- esDeTrapo(NombreJuguete).

generarFelicidad(_, NombreJuguete, CantidadFelicidad):- 
    juguete(NombreJuguete, miniFiguras(_, CantidadFiguras)),
    CantidadFelicidad is 20 * CantidadFiguras.

generarFelicidad(NombreDuenio, NombreJuguete, 120):- 
    esColeccionista(NombreDuenio),
    esDeColeccion(NombreJuguete),
    esDeAccion(NombreJuguete).

generarFelicidad(_, NombreJuguete, 100):- esDeAccion(NombreJuguete).

generarFelicidad(_, NombreJuguete, Felicidad):-
    encontrarPiezas(Piezas, PiezasOriginales, PiezasDeRepuesto),
    Felicidad is (PiezasOriginales * 5 + PiezasDeRepuesto * 8).

encontrarPiezas(Piezas, CantidadPiezasOriginales, CantidadPiezasDeRepuesto):-
    findall(PiezaOriginal, member(original(PiezaOriginal), Piezas), PiezasOriginales),
    findall(PiezaRepuesto, member(repuesto(PiezaRepuesto), Piezas), PiezasRepuesto),
    length(PiezasOriginales, CantidadPiezasOriginales),
    length(PiezaRepuesto, CantidadPiezasDeRepuesto).

%% PUNTO 6 %% 

puedeJugarCon(NombrePersona, NombreJuguete):- 
    dueno(NombrePersona, NombreJuguete, _).
puedeJugarCon(NombrePersona, NombreJuguete):- 
    puedeJugarCon(OtraPersona, NombreJuguete),
    puedePrestar(OtraPersona, NombrePersona),
    OtraPersona \= NombrePersona.

puedePrestar(UnaPersona, OtraPersona):-
    juguetesTotales(UnaPersona, TotalJuguetesPersona),
    juguetesTotales(OtraPersona, TotalJuguetesOtra),
    TotalJuguetesPersona > TotalJuguetesOtra.

juguetesTotales(Persona, CantidadJuguetes):-
    dueno(Persona, _, _),
    findall(Juguete, dueno(Persona, Juguete, _), Juguetes),
    length(Juguetes, CantidadJuguetes).


%% PUNTO 7 %% 

podriaDonar(NombreDuenio, ListaJuguetes, FelicidadMinima):-
    dueno(NombreDuenio, _,_),
    findall(JugueteCumpleFelicidad, (member(Juguete, ListaJuguetes), generarFelicidad(NombreDuenio, Juguete, JugueteCumpleFelicidad)), ListaJuguetesCumplen),
    sum_list(ListaJuguetesCumplen, FelicidadTotalDeJuguetes),
    FelicidadMinima > FelicidadTotalDeJuguetes.