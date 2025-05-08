// EJERCICIO 1 PEPITA
object pepita {
    var property energia = 100
    var property ubicacion = 0 //expresado en km

    method energia(){
        return energia
    }
    method comer(gramos) {
        energia += gramos * 4
    }
    method volar(kilometro){
        const despegue = 10
        energia -= despegue + kilometro * 1
    }

    method lugar(kilometro){
        ubicacion = kilometro
        self.volar(kilometro)
    }
    method distancia(km) = (km - self.ubicacion()).abs() 
    method puedeIrALugar(kilometroSeleccionado){
        if((self.distancia(kilometroSeleccionado)).energia() <= self.energia()){
            return "llega a volar"
        }
        else{
            return "no llega a volar"
        }
        
    }
}