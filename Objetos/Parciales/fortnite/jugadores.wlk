import armas.*
import items.*

class Jugador{
    var property vida = vidaMaxima // entre 0 y 100
    const vidaMaxima = 100
    var skin // una sola
    var items = [] // varios
    var arma // una sola
    var tipoJugador
    method cambiarVida(cantidad){ vida = (vida + cantidad).max(100).min(0) }
    

    method danioAtaque() = tipoJugador.calcularDanio(self)
    method danioArma() = arma.danio()
    method porcentajeExtraPorBajaVida() = if(vida <= 10) 2 else if(vida <=50) 1.25 else 1
    method tieneItem(item) = items.contains(item)
    method agregarPotenciador(potenciador){ arma.colocarPotenciador(potenciador) }
    method sumarItem(item) {items.add(item)}

    method descartarItem(item){ items.remove(item) }
    method tieneItemsVida() = items.any{ item => item.esItemVida()}

    method elegirItemVida() = items.filter{ item => item.esItemVida() }.head() 
    method elegirItemRegular() = items.filter{ item => !item.esItemVida() }.head() 

    method consumirItem(enemigo){
        if(vida <= 50 && self.tieneItemsVida()){
            var itemElegido = self.elegirItemVida()
            itemElegido.aplicarEfecto(self, enemigo)
            self.descartarItem(itemElegido) // no se que hacer con esto la verdad
        } else{
            var itemElegido = self.elegirItemRegular()
            itemElegido.aplicarEfecto(self,enemigo)
            self.descartarItem(itemElegido)
        }
        // self.descartarItem(itemElegido) me dice que no identifica la variable
    }

    method atacarEnemigo(jugador, danio){ jugador.cambiarVida(-danio) }
    method estaMuerto() = vida == 0
    method esPersonalidad(personalidad) = tipoJugador.toString() == personalidad
    method muere() {self.cambiarVida(-vida)}
}
const escopetitaAlfonso = new Escopeta()
const rifleBrisa = new Rifle(potenciador = silenciador)
const pistolaCruyff = new Pistola(potenciador = balasDeFuego)
const cuchilloRatita = new Cuchillo()

const alfonso = new Jugador(tipoJugador = estandar, arma = escopetitaAlfonso, skin = "Spiderman")
const brisa = new Jugador(tipoJugador = campero, arma = rifleBrisa, items = [silenciador, miniEscudo, miniEscudo, botiquin], skin = "LaraCroft")
const changuito = new Jugador(tipoJugador = ninioRata, arma = cuchilloRatita , items = [granada, granada, granada], skin = "Maradona")
const deLaCruyff = new Jugador(tipoJugador = arriesgado, arma = pistolaCruyff , items = [silenciador, balasDeFuego, botiquin], skin = "ElRubius")

// COMPOSICION DE PERSONALIDADES
class Personalidad{ method calcularDanio(jugador) = jugador.danioArma() }
object estandar inherits Personalidad{}
object arriesgado inherits Personalidad{ override method calcularDanio(jugador) = super(jugador) * jugador.porcentajeExtraPorBajaVida() }
object campero inherits Personalidad{}
object ninioRata inherits Personalidad{ override method calcularDanio(jugador) = super(jugador) * 0.8 } // 1 - 0.2