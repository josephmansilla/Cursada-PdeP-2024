import hechiceros.*

object coraje{
    method retornarCaracteristica(hechicero) = hechicero.coraje()
}

object empatia{
    method retornarCaracteristica(hechicero) = hechicero.empatia()
}

object conocimiento{
    method retornarCaracteristica(hechicero) = hechicero.conocimiento()
}

object balance{ // sumatoria de todas las caracteristicas
    method retornarCaracteristica(hechicero) {
        const caracteristicas = [coraje, empatia, conocimiento]
        return caracteristicas.sum{ unaCaracteristica=> unaCaracteristica.retornarCaracteristica(hechicero) }
                / caracteristicas.length()
    }
}