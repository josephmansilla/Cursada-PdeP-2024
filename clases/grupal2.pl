%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Base de conocimientos 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------
% Civilizaciones
%--------

% 1. Definición de jugadores y sus tecnologías.
civilizacion(lara,vikingos).
civilizacion(pedro,vikingos).
civilizacion(juan,japoneses).
civilizacion(juana,japoneses).
civilizacion(ana,romanos).
civilizacion(beto,incas).
civilizacion(carola,romanos).
civilizacion(dimitri,romanos).

tecnologiaDesarrollada(lara,herreria).
tecnologiaDesarrollada(lara,fundicion).

tecnologiaDesarrollada(pedro,herreria).
tecnologiaDesarrollada(pedro,forja).
tecnologiaDesarrollada(pedro,emplumado).
tecnologiaDesarrollada(pedro,laminas).

tecnologiaDesarrollada(juan,herreria).
tecnologiaDesarrollada(juan,fundicion).

tecnologiaDesarrollada(juana,herreria).
tecnologiaDesarrollada(juana,fundicion).

tecnologiaDesarrollada(ana,herreria).
tecnologiaDesarrollada(ana,forja).
tecnologiaDesarrollada(ana,emplumado).
tecnologiaDesarrollada(ana,laminas).

tecnologiaDesarrollada(beto,herreria).
tecnologiaDesarrollada(beto,fundicion).
tecnologiaDesarrollada(beto,forja).

tecnologiaDesarrollada(carola,herreria).

tecnologiaDesarrollada(dimitri,herreria).
tecnologiaDesarrollada(dimitri,fundicion).

%% Implementar los requerimientos del enunciado en esta sección.

% 2. Desarrollo de herreria, forja y (fundicion o romanos).
expertoEnMetales(Jugador) :-
  tecnologiaDesarrollada(Jugador,herreria),
  tecnologiaDesarrollada(Jugador,forja),
  (tecnologiaDesarrollada(Jugador,fundicion); 
  civilizacion(Jugador,romanos)).

% 3. (SE-1) Si más de un jugador tiene la civilización.
civilizacionPopular(Civilizacion) :-
  civilizacion(Uno, Civilizacion),
  civilizacion(Otro, Civilizacion),
  Uno \= Otro.

% 4. (SE-2) A nadie le falta desarrollarla.
alcanceGlobal(Tecnologia):-
  tecnologiaDesarrollada(_,Tecnologia),
  not((civilizacion(Jugador,_), not(tecnologiaDesarrollada(Jugador, Tecnologia)))).

% 5. (SE-3) Una Civilización es líder si tiene toda tecnología que tengan las demás.
civilizacionLider(Civilizacion) :-
    civilizacion(_, Civilizacion),
    forall(tecnologiaDesarrollada(_,Tecnologia), 
    (tecnologiaDesarrollada(Jugador,Tecnologia), 
    civilizacion(Jugador,Civilizacion))).

%--------
% Unidades
%--------

%ejercito(jugador,unidades).
ejercito(ana,jinete(caballo)).
ejercito(ana,piquero(1,escudo)).
ejercito(ana,piquero(2,sinEscudo)).

ejercito(beto,campeon(100)).
ejercito(beto,campeon(80)).
ejercito(beto,piquero(1,escudo)).
ejercito(beto,jinete(camello)).

ejercito(carola,piquero(2,escudo)).
ejercito(carola,piquero(3,sinEscudo)).

ejercito(lara,piquero(2,escudo)).
ejercito(lara,piquero(3,sinEscudo)).
ejercito(lara,piquero(3,escudo)).

%7 vida(Unidad,Vida).
vida(jinete(camello),80).
vida(jinete(caballo),90).

vida(campeon(Vida),Vida).

vida(piquero(1,sinEscudo),50).
vida(piquero(2,sinEscudo),65).
vida(piquero(3,sinEscudo),70).

