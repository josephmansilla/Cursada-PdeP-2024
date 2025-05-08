import jugadores.*
import items.*
import armas.*

class Partida{
    var turnos
    const zonas = #{}
    method interaccionJugadores(){

    }

    method recienArranca(){
        zonas.all{ zona => not zona.estaCerrada()}
    }
    method ganador(){

    }
    method seBugeo() = zonas.all{ zona => zona.jugadores().isEmpty()}
    method jugadoresTotales 
}

class Zona{
    var property jugadores = []
    var estaCerrada = false
    /*var enfrentados = profe.pares(jugadores)
    var jugador = enfrentados.get(0)
    var jugador2 = enfrentados.get(1)*/


    method interaccionJugadores(unJugador, otroJugador){
        
        unJugador.consumirItem(otroJugador)
        otroJugador.consumirItem(unJugador)
        unJugador.atacarEnemigo(otroJugador)
        otroJugador.atacarEnemigo(unJugador)
        self.removerMuerto(otroJugador)
        self.removerMuerto(unJugador)
    }
    method verificarSiSigue(jugador) = not jugador.estaMuerte()
    method removerMuerto(jugador){if(not self.verificarSiSigue(jugador)) jugadores.remove(jugador)}
}

class Evento{
    method ocurreEvento(jugadores)
}

object maradomarado inherits Evento{
    override method ocurreEvento(jugadores) = jugadores.forEach{ jugador => if(jugador.skin() == "Maradona") jugador.sumarItem(botiquin)}
}
object cierraZona inherits Evento{
    override method ocurreEvento(jugadores) = jugadores.forEach{ jugador => if(jugador.esPersonalidad("campero")) jugador.muere()}
}


object profe {
    method pares(lista) {
        const listaMezclada = lista.randomized()
        console.println(listaMezclada)
        const resultado = []
        (0..listaMezclada.size().div(2) - 1).forEach{ i =>
        const indice = i * 2
        resultado.add([listaMezclada.get(indice), listaMezclada.get(indice+1)])}
        return resultado
    }
}