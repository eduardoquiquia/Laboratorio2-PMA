import Foundation

// ==========================================
// SISTEMA GESTOR DE PRÉSTAMO DE LIBROS
// SEGUNDO COMMIT
// ==========================================

// Datos del préstamo
let tituloLibro = "El Principito"
let usuario = "Juan Pérez"
let tipoUsuario = "Alumno"

let fechaPrestamo = "15/10/2026"
let fechaLimite = "17/10/2026"
let fechaDevolucion = "21/10/2026"

// Días de atraso
let diasAtraso = 4

// ==========================================
// REGLAS SEGÚN TIPO DE USUARIO
// ==========================================

let diasPermitidos: Int
let multaBase: Double

if tipoUsuario == "Alumno" {
    diasPermitidos = 7
    multaBase = 5.50
} else if tipoUsuario == "Docente" {
    diasPermitidos = 15
    multaBase = 2.00
} else if tipoUsuario == "Administrador" {
    diasPermitidos = 10
    multaBase = 3.00
} else {
    diasPermitidos = 0
    multaBase = 0.00
}

// ==========================================
// CÁLCULO DE MULTA PROGRESIVA
// ==========================================

var multaTotal = 0.0

for dia in 1...diasAtraso {
    
    var multaDia = multaBase
    
    // Del día 4 al 6: 50% adicional
    if dia >= 4 && dia <= 6 {
        multaDia = multaBase * 1.50
    }
    
    // Desde el día 7: 100% adicional
    if dia >= 7 {
        multaDia = multaBase * 2.00
    }
    
    multaTotal += multaDia
    
    print("Día \(dia) - Multa: S/ \(multaDia) - Acumulado: S/ \(multaTotal)")
}

// ==========================================
// ESTADO DEL PRÉSTAMO
// ==========================================

let estado: String

if diasAtraso > 0 {
    estado = "Devuelto con atraso"
} else {
    estado = "Devuelto"
}

// ==========================================
// SITUACIÓN DEL USUARIO
// ==========================================

let situacion: String

if diasAtraso >= 10 {
    situacion = "Usuario suspendido"
} else {
    situacion = "Usuario habilitado"
}

// ==========================================
// MOSTRAR INFORMACIÓN
// ==========================================

print("")
print("===== SISTEMA DE PRÉSTAMO DE LIBROS =====")
print("Título: \(tituloLibro)")
print("Usuario: \(usuario)")
print("Tipo de usuario: \(tipoUsuario)")
print("Fecha de préstamo: \(fechaPrestamo)")
print("Fecha límite: \(fechaLimite)")
print("Fecha de devolución: \(fechaDevolucion)")
print("Días permitidos: \(diasPermitidos)")
print("Días de atraso: \(diasAtraso)")
print("Multa base: S/ \(multaBase)")
print("Multa total: S/ \(multaTotal)")
print("Estado: \(estado)")
print("Situación : \(situacion)")
