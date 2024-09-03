humano(socrates). %hecho.
%socrates es un individuo (atómo).
humano(platon).
humano(aristoteles).

mortal(Alguien) :- humano(Alguien). % regla.
%Alguien es una variable y se define con mayuscula.
mortal(elGalloDeAsclepio).

maestro(socrates, platon).
maestro(platon, aristoteles).

groso(Alguien) :-
    maestro(Alguien, Uno),
    maestro(Alguien, Otro),
    Uno \= Otro.

% ?maestro(platon, aristoteles). ---> ¿Platon es maestro de Aristoteles
% ?maestro(platon, Discipulo). ---> ¿Quien es discipulos de platon?
% ?maestro(Maestro, aristoteles). ---> ¿Quien es maestro de aristoteles
% ?maestro(Maestro, Discipulo). --> ¿Quien es maestro de quien?
% ?maestro(Maestro, _). --> ¿Quienes son maestros?
% ?maestro(_, Discipulo). --> ¿Quienes son discipulos?
% ?maestro(platon, _). --> ¿Platon es maestro de alguien?
% ?maestro(_, aristoteles). --> ¿Aristoteles es discipulos de alguien?
% ?maestro (_, _). --> ¿Hay alguien que sea maestro de alguien?

odia(platon, diogenes).
odia(diogenes, _).

esHijo(caro, arce).
esHijo(caro, julian).
esHijo(juana, arce).
esHijo(juana, julian).
esHijo(pipo, juana).


hermanas(Persona, Hermana) :-
    esHijo(Persona, Familia),
    esHijo(Hermana, Familia),
    Persona \= Hermana.

descendiente(Menor, Persona) :-
    esHijo(Menor, Persona),
    Menor \= Persona.
descendiente(Menor, Persona) :-
    esHijo(Menor, Padre),
    descendiente(Padre, Persona).