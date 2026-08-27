import Foundation

//ingreso de datos y el calculo de monto compra
print("Nombre del producto: ")
let producto = readLine() ?? ""

print("Precio unitario: ")
let precio = Double(readLine() ?? "0") ?? 0.0

print("Cantidad: ")
let cantidad = Int(readLine() ?? "0") ?? 0

let montoCompra = precio * Double(cantidad)
print("Monto total de compra: S/ \(montoCompra)")
print("---------------------------------------")

//plan de pagos, porcentajes y calculos
print("Elija el Plan de Pagos (6, 12, 24): ")
let mesesPlan = Int(readLine() ?? "0") ?? 0

var porcentajeInteres = 0.0

if mesesPlan == 6 {
    porcentajeInteres = 0.20
} else if mesesPlan == 12 {
    porcentajeInteres = 0.40
} else if mesesPlan == 24 {
    porcentajeInteres = 0.60
} else {
    print("Plan no valido. Se aplicará 0% de interes por defecto.")
}

let interesTotal = montoCompra * porcentajeInteres
let montoFinal = montoCompra + interesTotal
let cuotaMensual = montoFinal / Double(mesesPlan)


//plan de pago parte 1 cabecera
print("\n=============================================")
print("                Plan de Pago                 ")
print("=============================================")
print("Producto: \(producto) | Interes: S/ \(interesTotal) | CuotaM: S/ \(cuotaMensual)")
print("Monto Compra: S/ \(montoCompra) | Monto Final: S/ \(montoFinal)")
print("=============================================\n")

print("Mes | Monto Inicial | Cuota Mensual | Resta x Pagos")
print("---------------------------------------------------")

var saldoActual = montoFinal

//plan de pago parte 2 tabla
if mesesPlan > 0 {
    for mes in 1...mesesPlan {
        let montoInicialMes = saldoActual
        let restaPorPagos = montoInicialMes - cuotaMensual
        
        print("\(mes).    \(montoInicialMes)          \(cuotaMensual)           \(restaPorPagos)")
        
        saldoActual = restaPorPagos
    }
} else {
    print("No hay meses para generar una tabla de pagos.")
}