vida(piquero(Nivel, escudo), VidaTotal) :- 
    vida(piquero(Nivel,sinEscudo), Vida),
    VidaTotal is Vida + (Vida * 0.1).

%7 Busca la unidad con la vida máxima en el ejército de un jugador.
unidadMasViva(Jugador, Unidad) :-
  ejercito(Jugador, Unidad),
  forall(ejercito(Jugador, OtraUnidad),
         (vida(Unidad, VidaUnidad), vida(OtraUnidad, VidaOtraUnidad),
          VidaUnidad >= VidaOtraUnidad)).

%Si se quisieran implementar nuevas unidades NO seria dificil...
%Simplemente se debe indicar su vida(Unidad,Vida) y sus caracteristicas.
%Ejemplo: 
%saboteador(Explosivos). %cantidad de explosivos.
%vida(saboteador(_),80).

%-------
%2da Parte
%-------

%8
leGana(jinete(_),campeon(_)).

leGana(campeon(_),piquero(_,_)).

leGana(piquero(_,_),jinete(_)).

leGana(jinete(camello),jinete(caballo)).

leGana(Unidad,OtraUnidad):-
  vida(Unidad,Vida),
  vida(OtraUnidad,OtraVida),
  Vida > OtraVida.

%9
sobreviveAsedio(Jugador):-
  ejercito(Jugador,_),
  findall(PiqueroEscudo, (ejercito(Jugador, piquero(_, escudo))), PiquerosEscudo),
  findall(PiqueroSinEscudo, (ejercito(Jugador, piquero(_, sinEscudo))), PiquerosSinEscudo),
  length(PiquerosEscudo, CantEscudo),
  length(PiquerosSinEscudo, CantSinEscudo),
  CantEscudo > CantSinEscudo.

%10
promedioAvance(Civilizacion,Promedio):-
  civilizacion(_,Civilizacion),
  cantidadDeTecnos(Civilizacion, CantTecnos),
  cantidadQueJuegan(Civilizacion,CantJugadores),
  Promedio is CantTecnos // CantJugadores.

cantidadDeTecnos(Civilizacion, Cantidad):-
  findall(Tecno, (civilizacion(Jugador,Civilizacion), tecnologiaDesarrollada(Jugador, Tecno)), ListaTecnos),
  length(ListaTecnos, Cantidad).

cantidadQueJuegan(Civilizacion,Cantidad):-
  findall(Jugador, civilizacion(Jugador,Civilizacion), Jugadores),
  length(Jugadores,Cantidad).

%11
masPoder(Jugador,OtroJugador):-
  vidaTotal(Jugador,VidaTotal1),
  vidaTotal(OtroJugador,VidaTotal2),
  VidaTotal1 > VidaTotal2.

vidaTotal(Jugador,VidaTotal):-
  findall(Vida, (ejercito(Jugador,Unidad), vida(Unidad,Vida)), Vidas),
  sum_list(Vidas,VidaTotal).

%12 Arbol de Tecnologias
%arbol(Anterior,Siguiente).

%Nivel 2
arbol(molino,collera).
arbol(herreria,emplumado).
arbol(herreria,forja). 
arbol(herreria,laminas).

%Nivel 3
arbol(collera,arado). 
arbol(emplumado,punzon).
arbol(forja,fundicion).
arbol(laminas,malla).

%Nivel 4
arbol(fundicion,horno).
arbol(malla,placas).

%12 SE-1
puedeDesarrollar(Jugador, Tecno) :-
  tieneArbol(Jugador, Tecno),                     %Debe cumplir con todas las tecnologías previas
  not(tecnologiaDesarrollada(Jugador, Tecno)).    %No tiene la tecnología desarrollada

%Casos Base
tieneArbol(_,molino).
tieneArbol(_,herreria).

tieneArbol(Jugador,Tecno):-
  arbol(Anterior, Tecno),
  tecnologiaDesarrollada(Jugador, Anterior),      %Toda tecnologia anterior debe estar desarrollada
  tieneArbol(Jugador,Anterior).

