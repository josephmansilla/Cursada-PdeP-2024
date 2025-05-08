class Contenido{
    const property titulo
    var property visitas = 0
    var property contenidoOfensivo = false
    var property monetizacion

    method esPopular()

    method recaudacion() = monetizacion.recaudacion(self)
    method recaudacionMaxima()
    method monetizacion(tipoMonetizacion){ monetizacion = tipoMonetizacion }
    method puedeAlquilarse()
}

const tagDeModa = ["perro_salchicha", "gato"]

class Video inherits Contenido{
    override method esPopular() = visitas >= 10000
    override method recaudacionMaxima() = 10000
    override method puedeAlquilarse() = true
}
class Imagen inherits Contenido{
    var property tags
    override method esPopular() = tags.all{ tag => tagDeModa.contains(tag) }
    override method recaudacionMaxima() = 4000
    override method puedeAlquilarse() = false
}

class Monetizacion{
    method recaudacion(contenido)
    method habilitadoPara(contenido)
}
object Publicidad inherits Monetizacion{
    const property dineroPorVisita = 0.05
    const property plusPopular = 2000
    var esOfensivo = false // si coincide con el video

    override method recaudacion(contenido) =
        (dineroPorVisita * contenido.visitas() + self.contenidoPopularPlus(contenido)).min(contenido.recaudacionMaxima())

    method contenidoPopularPlus(contenido) = if(contenido.esPopular()) plusPopular else 0

    override method habilitadoPara(contenido) = self.coincidenRestricciones(contenido)
    method coincidenRestricciones(contenido) = esOfensivo == contenido.contenidoOfensivo()
}

class Donacion inherits Monetizacion{
    var property cantidadDonado
    
    override method recaudacion(contenido) = cantidadDonado
    override method habilitadoPara(contenido) = true
}

class Descarga inherits Monetizacion{
    const property precio
    override method recaudacion(contenido) = contenido.visitas() * precio
    override method habilitadoPara(contenido) = contenido.esPopular()
}

class Aquiler inherits Descarga{
    override method precio() = super().min(1)
    override method habilitadoPara(contenido) = super(contenido) && contenido.puedeAlquilarse()
}


class Usuario{
    const nombre
    const property email
    var property verificado = false
    
    method verificar(){ verificado = true }
    
    const contenidos = [] 
    method saldoTotal() = contenidos.sum{ contenido => contenido.recaudacion() }
    method cantidadContenidoPopular() = contenidos.count{ contenido => contenido.esPopular() }
    method esSuperUsuario() = self.cantidadContenidoPopular() >= 10

    method publicarContenido(contenido, monetizacion){
        self.esVerificado()
        self.verificarMonetizacionApto(monetizacion, contenido)
        contenido.monetizacion(monetizacion)
        contenidos.add(contenido)
    }
    method verificarMonetizacionApto(monetizacion, contenido){ if(not monetizacion.habilitadoPara(contenido)){ self.error("No está habilitado") } }
    method esVerificado(){ if(not verificado){ self.error("No está verificado") } }
}

class Plataforma{
    const property usuarios = []
    method usuarioADinerados() = 
        usuarios
        .filter{ usuario => usuario.verificado() }
        .sortedBy{ usuario, otroUsuario => usuario.saldoTotal() > otroUsuario.saldoTotal() }
        .take{ 100 }
        .map{ usuario => usuario.email() }

    method superUsarios() =
        usuarios
        .filter{ usuario => usuario.esSuperUsuario() }
}