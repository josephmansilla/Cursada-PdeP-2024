% Práctico
% Dado el predicado come/2 que relaciono un animal con otro Q1 cual se come,
% modelar los siguientes predicados:

% hostil/2: Relaciono un animal con un bioma si todos los animales que lo habitan se lo comen.
% terrible/2: Relaciona un animal con un bioma si todos los animales que se lo comen habitan en él.
% compatibles/2: Relaciona dos animales si ninguno de los dos come al otro.
% adaptable/ 1: Se cumple para los animales que habitan todos los biomas.
% raro/ 1: Se cumple para los animales que habitan un único bioma.
% dominante/ 1: Se cumple para los animales que se comen a todos los otros animales del bioma en el que viven

hostil(Animal, Bioma) :- 
    animal(Animal), habitat(_,Bioma),
    forall(habitat(OtroAnimal,Bioma), come(OtroAnimal, Animal)).
terrible(Animal, Bioma) :- 
    animal(Animal), habitat(_,Bioma),
    forall(come(OtroAnimal, Animal), habitat(OtroAnimal, Bioma)).
compatibles(Animal, OtroAnimal) :-
    animal(Animal), animal(OtroAnimal),
    not(come(Animal, OtroAnimal)), 
    not(come(OtroAnimal, Animal)).

adaptable(Animal) :-
    animal(Animal),
    forall(habitat(_,Bioma), habitat(Animal, Bioma)).
raro(Animal) :-
    habitat(Animal, Bioma),
    not((habitat(Animal, OtroBioma), Bioma \= OtroBioma)).
dominante(Animal) :-
    habitat(Animal, Bioma),
    forall((habitat(OtroAnimal, Bioma), OtroAnimal \= Animal), come(Animal, OtroAnimal)).