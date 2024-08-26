%% BASE DE CONOCIMIENTO %% 

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

%% PUNTO 1 %%

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

%% PUNTO 2 %% 

satisfaceNecesidad(Persona, Herramienta):-
    tiene(Persona, Herramienta).

satisfaceNecesidad(Persona, aspiradora(PoderRequerido)):-
    tiene(Persona, aspiradora(Potencia)),
	between(0, Potencia, PotenciaRequerida). 

satisfaceNecesidad(Persona, Lista):-
    member(Herramienta, Lista),
    satisfaceNecesidad(Persona, Herramienta).