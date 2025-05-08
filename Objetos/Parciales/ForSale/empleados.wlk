import inmuebles.*
// %%%%%%%%%%%%%%%%%%%%%%
// %%%% INMOBILIARIA %%%%
// %%%%%%%%%%%%%%%%%%%%%%

object inmobiliaria{
    var property porcentajeVentaInmobiliaria = 1.5
    const empleados = #{}

    method porcentajeVentaInmobiliaria(porcentajeNuevo){ porcentajeVentaInmobiliaria = porcentajeNuevo }

    method mejorEmpleadoSegun(criterio) = empleados.max { empleado => criterio.consideracion(empleado) }
}


// %%%%%%%%%%%%%%%%%%%
// %%%% EMPLEADOS %%%%
// %%%%%%%%%%%%%%%%%%%

class Empleado{
    var operacionesReservadas = #{}
    var operacionesConcretadas = #{}

    method comisionOperacion(operacion) = operacion.comisionConcretada()
    method totalComisiones() = operacionesConcretadas.sum { operacion => operacion.comisionOperacion(operacion) }
    method cantidadOperacionesConcretadas() = operacionesConcretadas.size()
    method cantidadOperacionesReservadas() = operacionesReservadas.size()

    method habraProblemasCon(unEmpleado) =
        self.cerraronOperacionesEnMismaZona(unEmpleado) 
        && 
        (self.concretoOperacionReservadaPor(unEmpleado) || unEmpleado.concretoOperacionReservadaPor(self))

    method cerraronOperacionesEnMismaZona(unEmpleado) = self.zonasOperadas().any {zona => unEmpleado.operaEnZona(zona)}

    method operaEnZona(zona) = self.zonasOperadas().contains(zona)
    method zonasOperadas() = operacionesConcretadas.map{ operacion => operacion.zona() }

    method concretoOperacionReservadaPor(unEmpleado) = operacionesConcretadas.any { operacion => unEmpleado.entreReservados(operacion) }

    method entreReservados(operacion) = operacionesReservadas.contains(operacion)

    method reservarOperacion(operacion, cliente){
        operacion.reservarPara(cliente)
        operacionesReservadas.add(operacion)
    }
    method concretarOperacion(operacion, cliente){
        operacion.concretarPara(cliente)
        operacionesConcretadas.add(operacion)
    }
}

class Cliente{
    const property nombre
}

// %%%%%%%%%%%%%%%%%%%
// %%%% CRITERIOS %%%%
// %%%%%%%%%%%%%%%%%%%

object totalComision { method consideracion(empleado) = empleado.totalcomisiones() }
object cantidadOperacionesConcretadas{ method consideracion(empleado) = empleado.cantidadOperacionesConcretadas() }
object cantidadOperacionesReservadas{ method consideracion(empleado) = empleado.cantidadOperacionesReservadas() }