class Tanque{
    const armas = []
    const tripulantes = 2
    var salud = 1000
    var property prendidoFuego = false

    method emiteCalor() = prendidoFuego || tripulantes > 3
    method sufrirDanio(danio){salud -= danio}
    method atacar(objetivo){
        armas.first{arma => !arma.estaAgotada()}.anyOne().dispararA(objetivo)
    }
}

class Recargable{
    var property cargador = 100
    method estaAgotada() = cargador <= 0
    method recargar(){cargador = 100}
}

class Lanzallamas inherits Recargable{
    method dispararA(objetivo){
        cargador -= 20
        objetivo.prendidoFuego(true)
    }
}

class Misil{
    const potencia
    method dispararA(objetivo){
        self.agotado(){true}
        objetivo.sufrirDanio(potencia)
    }
    method agotado() = false
}

class MisilTermico inherits Misil{
    override method dispararA(objetivo){ // no todos los lenguajes te piden este override
        if(objetivo.emiteCalor()){
            super(objetivo) // se busca tener el mismo efecto que tiene dispararA
        }
    }
}

object bulletBill inherits MisilTermico(potencia = 100){
    
}

class Metralleta inherits Recargable{
    const property calibre 
    method dispararA(objetivo){
        cargador -= 10
        if(calibre > 50){objetivo.sufrirDanio(calibre / 4)}
    }
}