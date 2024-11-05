// 1)
class Comensal {
    var property posicion
    const elementosCercanos
    const registroComidas

    method tieneElemento(elemento) = elementosCercanos.contains(elemento)
    method pedirElemento(otroComensal, elemento) {
        if(otroComensal.tieneElemento()){
            otroComensal.darElemento(elemento, self)
        } else {
            throw new DomainException(message = " La otra persona no tiene el elemento solicitado")
        }
    }
    method darElemento(elemento, comensalSolicitante) {}
    method recibirElemento(elemento) {
        elementosCercanos.add(elemento)
    }
    method cambiarPosicion(nuevaPosicion) { posicion = nuevaPosicion}
    method comer(bandeja) {}
    method registrarComida(bandeja) { registroComidas.add(bandeja)}
    method esPesada(bandeja) = bandeja.cantidadCalorias() > 500
    method estaPipon() = registroComidas.any{ comida => comida.esPesada(comida)} 
}

class Sordo inherits Comensal {
    override method darElemento(elemento, comensalSolicitante) {
        const primerElemento = elementosCercanos.head()
        comensalSolicitante.recibirElemento(elemento)
        elementosCercanos.remove(elemento)
    }
}
class Tranquilo inherits Comensal {
    override method darElemento(elemento, comensalSolicitante) {
        elementosCercanos.forEach{ elemento => 
        elementosCercanos.remove(elemento)
        comensalSolicitante.recibirElemento(elemento)}
    }  
}
class CambioDePosicion inherits Comensal {
    override method darElemento(elemento, comensalSolicitante) {
        const posicionComensal = self.posicion()
        const posicionComensalSolicitante = comensalSolicitante.posicion()
        comensalSolicitante.cambiarPosicion(posicionComensal)
        self.cambiarPosicion(posicionComensalSolicitante)
}
}
class PasanElemento inherits Comensal {
    override method darElemento(elemento, comensalSolicitante) {
        comensalSolicitante.recibirElemento(elemento)
        elementosCercanos.remove(elemento)
    }
}

//2)
class Bandeja {
    const calorias 
    const carne

    method esCarne() = carne   
    method cantidadCalorias() = calorias
}

class Vegetariano inherits Comensal {
    override method comer(bandeja) {
        if(!bandeja.esCarne()) {
            self.registrarComida(bandeja)
        }
}
}
class Dietetico inherits Comensal {
    var caloriasRecomendadas = 500

    method cambiarCalorias(nuevasCalorias) { caloriasRecomendadas = nuevasCalorias}
    override method comer(bandeja) {
        if(bandeja.cantidadCalorias() < caloriasRecomendadas){
            self.registrarComida(bandeja)
        }
}
}
class Alternado inherits Comensal {
    var contador = 0

    override method comer(bandeja) {
        if(contador == 0){
            self.registrarComida(bandeja)
            contador += 1
        } else {
            contador -= 1
        }
    }
}
class Combinacion inherits Comensal {
    override method comer(bandeja) {
        if(bandeja.esCarne() && bandeja.cantidadCalorias() > 150){
            self.registrarComida(bandeja)
        } 
    }
}

object pasarlaBien {
  method laPasoBien(persona) = !persona.registrarComida().isEmpty() 
}
object posicion {
  const posicionElegida = 1
  method laPasoBien(persona) = persona.posicion() == posicionElegida
}
object comioCarne {
    method laPasoBien(persona) = persona.registrarComida().any{ comida => comida.esCarne()}
}
object elementosCerca {
  const cantidadElementosCerca = 3

  method laPasoBien(persona) = persona.elementosCercanos().size() <= cantidadElementosCerca
}