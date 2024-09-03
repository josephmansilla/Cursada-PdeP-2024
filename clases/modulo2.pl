% Juan gusta de María.
% Pedro gusta de Ana y de Nora.
% Todos los que gustan de Nora gustan de Zulema.
% Julián gusta de las morochas y de las chicas con onda.
% Mario gusta de las morochas con onda y de Luisa.
% Todos los que gustan de Ana y de Luisa, gustan de Laura.
% Después cambiar ese "y" por un "o"

% gusta(juan, maria).
% gusta(pedro, ana).
% gusta(pedro, nora).

% gusta(Alguien, zulema) :- gusta(Alguien, nora).
% gusta(julian, Chica) :- chica(Chica), morocha(Chica).
% gusta(julian, Chica) :- chica(Chica), tieneOnda(Chica).

% gusta(mario, Chica) :- chica(Chica), morocha(Chica), tieneOnda(Chica).
% gusta(mario, luisa).

% gusta(Alguien, laura) :- gusta(Alguien, ana), gusta(Alguien, luisa).

% gusta(Alguien, laura) :-  gusta(Alguien, ana).
% gusta(Alguien, laura) :- gusta(Alguien, luisa).

%Dado la base:
progenitor(homero, bart).
progenitor(homero, lisa).
progenitor(homero, maggie).
progenitor(abe, homero).
progenitor(abe, jose).
progenitor(jose, pepe).
progenitor(mona, homero).
progenitor(jacqueline, marge).
progenitor(marge, bart).
progenitor(marge, lisa).
progenitor(marge, maggie).

%Resolver predicados hermano, tio, primo y abuelo.

hermano(Hermano1, Hermano2) :- progenitor(Padre, Hermano1), progenitor(Padre, Hermano2), Hermano1 \= Hermano2.

tio(Sobrino, Tio) :- progenitor(Padre, Sobrino), hermano(Padre, Tio).
tio(Tio, Sobrino) :- hermano(Tio, Padre), progenitor(Padre, Sobrino).

primo(Primo1, Primo2) :-
    progenitor(Padre, Primo1),
    progenitor(Tio, Primo2),
    hermano(Padre, Tio).

abuelo(Abuelo, Hijo) :-
    progenitor(Abuelo, Padre),
    progenitor(Padre, Hijo).