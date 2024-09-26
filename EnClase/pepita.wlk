object pepita {
    var energia = 100
    method energia(){
        return energia
    }
    method comer(gramos) {
        energia += gramos * 2
    }
    method volar(kilometro){
        const despegue = 40
        energia -= despegue + kilometro * 5
    }
}


