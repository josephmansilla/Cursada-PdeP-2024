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
    preferencias(Caballo, OtroJockey),
    UnJockey \= OtroJockey.

%% PUNTO 3 %% 

aborrece(NombreCaballo, GrupoJockeys):-
    caballo(NombreCaballo),
    representa(GrupoJockeys, _),
    forall(representa(GrupoJockeys, Jockey), not((preferencias(NombreCaballo, Jockey), representa(GrupoJockeys, Jockey)))).

%% PUNTO 4 %%

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

jockeyPiolin(NombreJockey):-
    jockey(NombreJockey,_,_),
    forall(ganaronAlgoImportante(NombreCaballo), preferencias(NombreCaballo, NombreJockey)).

ganaronAlgoImportante(NombreCaballo):- gano(NombreCaballo, Premio), premioImportante(Premio).

%% PUNTO 5 %%

salioPrimero((NombreCaballo), [NombreCaballo | _]).
salioSegundo(NombreCaballo, [_ | [NombreCaballo | _]]).
ganoApuesta(ganador(NombreCaballo), Resultado):- salioPrimero(NombreCaballo, Resultado).
ganoApuesta(segundo(NombreCaballo), Resultado):- salioSegundo(NombreCaballo, Resultado).
ganoApuesta(exacto(UnCaballo, OtroCaballo), Resultado):- ganadoresExactos(UnCaballo, OtroCaballo).
ganoApuesta(imperfecta(UnCaballo, OtroCaballo), Resultado):- ganadoresExactos(UnCaballo, OtroCaballo).
ganoApuesta(imperfecta(UnCaballo, OtroCaballo), Resultado):- ganadoresExactos(OtroCaballo, UnCaballo).

ganadoresExactos(UnCaballo, OtroCaballo):- salioPrimero(UnCaballo, Resultado), salioSegundo(OtroCaballo, Resultado).

%% PUNTO 6 %% 

colorReal(botafogo, tordo).
colorReal(oldMan, alazan).
colorReal(energica, ratonero).
colorReal(matBoy, palomino).
colorReal(yatasto, pinto).

color(pinto, blanco).
color(pinto, marron).
color(palomino, marron).
color(palomino, blanco).
color(ratonero, gris).
color(ratonero, negro).
color(oldMan, marron).
color(tordo, negro).

puedeComprar(ColorPreferencia, CaballosDisponibles):-
    findall(CaballoCumplidor, (color(ColorPosible, ColorPreferencia), colorReal(CaballoCumplidor, ColorPosible)), Caballos),
    combinar(Caballos, CaballosDisponibles),
    CaballosDisponibles \= [].

combinar([],[]).
combinar([Caballo | CaballosPosibles], [Caballo | Caballos]):- combinar(CaballosPosibles, Caballos).
combinar([_ | CaballosPosibles], Caballos):- combinar(CaballosPosibles, Caballos).