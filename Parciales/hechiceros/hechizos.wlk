import hechiceros.*
class Hechizo{
    const property potencia
    const caracteristica
    const modificador 
    const efectos = []

    method impactoSobreVida(lanzador, objetivo) =
        potencia + (2 * self.diferenciaEntreCaracteristicas(lanzador, objetivo)).max(0)

    method diferenciaEntreCaracteristicas(lanzador, objetivo) = 
        self.caracteristicaDe(lanzador) - self.caracteristicaDe(objetivo)
    method caracteristicaDe(lanzador) = caracteristica.retornarCaracteristica(lanzador)
    
    // 1B

    method hechiceroUsaraContra(lanzador, objetivo){ // EFECTO
        const impactoActual = self.impactoEnVida(lanzador, objetivo)
        self.aplicarEfecto(impactoActual, lanzador, objetivo)
        self.aplicarEfectosDuraderos(lanzador, objetivo)
    }

    // CONSULTO EL IMPACTO SOBRE RECEPTOR

    method impactoSobreReceptor(cantidadDanio, lanzador, objetivo) // Decide como se aplica el daño en cada hechizo

    method impactoEnVida(lanzador, objetivo) =
        self.impactoSobreReceptor(self.impactoSobreVida(lanzador, objetivo), lanzador, objetivo)
        // aplico la funcion dentro de cada hechizo en particular

    method receptor(lanzador, objetivo)
    method aplicarEfecto(impacto, lanzador, objetivo){(self.receptor(lanzador, objetivo)).cambiarVida(modificador * impacto)}


    // 1C
    method convenienciaBase(lanzador, objetivo) = self.impactoEnVida(lanzador, objetivo)
    method conveniencia(lanzador, objetivo) = 
        self.convenienciaBase(lanzador, objetivo) 
        +
        efectos.sum{ unEfecto => unEfecto.impactoAConveniencia() }

    // 2
    method aplicarEfectosDuraderos(lanzador, objetivo){
        efectos.forEach{ elEfecto => self.receptor(lanzador, objetivo).aplicarEfectoDuradero(elEfecto)}
    }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%% SUBTIPOS DE HECHIZO %%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%

class HechizoCurativo inherits Hechizo(modificador = 1){
    override method impactoSobreReceptor(cantidadDanio, lanzador, objetivo) = cantidadDanio.min(lanzador.vidaFaltante())
    override method receptor(lanzador, objetivo) = lanzador
}

class HechizoAtaque inherits Hechizo(modificador = -1){
    override method impactoSobreReceptor(cantidadDanio, lanzador, objetivo) = cantidadDanio.min()
    override method receptor(lanzador, objetivo) = objetivo
}