
class Item{
    const property efecto
    const esItemVida = false
    method aplicarEfecto(persona, contrincante) = (self.aplicarA(persona, contrincante)).agregarPotenciador(self).cambiarVida(efecto)
    method aplicarA(persona, contrincante)
}


class ItemRegular inherits Item{
    override method aplicarA(persona, contrincante) = persona
    override method aplicarEfecto(persona, otro) = (self.aplicarA(persona,otro)).agregarPotenciador(self)
}
class ItemVida inherits Item(esItemVida = true){
    override method aplicarA(persona, contrincante) = persona
}

object botiquin inherits ItemVida(efecto = 100){}
object miniEscudo inherits ItemVida(efecto = 30){}
object balasDeFuego inherits ItemRegular(efecto = 5){}
object silenciador inherits ItemRegular(efecto = 3){}
object granada inherits ItemRegular(efecto = -30){
    override method aplicarA(persona, contrincante) = contrincante
}