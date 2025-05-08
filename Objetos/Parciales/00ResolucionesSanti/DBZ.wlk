class Guerrero {
    const potencialOfensivo
    var experiencia
    var energiaActual
    const energiaInicial
    var traje
    var expPorPelea

    method expPorPelea() = expPorPelea
    method aumentarExpPorPelea(valor) { expPorPelea += valor}
    method disminuirExpPorPelea(valor) { 0.max(expPorPelea - valor)}

    method traje() = traje
    method cambiarTraje(nuevoTraje) { traje = nuevoTraje}    

    method potencialOfensivo() = potencialOfensivo

    method energiaActual() = energiaActual
    method disminuirEnergia(valor) {
        if(energiaActual - valor <= 0){
            self.morir()
        } else {
            energiaActual -= valor
        }
    }
    method restaurarEnergia() { energiaActual = energiaInicial} 

    method experiencia() = experiencia
    method aumentarExp(valor) { experiencia += valor}

    method morir() { energiaActual = 0}

    method atacar(guerrero) {
        const ataque = self.potencialOfensivo() * 0.1

        guerrero.traje().recibirDanio(guerrero, ataque)
        traje.aumentarExperiencia(expPorPelea, guerrero)
    }

    method comerSemilla() { self.restaurarEnergia()}
}

const goku = new Guerrero(potencialOfensivo = 100, experiencia = 100, energiaInicial = 5000, energiaActual = 5000, traje = sinTraje, expPorPelea = 1)
const vegetta = new Guerrero(potencialOfensivo = 100, experiencia = 100, energiaInicial = 5000, energiaActual = 5000, traje = trajeModularizado, expPorPelea = 1)

class Traje {
    var desgaste = 0
    const valorDesgaste = 5
    var estaGastado = false

    method estaGastado() = estaGastado
    method noPuedeUsarse() { estaGastado = true}

    method recibirDanio(guerrero, danio)

    method desgaste() = desgaste
    method aumentarDesgaste() { desgaste += valorDesgaste}
    method desgastar(guerrero) { 
        if(desgaste + valorDesgaste >= 100) {
            self.noPuedeUsarse()
            guerrero.cambiarTraje(sinTraje)
        } else{
            self.aumentarDesgaste()
        } 
    }

    method aumentarExperiencia(valor, guerrero) { guerrero.aumentarExp(valor) }
}

class TrajeComun inherits Traje{
    const danioDisminuido

    override method recibirDanio(guerrero, ataque) { 
        const danio = ataque - ataque * danioDisminuido
        guerrero.disminuirEnergia(danio)

        self.desgastar(guerrero)
    }
}

const trajeComun = new TrajeComun(danioDisminuido = 0.3 )

class TrajeEntrenamiento inherits Traje {
    override method recibirDanio(guerrero, ataque) {
        guerrero.disminuirEnergia(ataque)

        const exp = guerrero.expPorPelea() * 2
        guerrero.aumentarExp(exp)

        self.desgastar(guerrero)
    } 
}

const trajeEntrenamiento = new TrajeEntrenamiento() 

class SinTraje inherits Traje {
    override method recibirDanio(guerrero,ataque) {
        guerrero.disminuirEnergia(ataque)
    }
}

const sinTraje = new SinTraje()

class Modularizado inherits Traje {
    const piezas  

    method piezas() = piezas

    override method estaGastado() = piezas.all{ pieza => pieza.estaGastada()}

    override method recibirDanio(guerrero,ataque) {
        const noGastadas = self.piezasNoGastadas()
        const resistenciaTotal = noGastadas.sum{ pieza => pieza.resistencia()}

        guerrero.disminuirEnergia(ataque - resistenciaTotal)
        piezas.forEach{ pieza => pieza.desgastarPieza()}
     }

    method piezasNoGastadas() = piezas.filter{ pieza => !pieza.estaGastada()}

    override method aumentarExperiencia(valor, guerrero) {
        const aumento = self.piezasNoGastadas().size() / piezas.size()
        
        if(self.piezasNoGastadas().size() == 0){
            guerrero.aumentarExp(1)
        } else{
            guerrero.aumentarExp(aumento)
        }

    }
}

const trajeModularizado = new Modularizado(piezas = [pieza1, pieza2])

class Pieza {
    var desgaste
    const resistencia
    const valorDesgaste
    var estaGastada = false

    method estaGastada() = estaGastada
    method aumentarDesgaste() { desgaste += valorDesgaste}
    method gastar() { estaGastada = true}

    method desgastarPieza() {
        if(desgaste + valorDesgaste >= 20) {
            self.gastar()
        } else {
            self.aumentarDesgaste()
        }
    }

    method resistencia() = resistencia
}

const pieza1 = new Pieza(desgaste = 5, valorDesgaste = 1, resistencia = 1)
const pieza2 = new Pieza(desgaste = 5, valorDesgaste = 1, resistencia = 4)