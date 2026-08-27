import Foundation

//un calendario de pagos
//Ingresar el nombre del producto, precio, cantidad
let igv = 0.18
func CalcularDescuento(cantidad: Int, subtotal: Double) -> Double {
    if cantidad > 10 {
        return subtotal * 0.15
    } else if cantidad > 5 {
        return subtotal * 0.10
    }else {
        return 0.0
    }
}

print("Ingrese el nombre del producto: ")
let producto = readLine() ?? ""
print("Ingrese el precio del producto: ")
let precio = Double(readLine() ?? "0") ?? 0.0
print("Ingrese la cantidad del producto: ")
let cantidad = Int(readLine() ?? "0") ?? 0

let subtotal = precio * Double(cantidad)
let descuento = CalcularDescuento(cantidad: cantidad, subtotal: subtotal)

// Hallar el monto base : subtotal - descuento
let montoBase = subtotal - descuento

// Hallar el igv : montobase * igv
let igvCalculado = montoBase * igv

// total : montobase + igv
let total = montoBase + igvCalculado

//commit

//Mostrar los datos
print("\nBOLETA DE VENTA")
print("Producto: \(producto)")
print("Precio Unitario: S/ \(precio)")
print("Cantidad: \(cantidad)")
print("")
print("Subtotal: S/ \(subtotal)")
print("Descuento: S/ \(descuento)")
print("Monto Base: S/ \(montoBase)")
print("IGV (18%): S/ \(igvCalculado)")
print("")
print("TOTAL A PAGAR: S/ \(total)")
