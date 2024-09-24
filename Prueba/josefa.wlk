object josefa {
    var kilometrosVolados = 0
    var gramosComidos = 0
    const energiaInicial = 80
    method volar(kilometros){
        kilometrosVolados += kilometros
    }
    method comer(gramos){
        gramosComidos += gramos
    }
    method energia(){
        return energiaInicial + 5 * gramosComidos - 3 * kilometrosVolados
    }
    method volo() = kilometrosVolados > 0

    method comio() = gramosComidos > 0

    method comoTeSentis(){
        if(self.volo() && not self.comio()){
            return "Explotado"
        }
        if(gramosComidos > kilometrosVolados){
            return "Gordita"
        }
        if(self.energia() > energiaInicial){
            return "energizada"
        }
        return "Indiferente"
    }
}