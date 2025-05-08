% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, littoNebbia], hipodromoSanIsidro).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).

% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival 
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes: 
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

%% PUNTO 1
itinerante(NombreDelFestival):-
    festival(NombreDelFestival, Bandas, Ubicacion),
    festival(NombreDelFestival, Bandas, OtraUbicacion), 
    Ubicacion \= OtraUbicacion.
%% PUNTO 2
careta(personalFest).
careta(NombreDelFestival):-
    festival(NombreDelFestival, _,_),
    not(entradaVendida(NombreDelFestival, campo)).
%% PUNTO 3 
nacAndPop(NombreDelFestival):-
    festival(NombreDelFestival, _,_),
    not(careta(NombreDelFestival)),
    forall(member(Banda, Bandas), (esNacionalidad(Banda, argentino), popularidadMayorA(NombreBanda, 1000))).
esNacionalidad(NombreBanda, Nacionalidad):-
    banda(NombreBanda, Nacionalidad, _).
popularidadMayorA(NombreBanda, ValorIndicado):-
    banda(NombreBanda, _, Popularidad),
    Popularidad > ValorIndicado.
%% PUNTO 4
sobrevendido(NombreDelFestival):-
    festival(NombreDelFestival, _, NombreUbicacion),
    findall(Entrada, entradaVendida(NombreDelFestival, Entrada), Entradas),
    lugar(NombreUbicacion, Capacidad, _),
    length(Entradas, EntradasVendidas),
    EntradasVendidas > Capacidad.
%% PUNTO 5
recaudacionTotal(NombreDelFestival, RecaudacionTotal):-
    festival(NombreDelFestival, _, NombreUbicacion),
    findall(Precio, (entradaVendida(NombreDelFestival, Entrada), precioEntrada(Entrada, NombreUbicacion, Precio)), Precios),
    sumlist(Precios, RecaudacionTotal).
precioEntrada(campo, NombreUbicacion, Precio):- lugar(NombreUbicacion, _, Precio).
precioEntada(plateaGeneral(Zona), NombreUbicacion, Precio):-
    lugar(NombreUbicacion, _, PrecioBase),
    plusZona(NombreUbicacion, Zona, Recargo),
    Precio is PrecioBase + Recargo.
precioEntrada(plateaNumerada(Fila), NombreUbicacion, Precio):-
    Fila > 10,
    lugar(NombreUbicacion, _ , PrecioBase),
    Precio is PrecioBase * 3.
precioEntrada(plateaNumerada(Fila), NombreUbicacion, Precio):-
    Fila =< 10,
    lugar(NombreUbicacion, _, PrecioBase),
    Precio is PrecioBase * 6.

%% PUNTO 6
tocoCon(Banda1ra, Banda2da):-
    festival(_, Bandas, _),
    member(Banda1ra, Bandas),
    member(Banda2da, Bandas),
    Banda1ra \= Banda2da.

delMismoPalo(Banda1ra, Banda2da):- tocoCon(Banda1ra, Banda2da).
delMismoPalo(Banda1ra, Banda2da):- 
    tocoCon(Banda1ra, Banda3er),
    banda(Banda3er, _, Popularidad3raBanda),
    banda(Banda2da, _, Popularidad2daBanda),
    Popularidad3erBanda > Popularidad2daBanda,
    delMismoPalo(Banda3er, Banda2da).