import Asadito.*
// PARTE 1
// 1A CALCULAR IMPACTO NO MÁS hechizo.impactoSobreHechicero(unHechicero, OtroHechicero)
// 1B TENER EFECTO DEL HECHIZO hechicero.lanzarHechizo(hechizo, otroHechicero)
// 1C HECHIZO MAS CONVENIENTE hechicero.mejorHechizo(hechizos, otroHechicero)
import hechizos.*
import efectos.*

class Hechicero{
    const property vidaMaxima
    var property vidaActual = vidaMaxima
    const property coraje
    const property empatia
    const property conocimiento

    const efectosHechicero = new EfectosDuraderos(efectosVigentes = [])
    
    method cambiarVida(nuevaVida){ vidaActual = nuevaVida.vidaMaxima() }
    method vidaFaltante() = vidaMaxima - vidaActual
    
    method lanzarHechizo(hechizo, hechiceroObjetivo){
        self.algunEfectoImpideLanzar()
        hechizo.hechiceroUsaraContra(self, hechiceroObjetivo)
    }

    method mejorHechizo(hechizos, hechiceroObjetivo){ hechizos.max { hechizo => hechizo.conviencia(self, hechiceroObjetivo) } }

    method algunEfectoImpideLanzar(){ efectosHechicero.lePermiteLanzar() }
    method aplicarEfectoDuradero(elEfecto){ efectosHechicero.agregarEfecto(elEfecto) }

    method seFinalizaTurno(){
        efectosHechicero.pasarTurnosTodos(self)
        efectosHechicero.removerEfectos(self)
    }
}

