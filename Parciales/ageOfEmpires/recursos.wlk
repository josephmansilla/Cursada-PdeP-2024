import jugadores.*

class Zona{
    const property costo = 50
    const cantidadRecursos // asignar valor
    const tipo
    method agregarDelRecurso(jugador){ tipo.asignarRecurso(jugador, cantidadRecursos) }

}
class MinaOro inherits Zona{ override method agregarDelRecurso(jugador){ super(jugador) cantidadRecursos - 5} }
class MinaPiedra inherits Zona{ override method agregarDelRecurso(jugador){ super(jugador) cantidadRecursos - 3} }
class Bosque inherits Zona{
    var property estaExplotado = false
    override method agregarDelRecurso(jugador){ if(not estaExplotado){ super(jugador) /* Y */ estaExplotado = true } else { self.error("Está explotado") } }
}

class TipoMaterialZona{
    const cantidadResistencia 
    method asignarRecurso(jugador, cantidad) 
    method resistenciaAportada(cantidad) = cantidad * cantidadResistencia
}
object oro inherits TipoMaterialZona(cantidadResistencia = 30){
    override method asignarRecurso(jugador, cantidad){ jugador.cambiarOro(cantidad) } 

    override method resistenciaAportada(cantidad) = 
        if(cantidad >= 5000){ 2 * cantidadResistencia * cantidad } else super(cantidad) 
    
}
object piedra inherits TipoMaterialZona(cantidadResistencia = 10){ 
    override method asignarRecurso(jugador, cantidad){ jugador.cambiarPiedra(cantidad) } 
}
object madera inherits TipoMaterialZona(cantidadResistencia = 5){ 
    override method asignarRecurso(jugador, cantidad){ jugador.cambiarMadera(cantidad) } 
}