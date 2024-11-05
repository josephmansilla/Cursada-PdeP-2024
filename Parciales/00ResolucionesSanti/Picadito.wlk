class Jugador {
    var skills
    const peso
    const escoba
    const posicion
    const punteria
    const fuerza
    const nivelReflejos
    const nivelVision
    const equipo
    var valorArbitrario

    method nivelReflejos() = nivelReflejos
    method punteria() = punteria
    method fuerza() = fuerza
    method nivelVision() = nivelVision

    method ganaSkill(valor){ skills += valor}
    method pierdeSkill(valor){ skills = 0.max(skills - valor)}

    method cambiarValorArbitrario(nuevoValorArbitrario){ valorArbitrario = nuevoValorArbitrario}

    method nivelManejoEscoba() = skills / peso
    method velocidad() = escoba.velocidadEscoba() * self.nivelManejoEscoba()

    method habilidad() = self.velocidad() + skills + posicion.habilidadSegunPosicion()

    method lePasaElTrapo(otroJugador) = self.habilidad() >= otroJugador.habilidad()

    method esGroso() = self.habilidad() >= self.habilidadEquipoPromedia() && self.velocidad() >= valorArbitrario
    method habilidadEquipoPromedia() = equipo.habilidadPromedio()

    method esBloqueado(otroEquipo) = otroEquipo.any{ jugador => jugador.bloquea(self)}

    method esCazador() = false

    method jugarTurno(otroEquipo)

    method bloquea(otroJugador)
    
    method esBlancoUtil()

    method esGolpeado() {
        self.pierdeSkill(2)
        escoba.recibirGolpe()
    }
}

class Nimbus {
    const anioFabricacion
    const velocidadInicial = 80
    var salud
    const porcentajeSalud // lo considero como 0,N

    method perderSalud(valor){ salud = 0.max(salud - valor)}

    method velocidadEscoba() = (velocidadInicial - self.aniosDesdeFabricacion()) * porcentajeSalud
    method aniosDesdeFabricacion() = new Date().year() - anioFabricacion

    method recibirGolpe() {
        const danio = salud * 0.1
        self.perderSalud(danio)
    }
}

class SaetaDeFuego {
    const velocidad = 100

    method velocidadEscoba() = velocidad

    method recibirGolpe() { }
}

class Cazador inherits Jugador{
    var tieneQuaffle

    method tieneQuaffle() = tieneQuaffle
    method ganaQuaffle(){ tieneQuaffle = true}
    method pierdeQuaffle(){ 
        if(self.tieneQuaffle()){
            tieneQuaffle = false }
    }

    method habilidadSegunPosicion() = punteria * fuerza

    override method jugarTurno(otroEquipo){
        if(self.tieneQuaffle()){
            if(self.esBloqueado(otroEquipo)){
                const bloqueador = otroEquipo.bloqueador(self)
                self.pierdeSkill(2)
                bloqueador.ganaSkill(10) 
            } else{
                equipo.sumarPuntos(10)
                self.ganaSkill(10)
            }
            self.pierdeQuaffle()

            const cazadorMasRapidoRival = otroEquipo.cazadorMasRapido()
            cazadorMasRapidoRival.ganaQuaffle()

        } else{
            throw new DomainException(message = "El jugador no tiene la Quaffle")
        }
    }

    override method esCazador() = true

    override method bloquea(otroJugador) = self.lePasaElTrapo(otroJugador)

    override method esBlancoUtil() = self.tieneQuaffle()

    override method esGolpeado() { 
        super() 
        self.pierdeQuaffle() 
}
}

class Guardian inherits Jugador {

    method habilidadSegunPosicion() = nivelReflejos + fuerza

    override method jugarTurno(otroEquipo){ }

    override method bloquea(otroJugador) = 1.randomUpTo(3) == 3

    override method esBlancoUtil() = equipo.noTieneQuaffle()
}

class Golpeador inherits Jugador {

    method habilidadSegunPosicion() = punteria + fuerza

    override method jugarTurno(otroEquipo){
        const jugadorElegido = otroEquipo.anyOne{ jugador => jugador.esBlancoFacil()}

        if(self.puedeGolpear(jugadorElegido)){
            jugadorElegido.esGolpeado()
            self.ganaSkill(1)
        }
    }

    method puedeGolpear(jugador) = punteria >= jugador.nivelReflejos() || 1.randomUpTo(10) >= 8

    override method bloquea(otroJugador) = self.esGroso()
}

class Buscador inherits Jugador {
    var buscaSnitch
    var persigueSnitch
    var tieneSnitch
    var cantidadTurnosBuscando = 0
    var kmsRecorridos
    const kmsNecesarios
    var estaAturdido
    var turno = 0 // puede jugar cuando turno == 0

    method recorrer(){ 
        const kms = self.velocidad() / 1.6
        kmsRecorridos += kms
    }

    method pasoTurno() { cantidadTurnosBuscando += 1}
    method cantidadTurnosBuscando() = cantidadTurnosBuscando

    method buscaSnitch() = buscaSnitch
    method persigueSnitch() = persigueSnitch
    method perseguirSnitch(){ buscaSnitch = false
                              persigueSnitch = true}
    method atraparSnitch(){ persigueSnitch = false
                           tieneSnitch = true}


    method habilidadSegunPosicion() = nivelReflejos * nivelVision

    override method jugarTurno(otroEquipo){
        if(turno == 0){
        if(self.buscaSnitch()){
            const numero = 1.randomUpTo(1000)
            if(numero <= self.habilidad() + self.cantidadTurnosBuscando()){
                self.perseguirSnitch()
            }
        } else{ // considero que si no esta buscando la snitch entonces la esta persiguiendo 
            self.recorrer()
            if(kmsRecorridos >= kmsNecesarios){
                self.atraparSnitch()
                self.ganaSkill(10)
                equipo.sumarPuntos(150)
            }
}} else{
    throw new DomainException(message = "El buscador esta aturdido")
}
            self.pasoTurno()
            self.desAturdir()
}

    override method esBlancoUtil() = self.buscaSnitch() || kmsNecesarios - kmsRecorridos <= 1000

    override method esGolpeado(){
        if(self.esGroso()){
            self.aturdir()
        } else {
        super()
        self.reiniciarBusqueda()
    }
}
    method reiniciarBusqueda(){ kmsRecorridos = 0}

    method aturdir(){
        turno += 1
        estaAturdido = true
    }
    method desAturdir(){
        if(estaAturdido){
            estaAturdido = false
            turno -= 1
        }
    }
}

class Equipo {
    const jugadores
    var puntos

    method sumarPuntos(nuevosPuntos){ puntos += nuevosPuntos}

    method promedioHabilidad() = jugadores.sum{ jugador => jugador.habilidad()} / jugadores.size()

    method tieneEstrella(otroEquipo) = jugadores.any{ jugador => otroEquipo.all{ otroJugador => 
                                                      jugador.lePasaElTrapo(otroJugador)}}

    method jugar(otroEquipo) = jugadores.forEach{ jugador => jugador.jugarTurno(otroEquipo)}

    method bloqueador(jugadorRival) = jugadores.find{ jugador => jugador.bloquea(jugadorRival)}

    method cazadorMasRapido() {
        const cazadores = jugadores.filter{ jugador => jugador.esCazador()}

        return cazadores.max{ cazador => cazador.velocidad()}
    }

    method noTieneQuaffle() = jugadores.all{ jugador => !jugador.tieneQuaffle()}
}