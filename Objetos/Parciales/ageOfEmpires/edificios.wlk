import jugadores.*
import recursos.*

class Edificio{
    const costo /*oro, piedra, madera, comida*/
    const costoMejora = costo.map{ recurso => recurso * 1.5 }
    method costoOro() = costo.get(0)
    method costoPiedra() = costo.get(1)
    method costoMadera() = costo.get(2)
    method costoComida() = costo.get(3)
    
    var resistencia = self.resistenciaMaxima()
    method reparar(cantidad){ 
        resistencia = (resistencia + cantidad).max(self.resistenciaMaxima()) 
        
    }
    method buenEstado() = self.resistenciaMaxima() * 0.5 >= resistencia
    var property destruido = false

    method resistenciaMaxima() = 
        if(not destruido) {(oro.resistenciaAportada(self.costoOro()) + piedra.resistenciaAportada(self.costoPiedra()) + madera.resistenciaAportada(self.costoMadera())) * mejora.costoBonus()} 
        else 0
    method poderEspecial(duenio, jugadorEnemigo, edificio){ edificio.recibeDanio(self.danioRealizado())  }
    method danioRealizado() = 0
    method recibeDanio(cantidad){ resistencia = (resistencia - cantidad).min(0) }
    method seDestruyo(){ if(resistencia == 0){ destruido = true }}

    method sePuedeConvertir() = mejora.permeable()
    var property yaMejorado = false

    var mejora = sinMejorar
    method costoMejoraOro() =  costoMejora.get(0) 
    method costoMejoraPiedra() = costoMejora.get(1) 
    method costoMejoraMadera() = costoMejora.get(2) 
    method costoMejoraComida() = costoMejora.get(3) 
    
    method mejorarEdificio(){
        mejora = mejorado
        yaMejorado = true
        self.reparar(99999999)
    }
}

object sinMejorar{
    method permeable() = true
    method bonusCosto() = 1.0
}
object mejorado{
    method permeable() = false
    method bonusCosto() = 1.5
}

object galeriaDeTiro inherits Edificio(costo = [1000,0,500,350]){
    const multiplicadorDanio = 3
    override method danioRealizado() = 100
    override method poderEspecial(duenio, jugadorEnemigo, edificio){
        if(edificio.buenEstado()){ super(duenio, jugadorEnemigo, edificio) }
        else { edificio.recibeDanio(multiplicadorDanio * self.danioRealizado()) }
    }
}
object fuerte inherits Edificio(costo = [2000, 1500, 300, 200]){
    const cantidadReparacion = 20
    override method danioRealizado() = 50
    override method poderEspecial(duenio, jugadorEnemigo, edificio){
        duenio.cambiarComida(500)
        self.reparar(cantidadReparacion)
        super(duenio, jugadorEnemigo, edificio)
    }
}
object templo inherits Edificio(costo = [8000,750,0,500]){
    override method poderEspecial(duenio, jugadorEnemigo, edificio){
        if(edificio.sePuedeConvertir()){
            duenio.agregarEdificio(edificio)
            jugadorEnemigo.perderEdificio(edificio)
        }
    }
}