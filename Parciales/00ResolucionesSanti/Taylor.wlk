class Artista {
    var instrumento
    const estilos
    var allegados

    method cambiarInstrumento(nuevoInstrumento) { instrumento = nuevoInstrumento}
    method instrumento() = instrumento

    method estilos() = estilos

    method cantidadEstilos() = estilos.size()

    method calidad() = self.cantidadEstilos() + instrumento.puntos(self)

    method haceEstilo(estilo) = estilos.contains(estilo)

    method esVocalista() = instrumento.esVocalista()

    method sumarAllegados(nuevosAllegados) { allegados += nuevosAllegados}
    method restarAllegados(allegadosPerdidos) { allegados = 0.max(allegados - allegadosPerdidos)}

    method estaPegada() = allegados >= 20000
}

const taylor = new Artista(instrumento = vozTaylor, estilos = ["pop","rock", "country"], allegados = 100)
const maikel = new Artista(instrumento = vozMaikel, estilos = ["pop", "soul"], allegados = 100)
const riorio = new Artista(instrumento = guitarraRiorio, estilos = ["metal", "heavyMetal"], allegados = 100)
const hellMusic = new Artista(instrumento = vozHellMusic, estilos = ["metal", "deathMetal"], allegados = 100)
const truquillo = new Artista(instrumento = bajoTruquillo, estilos = ["rock", "metal"], allegados = 100)
const emiliaViernes = new Artista(instrumento = vozEmilia, estilos = ["umbiaUruguaya", "pop"], allegados = 100)
const rengoEstar = new Artista(instrumento = bateriaRengoEstar, estilos = ["rock", "pop"], allegados = 100)

class Instrumento {
    method puntos(artista)

    method esVocalista() = false
}

class GuitarraCriolla inherits Instrumento {
    const cuerdasSanas

    override method puntos(artista) = 10 + cuerdasSanas
}

class GuitarraElectrica inherits Instrumento {
    const amplificador

    method potenciaAmplificador() = amplificador.potencia()

    override method puntos(artista) = 15 + self.potenciaAmplificador()
}

const guitarraRiorio = new GuitarraElectrica(amplificador = marshall)

class Amplificador{
    const potencia

    method potencia() = potencia
}

const marshall = new Amplificador(potencia = 7)

class Bajo inherits Instrumento {
    const color
    const estiloExtra = "metal"

    method esRojo() = color == "rojo"

    override method puntos(artista) = 5 + self.puntosExtra(artista)

    method puntosExtra(artista) {
        if(artista.haceEstilo(estiloExtra)) {
            if(self.esRojo()) return 7 else return 2
        } else return 0
    }
}

const bajoTruquillo = new Bajo(color = "rojo")

class Bateria inherits Instrumento {
    const estiloExtra = "rock"

    override method puntos(artista) = 10 + self.puntosExtra(artista)

    method puntosExtra(artista) {
        if(artista.haceEstilo(estiloExtra)) return 10 else return 0
    }
}

const bateriaRengoEstar = new Bateria()

class Voz inherits Instrumento {
    var puntos = 16

    override method esVocalista() = true

    override method puntos(artista) = 16

    method cambiarPuntos(nuevosPuntos) { puntos = 0.max(nuevosPuntos)} //considero los puntos >= 0
}

const vozTaylor = new Voz()
const vozMaikel = new Voz()
const vozHellMusic = new Voz()
const vozEmilia = new Voz()

class Banda {
    const integrantes
    var allegados = 0

    method puedenSerBanda() = self.hayUnSoloVocalista() && self.tienenEstiloEnComun() && self.noSonMasDe4()

    method noSonMasDe4() {
        if(integrantes.size() <= 4) return true
        else throw new DomainException(message = "Los integrantes son mas de 4")
    }
    method hayUnSoloVocalista() {
        if(integrantes.count{ integrante => integrante.esVocalista()} <= 1) return true //considero que pueden haber bandas sin vocalistas
        else throw new DomainException(message = "Hay mas de un vocalista")
    }
    method tienenEstiloEnComun() {
        const estilosIniciales = integrantes.first().estilos()
        const estilosComunes = estilosIniciales.filter{ estilo => integrantes.all{ integrante => 
                                                integrante.haceEstilo(estilo) }}
    
    if(!estilosComunes.isEmpty()) return true
    else throw new DomainException(message = "No tienen estilo en comun")
    }

    method calidad() = self.estilosTotales() + self.calidadMaxima() + self.plusPorIntegrante()

    method plusPorIntegrante() = 2 * integrantes.size()
    method calidadMaxima() = self.integranteConMasCalidad().calidad()
    method estilosTotales() = integrantes.sum{ integrante => integrante.cantidadEstilos()}

    method sumarAllegados(nuevosAllegados) { 
        allegados += nuevosAllegados
        
        const musicoConMasCalidad = self.integranteConMasCalidad()

        musicoConMasCalidad.sumarAllegados(nuevosAllegados / 2)
    }
    method restarAllegados(allegadosPerdidos) { allegados = 0.max(allegados - allegadosPerdidos)}

    method integranteConMasCalidad() = integrantes.max{ integrante => integrante.calidad()}

    method estaPegada() = allegados >= 20000
}

class Recital {
    const duracion // horas
    const artista
    const participantes

    method sumarAllegados() {
        if(duracion < 1) {
            const allegadosPerdidos = participantes * 0.03

            artista.restarAllegados(allegadosPerdidos)
        }
        else {
        const porcentajeAllegados = artista.calidad()
        const allegadosNuevos = participantes.min(participantes * porcentajeAllegados / 100)

        artista.sumarAllegados(allegadosNuevos)
    }
    }
}