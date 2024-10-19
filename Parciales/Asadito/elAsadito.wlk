//PUNTO 1
class Comensal{
    var property posicion
    // property para intercambiar las posiciones
    var property elementos
    var property criterio
    // property por si lo queremos cambiar

    method pedirElemento(otraPersona, elemento){otraPersona.pasarElemento(self, elemento)}

    method pasarElemento(persona,elemento){
        if(elementos.isEmpty()){throw new NoTieneElementosCercaException()}

        criterio.pasarElemento(self, persona, elemento)
        
    }

    method agregarElemento(elemento){elementos.add(elemento)}
    method removerElemento(elemento){elementos.remove(elemento)}
    method recibirElementos(elementosARecibir){elementos.addAll(elementosARecibir)}
    method deshacerseElementos(){elementos.clear()}

    // PUNTO 2 Y 3

    var property preferencia
    var property estomago = []

    method comer(bandeja){
        preferencia.puedeComer(bandeja)    
        estomago.add(bandeja)
    }

    method estaPipon() = estomago.any({comida => comida.calorias()>500})

    // PUNTO 4

    method laEstaPasandoBomba() = estomago.size() > 0

    method comioCarne() = estomago.any({comida => comida.esCarne()})

    method tieneTantosElementosCerca(cantidad) = cantidad > elementos.size()  
}

class NoTieneElementosCercaException inherits Exception{}


// MODELAMOS LOS CRITERIOS CON COMPOSICION PORQUE ES POSIBLE QUE CAMBIEN

class Sordo{
    method pasarElemento(persona, otraPersona, elemento){
        otraPersona.agregarElemento(persona.elementos().head()) // le da lo primero que tiene a mano
        persona.removerElemento(persona.elementos().head())     // borra lo primero que tiene a mano
    }
}

class Tranquilo{
    method pasarElemento(persona, otraPersona, elemento){
        otraPersona.recibirElementos(persona.elementos())     // da todos sus elementos
        persona.deshacerseElementos()                         // borra todos sus elementos
    }
}

class Inquieto{
    method pasarElemento(persona, otraPersona, elemento){
        const auxiliarPosicion = otraPersona.posicion()
        otraPersona.posicion(persona.posicion())
        persona.posicion(auxiliarPosicion)
        // intercambian posicion y ahora sus elementos

        const auxiliarElementos = persona.elementos()
        persona.deshacerseElementos()
        persona.recibirElementos(otraPersona.elementos())
        otraPersona.deshacerseElementos()
        otraPersona.recibirElementos(auxiliarElementos)
        // intercambian elementos, no lo pedia, pero me parece necesario...        

    }
}

class Generoso{
    method pasarElemento(persona, otraPersona, elemento){
        if(!persona.elementos().any(elemento)){throw new NoTengoEseCosoException()}
        // NO TE PUEDO PASAR EL COSO PORQUE NO TENGO EL COSO

        otraPersona.recibirElemento(elemento)
        persona.removerElemento(elemento)

    }
}

class NoTengoEseCosoException inherits Exception{}

// PUNTO 2

class Bandeja{
    const nombre
    const property esCarne
    const property calorias
}

// MODELAMOS LAS PREFERENCIAS CON COMPOSICION PORQUE ES POSIBLE QUE CAMBIEN LAS PREFERENCIAS

class Vegetariano{
    method puedeComer(bandeja) = !bandeja.esCarne()
}

class Dietetico{
    method puedeComer(bandeja) = bandeja.calorias() < 500
}

class Alternado{
    var tieneHambre = true 

    method puedeComer(bandeja) = if(tieneHambre){tieneHambre = false} else{tieneHambre = true} // revisar si se puede sacar un valor true y tener efecto al mismo tiempo

}

class Insoportable{
    method puedeComer(bandeja) = bandeja.calorias() < 200 && bandeja.esCarne() && !bandeja.nombre().head("F")
}


// PUNTO 4
// USO CLASES PARA NO TENER QUE INICIALIZAR VARIBALES

class Osky inherits Comensal{} // siempre la pasa bomba si come
class Moni inherits Comensal{
    override method laEstaPasandoBomba() = super() && (posicion == 1) // asumo que 1@1 significa 1
}
class Facu inherits Comensal{
    override method laEstaPasandoBomba() = super() && self.comioCarne()
}
class Vero inherits Comensal{
    override method laEstaPasandoBomba() = super() && !self.tieneTantosElementosCerca(3)
}

// PUNTO 5

// se usó herencia en el punto 5 para cumplir condiciones de tipos de personas, donde tambien necesito ejecutar un super() porque hay una condicion
// global además de la que tiene cada persona

// se usó composición en los puntos 1 y 2 porque si una persona quiere cambiar de preferencia o criterio lo puede hacer facilmente!

// se usó polimorfismo se aplica en casi todo el parcial, donde destacaría su implementación es en el sector de bandejas donde permite realizar 
// varios metodos siempre y cuando sea un objeto que entienda esos mensajes