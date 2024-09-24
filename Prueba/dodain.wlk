object dodain{
    method entrenar(pajarito){
        pajarito.comer(10)
        pajarito.volar(20)
        if(pajarito.energia()<20){
            pajarito.comer(10)
        }else{
            pajarito.comer(5)
        }
    }
}