%12 SE-2
esClave(Tecnologia):-
  arbol(Tecnologia, Siguiente),
  arbol(Siguiente, OtroSiguiente).

%12 SE-3
salteoEtapas(Jugador,Tecnologia):-
  tecnologiaDesarrollada(Jugador,Tecnologia),
  not(tieneArbol(Jugador,Tecnologia)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Pruebas %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(tp).

%PUNTO 2
test('Ana es experta en metales', nondet):-
  expertoEnMetales(ana).
test('Beto es experto en metales', nondet):-
  expertoEnMetales(beto).
test('Carola no es experta en metales', fail):-
  expertoEnMetales(carola).
test('Dimitri no es experto en metales', fail):-
  expertoEnMetales(dimitri).
test('Jugadores expertos en Metales', set(X == [ana,beto])):-
  expertoEnMetales(X).

%PUNTO 3
test('Romanos es una civilizacion popular', nondet):-
  civilizacionPopular(romanos).
test('Incas no es una civilizacion popular', fail):-
  civilizacionPopular(incas).
test('Civilizacion popular', set(X == [romanos,vikingos,japoneses])):-
  civilizacionPopular(X).

%PUNTO 4
test('Herreria tiene alcance global', nondet):-
  alcanceGlobal(herreria).
test('Forja no tiene alcance global', fail):-
  alcanceGlobal(forja).
test('Tecnologias de Alcance Global', set(X == [herreria])):-
  alcanceGlobal(X).

%PUNTO 5
test('Romanos es una civilizacion lider', nondet):-
  civilizacionLider(romanos).
test('Incas no es una civilizacion lider', fail):-
  civilizacionLider(incas).
test('Civilizacion Lider', set(X == [romanos,vikingos])):-
  civilizacionLider(X).

%PUNTO 7
test('unidad mas viva de Ana', nondet):-
  unidadMasViva(ana, jinete(caballo)).
test('unidad mas viva de Carola', nondet):-
  unidadMasViva(carola, piquero(2,escudo)).

%PUNTO 8
test('Le gana',nondet):-
  leGana(piquero(1,escudo),jinete(camello)).
test('Le gana',nondet):-
  leGana(campeon(95),campeon(50)).
test('Le gana',nondet):-
  leGana(jinete(caballo),campeon(95)).
test('Le gana',nondet):-
  leGana(piquero(3,escudo),piquero(1,escudo)).

%PUNTO 9
test('Sobreviven Asedios', set(X == [beto,lara])):-
  sobreviveAsedio(X).

%PUNTO 10
test('Promedio de avance en Romanos',nondet):-
  promedioAvance(romanos,2).
test('Promedio de avance en Vikingos',nondet):-
  promedioAvance(vikingos,3).
test('Promedio de avance en Japoneses',nondet):-
  promedioAvance(japoneses,2).

%PUNTO 11
test('Beto tiene mas poder que Carola',nondet):-
  masPoder(beto,carola).
test('Ana tiene mas poder que Carola',nondet):-
  masPoder(ana,carola).

%PUNTO 12 B
test('Beto desarrolla molino',nondet):-
  puedeDesarrollar(beto,molino).
test('Beto desarrolla horno',nondet):-
  puedeDesarrollar(beto,horno).
test('Ana desarrolla fundicion',nondet):-
  puedeDesarrollar(ana,fundicion).
test('Beto no desarrolla herreria',fail):-
  puedeDesarrollar(beto,herreria).

test('Beto puede desarrollar', set(X == [molino,horno,emplumado,laminas])):-
  puedeDesarrollar(beto,X).
  
test('Ana puede desarrollar', set(X == [punzon,fundicion,malla,molino])):-
  puedeDesarrollar(ana,X).

%PUNTO 12 C
test('Son claves', set(X == [herreria,molino,forja,laminas])):-
  esClave(X).

%PUNTO 12 D
test('Dimitri salteo etapa',nondet):-
  salteoEtapas(dimitri,fundicion).

:- end_tests(tp).
