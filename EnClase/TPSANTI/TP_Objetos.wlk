object baculo {
  method poder() = 400 
}

object espada {
  var property origen = "elfico"

  method poder(){
    if(origen == "elfico") return 25 * 10
    else if(origen == "enana") return 20 * 10
    else return 15 * 10
  } 
}

// RECORRIENDO LA TIERRA MEDIA

class Guerrero {
    var property armas 
    var property vida 

    method recorrerZona(zona) {
        if (self.puedePasar(zona)) zona.consecuencias(self)
    }  
    method puedePasar(zona) = zona.permitePasar(self)
    method recorreCamino(zona1, zona2) {
        if(zona1 != zona2 && self.puedePasar(zona1) && self.puedePasar(zona2)) {
            self.recorrerZona(zona1)
            self.recorrerZona(zona2)
        }
    }
    method disminuirVida(valor) { vida -= valor}
    method aumentarVida(valor) { vida += valor}  
    method poder() { 
    if(vida < 10) return vida * 300 + self.poderArmas() * 2 
    else return vida * 15 + self.poderArmas() * 2
}
  method poderArmas() = self.armas().sum{ arma => arma.poder()} 
}

const unGandalf = new Guerrero(armas = [baculo, espada], vida = 100)

object lebennin {
  method permitePasar(guerrero) = guerrero.poder() > 1500
  method consecuencias(guerrero) {}
}

object minasTirith {
  method permitePasar(guerrero) =  ! guerrero.armas().isEmpty() 
  method consecuencias(guerrero) { guerrero.disminuirVida(10) }
}

object lossarnach {
  method permitePasar(guerrero) = true
  method consecuencias(guerrero) { guerrero.aumentarVida(1)} 
}


object tomBombadil {
  method recorrerZona(zona) = true
  method puedePasar(zona) = true 
  method recorreCamino(zona1, zona2) = true
}