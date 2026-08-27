import Foundation

// ==========================================
// SISTEMA GESTOR DE PRÉSTAMO DE LIBROS
// PRIMER COMMIT
// ==========================================

// Datos del préstamo
let tituloLibro = "El Principito"
let usuario = "Juan Pérez"

let fechaPrestamo = "15/10/2026"
let fechaLimite = "17/10/2026"
let fechaDevolucion = "21/10/2026"

// Días de atraso
let diasAtraso = 4

// Multa por día
let multaPorDia = 1.50

// Cálculo de multa
let multaTotal = multaPorDia * Double(diasAtraso)

// Estado del préstamo
let estado: String

if diasAtraso > 0 {
    estado = "Devuelto con atraso"
} else {
    estado = "Devuelto"
}

// Situación del usuario
let situacion: String

if diasAtraso > 0 {
    situacion = "Usuario habilitado"
} else {
    situacion = "Usuario habilitado"
}

// ==========================================
// MOSTRAR INFORMACIÓN
// ==========================================

print("===== SISTEMA DE PRÉSTAMO DE LIBROS =====")
print("Título: \(tituloLibro)")
print("Usuario: \(usuario)")
print("Fecha de préstamo: \(fechaPrestamo)")
print("Fecha límite: \(fechaLimite)")
print("Fecha de devolución: \(fechaDevolucion)")
print("Días de atraso: \(diasAtraso)")
print("Multa por día: S/ \(multaPorDia)")
print("Multa total: S/ \(multaTotal)")
print("Estado: \(estado)")
print("Situación: \(situacion)")
