class Vikingo {
    var castaSocial 
    var property armas 

    method puedeSubirAExpedicion() = self.esProductivo() && self.puedeSubirSegunCasta()
    method tieneArmas() = !armas.isEmpty()
    method puedeSubirSegunCasta() = castaSocial.puedeSubir(self)
    method esProductivo() 
    method ascender() { castaSocial.ascender(self)}
    method modificarCasta(nuevaCasta) { castaSocial = nuevaCasta}
}

class Soldado inherits Vikingo {
    var vidasCobradas
    override method esProductivo() = vidasCobradas >= 20 && self.tieneArmas()
    method vaAExpedicion(invadidos) {
        if(self.puedeSubirAExpedicion() && invadidos.esCapital()) vidasCobradas +=1 }
    method ascenso(){
		armas += 10
	}
}

class Granjero inherits Vikingo {
    var cantidadHijos
    var cantidadHectareas

    override method esProductivo() = cantidadHectareas % cantidadHijos >= 2
    method ascenso() {
        cantidadHectareas += 2
        cantidadHijos += 2
    }
}

class Casta {
    method puedeSubir(vikingo) = true
    method ascender(vikingo)
}
object jarl inherits Casta {
    override method puedeSubir(vikingo) = !vikingo.tieneArmas()
    override method ascender(vikingo) {
        vikingo.modificarCasta(karl)
        vikingo.ascenso()

    }  
}

object karl inherits Casta {
    override method ascender(vikingo) {
        vikingo.modificarCasta(thrall)}
}

object thrall inherits Casta {
    override method ascender(vikingo) { }
}

class Expedicion {
    const invadidos

    method valeLaPena() = invadidos.valeLaPena()
}

class Aldea {
    var property sedDeSaqueo = 15
    const cantidadCrucifijos 

    method valeLaPena() = self.botinTotal() >= sedDeSaqueo
    method esCapital() = false
    method botinTotal() = cantidadCrucifijos
}

class AldeaAmurallada inherits Aldea{
    var property vikingosEnComitiva 
    const cantidadMinimaVikingosEnComitiva

    override method valeLaPena() = super() && (vikingosEnComitiva >= cantidadMinimaVikingosEnComitiva)   
}

class Capital {
    const defensoresDerrotados
    const vikingosInvasores
    const factorRiqueza // puede ser negativo

    method valeLaPena() = self.botinTotal() >= 3 * vikingosInvasores
    method esCapital() = true
    method botinTotal() = 0.min(defensoresDerrotados + factorRiqueza)


}
