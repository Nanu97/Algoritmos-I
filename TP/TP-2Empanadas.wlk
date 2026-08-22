object galvan {
  var sueldo = 15000
  var dinero = 0
  var deuda = 0

  method sueldo() = sueldo

  method sueldo(nuevoSueldo) { sueldo = nuevoSueldo }

  method dinero() = dinero

  method deuda() = deuda

  method gastar(importe) {
    if (dinero >= importe) {
      dinero -= importe
    } else {
      deuda += importe - dinero
      dinero = 0
    }
  }

  method cobrarSueldo() {
    if (sueldo >= deuda) {
      dinero += sueldo - deuda
      deuda = 0
    } else {
      deuda -= sueldo
    }
  }
}
object baigorria {
  var empanadasVendidas = 0
  const precioEmpanadas = 15
  var totalCobrado = 0

  method venderEmpanadas(cantidad) { empanadasVendidas += cantidad }

  method sueldo() = empanadasVendidas * precioEmpanadas

  method totalCobrado() = totalCobrado

  method cobrarSueldo() { totalCobrado += self.sueldo() 
                            empanadasVendidas = 0 }

}

object gimenez {
  var fondo = 300000

  method fondo() = fondo

  method pagar(empleado) { fondo -= empleado.sueldo()
                          empleado.cobrarSueldo() }
}
