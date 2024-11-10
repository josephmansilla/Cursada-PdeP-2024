// Parte 1

// 1a. hechizo.impactoEnResistencia(lanzador, contrincante)
// 1b. hechicero.lanzarHechizo(hechizo, contrincante)
// 1c. hechicero.hechizoMasConveniente(hechizos, contrincante)
// 1d. No hay nuevo punto de entrada - se agrega caracteristicaBalance polimórfica con las otras

// Instanciación de objetos del ejemplo:
// const hechizoCurativo = new HechizoCurativo(potencia = 5, caracteristica = caracteristicaEmpatia)
// const hechicero1 = new Hechicero(empatia = 25, coraje = 7, conocimiento = 10, resistenciaMaxima = 100, resistencia = 50)
// const hechicero2 = new Hechicero(empatia = 22, coraje = 7, conocimiento = 10, resistenciaMaxima = 100)

// Parte 2

// 2a. Efectos duraderos, cambio en el cálculo de conveniencia de un hechizo
// 2b. Efectos duraderos, cambio en el uso de hechizos
// 2c. hechicero.finalizarTurno()

class Hechizo {
    const potencia
    const caracteristica 
    const efectos = []  

    method impactoBase(lanzador, oponente) =
        (potencia + 2 * self.diferenciaEnCaracteristica(lanzador, oponente)).max(0)
    
    method diferenciaEnCaracteristica(lanzador, oponente)
     = caracteristica.valor(lanzador) - caracteristica.valor(oponente)

    method impactoSobreReceptor(calculo, lanzador, oponente)
    
    method impactoEnResistencia(lanzador, oponente) 
        = self.impactoSobreReceptor(self.impactoBase(lanzador, oponente), 
                                lanzador, oponente)

    method serUsadoPor(lanzador, oponente) {
        const impacto = self.impactoEnResistencia(lanzador, oponente)
        self.aplicarEfecto(impacto, lanzador, oponente)
        self.agregarEfectosDuraderos(lanzador, oponente)
    }

    method aplicarEfecto(impacto, lanzador, oponente) 
    method receptor(lanzador, oponente)
    method agregarEfectosDuraderos(lanzador, oponente) {
        efectos.forEach({unEfecto => 
            self.receptor(lanzador, oponente).agregarEfectoDuradero(unEfecto)
        })
    }

    method convenenciaBase(lanzador, oponente) = self.impactoEnResistencia(lanzador, oponente)

    method convenencia(lanzador, oponente) = self.convenenciaBase(lanzador, oponente) + efectos.sum({unEfecto => unEfecto.impactoAConveniencia()})
}
class HechizoAtaque inherits Hechizo {
    override method impactoSobreReceptor(calculo, lanzador, oponente) 
        = calculo.min(oponente.resistencia())
        
    override method aplicarEfecto(impacto, lanzador, oponente) {
        oponente.variarResistencia(-impacto)  
    }
    
    override method receptor(lanzador, oponente) = oponente

    override method convenenciaBase(lanzador, oponente) {
        const terminariaElDuelo = self.impactoEnResistencia(lanzador, oponente) >= oponente.resistencia()
        return super(lanzador, oponente) * if(terminariaElDuelo)  2 else 1
    }
}
class HechizoCurativo inherits Hechizo {
    override method impactoSobreReceptor(calculo, lanzador, oponente) 
        = calculo.min(lanzador.resistenciaMaxima() - lanzador.resistencia())
        
    override method aplicarEfecto(impacto, lanzador, oponente) {
        lanzador.variarResistencia(impacto)
    }
    override method receptor(lanzador, oponente) = lanzador
}

class Efecto {
    const property turnosQueDura

    method multiplicadorConveniencia()

    method impactoAConveniencia() = self.multiplicadorConveniencia() * turnosQueDura  
    method permiteLanzarHechizos() = true

    method afectar(hechicero){
        // No hace nada por defecto
    }
}

