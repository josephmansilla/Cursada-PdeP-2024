import pokemon.*

class Movimiento{
    var cantidadUsosRestantes
    const sigma = 1
    const property cantPuntos 
    const efecto 

    method poder() 
    method afectarA(mismoPokemon, otroPokemon) = otroPokemon

    method atacar(pokemon, otroPokemon){
        self.efectoAtaque(pokemon, otroPokemon)
        self.aplicarEfecto(self.afectarA(Pokemon, otroPokemon))
        self.decrementarUso()
    }
    method decrementarUso(){ cantidadUsosRestantes -= 1}
    method efectoAtaque(pokemon, otroPokemon){
        self.afectarA(pokemon, otroPokemon).cambiarVida(self.calcularDanio(pokemon, otroPokemon))
    }
    method calcularDanio(pokemon, otroPokemon) = self.afectarA(pokemon, otroPokemon).vidaActual() + sigma * cantPuntos
    method aplicarEfecto(pokemon){ 
        pokemon.agregarEfecto(efecto)
        efecto.afectar(pokemon)
    }
    method tieneUsos() = cantidadUsosRestantes > 0

}

class MovimientoCurativo inherits Movimiento{
    
    override method afectarA(mismoPokemon, otroPokemon) = mismoPokemon
    override method poder() = cantPuntos

}
class MovimientoDanino inherits Movimiento(sigma = -1){
    override method poder() = cantPuntos * 2
}
class MovimientoEspeciales inherits Movimiento(cantPuntos = 0){
    override method poder() = efecto.poderEfecto()
    override method efectoAtaque(pokemon, otroPokemon){
        super(pokemon, otroPokemon)
        self.aplicarEfecto(self.afectarA(pokemon, otroPokemon))
    }
    
}

class Efecto{
    method dejaAtacar() = false
    const turnos
    method sinTurnos() = turnos == 0
    method poderEfecto()
    method afectar(pokemon){}
}

class Paralisis inherits Efecto{
    override method poderEfecto() = 30
}

class Suenio inherits Efecto{
    override method dejaAtacar() = 0.randomUpTo(2).roundUp().even()
    override method poderEfecto() = 50
}

class Confusion inherits Efecto{
    override method afectar(pokemon){ pokemon.cambiarVida((pokemon.vidaActual() - 20).min(0)) }
    override method poderEfecto() = 40 * turnos
}