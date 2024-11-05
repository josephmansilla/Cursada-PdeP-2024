//1)
class Persona {
    var property sueniosPendientes
    var property edad 
    var property carrerasHechas
    var property sueldo  
    var property viajesHechos  
    var property tieneHijos
    var property hijos  
    var property sueniosCumplidos = []  
    var property felicidadTotal
    var personalidad

    method cumplirSuenio() {
        const suenio = personalidad.encontrarSuenio()
        if(suenio.puedeCumplirse(self)){
            suenio.cumplir(self)
            sueniosCumplidos.add(suenio)
            sueniosPendientes.remove(suenio)
            felicidadTotal += suenio.nivelFelicidad()
        } else {
            throw new DomainException(message = "El suenio no cumple los requisitos para ser cumplido")
        }
    }
    method adoptoHijos() { tieneHijos = true}
    method cambiarSueldo(nuevoSueldo) { sueldo = nuevoSueldo}
    method suenioMasFeliz() = sueniosPendientes.max{ suenio => suenio.nivelFelicidad()}
    method elegirSuenioAlAzar() = self.sueniosPendientes().anyOne()
    method personalidad() = personalidad
    method cambiarPersonalidad(nuevaPersonalidad) { personalidad = nuevaPersonalidad}
    method esFeliz() = felicidadTotal > self.felicidadSueniosPendientes()
    method felicidadSueniosPendientes() = sueniosPendientes.sum{ suenio => suenio.nivelFelicidad()} 
    method obtenerTodosLosSuenios() = sueniosPendientes + sueniosCumplidos
    method esAmbiciosa() = self.obtenerTodosLosSuenios().count{ suenio => suenio.suenioAmbicioso()} >= 3
}

object realista {
    method encontrarSuenio(persona) {
        const suenioImportante = persona.suenioMasFeliz()
        return suenioImportante } // Funciona igual

}


object alocado  {
    method encontrarSuenio(persona) {
        const suenioAlAzar = persona.elegirSuenioAlAzar()
        return suenioAlAzar
    }
}

object obsesivo  {
    method encontrarSuenio(persona) {
        const primerSuenio = persona.sueniosPendientes().head()
        return primerSuenio
    }
}


const santi = new Persona(personalidad = obsesivo, sueniosPendientes = [trabajo], edad = 19, tieneHijos = false, hijos = [], carrerasHechas = [], sueldo = 0, sueniosCumplidos = [viaje], viajesHechos = [], felicidadTotal = 0)
const santo = new Persona(personalidad = realista, sueniosPendientes = [], edad = 19, tieneHijos = false, hijos = [], carrerasHechas = [], sueldo = 0, sueniosCumplidos = [], viajesHechos = [], felicidadTotal = 0)

class Suenio {
    var property nivelFelicidad

    method puedeCumplirse(persona)
    method cumplir(persona)
    method suenioAmbicioso() = nivelFelicidad > 100
}

class Recibirse inherits Suenio {
    const carreraDecidida
    var property carrerasDeseadas

    override method puedeCumplirse(persona) = carrerasDeseadas.contains(carreraDecidida) && 
                                              !persona.carrerasHechas().contains(carreraDecidida)
    override method cumplir(persona) { persona.carrerasHechas().add(carreraDecidida)}
}

class TenerHijo inherits Suenio {
    const hijosAAdoptar // Lista para adoptar una cantidad X de hijos

    override method puedeCumplirse(persona) = !persona.tieneHijos()
    override method cumplir(persona) { 
        persona.adoptoHijos()
        persona.hijos() + hijosAAdoptar
}
}

class Viajar inherits Suenio {
    const lugarDeseado
    var property lugaresDeseados

    override method puedeCumplirse(persona) = lugaresDeseados.contains(lugarDeseado)
    override method cumplir(persona) { persona.viajesHechos().add(lugarDeseado)}
}

class Laburo inherits Suenio {
    var property sueldoDeseado 

    override method puedeCumplirse(persona) = sueldoDeseado >= persona.sueldo()
    override method cumplir(persona) { persona.cambiarSueldo(sueldoDeseado)}

}

//2)

const viaje = new Viajar(lugarDeseado = "Cataratas", lugaresDeseados = [], nivelFelicidad = 8)
const tenerUnHijo = new TenerHijo(hijosAAdoptar = ["unHijo"], nivelFelicidad = 10)
const trabajo = new Laburo(sueldoDeseado = 10000, nivelFelicidad = 7) 