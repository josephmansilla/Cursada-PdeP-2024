// NECESITAMOS A OTRO MORTY 

// SI QUIERO TENER OTRO OBJECT: PUEDO COPIAR Y PEGAR PERO ES UNA SOLUCIÓN QUIKC AND DIRTY
// el código repetido y encima hay un vinculo fuerte entre los distintos morties

// Desventajas: 
    // si habia errores, se replican
    // si cambia el requerimiento, hay que cambiar todo a mano
    // propenso a errores
class Morty{ // debe ir con mayúscula la primera letra
    var property energia = 100
    const poderBase = 100
    const property dimension // para iniciarlizar un nuevo morty si o si debo agregar esta variable
    // el resto es opcional
    method poder() = poderBase * if(not self.estaTraumado()) 1 else 3
    method atacar(contrincante){
        energia -= 10
    }
    method estaTraumado() = self.energia() > 30 
 
}

object rick{
    method esDeSuDimension(unMorty) = unMorty.dimension() === "C-137"
}
