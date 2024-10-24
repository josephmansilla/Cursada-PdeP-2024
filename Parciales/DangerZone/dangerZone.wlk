// BASE DEL MODELO

class Empleado{

    var property salud
    var property habilidades = []
    var property rol

    method aprenderNuevaHabilidad()

    method estaIncapacitado() = salud <= rol.saludCritica()

    method recibirDanio(danioBase){
        salud -= danioBase
    }

    method puedeUsarHabilidad(habilidad) = self.estaIncapacitado() && self.tieneHabilidad(habilidad)
    method tieneHabilidad(habilidadDada) = habilidades.any({habilidad => habilidadDada == habilidad})

    method ascenderRol(){if(rol.estrellas() >= 3){rol = "espia"}}

    method aprenderNuevaHabilidad(mision){
        habilidades.add(habilidades.last()).asSet()
    }
    method recompensaMision(agnte, mision)
}


class Jefe inherits Empleado{
    var empleados
    override method tieneHabilidad(habilidadDada) = empleados.any{ empleado => empleado.super() }
}

class Espia{
    method saludCritica() = 15
    method recompensaMision(agente, mision){agente.habilidades().add(agente.habilidades().last()).asSet()}
    

}

class Oficinista{
    var estrellas
    method recompensaMision(mision){estrellas += 1}
    
}

class Equipo{
    var equipo

    method puedeusarHabilidad(habilidad){
        equipo.any{agente => agente.puedeUsarHabilidad(habilidad)}
    }

    method cumpleTodosRequisitos(mision){
        mision.habilidadesRequeridas().all({habilidad => equipo.puedeUsarHabilidad(habilidad)})
    } 
    method puedeHacerMision(mision) = equipo.any{agente => equipo.cumpleTodosRequisitos(agente)}
    method todosRecibenDanio(valor){
        equipo.forEach{agente => agente.recibirDanio(valor)}
    }
    method removerIncapacitados(){
        equipo.map{agente => agente.estaIncapacitado()}
    }
    method aplicarRecompensa(){
        equipo.map{agente => agente.rol().recompensaMision(agente, self)}
    }
}



class Mision{
    const objetivos
    var property danioBase
    var property habilidadesRequeridas = []

    method definirHabilidades(){
        objetivos.forEach{habilidadRequerida => habilidadesRequeridas.add(habilidadRequerida)}
    }

    method hacerMision(equipo){
        self.definirHabilidades()
        if(!equipo.puedeHacerMision(self)){throw new NoPuedeHacerMisionException()}

        
        if(equipo.size() > 1){
            danioBase = danioBase / 3
        }
        equipo.todosRecibenDanio(danioBase)
        equipo.removerIncapacitados()
        equipo.aplicarRecompensa()
    }
}

class NoPuedeHacerMisionException inherits Exception{}

class Objetivo{
    const habilidadRequerida
}


class ObjetivosPeligrosos{
    const tamanioMinimo = 3

    method hacerMision(equipo){    
        if(equipo.size() >= tamanioMinimo){self.error("No cumple con el tamaño Necesario")}


    }
}