class EfectoSobreResistencia inherits Efecto {
    const resistenciaPorTurno

    method factor()

    override method multiplicadorConveniencia() = self.factor() * resistenciaPorTurno
    override method afectar(hechicero) {
        hechicero.variarResistencia(self.deltaEnResistencia())
    }
    method deltaEnResistencia() = resistenciaPorTurno
}
class EfectoCurativo inherits EfectoSobreResistencia {
    override method factor() = 2
}

class EfectoDanio inherits EfectoSobreResistencia {
    override method factor() = 3
    override method deltaEnResistencia() = super() * -1
}

// Otra opción sería que EfectoCurativo y EfectoDanio hereden directo de Efecto y no generalizar de EfectoSobreResistencia
// teniendo una clase un atributo resistenciaAGanar y otra resistenciaAPerder. Mostramos esta variante porque nos pareció
// interesante ver cómo se puede generalizar el comportamiento de dos efectos que son similares en alguna medida sin forzar el modelo.

class EfectoAturdimiento inherits Efecto {
    override method multiplicadorConveniencia() = 5
    override method permiteLanzarHechizos() = false
}

object caracteristicaEmpatia {
    method valor(hechicero) = hechicero.empatia()
}
object carateristicaCoraje {
    method valor(hechicero) = hechicero.coraje()
}
object carateristicaConocimiento {
    method valor(hechicero) = hechicero.conocimiento()
}
object carateristicaBalance {
    // Opcion 1
    // method valor(hechicero) = (hechicero.coraje() + hechicero.empatia() + hechicero.conocimiento()) / 3

    // Opcion 2
    method valor(hechicero) {
        const caracteristicas = [caracteristicaEmpatia, carateristicaCoraje, carateristicaConocimiento]
        return caracteristicas.sum {caracteristica => caracteristica.valor(hechicero)}
                    / caracteristicas.length()
    }
}

class Hechicero { 
    const property coraje
    const property empatia
    const property conocimiento
    const property resistenciaMaxima
    // Un buen default sería que si no se indica la resistencia actual
    // se inicialice con la resistencia máxima
    var property resistencia = resistenciaMaxima
    const efectosVigentes = []

    method resistencia(nuevaResistencia) {
        resistencia = (nuevaResistencia.min(resistenciaMaxima)).max(0)
    }

    method lanzarHechizo(hechizo, contrincante) {
        self.validarQuePuedeLanzarHechizos()
        hechizo.serUsadoPor(self, contrincante)
    }

    method variarResistencia(unValor) {
        self.resistencia(self.resistencia() + unValor)
    }

    method hechizoMasConveniente(hechizos, contrincante) =
        hechizos.max({hechizo => hechizo.conveniencia(self, contrincante)})

    method validarQuePuedeLanzarHechizos() {
        efectosVigentes.forEach({efectoVigente => 
            efectoVigente.validarQuePermiteLanzarHechizos()
        })
    }
    method agregarEfectoDuradero(unEfecto) {
        efectosVigentes.add(new EfectoVigente(efecto = unEfecto))
    }

    method finalizarTurno() {
        efectosVigentes.forEach({efectoVigente => 
            efectoVigente.pasoUnTurno(self)
        })
        efectosVigentes.removeAllSuchThat({efectoVigente => efectoVigente.turnosRestantes() == 0})
    }
}

class EfectoVigente {
    const property efecto
    var property turnosRestantes = efecto.turnosQueDura()

    method validarQuePermiteLanzarHechizos() {
        if(turnosRestantes > 0 && not efecto.permiteLanzarHechizos()) {
            throw new NoSePuedeLanzarHechizosException(message = "No se pueden lanzar hechizos por "+turnosRestantes+" turnos")
        }
    }

    method pasoUnTurno(hechiceroAfectado) {
        turnosRestantes -= 1
        efecto.afectar(hechiceroAfectado)
    }
}

class NoSePuedeLanzarHechizosException inherits DomainException {}