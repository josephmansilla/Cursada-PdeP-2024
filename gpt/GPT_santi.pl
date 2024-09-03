
% 1)
%%PP
palabra(perro, chatPGT, 2112).
palabra(perro, piscis, 2510).
palabra(perro, pongAI, 2112).
palabra(gato, chatPGT, 2215).
palabra(gato, piscis, 2700).
palabra(gato, pongAI, 2492).
%% como hubiese modelado yo

palabra(pgt, perro, 2112).
palabra(piscis, perro, 2150).
palabra(pongAI, perro, 2112).

palabra(pgt, gato, 2215).
palabra(piscis, gato, 2215).
palabra(pongAI, gato, 2215).

palabra(pgt, comida, 2450).
palabra(piscis, comida, 2700).
palabra(pongAI,comida, 2492).

palabra(pgt, morfi, 2452).
palabra(piscis, morfi, 2721).
% Morfi no existe en PongAI y por el principio del Universo Cerrado todo lo que no este
% en la base de conocimientos se considera como falso. Por lo tanto, no agrego esta
% informacion a mi base de conocimientos. 

palabra(pgt, corcho, 1852).
palabra(piscis, corcho, 1918).
palabra(pongAI, corcho, 1918).

palabra(pgt, palabra, 1999).

palabra(pgt, cosito, 1000).
palabra(piscis, cosito, 1000).
palabra(pongAI, cosito, 1000).

palabra(pgt, ruby, 2000).

% MartínEsElMejorProfe tampoco existe y en este caso en ningun modelo, entonces por 
% principio del Universo Cerrado se considera como falso.  

% buena justificacion

modelo(Modelo):-
    palabra(Modelo, _, _).
persona(Persona):-
    perfil(Persona, _).


%% PP
% como hubiese modelado yo
modeloIA(chatPGT).
modeloIA(piscis).
modeloIA(pongAI).

% 2)
noLaSabeNadie(Palabra):-
    not(palabra(_, Palabra, _)).


%% PP
noLaSabeNadie(Palabra):-
    not((modeloIA(Nombre), palabra(Palabra,Nombre,_))).
    % no existen modelos IA que sepan esa palabra
    % tambien se puede plantear
    % ningun modeloIA sabe la palabra
    % forall(modeloIA(Nombre), not(palabra(Nombre, Palabra, _))).


% 3)
sabePalabra(Palabra, Modelo) :-
    palabra(Modelo, Palabra, _).

sabePalabra2(Palabra, Modelo):- palabra(Palabra, Modelo,_). % es más coherente el orden, pero no es recomendable hacer predicados de 1 linea
                                                            % puede agregan expresividad o solamente son codesmells (no era necesario).

esPalabraDificil(Palabra) :-
    palabra(Modelo, Palabra, _),  % Asegura que la palabra es conocida por algún modelo
    findall(OtroModelo, 
            (palabra(OtroModelo, _, _), Modelo \= OtroModelo, not(sabePalabra(Palabra, OtroModelo))), 
            OtrosModelos),
    length(OtrosModelos, CantidadModelosNoSaben),
    CantidadModelosNoSaben >= 2.

%% PP
noLaConocenDos(Palabra):-
    not(palabra(Palabra, UnModeloIA, _)),
    not(palabra(Palabra, OtroModeloIA, _)),
    UnModeloIA \= OtroModeloIA.

esPalabraDificil(Palabra):-
    noLaConocenDos(Palabra),
    palabra(Palabra, ModeloIA,_).
    
% 4)
diferenciaAbsoluta(Modelo, Palabra, OtraPalabra, Valor):-
    palabra(Modelo, Palabra, ValorPalabra),
    palabra(Modelo, OtraPalabra, ValorOtraPalabra),
    Diferencia is ValorPalabra - ValorOtraPalabra,
    Valor is abs(Diferencia).

sonPalabrasCercanasAux(Palabra1, Palabra2, Modelo):-
    palabra(Modelo, Palabra1, _),
    palabra(Modelo, Palabra2, _),
    Palabra1 \= Palabra2,
    diferenciaAbsoluta(Modelo, Palabra1, Palabra2, Valor),
    Valor < 200.

% PP
palabrasCercanaBis(Modelo, UnaPalabra, OtraPalabra):-
    diferenciaAbsolutaModelos(UnaPalabra, OtraPalabra, Modelo, Resultado),
    Resultado < 200.
