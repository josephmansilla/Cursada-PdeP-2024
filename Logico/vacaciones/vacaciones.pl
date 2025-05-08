%% PUNTO 1 %%

viajaA(dodain, villaPehuenia).
viajaA(dodain, sanMartinDeLosAndes).
viajaA(dodain, esquel).
viajaA(dodain, sarmiento).
viajaA(dodain, camarones).
viajaA(dodain, playasDoradas).

viajaA(alf, sanMartinDeLosAndes).
viajaA(alf, bariloche).
viajaA(alf, elBolson).

viajaA(nico, marDelPlata).
viajaA(vale, calafate).
viajaA(vale, elBolson).

viajaA(martu, elBolson).
viajaA(martu, marDelPlata).
viajaA(martu, sanMartinDeLosAndes).
viajaA(martu, bariloche).

viajaA(juan, federacion).
viajaA(juan, villaGesell).
viajaA(joseph, esquel).

%% PUNTO 2 %%

% atracciones(parquenacional(Nombre)).
% atracciones(cerro(Nombre, Altura)).
% atracciones(cuerpoDeAgua(0 o 1 dependiendo si se puede pescar o no, Temp Agua)).
% atracciones(playa(Baja, Alta)).
% atracciones(excursion(Nombre)).

atracciones(esquel, parquenacional(losAlerces)).
atracciones(esquel, excursion(trochita)).
atracciones(esquel, excursion(trevelin)).

atracciones(villaPehuenia, cerro(bateaMahuida, 2000)).
atracciones(villaPehuenia, cuerpoDeAgua(1, 14)).
atracciones(villaPehuenia, cuerpoDeAgua(1,19)).

viajeCopadoMal(Nombre):-
    viajaA(Nombre,_),
    forall(viajaA((Nombre, NombreLugar), atracciones(NombreLugar, Atraccion)), atraccionCopada(Atraccion)).

atraccionCopada(cerro(_, Altura)):- Altura >= 2000.
atraccionCopada(cuerpoDeAgua(1, Temperatura)):- Temperatura > 20.
atraccionCopada(playa(MareaBaja, MareaAlta)):- 
    DiferenciaMareas is MareaAlta - MareaBaja,
    DiferenciaMareas < 5.
atraccionCopada(excursion(Nombre)):- 
    atom_length(Nombre, LongitudNombre),
    LongitudNombre >= 7.
atraccionCopada(parquenacional(_)).
    


%% PUNTO 3 %%

seCruzan(UnNombre, OtroNombre):-
    viajaA(UnNombre, Destino),
    viajaA(OtroNombre, Destino).

niSeMeCruzoPorLaCabeza(UnNombre, OtroNombre):-
    viajaA(UnNombre, _),
    viajaA(OtroNombre, _),
    not(seCruzan(UnNombre, OtroNombre)).

%% PUNTO 4 %% 

costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(villaPehuenia, 180).
costoDeVida(sanMartinDeLosAndes, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(calafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

vacacionesGasoleras(Nombre):-
    viajaA(Nombre, _),
    forall((viajaA(Nombre, NombreLugar), costoDeVida(NombreLugar, Nafta)), between(0, 160, Nafta)).

%% PUNTO 5 %%

itinerariosPosibles(Nombre, Posibles):-
    viajaA(Nombre,_),
    findall(Combinacion, viajaA(Nombre, Combinacion), Posibles).