%% BASE DE CONOCIMIENTO %%

protagonista(amigazo).
protagonista(zulemaLogato).
protagonista(hellMusic).
protagonista(ogiCuenco).
protagonista(elGigolo).
talento(amigazo, hablar(ceceoso)).
talento(amigazo, desmayarse).
talento(zulemaLogato, actuar).
talento(zulemaLogato, cantar(20, [teatro])).
talento(hellMusic, cantar(30, [deathMetal, rock])).
talento(hellMusic, hablar(ingles)).
talento(ogiCuenco, actuar).

%% PUNTO 1 %%

entrevista(amigazo, jueves, 1500).
entrevista(amigazo, sabado, 14500).
entrevista(hellMusic, lunes, 200).
entrevista(hellMusic, martes, 70000).
entrevista(zulemaLogato, domingo, 100000).

%% PUNTO 2 %%

esTalentoOculto(Protagonista):-
    protagonista(Protagonista),
    talento(Protagonista, _),
    not(entrevista(Protagonista, _, _)).

%% PUNTO 3 %% 

esMultiFacetico(Protagonista):-
    talento(Protagonista, UnTalento),
    talento(Protagonista, OtroTalento),
    UnTalento \= OtroTalento.

carisma(Protagonista, NivelCarisma):-
    protagonista(Protagonista),
    talento(Protagonista, cantar(NivelCanto, Lista)),
    length(Lista,1),
    NivelCarisma is NivelCanto.

carisma(Protagonista, NivelCarisma):-
    protagonista(Protagonista),
    talento(Protagonista, cantar(NivelCanto, Lista)),
    length(Lista,Longitud),
    Longitud > 1,
    NivelCarisma is NivelCanto * 2.

carisma(Protagonista, 35):-
    talento(Protagonista, actuar).

carisma(Protagonista, NivelCarisma):-
    protagonista(Protagonista),
    talento(Protagonista, cantar(NivelCanto, Lista)),
    length(Lista,Longitud),
    Longitud > 1,
    NivelCarisma is NivelCanto * 2.

esCeceoso(Protagonista, 25):-
    talento(Protagonista, hablar(ceceoso)).

carisma(Protagonista, NivelCarisma):-
    esCeceoso(Protagonista, NivelCeceoso),
    talento(Protagonista, hablar(_)),
    valorBasePorHablar(ValorBaseHablar),
    NivelCarisma is ValorBaseHablar + NivelCeceoso.

valorBasePorHablar(40).

sumaTotalCarisma(Protagonista, ValorTotalCarisma):-
    protagonista(Protagonista),
    findall(Carisma, carisma(Protagonista, Carisma), ListaCarismaTotal),
    sum_list(ListaCarismaTotal, ValorTotalCarisma).
    
%% ceceoso en si no suma puntos, solamente son puntos extra si habla algo aparte de ceceoso
%% entonces si hablar ingles y habla ceceoso suma 65 con este valor base modificable

%% PUNTO 5 %%

fama(Protagonista, FamaDelProtagonista):-
    entrevista(Protagonista, DiaEntrevista, Visitas),
    sumaTotalCarisma(Protagonista, CarismaDelProtagonista),
    multiplicadorSegunDia(DiaEntrevista, ValorDelDia),
    FamaDelProtagonista is Visitas * ValorDelDia * CarismaDelProtagonista.

multiplicadorSegunDia(DiaEntrevista, 0.5):- esFinDeSemana(DiaEntrevista).
multiplicadorSegunDia(DiaEntrevista, 0.1):- not(esFinDeSemana(DiaEntrevista)).

esFinDeSemana(sabado).
esFinDeSemana(domingo).

%% PUNTO 6 %% 

protagonistaMasApto(Protagonista, TalentoAAprender):-
    protagonista(Protagonista),
    not(talento(Protagonista, TalentoAAprender)),
    forall(
        (protagonista(Protagonista), protagonista(OtroProtagonista), talento(Protagonista, UnTalento), talento(OtroProtagonista, OtroTalento), 
        carisma(Protagonista, UnCarisma), carisma(OtroProtagonista, OtroCarisma)),
        (UnCarisma > OtroCarisma)).

%% PUNTO 7 %%

%% BASE DE CONOCIMIENTO %% 

amigo(zulemaLogato, inia).
amigo(hellMusic, martin).
amigo(amigazo, cappe).
amigo(amigazo, edu).
amigo(inia, martin).
amigo(martin, ogiCuenco).
bronca(samid, viale).
bronca(martin, amigazo).
bronca(ogiCuenco, mirtaLagrande).

seLaPudre(UnProtagonista, OtroProtagonista):-
    bronca(UnProtagonista, OtroProtagonista).

seLaPudre(UnProtagonista, OtroProtagonista):-
    amigo(UnProtagonista, UnAmigo),
    bronca(UnAmigo, OtroProtagonista).
