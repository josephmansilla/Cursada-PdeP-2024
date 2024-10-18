/* Modelar un corral de vacas que permita:
Consultar cu6ntos litros de leche que podemos ordeöar de vacas contentas.
Sober si todas las vacas est6n contentas.
Ordeñar todas las vacas contentas.
Podemos agregar cabras? */

class Vaca {
    var leche
    method estaContenta(){
        leche > 10
    }
    method litrosDeLeche(){
        return leche
    }
    method ordenar(){
        leche -= 2
    }
}

class Corral{
    const vacas = []

    method lecheDisponible() = vacas.filter {vaca => vaca.estaContenta()}.sum{vaca => vaca.litrosDeLeche()}

    method todasContentas() = vacas.all{vaca => vaca.estaContenta()}

    method ordenar(){
        vacas.forEach{vaca => if(vaca.estaContenta()) vaca.ordenar()}
    }
}