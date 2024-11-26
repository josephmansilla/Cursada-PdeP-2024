% Recorridos en GBA:

% recorrido(linea, zona, calle) (PUNTO DE PARTIDA).
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).

% Recorridos en CABA:
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Punto 1

puedeCombinarse(UnaLinea, OtraLinea):-
    recorrido(UnaLinea, Zona, Calle),
    recorrido(OtraLinea, Zona, Calle),
    UnaLinea \= OtraLinea.

%% Punto 2

cruzaGralPaz(Linea):-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_),_).

jurisdiccionLinea(Linea, nacional):-
    cruzaGralPaz(Linea).
jurisdiccionLinea(Linea, Provincia):-
    recorrido(Linea,Zona,_),
    not(cruzaGralPaz(Linea)),
    provincia(Zona, Provincia).

provincia(gba(_), buenosAires).
provincia(caba, caba).
provincia(cordoba, cordoba).

%% PUNTO 3 

calleMasTransitadaDeZona(ZonaMasTransitada, CalleMasTransitada):-
    recorrido(_, Zona, Calle),
    lineasQuePasanPor(ZonaMasTransitada, CalleMasTransitada, MayorCantidadLineas),
    forall((recorrido(_, Zona, Calle), lineasQuePasanPor(Zona, Calle, CantidadLineas)), MayorCantidadLineas > CantidadLineas).

lineasQuePasanPor(Zona, Calle, CantidadLineas):-
    findall(Linea, recorrido(Linea, Zona, Calle), LineasQuePasan),
    sum_list(LineasQuePasan, CantidadLineas).

%% PUNTO 4

esCalleDeTransbordoDeZona(Zona, Calle):-
    recorrido(_, Zona, Calle),
    lineasQuePasanPor(Zona, Calle, 3),
    forall(recorrido(Linea, Zona, Calle), jurisdiccionLinea(Linea, nacional)).


%% PUNTO 5

registrados(pepita).
registrados(marta).
registrados(juanita).

beneficiarios(pepita, particular(gba(oeste))).
beneficiarios(juanita, estudiante).
beneficiarios(marta, jubiliado).
beneficiarios(marta, particular(caba)).
beneficiarios(marta, particular(gba(sur))).

valorBoleto(Linea, 500):- jurisdiccionLinea(Linea, nacional).
valorBoleto(Linea, 350):- jurisdiccionLinea(Linea, caba).
valorBoleto(Linea, ValorTotal):- 
    jurisdiccionLinea(Linea, gba(_)),
    findall(Calle, recorrido(Linea, _, Calle), Calles),
    length(Calles, CantidadCalles),
    plus(Linea, PlusDado),
    ValorTotal is (CantidadCalles  * 25 ) + PlusDado.

plus(Linea, 50):- pasaPorZonasDiferentes(Linea).
plus(Linea, 0):- recorrido(Linea, _,_ ), not(pasaPorZonasDiferentes(Linea)).

pasaPorZonasDiferentes(Linea):-
    recorrido(Linea, gba(UnaZona), _),
    recorrido(Linea, gba(OtraZona), _),
    UnaZona \= OtraZona.

beneficios(estudiante, _, 50).
beneficios(particular(Zona), Linea, 0):- recorrido(Linea, Zona, _).
beneficios(jubilado, Linea, Valor):- 
    valorBoleto(Linea, Boleto),
    Valor is Boleto / 2.

costo(NombrePasajero, Linea, ValorFinal):-
    registrados(NombrePasajero),
    not(beneficiarios(NombrePasajero, _)),
    valorBoleto(Linea, ValorFinal).

costo(NombrePasajero, Linea, ValorFinal):-
    registrados(NombrePasajero),
    beneficiarios(NombrePasajero, UnBeneficio),
    beneficios(UnBeneficio, Linea, ValorFinal),
    forall((beneficiarios(NombrePasajero, OtroBeneficio), beneficios(OtroBeneficio, Linea, OtroValor)), 
            (UnBeneficio \= OtroBeneficio, (ValorFinal < OtroValor))). 