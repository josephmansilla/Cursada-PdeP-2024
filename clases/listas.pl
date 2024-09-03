%tenemos la información sobre las notas que se sacaron los estudiantes de un curso de pdp en parciales y recus
% alguien aprobo si la ultima nota que se saco en cada paradigma es al menos 6

%sin listas
nota(pepito, parcial,funcional, 2).
nota(pepito, parcial,logico, 10).
nota(pepito, parcial,objetos, 9).
nota(pepito, recu(l), funcional, 9).
nota(juanita, parcial,funcionat, 10).
nota(juanita, parcial, objetos, 8).
nota(juanita, recu(l), logico, 10).
nota(tito, parcial, funcional, 2).
nota(tito, recu(1), logico, 4).
nota(tito, recu(2), logico, 8).

aprobo(Estudiante):-
    nota(Estadiante,_,_,_),
    forall(paradigma(Paradigma),aproboTema(Estudiante, Paradigma)).

aproboTema(Estudiante, Tema):-
    ultimaNota(Estudiante, Tema, Nota),
    Nota >= 6.

ultimaNota(Estudiante, Tema, Nota):-
    nota(Estudiante, Examen, Tema, Nota),
    not((nota(Estudiante, Examen, Tema, _), posterior(Examen2, Examen))).

%Variante con listas
notas(pepito, funcional, [2,9]).
notas(pepito, logico, [10]).
notas(pepito, objetos, [9]).
notas(juanita, funcional, [10]).
notas(juanita, logico, [8]).
notas(juanita, objetos, [9]).
notas(tito, funcional, [2,6]).
notas(tito, logico, [4,8]).
paradigma(funcional).
paradigma(logico).
paradigma(objetos).

ultimaNota(Estudiante, Tema, Nota):-
    notas(Estudiante, Tema, Notas),
    last(Notas, Nota).

%notas(pepito, funcional, Notas), length (Notas, Cantidad).
%Cantidad = 2.

% Solución con listas
vecesQueRindio(Estudiante, Tema, Veces):-
    notas(Estudiante, Tema, Notas),
    length(Notas, Veces).

% Solución sin listas
vecesQueRindio1(Estudiante, Tema, Veces) :-
    findall(Nota, nota(Estadiante, _, Tema, _), Notas),
    length(Notas, Veces).