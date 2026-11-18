object cotizacion {
  var property valor = 1000
}

class Pais {
  const sitios = #{}
  
  method agregarSitio(sitio) { 
    sitios.add(sitio) 
  }

  method sitiosQuePuedeVisitar(turista) {
    return sitios.filter( { sitio => sitio.puedeSerVisitadoPor(turista) } )
  }
  
  method fueAlgunaVez(turista) {
    return sitios.any( { sitio => sitio.fueVisitadoPor(turista) } )
  }
  
  method sitioMasVisitadoPorMenores() {
    return sitios.max( { sitio => sitio.cantidadMenoresQueVisitaron() } )
  }
}

class Categoria {
  const property tipo
  var property millasRef

  method repartirA(turista) {
    const visitados = turista.cantidadDeVisitasA(self)

    if (visitados > 0) {
      turista.ganarMillas(visitados * millasRef)
    } else {
      turista.perderMillas(10 * millasRef)
    }
  }
}

class Sitio {
  const property precioEntrada
  const property categoria
  const property visitantes = #{}
  
  method costoPara(turista) = precioEntrada
  
  method puedeSerVisitadoPor(turista) {
    return turista.dineroDisponible() >= self.costoPara(turista)
  }
  
  method validarVisita(turista) {
    if (not self.puedeSerVisitadoPor(turista)) {
      self.error(turista.toString() + " no puede visitar " + self.toString())
    }
  }
  
  method registrarVisita(turista) {
    visitantes.add(turista)
  }
  
  method aplicarBonificacion(turista) {} 
  
  method recibirVisitaDe(turista) {
    self.validarVisita(turista)
    turista.pagar(self.costoPara(turista))
    turista.registrarVisita(self)
    self.registrarVisita(turista)
    self.aplicarBonificacion(turista)
  }
  
  method fueVisitadoPor(turista) = visitantes.contains(turista)
  
  method cantidadMenoresQueVisitaron() {
    return visitantes.count( { turista => turista.esMenor() } )
  }

  method perteneceA(unaCategoria) = categoria == unaCategoria
}

class SitioInfantil inherits Sitio {
  override method puedeSerVisitadoPor(turista) =
    super(turista) and turista.esMenor()

  override method aplicarBonificacion(turista) {
    turista.ganarMillas(10)
  }
}

class SitioConDescuentoParaAncianos inherits Sitio {
  const porcentajeDescuento = 20

  override method costoPara(turista) =
    if (turista.esAnciano()) {
      precioEntrada * (1 - porcentajeDescuento / 100)
    } else {
      precioEntrada
    }
}

class SitioVIP inherits Sitio {
  override method puedeSerVisitadoPor(turista) =
    super(turista) and turista.millas() >= 500

  override method aplicarBonificacion(turista) {
    turista.ganarMillas(25)
  }
}

class Turista {
  var property edad
  var property millas
  const property preferencias = #{}
  const sitiosVisitados = []
  
  method dineroDisponible() = millas * cotizacion.valor()

  method esMenor() = edad < 18

  method esAnciano() = edad > 70

  method cumplirAnios() { 
    edad += 1 
  }
  
  method pagar(monto) {
    millas -= monto / cotizacion.valor()
  }
  
  method ganarMillas(cantidad) {
    millas += cantidad
  }

  method perderMillas(cantidad) {
    millas -= cantidad
  }

  method registrarVisita(sitio) {
    sitiosVisitados.add(sitio)
  }

  method cantidadDeVisitasA(categoria) = sitiosVisitados.count( { sitio => sitio.perteneceA(categoria) } )
  
  method agregarPreferencia(categoria) {
    preferencias.add(categoria)
  }

  method removerPreferencia(categoria) {
    preferencias.remove(categoria)
  }
  
  method repartoDeMillas() {
    preferencias.forEach( { categoria => categoria.repartirA(self) } )
  }
}

object tiempo {

  method aumentarEdad(personas) {
    personas.forEach( { persona => persona.cumplirAnios() } )
  }
}
