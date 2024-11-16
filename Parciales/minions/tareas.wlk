import minions.*

class Laboratorio{
    const sectores = []
}

class Sector{
    method dificultad(minion)
    method stamina(minion)
    method cumple(minion)
    method accionSector(minion){
        if(not self.cumple(minion)){ self.error("No cumple los requisitos") }
        self.stamina(minion)
        minion.sumarTarea(self.dificultad(minion))
    }
    method masCapacitado(subordinados)
}

class Maquina inherits Sector{
    const complejidad 
    const herramientasRequeridas
    override method dificultad(minion) = complejidad * 2
    override method stamina(minion) = minion.cambiarEnergia(complejidad)
    override method cumple(minion) = minion.cumpleStaminaReparacion(complejidad) && minion.tieneHerramientasNecesarias(herramientasRequeridas)
    override method masCapacitado(minions) = 
        [minions.filter{ minion => minion.tieneHerramientasNecesarias(herramientasRequeridas) }.head()]
}

// los requerimientos para cada sector se podrian generalizar, pero son las 2 de la mañana 

class DefenderSector inherits Sector{
    const gradoAmenaza
    
    override method cumple(minion) = minion.puedeDefenderAmenaza(gradoAmenaza)
    override method dificultad(minion) = minion.gradoDificultadDefender() * gradoAmenaza
    override method stamina(minion) = minion.cambiarEnergia(minion.staminaPerdidoDefender())
    override method masCapacitado(minions) = 
        [minions.filter{ minion, otroMinion => minion.fuerza() >= otroMinion.fuerza() }.head()] // revisar
}

class LimpiarSector inherits Sector{
    var property dificultadLimpieza = 10
    const staminaParaLimpiar = 1

    override method dificultad(minion) = dificultadLimpieza
    override method cumple(minion) = minion.puedeLimpiar(staminaParaLimpiar)
    override method stamina(minion) = minion.cambiarEnergia(minion.staminaPerdidoAlLimpiar())
    override method masCapacitado(minions) = 
        [minions.filter{ minion, otroMinion => minion.staminaPerdidoAlLimpiar() <= otroMinion.staminaPerdidoAlLimpiar() }.head()] // revisar
}

class LimpiarSectorGrande inherits LimpiarSector(staminaParaLimpiar= 4){}