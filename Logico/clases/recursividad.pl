valor(dibuMartinez, 10).
valor(armani, 4).
valor(messi, 100).
valor(tagliafico, 5).
valor(paredes, 5).
valor(dePaul, 6).
valor(pellegrini, 4).
valor(hauche, 3).
valor(montiel, 6).
valor(macAllister,8).
valor(armoa, 2).

seleccion(dibuMartinez).
seleccion(armani).
seleccion(messi).
seleccion(tagliafico).
seleccion(paredes).
seleccion(dePaul).
seleccion(montiel).
seleccion(macAllister).

jugadoresAComprar(Plata, Jugadores):-
    findall(jugador(Jugador, Valor), (valor(Jugador, Valor), seleccion(Jugador)), JugadoresPosibles),
    combinarJugadores(Plata, JugadoresPosibles, Jugadores),
    length(Jugadores, CantidadJugadores),
    CantidadJugadores >= 2.

combinarJugadores(_,[],[]).
combinarJugadores(Plata, [jugador(Jugador, Valor)| JugadoresPosibles], [Jugador | Jugadores]):-
    Plata >= Valor,
    PlataRestante is Plata - Valor,
    combinarJugadores(PlataRestante, JugadoresPosibles, Jugadores).
combinarJugadores(Plata, [_ | JugadoresPosibles], Jugadores):-
    combinarJugadores(Plata, JugadoresPosibles, Jugadores).

jugadoresAComprar2(Plata, PlataRestante, Jugadores):-
    findall(jugador(Jugador, Valor), (valor(Jugador, Valor), seleccion(Jugador)), JugadoresPosibles),
    combinarJugadores2(Plata, PlataRestante, JugadoresPosibles, Jugadores),
    length(Jugadores, CantidadJugadores),
    CantidadJugadores >= 2.

combinarJugadores2(Plata,Plata,[],[]).
combinarJugadores2(Plata, VueltoPorJugador, [jugador(Jugador, Valor)| JugadoresPosibles], [Jugador | Jugadores]):-
    combinarJugadores2(Plata, PlataRestante, JugadoresPosibles, Jugadores),
    PlataRestante >= Valor,
    VueltoPorJugador is PlataRestante - Valor.
combinarJugadores2(Plata, PlataRestante,[_ | JugadoresPosibles], Jugadores):-
    combinarJugadores2(Plata, PlataRestante, JugadoresPosibles, Jugadores).