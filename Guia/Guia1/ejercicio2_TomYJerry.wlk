// EJERCICIO 2 TOM Y JERRY

object tom {
    // A
    var property energia = 100
    
    method come(unRaton){
        energia += self.energiaDeComer(unRaton)
    }

    method velocidad() = 5 + (energia / 10)

    method corre(segundos){
        energia -= self.energiaDeCorrer(self.velocidad() * segundos)
    }
    // el otro objeto del juego seria jerry, no sabria que mensaje necesitaria entender ahora

    // B
 
    method energiaDeComer(raton) = 12 + raton.peso()
	
	method energiaDeCorrer(metros) = 0.5 * metros

    method meConvieneComerRatonA(unRaton, unaDistancia) = 
        self.energiaDeComer(unRaton) > self.energiaDeCorrer(unaDistancia)
}
object jerry {
    var property gramos = 10
    var property velocidad = 1
}