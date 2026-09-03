import Foundation

// ==========================================
// SISTEMA GESTOR DE PRÉSTAMO DE LIBROS
// TERCER COMMIT (SISTEMA COMPLETO Y RASTREO)
// ==========================================

// Convierte un String en Date (dd/MM/yyyy)
func obtenerFecha(desde texto: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.isLenient = false
    return formatter.date(from: texto)
}

// Convierte un Date en String (dd/MM/yyyy)
func formatearFecha(_ fecha: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: fecha)
}

// Valida fecha de préstamo (formato correcto y no anterior a hoy)
func esFechaPrestamoValida(_ fechaString: String) -> Bool {
    let calendario = Calendar.current
    let hoyInicio = calendario.startOfDay(for: Date())
    
    guard let fechaIngresada = obtenerFecha(desde: fechaString) else { return false }
    let fechaIngresadaInicio = calendario.startOfDay(for: fechaIngresada)
    
    return fechaIngresadaInicio >= hoyInicio
}

// Valida fecha de devolución (formato correcto y no anterior al préstamo)
func esFechaDevolucionValida(_ fechaDevolucionString: String, fechaPrestamoString: String) -> Bool {
    let calendario = Calendar.current
    
    guard let fechaDev = obtenerFecha(desde: fechaDevolucionString),
          let fechaPres = obtenerFecha(desde: fechaPrestamoString) else { return false }
    
    let devInicio = calendario.startOfDay(for: fechaDev)
    let presInicio = calendario.startOfDay(for: fechaPres)
    
    return devInicio >= presInicio
}

// Catálogo de libros
let librosDisponibles = [
    "El Principito",
    "Cien años de soledad",
    "Don Quijote de la Mancha",
    "1984",
    "La ciudad y los perros"
]

// Variables de estado del sistema
var codigoUsuario = ""
var tipoUsuario = ""
var tituloLibro = ""
var fechaPrestamo = ""
var fechaDevolucion = "Pendiente"
var fechaLimite = ""
var diasPermitidos = 0
var diasSolicitados = 0
var diasAtraso = 0
var multaBase = 0.0
var multaTotal = 0.0
var estado = "Sin registro"
var tienePrestamoActivo = false
var usuarioInhabilitado = false
var hayRegistros = false

var salir = false

