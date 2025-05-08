%% PUNTO 1 %%

cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).

cree(juna, conejoPascua).

cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% suenio(cantante(discosVendidos)).
% suenio(futbolista(Equipo)).
% suenio(loteria(NumerosAPostado)).

sueno(gabriel, loteria(5)).
sueno(gabriel, loteria(9)).
sueno(gabriel, futbolista(arsenal)).

sueno(joseph, futbolista(boca)).
sueno(joseph, cantante(10000000)).

sueno(juan, cantante(100000)).
sueno(macarena, cantante(10000)).

% en este entró en juego el concepto de functores

%% PUNTO 2 %%

esAmbiciosa(Persona):-
    sueno(Persona, _),
    findall(NivelSuenio, (sueno(Persona, Suenio), valorSuenio(Suenio, NivelSuenio)), ListaNiveles),
    sum_list(ListaNiveles, SumaTotalNiveles),
    valorAmbicioso(SumaTotalNiveles, 20).

valorAmbicioso(SumaTotalNiveles, Valor):-
    SumaTotalNiveles > Valor.

valorSuenio(cantante(DiscosVendidos), 6):- DiscosVendidos >= 500000.
valorSuenio(cantante(DiscosVendidos), 4):- between(0, 500000, DiscosVendidos).

valorSuenio(loteria(Numero), ValorDificultad):- ValorDificultad is 10 * Numero.

valorSuenio(futbolista(EquipoSonado), 3):-  esEquipoChico(EquipoSonado).
valorSuenio(futbolista(EquipoSonado), 16):- not(esEquipoChico(EquipoSonado)).

esEquipoChico(arsenal).
esEquipoChico(aldosivi).

%% PUNTO 3 %% 

% tieneQuimica(Personaje, Persona).

tieneQuimica(campanita, Persona):-
    cree(Persona, campanita),
    sueno(Persona, SuenioElegido),
    valorSuenio(SuenioElegido, ValorArbitrario),
    between(0, 5, ValorArbitrario).

tieneQuimica(Personaje, Persona):-
    cree(Persona, Personaje),
    soloSueniosPuros(Persona),
    not(esAmbiciosa(Persona)).

soloSueniosPuros(Persona):-
    sueno(Persona, _),
    forall(sueno(Persona, Suenio), esSuenioPuro(Suenio)).

esSuenioPuro(futbolista(_)).
esSuenioPuro(cantante(DiscosVendidos)):- between(0, 200000, DiscosVendidos).


%% PUNTO 4 %% 

amigos(campanita, reyesMagos).
amigos(campanita, conejoPascua).
amigos(conejoPascua, cavenaghi).

sonAmigos(UnPersonaje, OtroPersonaje):-
    amigos(UnPersonaje, OtroPersonaje).
sonAmigos(UnPersonaje, OtroPersonaje):-
    amigos(UnPersonaje, TercerPersonaje),
    amigos(TercerPersonaje, OtroPersonaje).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoPascua).

puedeAlegrar(Personaje):-
    not(estaEnfermo(Personaje)).
puedeAlegrar(Personaje):-
    amigos(Personaje, OtroPersonaje),
    not(estaEnfermo(OtroPersonaje)).

leAlegra(Personaje, Persona):-
    sueno(Persona, _),
    tieneQuimica(Personaje, Persona),
    puedeAlegrar(Personaje).