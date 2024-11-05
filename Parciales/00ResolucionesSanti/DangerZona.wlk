class Empleado {
    var property vida
    const habilidades 

    method saludCritica() 
    method estaIncapacitado() = vida < self.saludCritica()
    method puedeUsarHabilidad(habilidad) = ! self.estaIncapacitado() && habilidades.contains(habilidad)
    method cumpleMision(habilidadesMision) = habilidadesMision.all{habilidad => self.puedeUsarHabilidad(habilidad)} 
    method disminuirVida(valor) { vida = 0.max(vida - valor)}
    method danioPorMision(peligrosidadMision) {
        self.disminuirVida(peligrosidadMision)}
    method sobreViveMision(habilidadesMision, peligrosidadMision) {
    if(self.cumpleMision(habilidadesMision)) {
        self.danioPorMision(peligrosidadMision)
        //if(vida > 0)  return true
    } 
    else return false
}    
}

class Equipo {
    const integrantes

    method puedenUsarHabilidad(habilidad) = integrantes.all{integrante => ! integrante.estaIncapacitado()} &&
    integrantes.any{integrante => integrante.habilidades().contains(habilidad)}
    method cumplenMision(habilidadesMision) = habilidadesMision.all{habilidad => self.puedenUsarHabilidad(habilidad)}
    method danioPorMision(peligrosidadMision) { 
        integrantes.forEach{integrante => integrante.disminuirVida(peligrosidadMision/3)}}

}

const equipo = new Equipo (integrantes = [santi])

class Espia inherits Empleado {  
    override method saludCritica() = 15 
    method aprendeHabilidad(habilidadesMision) {
        //habilidadesMision.forEach{habilidad => self.habilidades.add(habilidad)}
}}

const santi = new Espia (vida = 100, habilidades = [])

class Oficinista inherits Empleado {
    var cantidadEstrellas
    override method saludCritica() = 0.max(40 - 5 * cantidadEstrellas)
    method sumarEstrella (habilidadesMision, peligrosidadMision) {
        if(self.sobreViveMision(habilidadesMision, peligrosidadMision)) cantidadEstrellas += 1
    }
    method experienciaParaEspia() = cantidadEstrellas >= 3
}

class Jefe inherits Espia {
    const subordinados
    
    override method puedeUsarHabilidad(habilidad) = super(habilidad) || 
    subordinados.any{subordinado => subordinado.puedeUsarHabilidad(habilidad)} 

}
