import aldea.*

class Vikingo{
    var property vida
    var property rol
    var property organizacion
    const property armas = []
    var property oro = 0

    method esProductivo() = rol.esProductivo(self)
    method cumpleRequisitoArmas() = rol.armasParaLlevar(self)
    method cambiarVida(cantidad){ vida += cantidad }
    method cantidadArmas() = armas.size()

    method subirClase(){
        self.verificarClase()
        rol = karl
    }
    method verificarClase(){ if(not rol.esEsclavo()) self.error("No es esclavo") }
    method sumarOro(cantidad){ oro += cantidad }
}

class ClaseSocial{
    method armasParaLlevar(vikingo) = vikingo.cantidadArmas() > 0
    method esEsclavo() = false
}
object jarl inherits ClaseSocial{ // esclavos
    override method armasParaLlevar(vikingo) = not super(vikingo)
    override method esEsclavo() = true

}
object karl inherits ClaseSocial{ // casta media

}

object thrall inherits ClaseSocial{ // nobles

}

class Soldado{
    var property kills // cantidad de asesinatos
    method esProductivo(vikingo) = self.masDeKills(20) && vikingo.cumpleRequisitoArmas()
    method masDeKills(cantidad) = cantidad >= kills
}

const cantidadHijosMinima = 3

class Granjero{
    var cantidadHijos = 0
    const hectareasDesignadas
    method hectareasPorHijo() = hectareasDesignadas / cantidadHijos
    method esProductivo(vikingo) = (cantidadHijos >= cantidadHijosMinima) && (self.hectareasPorHijo() >= 2)
}

