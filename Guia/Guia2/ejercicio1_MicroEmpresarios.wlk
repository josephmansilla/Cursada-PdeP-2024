// EJERCICIO 1 MICRO EMPRESARIOS

class Micro {
    var property capacidadSentados
    var property capacidadParados
    const capacidadTotal = capacidadSentados + capacidadParados
    const property volumen

    var property sentados
    var property parados 
    var property totalSentadosParados = sentados + parados

    method puedeSubir(persona) = totalSentadosParados < capacidadTotal && persona.aceptaSubir()

    method subir(persona){
        if(! self.puedeSubir(persona)){
            self.error("No puede subir al micro")
        }
        else{
            if((capacidadSentados > 0 && persona.preferenciaAsiento() == "sentado") || (capacidadSentados > 0 && persona.preferenciaAsiento() == null)){
                capacidadSentados -= 1
                sentados += 1
                persona.asignarAsiento("sentado")
            }
            else if(capacidadParados > 0 && persona.preferenciaAsiento() == "parado"){
                capacidadParados -= 1
                parados += 1
                persona.asignarAsiento("parado")
            }
            else if(capacidadParados > 0 && capacidadSentados == 0){
                capacidadParados -= 1
                parados += 1
                persona.asignarAsiento("parado")
            }
            
        }

    }


    method bajar(persona){
        if(totalSentadosParados == 0){
            self.error("No hay nadie en el micro, no se puede bajar")
        } else{
            if(persona.asientoElegido() === "parado" && parados > 0){
                capacidadParados += 1
                parados -= 1
            }
            if(persona.asientoElegido() == "sentado" && sentados > 0){
                capacidadSentados += 1
                sentados -= 1
            }
        }
    }

}

class Persona{
    var property micro
    const property preferenciaAsiento
    var property asientoElegido = null
    method asignarAsiento(asiento){asientoElegido = asiento}
    method aceptaSubir()
}

class Apurado inherits Persona(preferenciaAsiento = null){
    override method aceptaSubir() = true
}

class Claustrofobico inherits Persona(preferenciaAsiento = "parado"){
    override method aceptaSubir() = micro.volumen() > 120
}

class Fiaca inherits Persona(preferenciaAsiento = "sentado"){
    override method aceptaSubir() = micro.sentados() < micro.capacidadSentados()
}

class Moderado inherits Persona(preferenciaAsiento = null){
    const cantidadLugaresLibres

    override method aceptaSubir() = micro.totalSentadosParados() < cantidadLugaresLibres
}

class Obsecuentes inherits Persona(preferenciaAsiento = null){
    var property jefe
    override method aceptaSubir() = jefe.aceptaSubir()
}


class Jefe{
    method aceptaSubir() = true
}