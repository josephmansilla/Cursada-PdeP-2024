%% BASE DE CONOCIMIENTO


% visitante(Nombre, grupo, Edad, Plata, Hambre, Aburrimiento).
visitante(eusebio, viejitos,80,3000,50,0).
visitante(carmela,viejitos, 80,0,0,25).
visitante(joseph, mansilla, 12, 4500, 49, 50).
visitante(milena, mansilla, 11, 4000, 70, 70).

% puestoComida(nombre, precio)
puestoComida(hamburguesa, 2000).
puestoComida(panchoConPapas, 1500).
puestoComida(lomitoCompleto, 2500).
puestoComida(caramelos, 0).


% nombre, 0= chicos ; 1 = adultos & chicos, tipo de atraccion
atracciones(autitosChocadores, tranquila(1)).
atracciones(casaEmbrujada, tranquila(1)).
atracciones(laberinto, tranquila(1)).
atracciones(tobogan, tranquila(0)).
atracciones(calesita, tranquila(0)).

atracciones(barcoPirata, intenso(14)).
atracciones(tazaChinas, intenso(6)).
atracciones(simulador3D, intenso(2)).

%% nombre, montaña rusa(giros, Segundos)
atracciones(abismoMortalRecargada, montaniaRusa(3, 134)).
atracciones(paseoPorElBosque, montaniaRusa(0, 45)).

atracciones(elTorpedoSalpicon, acuatica(9, 3)).
atracciones(mudaDeRopa, acuatica(9, 3)).

%% PUNTO 2

% caso excepcion
bienestar(Visitante, podriaEstarMejor):- 
    visitante(Visitante, Grupo, _,_,_,_),
    visitante(OtroVisitante, _, _,_,_,_),
    not(visitante(OtroVisitante, Grupo, _, _,_,_)).

%caso felicidadPlena
bienestar(Visitante, felicidadPlena):- visitante(Visitante,_,_,_,0,0).

% podria estar mejor
bienestar(Visitante, podriaEstarMejor):- 
    evaluoHambreYAburrimiento(Visitante, Total),
    between(1, 50, Total).

% necesitaEntretenerse
bienestar(Visitante, necesitaEntretenerse):- 
    evaluoHambreYAburrimiento(Visitante, Total),
    between(51, 99, Total).

% seQueire ir a su casa....
bienestar(Visitante, seVaACasa):- 
    evaluoHambreYAburrimiento(Visitante, Total),
    Total >= 100.

evaluoHambreYAburrimiento(Visitante, Total):-
    visitante(Visitante, _,_,_, Hambre, Aburrimiento), 
    Total is Hambre + Aburrimiento.

%% PUNTO 3

satisface(_, lomitoCompleto). 
satisface(Visitante, hamburguesa):- 
    visitante(Visitante,_, _, _, Hambre, _),
    Hambre < 50.
satisface(Visitante, panchoConPapas):-
    esNinio(Visitante).

satisface(Visitante, caramelos):-
    visitante(Visitante, _, _, _, _,_),
    not((puestoComida(Comida, _), puedePagarComida(Visitante, Comida))).

puedePagarComida(Visitante, Comida):-
    visitante(Visitante, _, _, Plata, _, _),
    puestoComida(Comida, Precio), 
    Plata >= Precio.

pagaYQuedaSatisfecha(Visitante):-
    puedePagarComida(Visitante, Comida),
    satisface(Visitante, Comida).

grupoFamiliarSatisfecha(Visitante):-
    visitante(Visitante, _, _,_,_,_),
    forall((visitante(Visitante,Grupo, _,_,_,_), visitante(OtroVisitante, Grupo, _,_,_,_)), (pagaYQuedaSatisfecha(Visitante),pagaYQuedaSatisfecha(OtroVisitante))).

%% PUNTO 4

lluviaDeHamburguesas(Visitante, Atraccion):-
    puedePagarComida(Visitante, Comida),
    condicionAtraccion(Atraccion).
condicionAtraccion(Atraccion, _):-
    atracciones(Atraccion, intensa(ValorCoeficiente)),
    ValorCoeficiente >= 10.
condicionAtraccion(Atraccion, Visitante):-
    esMontaniaRusaPeligrosa(Atraccion, Visitante).
condicionAtraccion(tobogan).

esMontaniaRusaPeligrosa(Atraccion, Visitante):-
    atracciones(Atraccion, montaniaRusa(_, Segundos)),
    esNinio(Visitante),
    Segundos >= 60.

esNinio(Visitante):-
    visitante(Visitante, _, Edad, _,_,_),
    between(0,13, Edad).

esMontaniaRusaPeligrosa(Atraccion, Visitante):-
    not(esNinio(Visitante)),
    montaniaRusaConMasVueltas(Atraccion, MayorCantidadVueltas),
    atracciones(Atraccion, montaniaRusa(MayorCantidadVueltas)).
    
montaniaRusaConMasVueltas(Atraccion, Vueltas):-
    atracciones(Atraccion, montaniaRusa(Vueltas,_)),
    atracciones(OtraAtraccion, montaniaRusa(MenosVueltas,_)),
    Vueltas >= MenosVueltas.


%% PUNTO 5
% visitante(Nombre,grupo, Edad, Plata, Hambre, Aburrimiento).

