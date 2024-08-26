% BASE DE CONCOCIMIENTOS INCIAL
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

% 1)
% Amigazo fue entrevistado el jueves y lo vieron 1.500, también el sábado y lo vieron 14.500.
% entrevista(Protagonista, Dia, Audiencia).
entrevista(amigazo, jueves, 1500).
entrevista(amigazo, sabado, 14500).

% Hell Music fue entrevistado el lunes y el martes, y lo vieron 200 y 70.000 personas respectivamente.
entrevista(hellMusic, lunes, 200).
entrevista(hellMusic, martes, 70000).

% Zulema Logato fue entrevistada únicamente el domingo, y la vieron 100.000 personas.
entrevista(zulemaLogato, domingo, 100000).

% 2)
% Saber qué protagonistas son talentos ocultos, esto ocurre cuando tienen algún talento
% pero nunca fueron entrevistados.
esTalentoOculto(Protagonista):-
    talento(Protagonista, _),
    not(entrevista(Protagonista, _, _)).

% 3)
% También queremos saber si algún protagonista es multifacético. Esto pasa cuando tiene
% dos o más talentos.
esMultifacetico(Protagonista):-
    talento(Protagonista, UnTalento),
    talento(Protagonista, OtroTalento),
    UnTalento \= OtroTalento.

% 4)
% Hablemos de carisma, el carisma es una forma de medir el nivel de talento de un 
% protagonista, por cada talento se suma carisma, nos piden calcular el carisma de un 
% protagonista sabiendo que:
%   - Cantar suma el nivel de canto si sabe un solo estilo, si sabe más de uno, suma el
%   doble.
%   - Actuar suma siempre 35.
%   - Hablar suma 40 para cualquier talento de habla, y suma 25 extra si es ceceoso 
%   (tener en cuenta que el valor base puede cambiar y ceceoso siempre debe sumar 
%   25 más que el base).
%   - Desmayarse no suma nada
valorBaseHablar(40).
carismaPorTalento(cantar(NivelDeCanto, Estilos), Carisma):-
    length(Estilos, CantidadEstilos),
    CantidadEstilos > 1,
    Carisma is NivelDeCanto * 2.
carismaPorTalento(cantar(NivelDeCanto, _), NivelDeCanto). % Sabe un solo estilo
carismaPorTalento(actuar, 35).
carismaPorTalento(hablar(ceceoso), Carisma):-
    valorBaseHablar(ValorBase),
    Carisma is ValorBase + 25.
carismaPorTalento(hablar(_), Carisma):-
    valorBaseHablar(ValorBase),
    Carisma is ValorBase.
carismaPorTalento(desmayarse, 0).

carismaProtagonista(Protagonista, CarismaTotal):-
    protagonista(Protagonista),
    findall(Carisma, 
            (talento(Protagonista, Talento), carismaPorTalento(Talento, Carisma)), 
            Carismas),
    sumlist(Carismas, CarismaTotal).

% 5)
% El carisma no sirve de nada si no tenés fama, la fama es el valor que se obtiene de 
% ser entrevistado por Anabela. La fama es la suma de fama que de cada entrevista:
%   - Si fue entrevistado un día de semana la fama es: cantidad de personas que lo vio
%   * 0,1 * carisma del entrevistado.
%   - Si fue entrevistado un día de fin de semana la fama es: cantidad de personas que
%   lo vio * 0,5 * carisma del entrevistado.
esFinDeSemana(sabado).
esFinDeSemana(domingo).

multiplicadorSegunDia(Dia, 0.1):-
    not(esFinDeSemana(Dia)).
multiplicadorSegunDia(Dia, 0.5):-
    esFinDeSemana(Dia).

valorFamaEntrevista(Protagonista, Dia, Audiencia, Fama):-
    multiplicadorSegunDia(Dia, Multiplicador),
    carismaProtagonista(Protagonista, Carisma),
    Fama is Audiencia * Multiplicador * Carisma.

fama(Protagonista, ValorFama):-
    protagonista(Protagonista),
    findall(Fama, 
           (entrevista(Protagonista, Dia, Audiencia), 
           valorFamaEntrevista(Protagonista, Dia, Audiencia, Fama)),
           Famas),
    sumlist(Famas, ValorFama).

% 6) El canal decidió empezar un programa de talentos donde le enseñan un nuevo talento
% a un protagonista y nos piden saber quién es el más apto para aprender un nuevo 
% talento. Dado un talento nuevo para aprender, queremos saber quién tiene más carisma
% resultante, tener en cuenta que si la persona ya sabe ese exacto talento, no suma
% carisma. Crear un predicado que nos diga quién es el más apto. Requiere ser sólo inversible para el protagonista.
nuevoCarisma(Protagonista, Talento, NuevoCarisma):-
    talento(Protagonista, Talento),
    carismaProtagonista(Protagonista, NuevoCarisma).
nuevoCarisma(Protagonista, Talento, NuevoCarisma):-
    not(talento(Protagonista, Talento)),
    carismaPorTalento(Talento, CarismaTalento),
    carismaProtagonista(Protagonista, CarismaProtagonista),
    NuevoCarisma is CarismaTalento + CarismaProtagonista.

protagonistaMasApto(Protagonista, Talento):-
    protagonista(Protagonista),
    talento(_, Talento),
    forall(nuevoCarisma(OtroProtagonista, Talento, OtraCarisma),
          (nuevoCarisma(Protagonista, Talento, Carisma), Carisma >= OtraCarisma, 
          Protagonista \= OtroProtagonista)).

% 7) Hay protagonistas que tienen bronca con otro, y hay protagonistas que se perciben
% amigos de otros. Dados dos protagonistas, se pide saber si el primero se la pudre al
% segundo. Esto se da cuando el primero tiene bronca con el segundo, o cuando el primero
% tiene un amigo que se la pudre al segundo.
amigo(zulemaLogato, inia).
amigo(hellMusic, martin).
amigo(amigazo, cappe).
amigo(amigazo, edu).
amigo(inia, martin).
amigo(martin, ogiCuenco).

bronca(samid, viale).
bronca(martin, amigazo).
bronca(ogiCuenco, mirtaLagrande).

seLaPudre(Protagonista, OtroProtagonista):-
    bronca(Protagonista, OtroProtagonista).
seLaPudre(Protagonista, OtroProtagonista):-
    amigo(Protagonista, Amigo),
    seLaPudre(Amigo, OtroProtagonista).