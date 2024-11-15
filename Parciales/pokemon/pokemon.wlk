import movimientos.*

class Pokemon{
    const vidaMaxima
    var property vidaActual = vidaMaxima
    const movimientos = []
    var movimientosDisponibles = movimientos
    var efectos = #{}

    method cambiarVida(nuevaVida){ vidaActual = nuevaVida.max(vidaMaxima).min(0) }

    method grositud() = vidaMaxima * self.sumaPoderMoviminetos()

    method sumaPoderMoviminetos() = movimientosDisponibles.sum{ movimiento => movimiento.poder() }
    method agregarEfecto(efecto){ efectos.add(efecto) }
    method cantidadMovimientos() = movimientosDisponibles.size()

    method luchar(pokemon){
        const movimiento = movimientosDisponibles.head()
        if(!self.validarQuePuedeLuchar()){ self.error("No puede luchar")}
        movimiento.atacar(self, pokemon)
        self.removerEfectos()
        if(!movimiento.tieneUsos()){ self.removerMovimiento(movimiento)}
    }
    method validarQuePuedeLuchar() = vidaActual >= 0 && self.efectosNoImpidenAtacar()
    method tieneMovDisponibles() = movimientosDisponibles.any{ movimiento => movimiento.cantidadUsosRestantes() > 0}
    method efectosNoImpidenAtacar() = efectos.any{ movimiento => movimiento.dejaAtacar() }
    method removerEfectos(){ efectos.forEach{ efecto => if(efecto.sinTurnos()){self.removerEfecto(efecto)} } }
    method removerEfecto(efecto){ efectos.remove(efecto) }
    method removerMovimiento(movimiento){ movimientosDisponibles.remove(movimiento) }
}

