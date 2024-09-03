%% BASE DE CONOCIMIENTO %%

jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

preferencias(botafogo, baratucci).
preferencias(botafogo, NombreJockey):- jockey(NombreJockey,_, Peso), Peso < 52.
preferencias(oldMan, NombreJockey):- atom_length(NombreJockey, Length), Length > 7.
preferencias(energica, Jockey):- jockey(Jockey,_,_), not(preferencias(botafogo, Jockey)).
preferencias(matBoy, NombreJockey):- jockey(NombreJockey, Altura, _), Altura > 170.

representa(elTute, falero).
representa(elTute, valdivieso).
representa(lasHormigas, lezcano).
representa(elCharabon, baratucci).
representa(elCharabon, leguisamo).

gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).
gano(oldMan, granPremioRepublica).
gano(oldMan, campeonatoPalermoDeOroyEnergica).
gano(matBoy, granPremioCriadores).

%% PUNTO 2 %%

caballoPrefiereVariosJockey(Caballo):-
    caballo(Caballo),
    preferencias(Caballo, UnJockey),
    