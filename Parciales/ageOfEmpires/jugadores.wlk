
import recursos.*
import edificios.*

class Partida{
    const jugadores = []
}

class Jugador{
    const property equipo
    var property oro
    var property comida
    var property madera
    var property piedra
    // no puede gastar más de lo que tiene
    method explotarZona(zona){
        const costoDeExplotarZona = zona.costo()
        self.validarTieneSuficiente(oro, costoDeExplotarZona)
        self.cambiarOro(-costoDeExplotarZona)
        zona.agregarDelRecurso(self)
    }
    method validarTieneSuficiente(recurso, cantidad){ if(not (recurso >= cantidad)){ self.error("No tiene suficiente de " + recurso.toString() ) } }
    method cambiarOro(cantidad){ oro += cantidad }
    method cambiarPiedra(cantidad){ piedra += cantidad }
    method cambiarMadera(cantidad){ madera += cantidad }
    method cambiarComida(cantidad){ comida += cantidad }

    // PUNTO 2
    method rendirse(){
        edificios = []
        equipo.recibirRecursosDe(self)
    }

    // PUNTO 3
    method sinRecursos() = self.sinRecurso(oro) && self.sinRecurso(piedra) && self.sinRecurso(madera) && self.sinRecurso(comida)
    method sinRecurso(recurso) = recurso == 0
    var property cantidadEdificiosConstruidos = 0 // veremos si sirve o no

    // PUNTO 5
    var property edificios = []
    method construirEdificio(edificio){
        self.validarPuedeConstruir(edificio)
        self.consumirRecursos(edificio)
        self.agregarEdificio(edificio)
    }
    method validarPuedeConstruir(edificio){
        self.validarTieneSuficiente(oro, edificio.costoOro())
        self.validarTieneSuficiente(piedra, edificio.costoPiedra())
        self.validarTieneSuficiente(comida, edificio.costoComida())
        self.validarTieneSuficiente(madera, edificio.costoMadera())
    }
    method consumirRecursos(edificio){
        self.cambiarOro(-edificio.costoOro())
        self.cambiarPiedra(-edificio.costoPiedra())
        self.cambiarMadera(-edificio.costoMadera())
        self.cambiarComida(-edificio.costoComida())
    }
    method agregarEdificio(edificio){ edificios.add(edificio) }

    // PUNTO 6
    method atacarConEdificio(edificio, jugadorEnemigo){
        const edificioConveniente = self.edificioConveniente(jugadorEnemigo)
        if(not edificioConveniente.isEmpty()){ 
            edificio.poderEspecial(self, jugadorEnemigo, edificioConveniente)
            edificioConveniente.seDestruyo()
        } else {/*sinefecto*/}
    }
    method edificioConveniente(jugadorEnemigo) = jugadorEnemigo.edificiosVulnerables().head()

    method edificiosVulnerables(){ 
        const vulnerable = edificios.filter{ edificio => not edificio.destruido() && not edificio.buenEstado() }
        if(vulnerable.isEmpty())    return edificios.filter{ edificio => not edificio.destruido() }
        else                        return vulnerable
    }
    method perderEdificio(edificio){ edificios.remove(edificio) }

    // PUNTO 7
    method mejorarEdificio(edificio){
        if((not edificio.destruido()) && (not edificio.yaMejorado()) && self.validarPuedeMejorar(edificio)){
            edificio.mejorarEdificio()
        } 
        // nada de errores al fallar, queremos que sea una funcionalidad como los juegos que no pasa nada!!!!!!
        // si no tiene recursos ya tira su error
    }
    method validarPuedeMejorar(edificio){
        self.validarTieneSuficiente(oro, edificio.costoMejoraOro())
        self.validarTieneSuficiente(piedra, edificio.costoMejoraPiedra())
        self.validarTieneSuficiente(comida, edificio.costoMejoraComida())
        self.validarTieneSuficiente(madera, edificio.costoMejoraMadera())
        return true // se valida todo :)
    }
}


class Equipo{
    var miembros = #{}
    method recibirRecursosDe(jugador){
        miembros.remove(jugador)
        const division = miembros.size() - 1
        miembros.forEach{miembro => self.darRecursosDeA(jugador, miembro, division) }
    }
    method darRecursosDeA(jugador, miembro, division){
        miembro.cambiarOro(jugador.oro() / division)
        miembro.cambiarMadera(jugador.madera() / division)
        miembro.cambiarPiedra(jugador.piedra() / division)
        miembro.cambiarComida(jugador.comida() / division)
    }

    // PUNTO 3
    method fueDerrotado() = miembros.all{ miembro =>  miembro.sinRecursos() }
    method edificacionesTotales() = miembros.sum{ miembro => miembro.cantidadEdificiosConstruidos()}
}