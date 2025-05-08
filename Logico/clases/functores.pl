tematico(Autor):-
    autor(_, Autor),
    forall(vende(Articulo, _), autor(Articulo, Autor)).

autor(libro(_,Autor,_,_), Autor) :- vende(libro(_,Autor,_,_), _).
autor(cd(_,Autor,_,_,_), Autor) :- vende(cd(_,Autor,_,_,_),_).


% Práctica
% Extender la base de conocimiento con los siguientes predicados:

% libroMásCaro/1: Se cumple para un artículo si es el libro de mayor precio.
% curiosidad/ 1: Se cumple para un artículo si es lo único que hoy a la venta de su autor.
% sePrestaAConfusión/1: Se cumple para un título si pertenece a más de un artículo.
% mixto/ 1: Se cumple para los autores de más de un tipo de artículo.
% Agregar soporte paro vender Películas con título, director y género

libroMasCaro(Libro) :-
    vende(libro(Titulo, Autor, Genero, Editorial), Precio),
    forall((vende(libro(_,_,_,_), OtroPrecio))), 
    OtroPrecio <= Precio).


curiosidad(Articulo):-
    vende(Articulo),
    autor(Articulo, Autor),
    not((vende(Otro, _), autor(Otro, Autor), Articulo \= Otro)).
sePrestaAConfusion(Titulo) :-
    titulo(UnArticulo, Titulo),
    titulo(OtroArticulo, Titulo),
    UnArticulo \= OtroArticulo.
mixto(Autor) :- autor(libro(_,_,_,_), Autor), autor(cd(_,_,_,_,_), Autor).
mixto(Autor) :- autor(libro(_,_,_,_), Autor), autor(pelicula(_,_,_), Autor).
mixto(Autor) :- autor(pelicula(_,_,_), Autor), autor(cd(_,_,_,_,_), Autor).

autor(libro(_,Autor,_,_), Autor) :- vende(libro(_, Autor, _,_), _).
autor(cd(_,Autor,_,_,_), Autor) :- vende(cd(_, Autor, _, _), _).

titulo(libro(Titulo,_,_,_), Titulo) :- vende(libro(Titulo, _,_,_),_).
titulo(cd(Titulo,_,_,_,_,_), Titulo) :- vende(libro(Titulo,_,_,_,_)).
titulo(pelicula(Titulo,_,_), Titulo) :- vende(pelicula(Titulo,_,_),_).