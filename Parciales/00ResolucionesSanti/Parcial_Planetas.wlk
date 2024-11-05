class Persona {
    var monedas = 20
    var edad

    method ganarMonedas(valor) { monedas += valor}
    method perderMonedas(valor) { monedas = 0.max(monedas - valor)} 

    method cumplirAnios() { edad += 1}
    method edad() = edad

    method recursos() = monedas
    method esDestacado() = edad.between(18, 65) || self.recursos() >= 30

    method trabajar(tiempo, planeta){ }
}

class Productor inherits Persona {
    const tecnicas = ["cultivo"]
    const monedasPorUnidadTiempo = 3
    const monedasPerdidas = 1

    method cantidadTecnicas() = tecnicas.size()

    override method recursos() = super() * self.cantidadTecnicas()
    override method esDestacado() = super() || self.cantidadTecnicas() >= 5

    method realizarTecnica(tecnica, tiempo) {
        if(tecnicas.contains(tecnica)) {
            self.ganarMonedas(monedasPorUnidadTiempo * tiempo)
        } else {
            self.perderMonedas(monedasPerdidas)
        }
    }

    method aprenderTecnica(tecnica) { tecnicas.add(tecnica)}

    override method trabajar(tiempo, planeta) { 
        if(planeta.viveEnPlaneta(self)) {
            const tecnica = self.ultimaTecnicaAprendida()

            self.realizarTecnica(tecnica, tiempo)
        }
    }

    method ultimaTecnicaAprendida() = tecnicas.last()
}

class Constructor inherits Persona {
    const construccionesRealizadas // es un numero
    const region
    const monedasPorConstruccion = 10
    const construccionesParaDestacarse = 5
    const monedasPerdidasPorConstruccion

    method construccionesRealidazas() = construccionesRealizadas

    override method recursos() = super() + monedasPorConstruccion * construccionesRealizadas
    override method esDestacado() = construccionesRealizadas >= construccionesParaDestacarse

    override method trabajar(tiempo, planeta) {
        const construccionAConstruir = region.construccion(tiempo, self)

        planeta.agregarConstruccion(construccionAConstruir)
        self.perderMonedas(monedasPerdidasPorConstruccion)
    }


}

class Montania {
    method construccion(tiempo, constructorr) = new Muralla(longitud = tiempo / 2)
}

class Costa {
    method construccion(tiempo, constructorr) = new Museo(superficie = tiempo, indiceImportancia = 1)
}

class Llanura {
    method construccion(tiempo, constructorr) {
        if(constructorr.esDestacado()){
            const indice = 1.max(5.min(constructorr.recursos()))

            return new Museo(superficie = tiempo, indiceImportancia = indice)
        } else {
            return new Muralla(longitud = tiempo/2)
        }
    }
}

class LP {
    method construccion(tiempo, constructorr){
        if(constructorr.construccionesRealizadas() >= 10) {
            return new Muralla(longitud = 10000000)
        } else {
            return new Muralla(longitud = tiempo / 10)
        }
    }
}

class Muralla {
    const longitud
    const monedasPorUnidad = 10

    method valor() = longitud * monedasPorUnidad
}

class Museo {
    const superficie
    const indiceImportancia // va de 1 a 5 pero como no aumenta o disminuye por ningun otro metodo no lo verifico

    method valor() = superficie * indiceImportancia
}

class Planeta {
    const habitantes
    const construcciones

    method habitantes() = habitantes
    method viveEnPlaneta(persona) = habitantes.contains(persona)

    method delegacionDiplomatica() {
        const habitantesDestacados = habitantes.filter{ habitante => habitante.esDestacado()}
        const habitanteConMasRecursos = habitantes.max{ habitante => habitante.recursos()}

        habitantesDestacados.add(habitanteConMasRecursos)

        return habitantesDestacados.asSet()
    }

    method esValioso() = construcciones.sum{ construccion => construccion.valor()} >= 100

    method agregarConstruccion(construccion) { construcciones.add(construccion)}
}
