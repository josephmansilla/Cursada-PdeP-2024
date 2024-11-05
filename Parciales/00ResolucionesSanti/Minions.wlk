class Empleado {
    var rol
    var estaminaActual
    const tareas = []

    method estaminaActual() = estaminaActual

    method cambiarRol(nuevoRol){ 
        if(rol == soldado) {
            soldado.perderPractica()
        }
        rol = nuevoRol
        }

    method tieneEstaminaSuf(valor) = estaminaActual >= valor
    method tieneHerramientas(herramientas) = rol.tieneHerramientas(herramientas)

    method agotar(valor){ estaminaActual = 0.max(estaminaActual - valor)}

    method puedeDefenderSector() = rol.puedeDefenderSector()

    method tieneFuerzaNecesaria(fuerza) = self.fuerza() >= fuerza

    method fuerza() = self.estaminaActual() / 2 + rol.fuerzaPorRol() + self.fuerzaPorTipo()

    method fuerzaPorTipo()

    method tieneEstaminaSufParaSector(sector, estaminaSectorGrande, estaminaOtroSector) {
        if(sector.esGrande()) {
            return self.tieneEstaminaSuf(estaminaSectorGrande)
        } else {
            return self.tieneEstaminaSuf(estaminaOtroSector)
        }
    }

    method esMucama() = rol.esMucama()

    method realizarTarea(tarea) = rol.hacerTarea(self, tarea) // excepcion cuando no puede hacer la tarea

    method comerFruta(fruta) = fruta.comer(self)

    method aumentarEstamina(valor)

    method agregarTarea(tarea) { tareas.add(tarea)}

    method experienciaTotal() = self.cantidadTareas() * self.dificultadTareas()

    method cantidadTareas() = tareas.size()
    method dificultadTareas() = tareas.sum{ tarea => tarea.dificultadTarea()}


}

class Biclope inherits Empleado {
    //const ojos = 2 -> unused
    const estaminaMax = 10

    override method fuerzaPorTipo() = 0
    method dificultadDefenderSector(gradoAmenaza) = gradoAmenaza

    override method aumentarEstamina(valor) { estaminaActual = estaminaMax.min(estaminaActual + valor)} 
}

class Ciclope inherits Empleado {
    // const ojos = 1 -> unused
    // const estaEntussiasmado = true -> unused

    override method fuerzaPorTipo() = (self.fuerza() + rol.fuerzaPorRol()) / 2

    method dificultadDefenderSector(gradoAmenaza) = 2 * gradoAmenaza

    override method aumentarEstamina(valor) { estaminaActual += valor }
}

class Soldado {
    const arma
    const aumentoDanio = 2
    var practica = 0

    method perderPractica() { practica = 0}

    method puedeDefenderSector() = true

    method defenderSector() { 
        arma.aumentarDanio(aumentoDanio)
        practica += 1
}

    method tieneHerramientas(herramientas) = false

    method fuerzaPorRol() = aumentoDanio

    method perderEstamina(personaje) { }

    method esMucama() = false

    method limpiar(estaminaPerdida, empleado) = empleado.agotar(estaminaPerdida) 

    method hacerTarea(empleado, tarea) = tarea.hacerTarea(empleado)
}

const soldado = new Soldado(arma = "arma")

class Obrero {
    const cinturon

    method tieneHerramientas(herramientas) = herramientas.all{ herramienta => cinturon.contains(herramienta)}

    method puedeDefenderSector() = true

    method fuerzaPorRol() = 0

    method perderEstamina(personaje) { 
        const estaminaPerdida = personaje.estaminaActual() / 2

        personaje.agotar(estaminaPerdida)
    }

    method esMucama() = false

    method limpiar(estaminaPerdida, empleado) = empleado.agotar(estaminaPerdida)

    method hacerTarea(empleado, tarea) = tarea.hacerTarea(empleado)
}

class Mucama {
    method puedeDefenderSector() = false

    method fuerzaPorRol() = 0

    method esMucama() = true

    method limpiar(estaminaPerdida, empleado) { }

    method hacerTarea(empleado, tarea) = tarea.hacerTarea(empleado)
}

class Capataz {
    const subordinados

    method hacerTarea(empleado, tarea) = subordinados.anyOne{ subordinado => subordinado.hacerTarea()}
}

class Arma {
    var danio

    method aumentarDanio(valor){ danio += valor}
}

class ArreglarMaquina {
    const complejidad
    const herramientasNecesarias

    method puedeHacerTarea(empleado) = empleado.tieneEstaminaSuf(complejidad) && empleado.tieneHerramientas(herramientasNecesarias)
    method hacerTarea(empleado) {
        if(self.puedeHacerTarea(empleado)){
        empleado.agotar(complejidad)}
        empleado.agregarTarea(self)
    }

    method dificultadTarea() = complejidad * 2
}

class DefenderSector {
    const gradoAmenaza

    method puedeHacerTarea(empleado) = empleado.puedeDefenderSector() && empleado.tieneFuerzaNecesaria(gradoAmenaza)
    method hacerTarea(empleado) {
        if(self.puedeHacerTarea(empleado)){
            empleado.rol().perderEstamina(empleado)
            empleado.agregarTarea(self)
        }
    }

    method dificultadTarea(empleado) = empleado.dificultadDefenderSector(gradoAmenaza) 
}

class LimpiarSector {
    var dificultad = 10
    const sector
    const estaminaSectorGrande = 4
    const estaminaOtroSector = 1

    method dificultadTarea() = dificultad
    method cambiarDificultad(nuevaDificultad) { dificultad = nuevaDificultad}

    method puedeHacerTarea(empleado) = empleado.esMucama() || empleado.tieneEstaminaSufParaSector(sector, estaminaSectorGrande, estaminaOtroSector)
    method hacerTarea(empleado) {
        if(self.puedeHacerTarea(empleado)) {
            if(sector.esGrande()){
            empleado.rol().limpiar(estaminaSectorGrande, empleado)
        }else {
            empleado.rol().limpiar(estaminaOtroSector, empleado)
        }
        empleado.agregarTarea(self)
        }
    }
}

class Sector {
    const tamanio

    method esGrande() = tamanio == "grande"
}

class Fruta {
    const aumentoEstamina

    method comer(empleado) = empleado.aumentarEstamina(aumentoEstamina) 
}