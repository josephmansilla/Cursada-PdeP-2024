% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de
% bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia], hipodromoSanIsidro).

% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las
% entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).


% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes:
% - campo
% - plateaNumerada(Fila)
% - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).
% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio
% de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

%% PUNTO 1
itinerante(NombreFestival):-
    festival(NombreFestival, _, NombreLugar),
    festival(NombreFestival, _, OtroNombreLugar),
    OtroNombreLugar \= NombreLugar.

%% PUNTO 2
careta(personalFest).
careta(NombreFestival):-
    festival(NombreFestival, _,_),
    not(entradaVendida(NombreFestival, campo)).

%% PUNTO 3
nacAndPop(NombreFestival):-
    festival(NombreFestival, Bandas,_),
    not(careta(NombreFestival)),
    forall(member(NombreBanda, Bandas), (esNacionalidad(NombreBanda, argentina), esPopular(NombreBanda, 1000))).
esNacionalidad(NombreBanda, Pais):-
    banda(NombreBanda, Pais, _).
esPopular(NombreBanda, Cantidad):-
    banda(NombreBanda, _, Popularidad),
    Popularidad >= Cantidad.

%% PUNTO 4
sobrevendido(NombreFestival):-
    festival(NombreFestival, _, NombreLugar),
    findall(Entrada, entradaVendida(NombreFestival, Entrada), Entradas),
    lugar(NombreLugar, CapacidadMaxima, _),
    length(Entradas, CantidadEntradasVendidas),
    CantidadEntradasVendidas > CapacidadMaxima.

%% Punto 5
recaudacionTotal(NombreFestival, TotalVentas):-
    festival(NombreFestival, _, NombreLugar),
    findall(Venta, ((entradaVendida(NombreFestival, Ubicacion), recaudacion(NombreLugar, Ubicacion, Venta))) , Ventas),
    sumlist(Ventas, TotalVentas).

recaudacion(NombreLugar, campo, Precio):-
    lugar(NombreLugar, _, Precio).

recaudacion(NombreLugar, plateaGeneral(Zona), Precio):-
    lugar(NombreLugar, _, MontoBase),
    plusZona(NombreLugar, Zona, Plus),
    Precio is MontoBase + Plus.

recaudacion(NombreLugar, plateaNumerada(NumeroFila), Precio):-
    lugar(NombreLugar, _, MontoBase),
    multiplicador(NumeroFila, Multiplicador),
    Precio is MontoBase * Multiplicador.

multiplicador(NumeroFila, 6):- NumeroFila =< 10.
multiplicador(NumeroFila, 3):- NumeroFila > 10.