%herramientasRequeridas(Tarea, Herramientas).
%herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradora, cera, aspiradora(300)]).
herramientasRequeridas(ordenarCuarto, [[escoba, aspiradora(100)], trapeador, plumero]).


%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).



%tiene(Persona, Herramienta).
%persona(Persona, listaDeHerramientas).
%Elegimos trabajar con hechos en vez de listas 

%1
tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).


%2
satisfaceNecesidad(Persona, Herramienta):-
	tiene(Persona, Herramienta).

satisfaceNecesidad(Persona, aspiradora(PotenciaRequerida)):-
	tiene(Persona, aspiradora(Potencia)),
	between(0, Potencia, PotenciaRequerida). %inversible
	%Potencia >= PotenciaRequerida. -- No inversible hacia PotenciaRequerida


satisfaceNecesidad(Persona, ListaRemplazables):-
	member(Herramienta, ListaRemplazables),
	satisfaceNecesidad(Persona, Herramienta).
/*
Para el punto 6 agregamos una definición de satisfaceNecesidad
que contemplara la posibilidad de listas de herramientas remplazables
aprovechando el predicado para hacer uso de polimorfismo, y evitando
tener que modificar el resto de la solución ya planteada para
contemplar este nuevo caso. Mayor explicación al final.
*/

%3
puedeHacerTarea(Persona, Tarea):-
	herramientasRequeridas(Tarea, _),
	tiene(Persona, varitaDeNeutrones).

/*
puedeHacerTarea(Persona, Tarea):-
	tiene(Persona, _),
	herramientasRequeridas(Tarea, _),
	forall((herramientasRequeridas(Tarea, ListaDeHerramientas),
			member(Herramienta, ListaDeHerramientas)),
		satisfaceNecesidad(Persona, Herramienta)).

Acá ligamos la lista de herramientas antes del forall para 
poder hacer pattern matching adentro y evitar múltiples antecedentes
en el forall.

puedeHacerTarea(Persona, Tarea):-
	tiene(Persona, _),
	herramientasRequeridas(Tarea, ListaDeHerramientas),
	forall(member(Herramienta, ListaDeHerramientas)),
		satisfaceNecesidad(Persona, Herramienta)).



Acá pudimos abstraer el concepto de que una tarea requiera
una herramienta, y reemplazamos el member dentro del forall
por ese nuevo predicado.
*/

puedeHacerTarea(Persona, Tarea):-
	tiene(Persona, _),
	requiereHerramienta(Tarea, _),
	forall(requiereHerramienta(Tarea, Herramienta),
		satisfaceNecesidad(Persona, Herramienta)).

requiereHerramienta(Tarea, Herramienta):-
	herramientasRequeridas(Tarea, ListaDeHerramientas),
	member(Herramienta, ListaDeHerramientas).


%4
precioACobrar(Cliente, PrecioACobrar):-
	tareaPedida(Cliente, _, _),
	findall(Precio, precioPorTareaPedida(Cliente, _, Precio),
		ListaPrecios),
	sumlist(ListaPrecios, PrecioACobrar).

%Recordemos que precioACobrar es para saber la suma del precio de
%todas las tareas que solicitó un cliente


precioPorTareaPedida(Cliente, Tarea, Precio):-
	tareaPedida(Cliente, Tarea, Metros),
	precio(Tarea, PrecioPorMetro),
	Precio is PrecioPorMetro * Metros.

%5

tareaCompleja(limpiarTecho).

tareaCompleja(Tarea):-
	herramientasRequeridas(Tarea, Herramientas),
	length(Herramientas, Cantidad),
	Cantidad > 2.


aceptaPedido(Trabajador, Cliente):-
	puedeHacerPedido(Trabajador, Cliente),
	estaDispuestoAHacer(Trabajador, Cliente).

puedeHacerPedido(Trabajador, Cliente):-
	tareaPedida(Cliente, _, _),
	tiene(Trabajador, _),
	forall(tareaPedida(Cliente, Tarea, _),
		puedeHacerTarea(Trabajador, Tarea)).

estaDispuestoAHacer(peter, _).

estaDispuestoAHacer(ray, Cliente):-
	not(tareaPedida(Cliente, limpiarTecho, _)).

estaDispuestoAHacer(winston, Cliente):-
	precioACobrar(Cliente, PrecioACobrar),
	PrecioACobrar >= 500.

estaDispuestoAHacer(egon, Cliente):-
	not((tareaPedida(Cliente, Tarea, _),
		tareaCompleja(Tarea))).
/*
estaDispuestoAHacer(egon, Cliente):-
	forall(tareaPedida(Cliente, Tarea, _), 
		not(tareaCompleja(Tarea))).

Ambas propuestas para estaDispuestoAHacer son válidas
Decir "para todas las tareas que pidio un cliente, ninguna es compleja"
Equivale a decir "no existe una tarea que haya pedido un 
cliente y que sea compleja"

6
Por qué para este punto no bastaba sólo con agregar un nuevo 
hecho?
Con nuestra definición de puedeHacerTarea verificabamos con un 
forall que una persona posea todas las herramientas que requería
una tarea; pero sólo ligabamos la tarea. Entonces Prolog hubiera
matcheado con ambos hechos que encontraba, y nos hubiera devuelto
las herramientas requeridas presentes en ambos hechos.

Una posible solución era, dentro de puedeHacerTarea, también ligar
las herramientasRequeridas antes del forall, y así asegurarnos que
el predicado matcheara con una única tarea a la vez.

Cual es la desventaja de esto? Para cada nueva herramienta remplazable
deberíamos contemplar todos los nuevos hechos a generar para que 
esta solución siga funcionando como queremos.
Se puede hacer? En este caso sí, pero con el tiempo se volvería costosa.

La alternativa que planteamos en esta solución es agrupar en una lista
las herramientas remplazables, y agregar una nueva definición a 
satisfaceNecesidad, que era el predicado que usabamos para tratar
directamente con las herramientas, que trate polimorficamente tanto
a nuestros hechos sin herramientas remplazables, como a aquellos que 
sí las tienen. También se podría haber planteado con un functor en vez
de lista.

Cual es la ventaja? Cada vez que aparezca una nueva herramienta
remplazable, bastará sólo con agregarla a la lista de herramientas
remplazables, y no deberá modificarse el resto de la solución.

Notas importantes:
I) Este enunciado pedía que todos los predicados fueran inversibles
Recordemos que un predicado es inversible cuando 
no necesitás pasar el parámetro resuelto (un individuo concreto), 
sino que podés pasar una incógnita (variable sin unificar).
Así podemos hacer tanto consultas individuales como existenciales.

II) No siempre es conveniente trabajar con listas, no abusar de su uso.
	En general las listas son útiles sólo para contar o sumar muchas cosas
	que están juntas.

III) Para usar findall es importante saber que está compuesto por 3 cosas:
		1. Qué quiero encontrar
		2. Qué predicado voy a usar para encontrarlo
		3. Donde voy a poner lo que encontré

IV) Todo lo que se hace con forall podría también hacerse usando not.


*/