%
diferenciaAbsolutaBis(Valor, OtroValor, Resultado):- Resultado is abs(Valor - OtroValor).
%

% 5)
sonSinonimos(cosito, Palabra, Modelo):-
    palabra(Modelo, Palabra, ValorPalabra),
    between(1800, 2100, ValorPalabra).
sonSinonimos(Palabra, OtraPalabra, Modelo):-
    palabra(Modelo, Palabra, _),
    palabra(Modelo, OtraPalabra, _),
    Palabra \= OtraPalabra,
    diferenciaAbsoluta(Modelo, Palabra, OtraPalabra, Valor),
    Valor < 20.

% Paradigmas no tiene sinonimo, y al no agregarla a mi base de conocimientos, siempre 
% que se consulte sobre esta palabra dara falso, por el principio del Universo Cerrado.

%% PP
sonSinonimosBis(Palabra, cosito, Modelo):-
    palabra(Palabra, Modelo, ValorPalabra),
    between(1800, 2100, ValorPalabra).
sonSinonimosBis(UnaPalabra, OtraPalabra, Modelo):-
    diferenciaAbsolutaModelos(UnaPalabra, OtraPalabra, Modelo, Resultado),
    between(0, 20, Resultado). % como es valor absoluto nunca puede ser negativo!, esto ayuda a una inversibilidad que no me piden


% 6)
modeloMenosBot(Modelo, Palabra, OtraPalabra) :-
    modelo(Modelo),
    palabra(Modelo, Palabra, _),
    palabra(Modelo, OtraPalabra, _),
    diferenciaAbsoluta(Modelo, Palabra, OtraPalabra, ValorModelo),
    forall((diferenciaAbsoluta(OtroModelo, Palabra, OtraPalabra, ValorOtroModelo),
            Modelo \= OtroModelo),
            ValorModelo < ValorOtroModelo).


%% PP
modeloMenosBotBis(UnaPalabra, OtraPalabra, ModeloMenosBot):-
    diferenciaAbsolutaModelos(UnaPalabra, OtraPalabra, ModeloMenosBot, Resultado),
    forall(diferenciaAbsolutaModelos(UnaPalabra, OtraPalabra, OtroModelo, OtroResultado), (ModeloMenosBot \= OtroModelo, Resultado \= OtroResultado)).

diferenciaAbsolutaModelos(UnaPalabra, OtraPalabra, Modelo, Resultado):-
    modeloIA(Modelo),
    palabra(UnaPalabra, Modelo, ValorPalabra),
    palabra(OtraPalabra, Modelo, ValorOtraPalabra),
    UnaPalabra \= OtraPalabra,
    diferenciaAbsolutaBis(ValorPalabra, ValorOtraPalabra, Resultado).
    
% 7)
encontrarCantidadSinonimos(Palabra, Modelo, Cantidad):-
    modelo(Modelo),
    palabra(Modelo, Palabra, _),
    findall(Sinonimo, (palabra(Sinonimo), Palabra \= Sinonimo, sonSinonimos(Palabra, Sinonimo, Modelo)), %% mal ahi esto amigo, esto son las compus de mierda que 
                                                                                                        %% no te tiran el subrayado de errores..
    Sinonimos),
    length(Sinonimos, Cantidad).

palabraComodin(Palabra, Modelo):-
    palabra(Modelo, Palabra, _),
    not(( palabra(Modelo, OtraPalabra, _),
          Palabra \= OtraPalabra,
          encontrarCantidadSinonimos(Palabra, Modelo, CantidadSinonimosPalabra),
          encontrarCantidadSinonimos(OtraPalabra, Modelo, CantidadSinonimosOtraPalabra),
          CantidadSinonimosPalabra < CantidadSinonimosOtraPalabra )).

% PP

laCantidadDeSinonimos(UnaPalabra, Modelo, CantidadSinonimos):-
    findall(Sinonimo, (palabra(OtraPalabra, Modelo, _), sonSinonimosBis(Modelo, UnaPalabra, OtraPalabra)), ListaSinonimos),
    length(ListaSinonimos, CantidadSinonimos).

