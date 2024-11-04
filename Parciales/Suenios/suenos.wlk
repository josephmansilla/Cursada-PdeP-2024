// %%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%% Clase Persona %%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Persona{
    var suenios = []

    var edad
    var felicidad
    var cantidadHijos
    var carreraElegida = []
    var carreraTerminada = []
    var lugaresVisitados = []
    var cantidadPlataDeseada

    var tipoPersona // realista / obsesivo / alocado
    // es posible que cambie entonces dejamos 'var'

    method cumplir(suenio){
        if(self.sueniosCumplidos().contains(suenio)){
            self.error("Ya está cumplido")
        }
        suenio.cumplir(self)
    }

    method sueniosACumplir() = suenios.filter { suenio => suenio.estaPendiente() }
    method sueniosCumplidos() = !self.sueniosACumplir()
    method cambiarFelicidad(felicidonios){ felicidad += felicidonios}

    method tieneHijos() = cantidadHijos >= 1
    method agregarHijos() { cantidadHijos += cantidadHijos}

    method quiereEstudiar(unaCarrera) = carreraElegida.contains(unaCarrera)
    method yaTerminoCarrera(unaCarrera) = carreraTerminada.contains(unaCarrera)
    method terminarCarrera(unaCarrera) {
        carreraTerminada.add(unaCarrera)
        carreraElegida.remove(unaCarrera)
    }

    method viajarA(unLugar) { lugaresVisitados.add(unLugar) }

    // PUNTO 3

    method cumplirSuenioElegido() {
        const suenioElegido = tipoPersona.elegirSuenio(self.sueniosACumplir())
        self.cumplir(suenioElegido)
    }

    // PUNTO 4
    method esFeliz(){
        felicidad > self.felicidoniosPendientes()
    }

    method felicidoniosPendientes() = self.sueniosACumplir().sum { suenio => suenio.felicidonios() }

    // PUNTO 5
    method esAmbiciosa() = self.sueniosAmbiciosos().size() > 3
    method sueniosAmbiciosos() = suenios.filter { suenio => suenio.esAmbicioso() }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%% Tipos de Personas %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class TipoPersonas{
    method elegirSuenio(suenios)
} // formato tipoPersona

object realista inherits TipoPersonas{
    override method elegirSuenio(suenios){ suenios.max { suenio => suenio.felicidonios() } }
}
object alocado inherits TipoPersonas{
    override method elegirSuenio(suenios){ suenios.anyOne() }
}
object obsesivo inherits TipoPersonas{
    override method elegirSuenio(suenios){ suenios.head() }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% Clase Sueño %%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Suenio{
    var cumplido
    var felicidonios
    method felicidonios() = felicidonios

    method estaPendiente() = !cumplido
    
    method cumplir(persona){
        self.validar(persona)
        self.realizar(persona)
        self.cumplir()
        persona.cambiarFecilidad(+felicidonios)
    }
    method cumplir(){ cumplido = true }
    method validar(persona){}
    method realizar(persona){}

    method esAmbicioso() = self.felicidonios() > 100
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%% Sueño Simple y Compuesto %%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class SuenioSimple inherits Suenio{
    
}

class SuenioMultiple inherits Suenio{
    const suenios = []
    override method felicidonios() = suenios.sum {suenio => suenio.felicidonios()}
    override method validar(persona){ suenios.forEach { suenio => suenio.validar(persona) } }
    override method realizar(persona){ suenios.forEach { suenio => suenio.realizar(persona) } }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%% Tipos de Sueños %%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%

class AdoptarHijo inherits Suenio{
    const hijosAAdoptar

    override method validar(persona) = if(persona.tieneHijos()){self.error("No se puede adoptar si se tiene un hijo")}
    override method realizar(persona){ persona.agregarHijos(hijosAAdoptar) }
}
class RecibirseCarrera inherits Suenio{
    const carrera

    override method validar(persona) {
        if(!persona.quiereEstudiar(carrera)){self.error(persona.toString() ++ " no quiere estudiar " ++ carrera)}
        if(persona.yaTerminoCarrera(carrera)){self.error(persona.toString() ++ " ya terminó " ++ carrera)}
    }
    override method realizar(persona) { persona.terminarCarrera(carrera) }
}

class VisitarLugar inherits Suenio{
    const lugar
    
    override method realizar(persona){ persona.viajarA(lugar) }
}

class TenerHijo inherits Suenio{
    override method realizar(persona){ persona.agregarHijos(+1) }
}

class ConseguirTrabajo inherits Suenio{
    const cantidadPlata
    override method validar(persona){
        persona.cantidadPlataDeseada() <= cantidadPlata
    }
    override method realizar(persona){}
}