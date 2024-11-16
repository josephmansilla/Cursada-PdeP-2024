import tareas.*

class Minion{
    
    var stamina
    const cantOjos
    var rolAsignado
    var tareasRealizadas
        //
    method mitadStamina() = 0.5 * stamina
    method cambiarEnergia(cantidad){ stamina += cantidad } // para perder stamina al reparar
        //
    method cumpleStaminaReparacion(staminaNecesaria) = stamina >= staminaNecesaria
    method tieneHerramientasNecesarias(herramientas) = rolAsignado.tieneHerramientasNecesarias(herramientas)
    method gradoDificultadDefender()
    method fuerza() = (self.mitadStamina()) + 2 + rolAsignado.danioExtra()
    method staminaPerdidoDefender() = self.mitadStamina()
        //
    method staminaPerdidoAlLimpiar(cantidad) = rolAsignado.staminaPerdidoAlLimpiar(cantidad)
    method puedeLimpiar(staminaNecesaria) = rolAsignado.puedeLimpiar(stamina, staminaNecesaria)
        //
    method comerFruta(fruta){ self.cambiarEnergia(fruta.energia()) }
    method puedeDefenderAmenaza(amenaza) = if(rolAsignado.habilitadoAMatar()){ self.fuerza() >= amenaza }
            //
    method cantidadTareasRealizadas() = tareasRealizadas.size()  
    method sumarTarea(dificultad){ tareasRealizadas.add(dificultad) }
    method sumatoriaDificultades() = tareasRealizadas.sum() 
    method experencia() = self.cantidadTareasRealizadas() * self.sumatoriaDificultades()
            //
    method realizarTarea(tarea){ rolAsignado.realizarTarea(tarea) }
}

class Biclopes inherits Minion(stamina = 10, cantOjos = 2){
    // utiles para todas las tareas
    override method gradoDificultadDefender() = 1
}
class Ciclopes inherits Minion(stamina = 100000, cantOjos = 2){
    // cuesta disparar armas -> aciertan la mitad
    // siempre entusiasmados
    override method gradoDificultadDefender() = 2
    override method fuerza() = super() / 2
}

class Rol{
    method danioExtra() = 0
    method staminaPerdidoAlLimpiar(cantidad) = cantidad
    method habilitadoAMatar() = true
    method puedeLimipiar(staminaMinion, staminaNecesaria) = staminaMinion >= staminaNecesaria
    method tieneHerramientasNecesarias(herramientasNecesarias) = false
    method realizarTarea(tarea){ tarea.accionSector(self) }
}
class Soldado inherits Rol{
    var property danioExtra = 0
    method defenderLaboratorio(minion){ const mejoraPunteriaEn = +2 minion.danioExtra(mejoraPunteriaEn) } // no pierden stamina
    method danioExtra(cantidad){ danioExtra += cantidad }
}

class Obrero inherits Rol{
    var herramientas = []
    override method tieneHerramientasNecesarias(herramientasNecesarias) = herramientasNecesarias.all{ herramientaNecesaria => herramientas.contains(herramientaNecesaria) }
}

class Mucama inherits Rol{
    override method habilitadoAMatar() = false // lamentablemente no sabe como matar gente
    override method puedeLimipiar(staminaMinion, staminaNecesaria) = true
    override method staminaPerdidoAlLimpiar(cantidad) = 0
}

class Capataz inherits Rol{
    const subordinados = []
    override method realizarTarea(tarea){ 
        var minionSorteado = tarea.masCapacitado(subordinados)
        if( minionSorteado.isEmpty() ){ super(tarea) } else{ tarea.accionSector(minionSorteado) }
    }
}


object elCientifico{
    var minions = []
    
    // no pedia modelar a este vago
}

class Comida{ const property energia }
object banana inherits Comida(energia = 10){}
object manzana inherits Comida(energia = 5){}
object uva inherits Comida(energia = 1){}