palabraComodinBis(Palabra, Modelo):-
    modeloIA(Modelo),
    palabra(Palabra, Modelo, _),
    laCantidadDeSinonimos(Palabra, Modelo, CantidadSinonimos),
    forall((modeloIA(OtrosModelos), OtrosModelos \= Modelo, palabra(OtraPalabra, OtrosModelos,_), laCantidadDeSinonimos(OtraPalabra, OtrosModelos, OtraCantidadSinonimos)), CantidadSinonimos > OtraCantidadSinonimos).
    

% 8)

perfil(pedro, programador(ruby, 5)).
perfil(maria, estudiante(programacion)).
perfil(sofia, estudiante(psicologia)).
perfil(juan, hijoDePapi).

esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, programador(Lenguaje, Experiencia)),
    palabra(Modelo, Lenguaje, _),
    Palabra \= Lenguaje,
    diferenciaAbsoluta(Modelo, Palabra, Lenguaje, Valor),
    Valor < Experiencia * 50.
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, estudiante(programacion)),
    palabra(Modelo, wollok, _),
    diferenciaAbsoluta(Modelo, Palabra, wollok, Valor),
    Palabra \= wollok,
    Valor < 50.
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, estudiante(Carrera)),
    diferenciaAbsoluta(Modelo, Palabra, Carrera, Valor),
    palabra(Modelo, Carrera, _),
    Palabra \= Carrera,
    Valor =< 200.
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, hijoDePapi),
    palabra(Modelo, guita, _),
    sonSinonimos(Palabra, guita, Modelo). 
esRelevante(Palabra, Persona, Modelo):-
    palabra(Modelo, Palabra, _),
    perfil(Persona, futbolista),
    palabra(Modelo, pelotita, _),
    sonSinonimos(Palabra, pelotita, Modelo). % bonus


palabrasRelevantes(Palabras, Persona, Modelo):-
    persona(Persona), 
    modelo(Modelo), 
    findall(Palabra, esRelevante(Palabra, Persona, Modelo), Palabras).

%%PP

palabrasRelevantes(Persona, Modelo, PalabrasRelevantes):-
    perfil(Persona, _),
    modeloIA(Modelo),
    findall(PalabraRelevante, esPalabraRelevante(PalabraRelevante, Modelo, Persona), PalabrasRelevantes).

esPalabraRelevante(UnaPalabra, UnModelo, NombrePersona):-
    perfil(NombrePersona, programador(Lenguaje, AniosExperiencia)),
    diferenciaAbsolutaModelos(UnaPalabra, Lenguaje, UnModelo, Valor),
    Valor < AniosExperiencia * 50.

esPalabraRelevante(UnaPalabra, Modelo, NombrePersona):-
    perfil(NombrePersona, estudiante(programacion)),
    diferenciaAbsolutaModelos(UnaPalabra, wollok, Modelo, Valor),
    between(0,50,Valor).
esPalabraRelevante(UnaPalabra, Modelo, NombrePersona):-
    perfil(NombrePersona, estudiante(Carrera)),
    diferenciaAbsolutaModelos(UnaPalabra, Carrera, Modelo, Valor),
    between(0,200,Valor). 
esPalabraRelevante(UnaPalabra, Modelo, NombrePersona):-
    perfil(NombrePersona, hijoDePapi),
    sonSinonimosBis(UnaPalabra, guita, Modelo).

%% BONUS PP
esPalabraRelevante(amiguito, Modelo, lisandro):-
    modeloIA(Modelo),
    palabra(amiguito, Modelo, _).

% 9)
gusta(juan, plata).
gusta(maria, joda).
gusta(maria, tarjeta).
gusta(inia, estudiar).
gusta(bauti, utn).
gusta(martin, comer).

relacionado(plata, gastar).
relacionado(gastar, tarjeta).
relacionado(tarjeta, viajar).
relacionado(estudiar, utn).
relacionado(utn, titulo).
relacionado(tarjeta, finanzas).

relacionadoDirectoOIndirecto(OtroGusto, Gusto):- % relacion directa
    relacionado(OtroGusto, Gusto).
relacionadoDirectoOIndirecto(OtroGusto, Gusto):- % relacion indirecta
    relacionado(OtroGusto, AlgunGusto),
    relacionadoDirectoOIndirecto(AlgunGusto, Gusto).

leInteresa(Persona, Gusto):-
    gusta(Persona, Gusto).
leInteresa(Persona, Gusto):-
    gusta(Persona, OtroGusto),
    relacionadoDirectoOIndirecto(OtroGusto, Gusto).

%% nada que agregar ✅