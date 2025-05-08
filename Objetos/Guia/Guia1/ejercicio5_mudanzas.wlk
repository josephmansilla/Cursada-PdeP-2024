// EJERCICIO 5 MUDANZAS

// A 

// DE MENSAJES EN COMUN ENTRE ESTOS DOS ME INTERESA SABER 
// ALGUNOS DATOS ESPECIFICOS QUE SEAN COMUN ENTRE LOS DOS,
// IDEALMENTE SE PODRIAN AGRUPAR EN UNA CLASE

class Televisor{
    var property peso
    var property codigo 
}

class Silla{
    var property peso
    var property codigo
}

object silla1 {
    var silla1 = new Silla(peso = 20, codigo = "C10")
}
object silla2 {
    var silla2 = new Silla(peso = 35, codigo = "B0")
}
object televisor1 {
    var televisor1 = new Televisor(peso= 100, codigo = "K")
}
object televisor2{
    var televisor2 = new Televisor(peso= 79, codigo = "L09")
}
object televisor3{
    var televisor3 = new Televisor(peso= 124, codigo = "Ñ14")
}

object camion{
    const pesoMaximo = 200
    method posibleCargar(unObjeto, otroObjeto, tercerObjeto){
        self.sumaPeso(unObjeto, otroObjeto, tercerObjeto) <= pesoMaximo
        return "Se puede cargar"
    }
    method sumaPeso(unObjecto, otroObjeto, tercerObjeto){
        return unObjecto.peso() + otroObjeto.peso() + tercerObjeto.peso()
    }
}