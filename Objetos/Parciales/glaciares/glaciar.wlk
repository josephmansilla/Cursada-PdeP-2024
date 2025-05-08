class Glaciar{
    var afluente
    var desembocaEn // otro objeto -> masa de agua(rio, lago) o glaciar
    var masa // por tempanos que vienen de otros glaciares o que se le desperden
    const property temperatura = 1

    method pesoInicialTempano() =  0.000001 * masa * self.temperaturaDesembocadura()
    method temperaturaDesembocadura() = desembocaEn.temperatura() // el objeto a donde va el tempano debe entender este mensaje

    method cambiarPeso(cantidad){ masa += cantidad}
    method seDesprendeTempano(){
        const tempanito = new Tempano(masaTotal = self.pesoInicialTempano(), temperatura = self.temperaturaDesembocadura(), esAireado = false)
        self.cambiarPeso(-tempanito.masaTotal())
        desembocaEn.agregarTempano(tempanito)
    }
    method agregarTempano(tempanito) { 
        self.cambiarPeso(tempanito.masaTotal())
    }
}
/*
const peineta = new Glaciar()
const mayoNorte = new Glaciar()
const peritoMoreno = new Glaciar()
const lagoArgentino = new masaAgua()
const spegazzini = new Glaciar(desembocaEn = [mayorNorte, lagoArgentino])
*/
class Tempano{
    var property masaTotal // en kg
    var property esAireado
    const property temperatura

    method masaParteVisible(){
        return masaTotal * 0.15
    }
    method seVeAzul() = self.masaParteVisible() > 100 && not esAireado
    method cuantoEnFriaAgua(){
        if(esAireado){
            return 0.5 // grados
        } else{
            return masaTotal * 0.01
        }
    }
    method pesaMasQue(cantidad) = masaTotal > cantidad
    method cambiarPeso(cantidad) { masaTotal += cantidad }
    method esGrande() = pesoMayorA500.requisito(self)
    method seVuelveAireado() { esAireado = true }
}

class MasaAgua{
    var estaFlotando = []
    const requerimientoAtractivo = [pesoMayorA500, esAzul]
    var property temperaturaAmbiente

    method esAtractiva() = 
        self.tieneNTempanos(5) 
        && 
        (self.todosTempanosSon(requerimientoAtractivo.get(0)) || self.todosTempanosSon(requerimientoAtractivo.get(1)))
    method tieneNTempanos(cantidad) = self.cantidadTempanos() > cantidad
    method todosTempanosSon(requerimiento) = estaFlotando.all{ tempano => requerimiento.requisito(tempano)}
    method cantidadTempanos() = estaFlotando.length()

    method temperatura() = temperaturaAmbiente - self.tempanosEnfrian()
    method tempanosEnfrian() = estaFlotando.sum{ tempano => tempano.temperatura() }

    method cantidadTempanosGrandes() = estaFlotando.filter{ tempano => tempano.esGrande() }.length()
    method agregarTempano(tempanito){ estaFlotando.add(tempanito) }
    method permiteNavegar(embarcacion)

    method cambiarPesoTempanos(cantidad) = estaFlotando.forEach{ tempano => tempano.cambiarPeso(cantidad) }
    method seAireanTempanos(){ estaFlotando.forEach{ tempano => if(not tempano.esGrande()) tempano.seVuelveAireado() } }
}

class Rio inherits MasaAgua{
    var property velocidadBase
    override method temperatura() = super() + self.velocidadRio()
    method velocidadRio() = velocidadBase - self.cantidadTempanosGrandes()

    override method permiteNavegar(embarcacion) = embarcacion.fuerzaMotor() >= self.velocidadRio()
}

class Lago inherits MasaAgua{
    override method permiteNavegar(embarcacion) =
        if(self.cantidadTempanos() >= 20) embarcacion.tamanio() < 10
        &&
        self.temperatura() >= 0
}

class PesoMayor{
    const cantidad
    method requisito(tempano) = tempano.pesaMasQue(cantidad)
}
const pesoMayorA500 = new PesoMayor(cantidad = 500)
object esAzul{
    method requisito(tempano) = tempano.seVeAzul()
}

class Embarcacion{
    const property tamanio // en metros
    var property fuerzaMotor

    method esPosibleNavegar(masaAgua) = masaAgua.permiteNavegar(self)

    method efectoNavegar(masaAgua){
        masaAgua.cambiarPesoTempanos(-1)
        masaAgua.seAireanTempanos()
    }

    method navegar(masaAgua){
        if(self.esPosibleNavegar(masaAgua)){
            self.efectoNavegar(masaAgua)
        } else{ self.error("No es posible navegarlo") }
    }
}