import pepita.*
object beti {
    var companera = pepita

    method companera(ave){
        companera = ave
    }
    method energia() = companera.energia()
    method volar(kilometros) {
        companera.volar(kilometros)
    }
    method comer(gramos){
        companera.comer(gramos / 2)
    }
}