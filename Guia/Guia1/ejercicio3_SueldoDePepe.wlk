// EJERCICIO 3 SUELDO DE PEPE

// SUELDO NETO
object gerente{
    method neto(){
        return 1500
    }
}
object cadete{
    method neto(){
        return 1000
    }
}

// BONOS
// BONO POR PRESENTISMO
object bonoPorNoFaltar{
    method monto(empleado){
        if(empleado.cantidadDeFaltas() == 0){
            return 100
        }
        else if(empleado.cantidadDeFaltas() == 1){
            return 50
        }
        else {
            return 0
        }
    }
}

// BONO POR RESULTADOS
object bonoPorcentaje{
    method monto(empleado){
        return empleado.sueldoNeto() * 0.1
    }
}
object bonoMontoFijo{
    method monto(empleado){
        return 80
    }
}
object bonoNulo{
    method monto(empleado){
        return 0
    }
}

// EMPLEADO PEPE
object pepe {
    const categoria = gerente
    var property bonoPresentismo = bonoNulo //bonoPorNoFaltar
    var property bonoResultado = bonoPorcentaje// bonoMontoFijo
    const cantidadDeFaltas = 0
    
    method cantidadDeFaltas(){
        return cantidadDeFaltas
    }
    method sueldoNeto(){
        return categoria.neto()
    }
    method sueldo(){
        return self.sueldoNeto() + bonoPresentismo.monto(self) + bonoResultado.monto(self)

    }

}

class Empleado{
    const categoria
    var property bonoPresentismo
    var property bonoResultado
    const cantidadDeFaltas

    method cantidadDeFaltas(){
        return cantidadDeFaltas
    }
    method sueldoNeto(){
        return categoria.neto()
    }
    method sueldo(){
        return self.sueldoNeto() + bonoPresentismo.monto(self) + bonoResultado.monto(self)

    }
}
