object riley {
    const edad = 11
    var felicidad = 1000
    var emocionDominante = alegria
    const recuerdosDia = []
    const pensamientosCentrales = []
    const memoriaLargoPlazo = []
    const pensamientoActual = []

    method felicidad() = felicidad
    method aumentarFelicidad(valor) { felicidad = 1000.min(felicidad + valor)}
    method disminuirFelicidad(valor) { 
        if(felicidad - valor > 1) {
            felicidad -= valor
        }else{
            throw new DomainException(message = "La felicidad no puede ser menor que 1")
        }
}   

    method recuerdosDia() = recuerdosDia
    method agregarRecuerdo(recuerdo) { recuerdosDia.add(recuerdo)}

    method pensamientosCentrales() = pensamientosCentrales
    method agregarPensamientoCentral(nuevoPensamiento) { pensamientosCentrales.add(nuevoPensamiento)}

    method cambiarEmocion(nuevaEmocion) { emocionDominante = nuevaEmocion}

    method memoriaLargoPlazo() = memoriaLargoPlazo
    method agregarAMemoriaLP(recuerdo) { memoriaLargoPlazo.add(recuerdo)}

    method pensamientoActual() = pensamientoActual
    method reemplazarPensamientoActual(pensamiento) {
        self.pensamientoActual().clear()
        self.agregarPensamientoActual(pensamiento)
    }
    method agregarPensamientoActual(pensamiento) { pensamientoActual.add(pensamiento)}

    method vivirEvento(recuerdo) {
        self.agregarRecuerdo(recuerdo)
        self.acentarRecuerdo(recuerdo)
    }

    method acentarRecuerdo(recuerdo) = recuerdo.acentar(self)

    method recuerdosRecientes() {
        if(recuerdosDia.size() <= 5) {
            return recuerdosDia }
        else {
        const n = recuerdosDia.size() - 5
        return recuerdosDia.drop(n)
    }
}

    method conocerPensamientoCentrales() {
        const pensamientos = pensamientosCentrales.asSet()
        return pensamientos
    }

    method pensamientosDificiles() = pensamientosCentrales.filter{ recuerdo => recuerdo.dificilDeExplicar()} // considero la descripcion como una lista

    method asentamiento() = recuerdosDia.forEach{ recuerdo => self.acentarRecuerdo(recuerdo)}
    method asentamientoSelectivo(palabraClave) = self.recuerdosSelectivos(palabraClave).forEach { recuerdo => self.acentarRecuerdo(recuerdo)}
    method recuerdosSelectivos(palabraClave) = recuerdosDia.filter { recuerdo => recuerdo.tienePalabraClave(palabraClave)}

    method profundizacion() {
        const recuerdos = self.recuerdosNoCentrales()
        if(self.recuerdosSonAceptados(recuerdos)){
            self.memoriaLargoPlazo().union(recuerdos)
        }
    }
    method recuerdosNoCentrales() {
        const recuerdos = recuerdosDia.filter{ recuerdo => !pensamientosCentrales.contains(recuerdos)}
        return recuerdos
    }
    method recuerdosSonAceptados(recuerdos) = recuerdos.all{recuerdo => recuerdo.esAceptado(emocionDominante)}

    method controlHormonal() {
        if(self.hayDesequilibrioHormonal()) {
            self.disminuirFelicidad(felicidad * 0.15)
            pensamientosCentrales.drop(3)
        }
    }
    method hayDesequilibrioHormonal() = self.pensamientoIntrusivo() || self.emocionDomina()
    method pensamientoIntrusivo() = pensamientosCentrales.any{ recuerdo => self.memoriaLargoPlazo().contains(recuerdo)}
    method emocionDomina() = recuerdosDia.all{ recuerdo, otroRecuerdo => recuerdo.tieneMismaEmocion(otroRecuerdo) }

    method restauracionCognitiva(valor) {
        const incremento = self.obtenerValor(valor)
        self.aumentarFelicidad(incremento)
}
    method obtenerValor(valor) = 100.min(valor)

    method liberarRecuerdos() = recuerdosDia.clear()

    method dormir() {
        self.asentamiento()
        self.asentamientoSelectivo("hola")
        self.profundizacion()
        self.controlHormonal()
        self.restauracionCognitiva(500)
        self.liberarRecuerdos()
    }

    method rememorar() {
        const anioActual = new Date().year()
        const edadRiley = edad
        const antiguedadMinima = edadRiley / 2  
        const recuerdosViejos = self.memoriaLargoPlazo().filter({ recuerdo => (anioActual - recuerdo.fecha().year()) > antiguedadMinima})

        const pensamiento = recuerdosViejos.anyOne()
        if(self.pensamientoActual().isEmpty()) {
            self.agregarPensamientoActual(pensamiento)
        } else {
            self.reemplazarPensamientoActual(pensamiento)
        }
}

    method cantidadDeRepeticionesEnMLP(recuerdo) = self.memoriaLargoPlazo().count{ recuerdo => recuerdo.estaEnMLP(self)}
    method dejaVu() {
        const recuerdo = self.pensamientoActual().head()
        return self.cantidadDeRepeticionesEnMLP(recuerdo) > 1    
    }
}

class Recuerdo {
    const descripcion 
    const fecha
    const emocionDominante

    method fecha() = fecha

    method emocionDominante() = emocionDominante

    method acentar(persona) = emocionDominante.acentarSegunEmocion(persona, self) 
    method descripcion() = descripcion

    method dificilDeExplicar() = descripcion.size() > 10
    method tienePalabraClave(palabraClave) = descripcion.contains(palabraClave)
    method esAceptado(emocion) = !emocion.negar(self) 
    method tieneMismaEmocion(recuerdo) = self.emocionDominante() == recuerdo.emocionDominante()
    method estaEnMLP(persona) = persona.memoriaLargoPlazo().contains(self)
}

class EmocionCompuesta {
    const emociones

    method negar(recuerdo) = emociones.all{ emocion => emocion.negar(recuerdo)}
    method esAlegre() = emociones.any { emocion => emocion.esAlegre()}
    method acentarRecuerdo(persona, recuerdo) = emociones.forEach{ emocion => emocion.acentarSegunEmocion(persona, recuerdo)}
}

const emociones = new EmocionCompuesta (emociones = [alegria, tristeza, furia])

object alegria {
    method acentarSegunEmocion(persona, recuerdo) {
        if(persona.felicidad() > 500) {
            persona.agregarPensamientoCentral(recuerdo)
        }
    }

    method negar(recuerdo) = recuerdo.emocionDominante() != self
    method esAlegre() = true
}

object tristeza {
    method acentarSegunEmocion(persona, recuerdo) {
        persona.agregarPensamientoCentral(recuerdo)
        persona.disminuirFelicidad(persona.felicidad() * 0.1 )
    }

    method negar(recuerdo) = recuerdo.emocionDominante().esAlegre()
    method esAlegre() = false
}

object disgusto {
    method acentarSegunEmocion(persona, recuerdo) { }
    method negar(recuerdo) { }
    method esAlegre() = false
}

object furia {
    method acentarSegunEmocion(persona, recuerdo) { }
    method negar(recuerdo) { }
    method esAlegre() = false
}


object temor {
    method acentarSegunEmocion(persona, recuerdo) { }
    method negar(recuerdo) { }
    method esAlegre() = false
}