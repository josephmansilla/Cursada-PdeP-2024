import familia.*

class Veterinaria{
    var property registradosAdopcion
    var property animalesEnAdopcion

    method familiasCategoriaA() = registradosAdopcion.filter{ familia => self.hayMenores(familia) && self.noTienenMascota(familia) }
    method hayMenores(familia) = familia.tienenMenoresDeEdad()
    method noTienenMascota(familia) = not familia.hayMascota()
            //
    method nombresAniamlesSolitarios(){
        var animalesSolitarios = self.animalesSinPosibilidadAdoptacion()
        return animalesSolitarios.map{ animal => animal.nombre() }
    }
    method animalesSinPosibilidadAdoptacion() = animalesEnAdopcion.filter{ animal => self.noLoQuiereNadie(animal) }
    method noLoQuiereNadie(animal) = registradosAdopcion.all{ familia => not familia.puedeAdoptar(animal) }
            //
    method familiasCategoriaB() = registradosAdopcion.filter{ familia => self.puedeAdoptarAlgunAnimal(familia) }
    method puedeAdoptarAlgunAnimal(familia) = animalesEnAdopcion.any{ animal => familia.puedeAdoptar(animal)} 
            //
    method adoptarAnimal(familia, animal){
        if(self.esPosibleAdoptar(animal, familia)){
            familia.sumarMascota(animal)
            self.eliminarMascota(animal)
        }
    }
    method esPosibleAdoptar(animal, familia) = familia.puedeAdoptar(animal) && self.figuranEnBaseDeDatos(animal, familia)
    method figuranEnBaseDeDatos(animal, familia) = animalesEnAdopcion.contains(animal) && registradosAdopcion.contains(familia)
    method eliminarMascota(animal){ animalesEnAdopcion.remove(animal) }
}