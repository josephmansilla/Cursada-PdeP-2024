%% PUNTO 1 %%
% usuario(Nickname, Suscriptores, contenido(Videos/shorts/streams)).

usuario(markitoCuchillos, 45000, video(gatitoTocaElPiano, 45, 50000, 1000)).
usuario(markitoCuchillos, 45000, video(gatitoTocaElPiano2, 65, 2000,2)).
usuario(sebaElDolar, 5000, video(esEldolarOEsparta, 60000, 2000000, 1040500)).
usuario(sebaElDolar, 45000, stream)).
usuario(tiqtoqera, 40000, short(15, 800000, [goldenHauer, cirugiaEstetica])).
usuario(tiqtoqera, 40000, short(23, 0, [])).
usuario(tiqtoqera, 40000, stream).
usuario(user99018, 1, noTieneContenido).

%% PUNTO 2 %%

esMyTuber(Nickname):-
    usuario(Nickname, _, Contenido),
    tieneContenido(Contenido).

tieneContenido(video(_,_,_,_)).
tieneContenido(stream).
tieneContenido(short(_,_,_)).

%% PUNTO 3 %%

esMilenial(Nickname):-
    usuario(Nickname, _, _), 
    forall(usuario(Nickname, _, Contenido), cumpleCondicionMilenial(Contenido)).

cumpleCondicionMilenial(video(_, _, 1000000, _)).
cumpleCondicionMilenial(video(_,_,_,1000)).

%% PUNTO 4 %%

noSubioNada(Nickname):-
    usuario(Nickname, _, Contenido),
    not(noTieneContenido(Contenido)).

cantidadVideosSubidos(Nickname, CantidadContenido):-
    findall(Contenido, (usuario(Nickname, _, Contenido), tieneContenido(Contenido)), TotalDeContenido),
    length(TotalDeContenido, CantidadContenido).

noSubioNadaBis(Nickname):-
    cantidadVideosSubidos(Nickname, 0).

%% PUNTO 5 %%

calcularEngagement(Nickname, EngagementTotal):-
    usuario(Nickname, _,_),
    findall(ValorContenido, (usuario(Nickname, _ , Contenido), condicionEngagement(Contenido, ValorContenido)), ValoresContenidos),
    sum_list(Contenidos, EngagementTotal).

condicionEngagement(stream,2000).
condicionEngagement(short(_, Likes, _), Likes).
condicionEngagement(video(_,_, Views, Likes), ValorContenido):- ValorContenido is Likes + Views / 1000. 

%% PUNTO 6 %% 

definirPuntaje(Nickname, PuntajeTuber):-
    puntosPorFiltro(Nickname, PuntajeFlitros),
    puntosPorVideosEngagement(Nickname, PuntajeVideos),
    puntosPorVideosLargos(Nickname, PuntajeLongitud),
    puntosPorCantidadDeContenido(Nickname, PuntajeCantidad),
    puntosPorTotalEngagement(Nickname, PuntajeEngagement),
    PuntajeTuber is PuntajeFlitros + PuntajeVideos + PuntajeLongitud + PuntajeCantidad + PuntajeLongitud.

puntosPorFiltro(Nickname, PuntajeFlitros):-
    usuario(Nickname, _, _),
    findall(CantidadFiltros, cantidadDeFiltros(Nickname, ListaFiltros), ListaCantidadFiltros),
    sum_list(ListaCantidadFiltros, SumaTotalFiltros),
    PuntajeFlitros is 2 * SumaTotalFiltros.

cantidadDeFiltros(Nickname, CantidadFiltros):-
    usuario(Nickname, _,short(_,_,ListaFiltros)),
    length(ListaFiltros, CantidadFiltros).

puntosPorVideosEngagement(Nickname, PuntajeEngagement):-
    usuario(Nickname,_,_),
    findall(VideoCumpleEngagement, cumpleCondicionEngagementPremio(Nickname, MinimoEngagement, VideoCumpleEngagement), VideosQueCumplen),
    length(VideosQueCumplen, CantidadVideosEngagement),
    PuntajeEngagement is 1 * CantidadVideosEngagement.

cumpleCondicionEngagementPremio(Nickname, MinimoEngagement, Contenido):-
    usuario(Nickname, _, Contenido),
    condicionEngagement(Contenido, CantidadDeEngagementVideo),
    CantidadDeEngagementVideo >= MinimoEngagement.

puntosPorVideosLargos(Nickname, PuntajeVideosLargos):-
    usuario(Nickname, _, _),
    findall(VideoLargo, videoEsLargo(Nickname, LongitudMinima, VideoLargo), ListaVideosLargos),
    length(ListaVideosLargos, TotalVideosLargos)
    PuntajeVideosLargos is 2 * TotalVideosLargos.

videoEsLargo(Nickname, LongitudMinima, NombreVideo):-
    usuario(Nickname, _, video(NombreVideo,LongitudVideo,_,_,_)),
    LongitudVideo >= LongitudMinima.

puntosPorCantidadDeContenido(Nickname, 1):-
    cantidadVideosSubidos(Nickname, Cantidad),
    Cantidad > 1.

puntosPorTotalEngagement(Nickname, 10):-
    calcularEngagement(Nickname, EngagementTotal),
    EngagementTotal > 1000000.

%% PUNTO 7 %%

mejorPuntaje(Nickname):-
    usuario(Nickname,_,_),
    forall((usuario(Nickname,_,_), 
        usuario(OtroNickname, _,_),
        definirPuntaje(Nickname, UnPuntaje),
        definirPuntaje(OtroNickname, OtroPuntaje)),
        UnPuntaje > OtroPuntaje).

%% PUNTO 8 %% 

administra(martin, sebaElDolar).
administra(martin, markitoCuchillos).
administra(iniaki, martin).
administra(iniaki, gaston).
administra(gaston, tiqtoqera).

administra(UnaPersona, OtraPersona):-
    administra(UnaPersona, TerceraPersona),
    administra(TerceraPersonam OtraPersona).