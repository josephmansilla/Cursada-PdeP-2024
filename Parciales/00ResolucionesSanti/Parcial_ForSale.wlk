class Inmueble {
    var property tamanio // m^2
    var property cantidadAmbientes
    var property operacion // venta o alquiler
    var property zona
    var property plusPorZona  
    var property estaReservada  
    var duenioReserva 
    var duenioPropiedad  
    var property esLocal  

    method valorInmueble() = plusPorZona
    method comisionEmpleado() = operacion.comisionSegunOperacion(self)

    method cambiarDuenioReserva(nuevoDuenio) { duenioReserva = nuevoDuenio}
    method duenioReserva() = duenioReserva

    method cambiarDuenioPropiedad(nuevoDuenio) { duenioPropiedad = nuevoDuenio}
    method duenioPropiedad() = duenioPropiedad

}

class Casa inherits Inmueble {
    var property valorCasa

    override method valorInmueble() = super() + valorCasa 
}

class PH inherits Inmueble {
    const valorMinimo = 500000
    const precioMetroCuadrado = 14000

    method precioPH() = precioMetroCuadrado * self.tamanio()
    override method valorInmueble() = super() + valorMinimo.max(self.precioPH())
}

class Departamento inherits Inmueble {
    const precioAmbiente = 350000

    override method valorInmueble() = super() + precioAmbiente * self.cantidadAmbientes()
}

class Local inherits Casa {
    var tipoLocal
    
    override method valorInmueble() = tipoLocal.precio()
    method tipoLocal() = tipoLocal 
    method cambiarTipo(nuevoTipo) { tipoLocal = nuevoTipo}
}

class Galpon inherits Local {
    method precio() = self.valorCasa() / 2
}

class ALaCalle inherits Local {
    const montoExtra
    method precio() = self.valorCasa() + montoExtra 
}

class Alquiler {
    const meses 

    method comisionEmpleado(inmueble) = meses * inmueble.valorInmueble() / 50000  
}

class Venta {
    const porcentaje = 0.015 // %  

    method comisionEmpleado(inmueble) = inmueble.valorInmueble() * porcentaje
    method puedeVenderse(inmueble) = ! inmueble.esLocal()
}

class Empleado {
    const operacionesCerradas
    const reservasCerradas
    const equipo
    var property zona

    method realizarReserva(inmueble, cliente) {
        if(!inmueble.estaReservada()) {
            inmueble.cambiarDuenioReserva(cliente)
            reservasCerradas.add(inmueble)
        }
}
    method concretarOperacion(inmueble, cliente) {
        if(inmueble.estaReservada() && inmueble.duenioReserva() == cliente){
            inmueble.cambiarDuenioPropiedad(cliente)
            operacionesCerradas.add(inmueble)
            reservasCerradas.remove(inmueble)
        } else {
            throw new DomainException(message = "Este inmueble ya está reservado para otra persona, por lo tanto no puede concretarse la operacion")
        }
}
    method obtenerComision(inmueble) = inmueble.comisionEmpleado()
    method comisionesTotales() = operacionesCerradas.sum { inmueble => inmueble.comisionEmpleado()}
    method cantidadOperaciones() = operacionesCerradas.size()
    method cantidadReservas() = reservasCerradas.size()
    method operacionesTotales() = reservasCerradas + operacionesCerradas

    method mejorSegun(criterio) = equipo.max{miembro => miembro.criterio()}
    method mejorSegunTotal() = self.mejorSegun(self.comisionesTotales())
    method mejorSegunCantidadOperaciones() = self.mejorSegun(self.cantidadOperaciones())
    method mejorSegunCantidadReservas() = self.mejorSegun(self.cantidadReservas())

    method tendraProblemas(empleado) = self.realizaronOpsEnMismaZona(empleado) && self.seSabotearon(empleado)
    method realizaronOpsEnMismaZona(empleado) = self.operacionesTotales().any { operacionActual => 
           empleado.operacionesTotales().any { operacionEmpleado => operacionActual.zona() == operacionEmpleado.zona()}
}

    method seSabotearon(empleado) = reservasCerradas.any{inmueble => empleado.operacionesCerradas().contains(inmueble)} ||
                                    operacionesCerradas.any{inmueble => empleado.reservasCerradas().contains(inmueble)} 

}

class Cliente {
    method reservar(inmueble, empleado) = empleado.realizarReserva(inmueble, self)
    method cerrarOperacion(inmueble, empleado) = empleado.concretarOperacion(inmueble, self)
}