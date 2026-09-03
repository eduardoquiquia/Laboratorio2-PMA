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

while !salir {
    print("\n===== MENÚ PRINCIPAL =====")
    print("1. Solicitar préstamo de libro")
    print("2. Registrar devolución de libro")
    print("3. Rastrear estado de préstamo por código de usuario")
    print("4. Salir")
    print("Seleccione una opción (1-4):")

    if let opcion = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
        
        switch opcion {
        case "1":
            if tienePrestamoActivo {
                print("\nError: Ya existe un préstamo activo en el sistema. Debe registrar su devolución antes de solicitar otro.")
                break
            }
            
            print("\n--- REGISTRO DE PRÉSTAMO ---")
            
            // --- CÓDIGO DE USUARIO ---
            codigoUsuario = ""
            while codigoUsuario.isEmpty {
                print("Ingrese el código del usuario:")
                if let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !entrada.isEmpty {
                    codigoUsuario = entrada
                } else {
                    print("Error: El código de usuario no puede estar vacío.")
                }
            }
            
            // --- TIPO DE USUARIO ---
            diasPermitidos = 0
            while diasPermitidos == 0 {
                print("\nIngrese tipo de usuario (Alumno / Docente / Administrador):")
                if let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    let tipo = entrada.lowercased()
                    if tipo == "alumno" {
                        tipoUsuario = "Alumno"
                        diasPermitidos = 7
                        multaBase = 5.50
                    } else if tipo == "docente" {
                        tipoUsuario = "Docente"
                        diasPermitidos = 15
                        multaBase = 2.00
                    } else if tipo == "administrador" {
                        tipoUsuario = "Administrador"
                        diasPermitidos = 10
                        multaBase = 3.00
                    } else {
                        print("Error: Tipo de usuario no válido.")
                    }
                }
            }
            
            // --- SELECCIÓN DE LIBRO ---
            tituloLibro = ""
            while tituloLibro.isEmpty {
                print("\n--- LIBROS DISPONIBLES ---")
                for (i, libro) in librosDisponibles.enumerated() {
                    print("\(i + 1). \(libro)")
                }
                print("Seleccione el libro (Escriba el nombre o número):")
                
                if let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if let numero = Int(entrada), numero >= 1 && numero <= librosDisponibles.count {
                        tituloLibro = librosDisponibles[numero - 1]
                    } else {
                        for libro in librosDisponibles {
                            if libro.lowercased() == entrada.lowercased() {
                                tituloLibro = libro
                                break
                            }
                        }
                    }
                }
                if tituloLibro.isEmpty {
                    print("Error: El libro no existe en la lista de disponibles.")
                }
            }
            
            // --- DÍAS SOLICITADOS ---
            diasSolicitados = 0
            while diasSolicitados == 0 {
                print("\nIngrese cantidad de días solicitados (Máximo \(diasPermitidos) para \(tipoUsuario)):")
                if let entrada = readLine(), let numDias = Int(entrada) {
                    if numDias <= 0 {
                        print("Error: La cantidad de días debe ser mayor a 0.")
                    } else if numDias > diasPermitidos {
                        print("Error: Un \(tipoUsuario) solo puede solicitar préstamos por un máximo de \(diasPermitidos) días.")
                    } else {
                        diasSolicitados = numDias
                    }
                } else {
                    print("Error: Ingrese un número entero válido.")
                }
            }
            
            // --- FECHA DE PRÉSTAMO Y CÁLCULO DE FECHA LÍMITE ---
            fechaPrestamo = ""
            while fechaPrestamo.isEmpty {
                print("\nIngrese fecha de préstamo (dd/mm/aaaa):")
                if let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if esFechaPrestamoValida(entrada) {
                        fechaPrestamo = entrada
                        
                        if let fechaObj = obtenerFecha(desde: entrada),
                           let limiteObj = Calendar.current.date(byAdding: .day, value: diasSolicitados, to: fechaObj) {
                            fechaLimite = formatearFecha(limiteObj)
                        }
                    } else {
                        print("Error: La fecha de préstamo no es válida o es anterior a la fecha actual.")
                    }
                }
            }
            
            fechaDevolucion = "Pendiente"
            diasAtraso = 0
            multaTotal = 0.0
            estado = "En préstamo (Activo)"
            tienePrestamoActivo = true
            hayRegistros = true
            print("\n¡Préstamo registrado exitosamente para el usuario '\(codigoUsuario)'!")
            print("Fecha límite para la devolución: \(fechaLimite)")

        case "2":
            if !tienePrestamoActivo {
                print("\nError: No hay ningún préstamo activo pendiente de devolución en el sistema.")
                break
            }
            
            print("\n--- DEVOLUCIÓN DE LIBRO ---")
            print("Ingrese el código del usuario para rastrear y procesar la devolución:")
            
            if let codigoIngresado = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if codigoIngresado.lowercased() != codigoUsuario.lowercased() {
                    print("\nError: No se encontró un préstamo activo para el código '\(codigoIngresado)'.")
                    break
                }
            }
            
            // --- FECHA DE DEVOLUCIÓN ---
            fechaDevolucion = ""
            while fechaDevolucion.isEmpty {
                print("Ingrese la fecha real de devolución (dd/mm/aaaa):")
                if let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if esFechaDevolucionValida(entrada, fechaPrestamoString: fechaPrestamo) {
                        fechaDevolucion = entrada
                    } else {
                        print("Error: La fecha de devolución debe ser igual o posterior a la fecha del préstamo (\(fechaPrestamo)).")
                    }
                }
            }
            
            // --- CÁLCULO AUTOMÁTICO DE DÍAS DE ATRASO ---
            if let fLimite = obtenerFecha(desde: fechaLimite),
               let fDevolucion = obtenerFecha(desde: fechaDevolucion) {
                
                let componentes = Calendar.current.dateComponents([.day], from: fLimite, to: fDevolucion)
                let diferenciaDias = componentes.day ?? 0
                diasAtraso = max(0, diferenciaDias)
            }
            
            // --- CÁLCULO DE MULTAS ---
            multaTotal = 0.0
            if diasAtraso > 0 {
                for dia in 1...diasAtraso {
                    var multaDia = multaBase
                    
                    if dia >= 4 && dia <= 6 {
                        multaDia = multaBase * 1.50
                    } else if dia >= 7 {
                        multaDia = multaBase * 2.00
                    }
                    multaTotal += multaDia
                }
                estado = "Devuelto con atraso"
            } else {
                estado = "Devuelto a tiempo"
            }
            
            // Inhabilitación si acumula 10 o más días de atraso
            if diasAtraso >= 10 {
                usuarioInhabilitado = true
            }
            
            tienePrestamoActivo = false
            
            print("\n===== RESUMEN DE LA DEVOLUCIÓN =====")
            print("Código de Usuario: \(codigoUsuario)")
            print("Libro devuelto: '\(tituloLibro)'")
            print("Fecha límite acordada: \(fechaLimite)")
            print("Fecha de devolución: \(fechaDevolucion)")
            print("Días de retraso acumulados: \(diasAtraso)")
            print(String(format: "Multa total a pagar: S/ %.2f", multaTotal))
            print("Situación del usuario: \(usuarioInhabilitado ? "INHABILITADO POR EXCESO DE ATRASO" : "HABILITADO")")

        case "3":
            if !hayRegistros {
                print("\nNo existen préstamos registrados en el sistema.")
            } else {
                print("\n--- RASTREAR ESTADO DE PRÉSTAMO ---")
                print("Ingrese el código del usuario a consultar:")
                
                if let codigoBuscado = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    if codigoBuscado.lowercased() == codigoUsuario.lowercased() {
                        let situacionUsuario = usuarioInhabilitado 
                            ? "INHABILITADO (Cuenta con 10 o más días de atraso acumulados)"
                            : "HABILITADO (Sin sanciones activas)"
                        
                        print("\n===== INFORMACIÓN DETALLADA DEL PRÉSTAMO =====")
                        print("Código de Usuario: \(codigoUsuario)")
                        print("Tipo de usuario: \(tipoUsuario)")
                        print("Libro: \(tituloLibro)")
                        print("Fecha de Préstamo: \(fechaPrestamo)")
                        print("Fecha Límite Pactada: \(fechaLimite)")
                        print("Fecha de Devolución: \(fechaDevolucion)")
                        print("Días Solicitados: \(diasSolicitados)")
                        print("Días de Atraso: \(diasAtraso)")
                        print(String(format: "Multa Calculada: S/ %.2f", multaTotal))
                        print("Estado del Préstamo: \(estado)")
                        print("Situación del Usuario: \(situacionUsuario)")
                    } else {
                        print("\nError: No existen préstamos asociados al código de usuario '\(codigoBuscado)'.")
                    }
                }
            }

        case "4":
            print("\nSaliendo del sistema...")
            salir = true

        default:
            print("\nError: Opción no válida. Ingrese un número del 1 al 4.")
        }
    }
}