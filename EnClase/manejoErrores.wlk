import ejercicio5_mudanzas.*
class Impresora{
    const cabezal
    const cabezalAux
    var property ocupada

    method trazar(recorrido){true}

   
    method imprimir(documento){
        if(ocupada){throw new NoPuedeImprimirException()}

        ocupada = true

        try{
            cabezal.eyectar(documento.tinta())
            self.trazar(documento.recorrido())
        } catch error: SinCargaException {
            cabezalAux.eyectar(documento.tinta())
        } then always{
            ocupada = false
        }
        
    }
}

class Cabezal{
    const eficiencia
    const cartucho
    method liberar(){true}
    method eyectuar(cantidad){
        cartucho.extraer(1/eficiencia * cantidad)
        self.liberar()
    }
}

class Cartucho{
    var carga

    method extraer(cantidad){
        if(carga < cantidad){throw new SinCargaException{carga = carga}}
    }
}

class NoPuedeImprimirException inherits DomainException{}


class SinCargaException inherits DomainException{
    const property carga
}