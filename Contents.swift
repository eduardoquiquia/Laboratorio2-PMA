import Foundation

//variables, calculos y plan de pagos con su validacion
print("Nombre del producto: ")
let producto = readLine() ?? ""

print("Precio unitario: ")
let precio = Double(readLine() ?? "0") ?? 0.0

print("Cantidad: ")
let cantidad = Int(readLine() ?? "0") ?? 0

let montoCompra = precio * Double(cantidad)
print("Monto total de compra: S/ \(montoCompra)")
print("---------------------------------------")

print("Elija el Plan de Pagos (6, 12, 24): ")
let mesesPlan = Int(readLine() ?? "0") ?? 0

var porcentajeInteres = 0.0
var esPlanValido = false

if mesesPlan == 6 {
    porcentajeInteres = 0.20
    esPlanValido = true
} else if mesesPlan == 12 {
    porcentajeInteres = 0.40
    esPlanValido = true
} else if mesesPlan == 24 {
    porcentajeInteres = 0.60
    esPlanValido = true
} else {
    print("Plan no valido. No se puede proceder.")
}

//calculos finales para el plan de pagos
if esPlanValido {
    
    let interesTotal = montoCompra * porcentajeInteres
    let montoFinal = montoCompra + interesTotal
    let cuotaMensual = montoFinal / Double(mesesPlan)
    
    print("En que mes hara un pago adelantado? (0 para ninguno, 1 al \(mesesPlan)): ")
    let mesAdelantado = Int(readLine() ?? "0") ?? 0
    
    var montoAdicional = 0.0
    if mesAdelantado >= 1 && mesAdelantado <= mesesPlan {
        print("Monto adicional a pagar ese mes (S/): ")
        montoAdicional = Double(readLine() ?? "0") ?? 0.0
    }

//plan de pagos impresion
    //plan de pago parte 1 cabecera
    print("\n================== PLAN DE PAGO ==================")
    print("Producto: \(producto) | Interes: S/ \(interesTotal) | CuotaM: S/ \(cuotaMensual)")
    print("Monto Compra: S/ \(montoCompra) | Monto Final: S/ \(montoFinal)")
    print("==================================================\n")
    
    print("Mes |       Fecha       | Monto Inicial |     Pago     | Resta Por Pagos")
    print("-----------------------------------------------------------------------")
    
    var saldoActual = montoFinal
    var mesesRealesPagados = 0
    
    let calendar = Calendar.current
    let fechaActual = Date()
    
    //plan de pago parte 2 tabla
    for mes in 1...mesesPlan {
        if saldoActual <= 0.05 {
            break
        }
        
        mesesRealesPagados = mesesRealesPagados + 1
        let montoInicialMes = saldoActual
        
        var pagoDelMes = cuotaMensual
        if mes == mesAdelantado {
            pagoDelMes = cuotaMensual + montoAdicional
        }
        
        if pagoDelMes > montoInicialMes {
            pagoDelMes = montoInicialMes
        }
        
        let restaPorPagos = montoInicialMes - pagoDelMes
        
        var componentes = DateComponents()
        componentes.month = mes
        let fechaFutura = calendar.date(byAdding: componentes, to: fechaActual) ?? fechaActual
        
        let formateador = DateFormatter()
        formateador.dateFormat = "dd/MM/yyyy"
        let fechaString = formateador.string(from: fechaFutura)
        
//fin de la tabla y meses pagados
        var restaString = String(restaPorPagos)
        if restaPorPagos <= 0.05 {
            restaString = "—"
        }
        
        print(" \(mes)        \(fechaString)       \(montoInicialMes)         \(pagoDelMes)           \(restaString)")
        
        saldoActual = restaPorPagos
    }
    
    print("-----------------------------------------------------------------------")
    print("\n                            MESES PAGADOS \(mesesRealesPagados) DE \(mesesPlan)\n")

}
