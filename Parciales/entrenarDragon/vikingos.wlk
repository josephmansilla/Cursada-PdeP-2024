
class Vikingo{
    const peso // en kg
    var property velocidad // en km/h
    const inteligencia
    const property barbarosidad
    var property nivelHambre // 0% es panza llena
    var property item

    method pescadoCargado() = peso * 0.5 + 2 * barbarosidad
    method cambiarHambre(valor) { nivelHambre += valor }
    method danioProducido() = barbarosidad + item.danio()

    method puedeParticipar(posta) = nivelHambre + posta.requisitoHambre() <= 1
    method participar(posta){
        self.cambiarHambre(posta.requisitoHambre())
    }
    method removerItem(){ item = null }

    method consumirComida(){ 
        self.cambiarHambre(item.satisface())
        self.removerItem()
    }
    method esMejorEnQue(posta, vikingo) = posta.ganador([self,vikingo]) == self
}

class Posta{
    method requisitoHambre() = 0.5
    method ganador(participantes)
    method efectoParticipar(participantes){
        participantes.forEach{ participante => participante.participar(self) }
    }
    
}

class Pesca inherits Posta{
    override method ganador(participantes) = participantes.max{ participante => participante.pescadoCargado() } 
    
}
class Combate inherits Posta{
    override method requisitoHambre() = super() * 2
    override method ganador(participantes) = participantes.max{ participante => participante.danioProducido() }
    
}

class Carrera inherits Posta{
    const kmCarrera
    method truncarParticipantes(participantes) = participantes.take(2)

    override method requisitoHambre() = 0.01 * kmCarrera
    override method ganador(participantes) = self.truncarParticipantes(participantes).max{ participante => participante.velocidad() } 

}
const sistemaDeVuelo = new Item()
object hipo inherits Vikingo(peso = 50, velocidad = 10, inteligencia = 10, barbarosidad = 4, nivelHambre = 0, item = sistemaDeVuelo){}
object astrid inherits Vikingo(peso = 100, velocidad = 5 , inteligencia = 4, barbarosidad = 10, nivelHambre = 50, item = hacha){}
object patan inherits Vikingo(peso = 55, velocidad = 7 , inteligencia = 1, barbarosidad = 7, nivelHambre = 20, item = masa){}
object patapez inherits Vikingo(peso = 40, velocidad = 2 , inteligencia = 5, barbarosidad = 9, nivelHambre = 10, item = null){
    override method cambiarHambre(cantidad){ nivelHambre += cantidad * 2 }
    override method puedeParticipar(posta) = super(posta) / 2
    override method participar(posta){
        self.cambiarHambre(posta.requisitoHambre())
        self.consumirComida()
    }
    
}


class Item{
    method danio() = 0
}

object hacha inherits Item{ override method danio() = 30 }
object masa inherits Item{ override method danio() = 100 }