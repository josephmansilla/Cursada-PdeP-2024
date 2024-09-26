// EJERCICIO 4 CELULARES
// PARTE A
const maxBateria = 5

class Telefono {
    var property bateria = maxBateria
    method cantidadBateria(){
        return bateria
    }
    method estaApagado() = bateria == 0
    method recargar(){
        bateria = maxBateria
    }
    method llamada(tiempo, costoDeBateria){
        bateria = (bateria - costoDeBateria).max(0)
    }
}
object samsung21 {
    const samsung = new Telefono()
    
    method realizarLlamado(tiempo){
        const costoDeBateria = 0.25
        samsung.llamada(tiempo, costoDeBateria)
    }  }
object iPhone14 {
    const iPhone = new Telefono()

    method realizarLlamado(tiempo){
        iPhone.llamada(tiempo, self.costoAlLlamar(tiempo))
    }
    method costoAlLlamar(tiempo){
        return 0.1 * tiempo
    }

}

class Persona{
    var property celular 
    var property compania
    var totalLlamadas = 0

    method llamar(tiempo){
        celular.realizarLlamado(tiempo)
        totalLlamadas += tiempo
    }
    method costoCompania(){
        return compania.cobrar(totalLlamadas)
    }
    method cargarCelular(){
        celular.recargar()
    }
    method bateriaRestante(){
        celular.cantidadBateria()
    }

    method tieneCelularApagado(){
        if(celular.estaApagado()){
            return "Apagado"
        } else {
            return "Prendido"
        }
    }
}

object juliana {
    const juliana = new Persona(celular = samsung21, compania = personal)
}
object catalina {
    const catalina = new Persona(celular = iPhone14, compania = movistar)
}
// estaria buena una implementacion donde catalina o juliana hace algo en particular que no hace otra persona
// se verá en la proxima unidad supongo

// PARTE B

object movistar {
    method facturar(tiempo){
        const costoFijo = 60
        return costoFijo * tiempo
    }
    
}
object claro{
    method cobrar(tiempo){
        const costoFijo = 50
        return (costoFijo * tiempo) + ((costoFijo * tiempo) * 0.21)
    }
}
object personal {
    method cobrar(tiempo){
        const costoFijo = 40
        const costoInicial = 70
        if(tiempo < 10){
            return tiempo * costoInicial
        } else {
            return (costoInicial * 10) + ((tiempo - 10) * costoFijo)
        }
    }

}
// no es necesario una clase de companiasTelefonicas porque todas tienen logicas diferentes para cobrar y no es posible aplicar
// polimorfismo (creo) de manera que no repita o sea más complicado de lo necesario