import empleados.*

// %%%%%%%%%%%%%%%%%%%
// %%%% INMUEBLES %%%%
// %%%%%%%%%%%%%%%%%%%

class Inmueble{
    const property tamanio
    const property cantAmbientes
    const property zona
    method valorInmueble() = zona.valor()

    method cambiarDimensiones(nuevoTamanio, nuevaCantAmbientes, nuevaZona){
        tamanio = nuevoTamanio
        cantAmbientes = nuevaCantAmbientes
        zona = nuevaZona
    }

    method validarQueSePuedeVender(){}
}

class Casa inherits Inmueble{
    var valorParticular
    override method valorInmueble() = super() + valorParticular
    method cambiarValor(nuevoValor){ valorParticular = nuevoValor }
}
class PentHouse inherits Inmueble{
    override method valorInmueble() = super() + (14000 * tamanio).max(500000)
}
class Departamento inherits Inmueble{
    override method valorInmueble() = super() + 350000 * cantAmbientes
}


// %%%%%%%%%%%%%%%%%
// %%%% LOCALES %%%%
// %%%%%%%%%%%%%%%%%

class Local inherits Casa{
    var tipoDeLocal
    override method valorInmueble() = tipoDeLocal.valor(super())
    override method validarQueSePuedeVender(){ self.error("No se puede vender un local") }
    method cambiarTipo(nuevoTipo){ tipoDeLocal = nuevoTipo }
}

object galpon{
    method valor(valorDado) = valorDado / 2
}

object aLaCalle{
    var montoFijo
    method cambiarMonto(nuevoMonto){ montoFijo = nuevoMonto }
    method valor(valorDado) = montoFijo + valorDado
}


// %%%%%%%%%%%%%%
// %%%% ZONA %%%%
// %%%%%%%%%%%%%%

class Zona{
    var property valor
    method cambiarValor(valorDado){valor = valorDado}
}

// %%%%%%%%%%%%%%%%%%%%%
// %%%% OPERACIONES %%%%
// %%%%%%%%%%%%%%%%%%%%%

class Operacion{
    const property inmueble
    var estado = disponible
    method cambiarEstado(nuevoEstado){ estado = nuevoEstado }

    method comisionAgente()
    method zona() = inmueble.zona()

    method reservarPara(cliente){
        estado.reservarPara(self, cliente)
    }
    method concretarPara(cliente){
        estado.concretarPara(self,cliente)
    }
    method porcentaje() = inmobiliaria.porcentajeVentaInmobiliaria()


}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%% TIPOS DE OPERACIONES %%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Alquiler inherits Operacion{
    var property cantidadDeMeses
    override method comisionAgente() = (cantidadDeMeses * inmueble.valorInmueble()) / 50000
}

class Venta inherits Operacion{
    override method comisionAgente() = inmueble.valorInmueble() * self.porcentaje()
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%% ESTADOS DE OPERACIONES %%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class EstadoOperacion{
    method reservarPara(operacion, cliente)
    method concretarPara(operacion, cliente){
        self.validarCierrePara(cliente)
        operacion.cambiarEstado(cerrada)
    }
    method validarCierrePara(cliente){}
}

object disponible inherits EstadoOperacion{
    override method reservarPara(operacion, cliente){
        operacion.cambiarEstado(new Reservada(clienteQueReservo = cliente))
    }
    
}
object cerrada inherits EstadoOperacion{
    override method reservarPara(operacion, cliente){ self.error("Ya se cerró esta operación") }
    override method concretarPara(operacion, cliente){ self.error("No es posible concretar más de una vez") }
}
class Reservada inherits EstadoOperacion{
    var property clienteQueReservo

    override method reservarPara(operacion, cliente){
        self.error("Ya había una reserva de " ++ clienteQueReservo.nombre())
    }
    override method concretarPara(operacion, cliente){
        if(cliente != clienteQueReservo){
            self.error("Ya había reservado " ++ clienteQueReservo.nombre())
        }
    }
}