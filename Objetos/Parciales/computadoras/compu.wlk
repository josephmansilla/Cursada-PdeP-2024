class Equipo{
    var property modoTrabajo
    method consumoPC()
    method computoPC()
    const property consumoBase // watts
    const property computoBase // unidades
    const property conMicrochips = false
    var property estaQuemado = false
    method seQuemaPC(){ estaQuemado = true }
    method posibleUsar() = not estaQuemado
    method tiene

    method cambiarModoTrabajo(nuevo){ modoTrabajo = nuevo }
    method puedeComputar(problema) = self.computoPC() >= problema && not modoTrabajo.seQuemaAlUsar(self)
    method computoExitosamente(problema){ if(not self.puedeComputar(problema)) { self.error("No tiene el poder para computar") } }
}

class A105 inherits Equipo(consumoBase = 300, computoBase = 600){
    
    override method consumoPC() = modoTrabajo.consumo(self)
    override method computoPC() = modoTrabajo.consumo(self)
    override method puedeComputar(problema) = super(problema) && problema >= 5
}
class B2 inherits Equipo(consumoBase = 50, computoBase = 100, conMicrochips = true){
    var property cantidadMicroChips // cada uno cambia
    override method consumoPC() = modoTrabajo.consumo(self) * cantidadMicroChips
    override method computoPC() = (100 * cantidadMicroChips).min(800)
}

class ModoTrabajo{
    method consumo(pc)
    method computo(pc)
    method seQuemaAlUsar(pc) = false
}
object standard inherits ModoTrabajo{
    override method consumo(pc) = pc.consumoBase()
    override method computo(pc) = pc.computoBase()
}
class Overclock inherits ModoTrabajo{
    var property usosRestantes
    override method consumo(pc) = pc.consumoBase() * 2
    override method computo(pc) = if(pc.conMicrochips()) 20 + pc.computoBase() else pc.computoBase() * 1.3
    method usarPC(pc){ usosRestantes -=1 }

    method comprobarUsos(pc){ if(usosRestantes == 0) self.quemarPC(pc) self.error("Se quemó") }
    method quemarPC(pc){ pc.seQuemaPC() }

    override method seQuemaAlUsar(pc){ 
        self.usarPC(pc) 
        self.comprobarUsos(pc)
        return false
    }
}
class AhorroEnergia inherits ModoTrabajo{
    var property computosRealizados = 0

    override method consumo(pc) = 200
    override method computo(pc) = (pc.consumoBase() / self.consumo(pc)) * pc.computoBase()
    override method seQuemaAlUsar(pc){
        computosRealizados += 1
        self.generaError()
        return false
    } 
    method generaError() = if(self.errorComputo()){ self.error("Error ahorro energia") } 
    method errorComputo() = computosRealizados % 17 == 0
}
object aPruebaDeFallo inherits AhorroEnergia{
    override method computo(pc) = super(pc) * 1/2
    override method errorComputo() = computosRealizados % 100 == 0
}


class SuperComputadora{
    var property totalComputado = 0
    const property activa = true
    const property equipos = []
    
    method equiposActivos() = equipos.filter{ pc => not pc.estaQuemado() && pc.computoPC() > 0 }
    method cantidadEA() = self.equiposActivos().size()
    
    method totalConsumo() = equipos.sum{ pc => pc.consumoPC() }
    method totalComputo() = equipos.sum{ pc => pc.computoPC() }

    method pcMayorComputo() = equipos.max{ pc => pc.computoPC() }
    method pcMayorComsumo() = equipos.max{ pc => pc.comsumoPC() }

    method malConfigurado() = self.pcMayorComputo() != self.pcMayorComsumo()

    method computar(problema){
        const subProblema = problema.complejidad() / self.cantidadEA()
        equipos.all{ pc => pc.computoExitosamente(subProblema) }
        self.sumarTotalComputado(problema)
    }
    method sumarTotalComputado(problema){ totalComputado += problema }
    
}

class Problema{
    const property complejidad // N
}