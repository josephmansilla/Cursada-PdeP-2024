import items.*

class Arma{
    const danioBase
    var potenciador = null
    method danio() = danioBase + self.danioExtra()
    method danioExtra() = potenciador.efecto()
    method colocarPotenciador(nuevoPotenciador){ potenciador = nuevoPotenciador }
    
}
class Pistola inherits Arma(danioBase = 5){}

class Escopeta inherits Arma(danioBase = 20){}

class Rifle inherits Arma(danioBase = 22){}

class Cuchillo inherits Arma(danioBase = 10){ override method colocarPotenciador(nuevoPotenciador){ } }