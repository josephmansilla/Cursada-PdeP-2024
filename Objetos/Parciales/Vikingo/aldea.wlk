import Vikingo.*

class Expedicion{
    const lugares = []
    const vikingos = []

    method valePena() = lugares.all{ lugar => self.saleRentable(lugar) }
    method totalVikingos() = vikingos.size()
    method saleRentable(lugar) = lugar.rentabilidad(self) 
    method tomanDanio(cantidad){ vikingos.forEach{ vikingo => vikingo.cambiarVida(-cantidad) } }

    method sumarAExpedicion(vikingo){
        if(not vikingo.esProductivo()) self.error("No puede subirse")
        vikingos.add(vikingo)
    } 
    method repartirBotin(lugar){ 
        const oroParaCada = lugar.botin() / self.totalVikingos() 
        vikingos.forEach{ vikingo => vikingo.sumarOro(oroParaCada) }
    }

}

class Lugar{
    method rentabilidad(expedicion)
    method concecuenciasInvadir(expedicion){ expedicion.repartirBotin(self) }
    
}

class Capital inherits Lugar{
    var defensores
    const danio
    var property factorRiqueza
    method botin() = defensores * factorRiqueza

    override method rentabilidad(expedicion) = self.botin() / expedicion.totalVikingos() >= 3
    override method concecuenciasInvadir(expedicion){
        expedicion.tomanDanio(danio)
    }
}

class Aldeas{
    const aldeas = []
    method rentabilidad(expedicion) = aldeas.all{ aldea => aldea.rentabilidad(expedicion) }
}

class Aldea inherits Lugar{
    var defensa
    const iglesias = []
    method botin() = iglesias.sum{ iglesia =>  iglesia.cantidadCrucifijos() }

    const cantidadRentabilidad = 15
    override method rentabilidad(expedicion){
        self.verificarQuePuedeAtacar(expedicion)
        return self.botin() >= cantidadRentabilidad
    } 
        
    method verificarQuePuedeAtacar(expedicion){ if(not defensa.requisitoDefensa(expedicion)){self.error("No cumple requisitos para pasar")} }
}

object sinDefensa{
    method requisitoDefensa(expedicion) = true
}
class Muralla{
    const cantidadMinimaMuralla
    method requisitoDefensa(expedicion) = expedicion.totalVikingos() >= cantidadMinimaMuralla
}