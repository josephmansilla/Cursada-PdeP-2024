class Pajaro {
    var ira 
    var estaEnojado

    method ira() = ira
    method disminuirIra(valor) { ira = 0.max(ira - valor)}

    method fuerza() {
        if(estaEnojado) return self.fuerzaEnojado() else return ira
    } 
    method fuerzaEnojado() = ira * 2

    method hacerEnojar() { estaEnojado = true}
    method entaEnojado() = estaEnojado

    method lanzar(obstaculo) = self.fuerza() >= obstaculo.resistencia()
}

class Red inherits Pajaro {
    var cantidadEnojos

    method cantidadEnojos() = cantidadEnojos
    method aumentarCantidadEnojos(cantidad) { cantidadEnojos = cantidadEnojos + cantidad}

    override method fuerzaEnojado() = self.ira() * 10 * self.cantidadEnojos()
}

class Bomb inherits Pajaro {
    var maxFuerza = 9000

    method maxFuerza() = maxFuerza
    method cambiarMaxFuerza(nuevaMaxFuerza) { maxFuerza = nuevaMaxFuerza }

    override method fuerzaEnojado() = (self.ira() * 2).min(self.maxFuerza())
}

class Chuck inherits Pajaro {
    const velocidadActual
    const nuevaVelocidad = velocidadActual * 2
    const fuerzaSegunVelocidad = 150

    override method fuerza() {
        if(estaEnojado) return self.nuevaFuerza(nuevaVelocidad) else return self.nuevaFuerza(velocidadActual)
    } 
    method nuevaFuerza(velocidad) {
        if(velocidad <= 80) return fuerzaSegunVelocidad else return fuerzaSegunVelocidad + (velocidad - 80) * 5 
    } 
    override method disminuirIra(valor) { } // nada lo tranquiliza
}

class Terence inherits Red {
    var property multiplicador

    override method fuerzaEnojado() = self.ira() * self.multiplicador() * self.cantidadEnojos()
}

class Matilda inherits Pajaro {
    const huevos 

    override method fuerza() {
        if(estaEnojado) {
            huevos.add(huevoPesado)
            return self.ira() * 2 + self.huevosFuerza()
        } else return self.ira() * 2 + self.huevosFuerza()
    }
    
    method huevosFuerza() = huevos.sum{ huevo => huevo.fuerzaHuevo()}
}

class Huevo {
    const peso // kg

    method fuerzaHuevo() = peso
}

const huevoPesado = new Huevo(peso = 2)

class IslaPajaro {
  const pajaros
  const islaCerdito

  method pajarosFuertes() = pajaros.filter{ pajaro => pajaro.fuerza() > 50}
  method fuerzaIsla() = pajaros.sum{ pajaro => pajaro.fuerza()}

  method ocurreEvento(evento) = evento.ocurrir(pajaros)

  method atacar() {
    const obstaculoMasCercano = islaCerdito.head()
    const pajaro = pajaros.anyOne()
    if(pajaro.lanzar(obstaculoMasCercano)) {
        islaCerdito.remove(obstaculoMasCercano)
    }
    pajaros.remove(pajaro)
  }

  method seRecuperaronLosHuevos() = islaCerdito.quedoSinObstaculos() 
}

class SesionManejoIra {

    method ocurrir(pajaros) = pajaros.forEach{ pajaro => pajaro.disminuirIra(5)}   
}

class Invasion {
    var property cantidad 

    method ocurrir(pajaros) = pajaros.forEach{ pajaro => pajaro.aumentarCantidadEnojos(cantidad)}
}

class FiestaSorpresa {
    var property homenajeados  
    method ocurrir(pajaros) {
        if(homenajeados.all{ homenajeado => pajaros.contains(homenajeado)}){
            homenajeados.forEach{ homenajeado => homenajeado.hacerEnojar()}
        } else {
            throw new DomainException(message = "Los homenajeados no pertencen a la isla")
        }
    }
}

class SerieDeEventos {
    const eventos

    method ocurrir(pajaros) = eventos.forEach{ evento => evento.ocurrir(pajaros)}
}

class IslaCerdito {
    const obstaculos

    method quedoSinObstaculos() = obstaculos.isEmpty()
}

class Pared {
    const coeficienteResistencia
    const ancho

    method resistencia() = coeficienteResistencia * ancho
}

const paredVidrio = new Pared(coeficienteResistencia = 10, ancho = 5)
const paredMadera = new Pared(coeficienteResistencia = 25, ancho = 5)
const paredPiedra = new Pared(coeficienteResistencia = 50, ancho = 5)

class Cerdito {
    method resistencia()
}

class CerditoObrero inherits Cerdito {
    const coeficienteResistencia

    override method resistencia() = coeficienteResistencia
}

class CerditoArmado inherits Cerdito {
    const arma
    const coeficienteResistencia = 10

    override method resistencia() = coeficienteResistencia * arma.resistencia()
}