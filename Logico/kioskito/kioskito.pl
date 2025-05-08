horario(dodain, lunes, 9,15).
horario(dodain, miercoles, 9,15).
horario(dodain, viernes, 9,15).

horario(lucas, martes, 10, 20).

horario(juanC, sabado, 18,22).
horario(juanC, domingo, 18,22).

horario(juanFdS, jueves, 10,20).
horario(juanFdS, viernes, 12,20).

horario(leoC, lunes, 14,18).
horario(leoC, miercoles, 14,18).

horario(martu, miercoles, 23,24).

%% PUNTO 1

%% Para este punto nos piden realizar la implementación de una función conocida que es la Between
%% con este podemos relacionar el maximo y minimo

horario(vale, lunes, 9,15).
horario(vale, miercoles, 9,15).
horario(vale, viernes, 9,15).

horario(vale, sabado, 18,22).
horario(vale, domingo, 18,22).

horario(maiu, martes, 0, 8).
horario(maiu, miercoles, 0, 8).

%% PUNTO 2

atiende(Nombre, Dia, HoraConsultada):-
    horario(Nombre, Dia, HorarioEntrada, HorarioSalida),
    between(HorarioEntrada, HorarioSalida, HoraConsultada).

%% PUNTO 3

foreverAlone(Nombre, Dia, HorarioConsultada):-
    atiende(Nombre, Dia, HorarioConsultada),
    not((atiende(OtroNombre, Dia, HorarioConsultada), Nombre \= OtroNombre)).

%% PUNTO 4

posibilidadesDeAtencion(Dia, Opciones):-
    findall(Persona, atiende(Persona, Dia, _), PersonasPosibles),
    list_to_set(PersonasPosibles, Personas),
    permutar(Personas, Opciones).

permutar([], []).
permutar([Posible| Posibles], [ Posible , Personas]):- permutar(Posibles, Personas).
permutar([_ | Posibles], Personas) :- permutar(Posibles, Personas).


%% PUNTO 5

%golosinas(Valor).
%cigarrillos([Marcas]).
%bebidas(EsAlcholica, Cantidad).

venta(dodain, fecha(10,08), [golosinas(1200), golosinas(50)], cigarrillos([jockey])).

venta(dodain, fecha(12,08), [golosinas(10), bebidas(alcoholica, 8),bebidas(noAlcoholica)]).

venta(martu, fecha(12,08), [golosinas(1000), cigarrillos([chesterfield,colorado,parisiennes])]).

venta(lucas, fecha(11,08), [golosinas(600), bebidas(noAlcoholica, 2), cigarrillos([derby])]).

ventaImportante(golosinas(Precio)):-
    Precio > 100.
ventaImportante(bebidas(alcoholica, _)).
ventaImportante(bebidas(noAlcoholica, CantidadBebidas)):-
    CantidadBebidas > 5.
ventaImportante(cigarrillos(MarcasCigarrilos)):-
    length(MarcasCigarrilos, CantidadMarcas),
    CantidadMarcas > 2.

vendedorSuertudo(Nombre):-
    venta(Nombre, _ , _),
    forall(venta(Nombre, _, [Venta |_]), ventaImportante(Venta)).
