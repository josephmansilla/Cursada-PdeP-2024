class Juego{
    var property cantidadPlataInicial
    var property partidasGanadas = 0
    var property partidasPerdidas = 0
    var property maximoApostado = 0
    var property gorroConPremio = -1

    method ponerMoneda(){
        gorroConPremio = 1.randomUpTo(3).truncate(0)
    }
    
    method apostar(cantidadPlata, numeroElegidoGorro){ // le inserto la cantidad de plata con la que quiero jugar 
    // le inserto el numero del gorro que creo que es
        self.ponerMoneda()

        if(cantidadPlata <= cantidadPlataInicial){
            cantidadPlataInicial -= cantidadPlata

            if(numeroElegidoGorro == gorroConPremio){

                if(cantidadPlata > maximoApostado){maximoApostado = cantidadPlata}
                partidasGanadas += 1
                return cantidadPlata * 2

            } else {
                partidasPerdidas += 1
                return 0
            }
        }
        else{self.error("Saldo insuficiente")}
    }
}

const scam = new Juego(cantidadPlataInicial = 100)