import hechizos.*

class Efecto{
    const property duracionTurnos

    method multiplicadorEfecto()
    method afectar(hechicero){}
    method impactoAConveniencia() = self.multiplicadorEfecto() * duracionTurnos
    method permiteLanzar() = true
}

class EfectoSobreVida inherits Efecto{
    const resistenciaPorTurno
    const factor
    const tipoDanio = 1
    override method multiplicadorEfecto() = factor * resistenciaPorTurno
    override method afectar(hechicero){ hechicero.cambiarVida(tipoDanio * resistenciaPorTurno)}
}

class CuracionDiferida inherits EfectoSobreVida(factor = 2){}
class DanioDifereido inherits EfectoSobreVida(factor = 3, tipoDanio = -1){}
class Aturdimiento inherits Efecto{
    override method permiteLanzar() = false
    override method multiplicadorEfecto() = 5
}


class EfectoVigente{
    const property efecto
    var property turnosRestantes = efecto.duracionTurnos()

    method pasarTurno(hechicero){
        turnosRestantes -= 1
        efecto.afectar(hechicero)
    }
    method permiteLanzarHechizos(){
        if(turnosRestantes > 0 && !efecto.permiteLanzar()){
            self.error("No se pueden lanzar hechizos por " + turnosRestantes + " turnos...")
        }
    }
}

class EfectosDuraderos{
    var property efectosVigentes = []

    method pasarTurnoTodos(hechicero){ efectosVigentes.forEach{efecto => efecto.pasarTurno(hechicero)} }
    method sacarTurnos(hechicero){ efectosVigentes.filter{efecto => efecto.turnosRestantes() > 0} }
    method agregarEfecto(elEfecto){ efectosVigentes.add(elEfecto) }
    method lePermiteLanzar(){ efectosVigentes.forEach{ efecto => efecto.permiteLanzarHechizos() } }
}