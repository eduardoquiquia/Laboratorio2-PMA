import Foundation

// ==========================================================
// SISTEMA GESTOR DE PRÉSTAMO DE LIBROS
// ==========================================================

// ==========================================================
// 1. FUNCIONES PARA TRABAJAR CON FECHAS
// ==========================================================

// Convierte un texto dd/MM/yyyy en una fecha
func obtenerFecha(desde texto: String) -> Date? {
    
    // Primero verificamos que tenga exactamente 10 caracteres
    // y que las posiciones 2 y 5 sean "/"
    if texto.count != 10 {
        return nil
    }
    
    let caracteres = Array(texto)
    
    if caracteres[2] != "/" || caracteres[5] != "/" {
        return nil
    }
    
    // Verificamos que el resto sean números
    for i in 0..<10 {
        if i != 2 && i != 5 {
            if !caracteres[i].isNumber {
                return nil
            }
        }
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.isLenient = false
    
    return formatter.date(from: texto)
}


// Convierte una fecha a dd/MM/yyyy
func formatearFecha(_ fecha: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")
    formatter.calendar = Calendar(identifier: .gregorian)
    
    return formatter.string(from: fecha)
}


// Valida que la fecha de préstamo sea hoy o una fecha futura
func esFechaPrestamoValida(_ texto: String) -> Bool {
    
    guard let fechaIngresada = obtenerFecha(desde: texto) else {
        return false
    }
    
    let calendario = Calendar.current
    
    let hoy = calendario.startOfDay(for: Date())
    let fecha = calendario.startOfDay(for: fechaIngresada)
    
    return fecha >= hoy
}


// Valida que la devolución sea igual o posterior al préstamo
func esFechaDevolucionValida(
    _ textoDevolucion: String,
    fechaPrestamo: String
) -> Bool {
    
    guard let fechaDevolucion = obtenerFecha(desde: textoDevolucion),
          let fechaPrestamo = obtenerFecha(desde: fechaPrestamo) else {
        return false
    }
    
    let calendario = Calendar.current
    
    let devolucion = calendario.startOfDay(for: fechaDevolucion)
    let prestamo = calendario.startOfDay(for: fechaPrestamo)
    
    return devolucion >= prestamo
}


// ==========================================================
// 2. CATÁLOGO DE LIBROS
// ==========================================================

let librosDisponibles = [
    "El Principito",
    "Cien años de soledad",
    "Don Quijote de la Mancha",
    "1984",
    "La ciudad y los perros"
]


// ==========================================================
// 3. VARIABLES DEL PRÉSTAMO
// ==========================================================

var codigoUsuario = ""
var tipoUsuario = ""
var tituloLibro = ""

var fechaPrestamo = ""
var fechaLimite = ""
var fechaDevolucion = "Pendiente"

var diasPermitidos = 0
var diasSolicitados = 0
var diasAtraso = 0

var multaBase = 0.0
var multaTotal = 0.0

var estadoPrestamo = "Sin registro"

var tienePrestamoActivo = false
var hayRegistro = false

// Indica si el usuario está suspendido
var usuarioSuspendido = false

var salir = false


// ==========================================================
// 4. MENÚ PRINCIPAL
// ==========================================================

while !salir {
    
    print("")
    print("==========================================")
    print("       SISTEMA GESTOR DE PRÉSTAMOS")
    print("==========================================")
    print("1. Solicitar préstamo de libro")
    print("2. Registrar devolución de libro")
    print("3. Rastrear estado por código de usuario")
    print("4. Salir")
    print("==========================================")
    print("Seleccione una opción (1-4):")
    
    let opcion = readLine()?.trimmingCharacters(
        in: .whitespacesAndNewlines
    ) ?? ""
    
    
    // ======================================================
    // OPCIÓN 1: SOLICITAR PRÉSTAMO
    // ======================================================
    
    if opcion == "1" {
        
        print("")
        print("==========================================")
        print("          SOLICITAR PRÉSTAMO")
        print("==========================================")
        
        
        // --------------------------------------------------
        // Verificar si ya existe un préstamo activo
        // --------------------------------------------------
        
        if tienePrestamoActivo {
            
            print("Error: Ya existe un préstamo activo.")
            print("Debe registrar la devolución antes de solicitar otro.")
            
        } else {
            
            
            // --------------------------------------------------
            // CÓDIGO DE USUARIO
            // --------------------------------------------------
            
            codigoUsuario = ""
            
            while codigoUsuario.isEmpty {
                
                print("Ingrese el código del usuario:")
                
                let entrada = readLine()?.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""
                
                if entrada.isEmpty {
                    print("Error: El código de usuario no puede estar vacío.")
                } else {
                    codigoUsuario = entrada
                }
            }
            
            
            // --------------------------------------------------
            // TIPO DE USUARIO
            // --------------------------------------------------
            
            tipoUsuario = ""
            diasPermitidos = 0
            multaBase = 0.0
            
            while tipoUsuario.isEmpty {
                
                print("")
                print("Tipos de usuario disponibles:")
                print("- Alumno")
                print("- Docente")
                print("- Administrador")
                print("- Coordinador")
                print("")
                print("Ingrese el tipo de usuario:")
                
                let entrada = readLine()?.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).lowercased() ?? ""
                
                
                if entrada == "alumno" {
                    
                    tipoUsuario = "Alumno"
                    diasPermitidos = 7
                    multaBase = 5.50
                    
                } else if entrada == "docente" ||
                          entrada == "profesor" {
                    
                    tipoUsuario = "Docente / Profesor"
                    diasPermitidos = 15
                    multaBase = 2.00
                    
                } else if entrada == "administrador" ||
                          entrada == "administrativo" {
                    
                    tipoUsuario = "Administrador / Administrativo"
                    diasPermitidos = 10
                    multaBase = 3.00
                    
                } else if entrada == "coordinador" {
                    
                    tipoUsuario = "Coordinador"
                    diasPermitidos = 15
                    multaBase = 4.00
                    
                } else {
                    
                    print("Error: Tipo de usuario no válido.")
                }
            }
            
            
            // --------------------------------------------------
            // VERIFICAR SUSPENSIÓN
            // --------------------------------------------------
            
            if usuarioSuspendido {
                
                print("")
                print("==========================================")
                print("USUARIO SUSPENDIDO")
                print("==========================================")
                
                if tipoUsuario == "Coordinador" {
                    
                    print("Usuario suspendido: alcanzó más de 20 días de atraso.")
                    
                } else {
                    
                    print("Usuario suspendido: alcanzó 10 días de atraso y no puede realizar nuevos préstamos.")
                }
                
                print("No se puede registrar el préstamo.")
                
            } else {
                
                
                // --------------------------------------------------
                // SELECCIÓN DEL LIBRO
                // --------------------------------------------------
                
                tituloLibro = ""
                
                while tituloLibro.isEmpty {
                    
                    print("")
                    print("------------------------------------------")
                    print("LIBROS DISPONIBLES")
                    print("------------------------------------------")
                    
                    for i in 0..<librosDisponibles.count {
                        print("\(i + 1). \(librosDisponibles[i])")
                    }
                    
                    print("")
                    print("Seleccione el libro escribiendo su número o nombre:")
                    
                    let entrada = readLine()?.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ) ?? ""
                    
                    
                    // Selección mediante número
                    if let numero = Int(entrada) {
                        
                        if numero >= 1 &&
                           numero <= librosDisponibles.count {
                            
                            tituloLibro = librosDisponibles[numero - 1]
                            
                        } else {
                            
                            print("Error: El número de libro no existe.")
                        }
                        
                    } else {
                        
                        // Selección mediante nombre
                        for libro in librosDisponibles {
                            
                            if libro.lowercased() == entrada.lowercased() {
                                
                                tituloLibro = libro
                                break
                            }
                        }
                        
                        if tituloLibro.isEmpty {
                            print("Error: El libro no existe en la lista.")
                        }
                    }
                }
                
                
                // --------------------------------------------------
                // DÍAS SOLICITADOS
                // --------------------------------------------------
                
                diasSolicitados = 0
                
                while diasSolicitados == 0 {
                    
                    print("")
                    print("Ingrese cantidad de días solicitados.")
                    print("Máximo permitido para \(tipoUsuario): \(diasPermitidos) días")
                    
                    let entrada = readLine() ?? ""
                    
                    if let cantidad = Int(entrada) {
                        
                        if cantidad <= 0 {
                            
                            print("Error: La cantidad de días debe ser mayor que cero.")
                            
                        } else if cantidad > diasPermitidos {
                            
                            print("Error: Un \(tipoUsuario) solo puede solicitar préstamos por un máximo de \(diasPermitidos) días.")
                            
                        } else {
                            
                            diasSolicitados = cantidad
                        }
                        
                    } else {
                        
                        print("Error: Ingrese un número entero válido.")
                    }
                }
                
                
                // --------------------------------------------------
                // FECHA DE PRÉSTAMO
                // --------------------------------------------------
                
                fechaPrestamo = ""
                
                while fechaPrestamo.isEmpty {
                    
                    print("")
                    print("Ingrese la fecha de préstamo (dd/MM/yyyy):")
                    
                    let entrada = readLine()?.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ) ?? ""
                    
                    if esFechaPrestamoValida(entrada) {
                        
                        fechaPrestamo = entrada
                        
                        // Calcular fecha límite automáticamente
                        if let fecha = obtenerFecha(desde: entrada) {
                            
                            if let limite = Calendar.current.date(
                                byAdding: .day,
                                value: diasSolicitados,
                                to: fecha
                            ) {
                                
                                fechaLimite = formatearFecha(limite)
                            }
                        }
                        
                    } else {
                        
                        print("Error: La fecha debe tener el formato dd/MM/yyyy.")
                        print("Además, debe ser igual o posterior a la fecha actual.")
                    }
                }
                
                
                // --------------------------------------------------
                // REGISTRAR PRÉSTAMO
                // --------------------------------------------------
                
                fechaDevolucion = "Pendiente"
                diasAtraso = 0
                multaTotal = 0.0
                
                estadoPrestamo = "En préstamo"
                
                tienePrestamoActivo = true
                hayRegistro = true
                
                
                print("")
                print("==========================================")
                print("¡PRÉSTAMO REGISTRADO EXITOSAMENTE!")
                print("==========================================")
                print("Código de Usuario: \(codigoUsuario)")
                print("Libro: \(tituloLibro)")
                print("Fecha de préstamo: \(fechaPrestamo)")
                print("Fecha límite: \(fechaLimite)")
                print("==========================================")
            }
        }
        
        
    // ======================================================
    // OPCIÓN 2: REGISTRAR DEVOLUCIÓN
    // ======================================================
        
    } else if opcion == "2" {
        
        print("")
        print("==========================================")
        print("       REGISTRAR DEVOLUCIÓN")
        print("==========================================")
        
        
        if !tienePrestamoActivo {
            
            print("Error: No existe un préstamo activo.")
            
        } else {
            
            print("Ingrese el código del usuario:")
            
            let codigoIngresado = readLine()?.trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""
            
            
            // Verificar código
            if codigoIngresado.lowercased() != codigoUsuario.lowercased() {
                
                print("")
                print("Error: El código ingresado no coincide con el préstamo registrado.")
                
            } else {
                
                
                // --------------------------------------------------
                // FECHA DE DEVOLUCIÓN
                // --------------------------------------------------
                
                fechaDevolucion = ""
                
                while fechaDevolucion.isEmpty {
                    
                    print("")
                    print("Ingrese la fecha real de devolución (dd/MM/yyyy):")
                    
                    let entrada = readLine()?.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ) ?? ""
                    
                    
                    if esFechaDevolucionValida(
                        entrada,
                        fechaPrestamo: fechaPrestamo
                    ) {
                        
                        fechaDevolucion = entrada
                        
                    } else {
                        
                        print("Error: La fecha de devolución no es válida.")
                        print("Debe ser igual o posterior a \(fechaPrestamo).")
                    }
                }
                
                
                // --------------------------------------------------
                // CALCULAR DÍAS DE ATRASO
                // --------------------------------------------------
                
                diasAtraso = 0
                
                if let limite = obtenerFecha(desde: fechaLimite),
                   let devolucion = obtenerFecha(desde: fechaDevolucion) {
                    
                    let componentes = Calendar.current.dateComponents(
                        [.day],
                        from: limite,
                        to: devolucion
                    )
                    
                    let diferencia = componentes.day ?? 0
                    
                    if diferencia > 0 {
                        diasAtraso = diferencia
                    } else {
                        diasAtraso = 0
                    }
                }
                
                
                // --------------------------------------------------
                // CALCULAR MULTA DÍA POR DÍA
                // --------------------------------------------------
                
                multaTotal = 0.0
                
                print("")
                print("==========================================")
                print("        DESGLOSE DE MULTA")
                print("==========================================")
                
                
                if diasAtraso == 0 {
                    
                    print("No existen días de atraso.")
                    print("Multa: S/ 0.00")
                    
                } else {
                    
                    for dia in 1...diasAtraso {
                        
                        var multaDia = 0.0
                        
                        
                        // ==========================================
                        // REGLAS PARA COORDINADOR
                        // ==========================================
                        
                        if tipoUsuario == "Coordinador" {
                            
                            if dia >= 1 && dia <= 3 {
                                
                                multaDia = 0.00
                                
                            } else if dia >= 4 && dia <= 6 {
                                
                                // S/ 4 + 25% = S/ 5
                                multaDia = multaBase * 1.25
                                
                            } else if dia >= 7 && dia <= 10 {
                                
                                // S/ 4 + 50% = S/ 6
                                multaDia = multaBase * 1.50
                                
                            } else if dia >= 11 && dia <= 20 {
                                
                                // S/ 4 + 100% = S/ 8
                                multaDia = multaBase * 2.00
                                
                            } else {
                                
                                // Día 21 en adelante
                                multaDia = 0.00
                            }
                            
                            
                        // ==========================================
                        // REGLAS PARA ALUMNO, DOCENTE Y ADMINISTRADOR
                        // ==========================================
                            
                        } else {
                            
                            if dia >= 1 && dia <= 3 {
                                
                                // Multa base
                                multaDia = multaBase
                                
                            } else if dia >= 4 && dia <= 6 {
                                
                                // Multa base + 50%
                                multaDia = multaBase * 1.50
                                
                            } else {
                                
                                // Día 7 en adelante
                                // Multa base + 100%
                                multaDia = multaBase * 2.00
                            }
                        }
                        
                        
                        multaTotal += multaDia
                        
                        print(
                            String(
                                format: "Día %2d de atraso: S/ %.2f",
                                dia,
                                multaDia
                            )
                        )
                    }
                }
                
                
                // --------------------------------------------------
                // DETERMINAR ESTADO DEL PRÉSTAMO
                // --------------------------------------------------
                
                if diasAtraso == 0 {
                    
                    estadoPrestamo = "Devuelto"
                    
                } else {
                    
                    estadoPrestamo = "Devuelto con atraso"
                }
                
                
                // --------------------------------------------------
                // DETERMINAR SUSPENSIÓN
                // --------------------------------------------------
                
                if tipoUsuario == "Coordinador" {
                    
                    if diasAtraso >= 21 {
                        
                        usuarioSuspendido = true
                    }
                    
                } else {
                    
                    if diasAtraso >= 10 {
                        
                        usuarioSuspendido = true
                    }
                }
                
                
                // Ya no existe préstamo activo
                tienePrestamoActivo = false
                
                
                // --------------------------------------------------
                // MOSTRAR RESUMEN
                // --------------------------------------------------
                
                print("")
                print("==========================================")
                print("       RESUMEN DE PRÉSTAMO")
                print("==========================================")
                print("Código de Usuario: \(codigoUsuario)")
                print("Tipo de usuario: \(tipoUsuario)")
                print("Título del libro: \(tituloLibro)")
                print("Fecha de préstamo: \(fechaPrestamo)")
                print("Fecha límite pactada: \(fechaLimite)")
                print("Fecha de devolución: \(fechaDevolucion)")
                print("Días permitidos: \(diasPermitidos)")
                print("Días solicitados: \(diasSolicitados)")
                print("Días de atraso: \(diasAtraso)")
                print(
                    String(
                        format: "Multa base: S/ %.2f",
                        multaBase
                    )
                )
                print(
                    String(
                        format: "Multa total: S/ %.2f",
                        multaTotal
                    )
                )
                print("Estado del préstamo: \(estadoPrestamo)")
                
                
                if usuarioSuspendido {
                    
                    if tipoUsuario == "Coordinador" {
                        
                        print(
                            "Situación del usuario: Suspendido"
                        )
                        print(
                            "Usuario suspendido: alcanzó más de 20 días de atraso."
                        )
                        
                    } else {
                        
                        print(
                            "Situación del usuario: Suspendido"
                        )
                        print(
                            "Usuario suspendido: alcanzó 10 días de atraso y no puede realizar nuevos préstamos."
                        )
                    }
                    
                } else {
                    
                    print("Situación del usuario: Habilitado")
                }
                
                print("==========================================")
            }
        }
        
        
    // ======================================================
    // OPCIÓN 3: RASTREAR PRÉSTAMO
    // ======================================================
        
    } else if opcion == "3" {
        
        print("")
        print("==========================================")
        print("      RASTREAR PRÉSTAMO POR CÓDIGO")
        print("==========================================")
        
        
        if !hayRegistro {
            
            print("No existen préstamos registrados.")
            
        } else {
            
            print("Ingrese el código del usuario:")
            
            let codigoBuscado = readLine()?.trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""
            
            
            if codigoBuscado.lowercased() != codigoUsuario.lowercased() {
                
                print("")
                print(
                    "Error: No existe un préstamo asociado al código '\(codigoBuscado)'."
                )
                
            } else {
                
                
                // --------------------------------------------------
                // MOSTRAR SITUACIÓN DEL USUARIO
                // --------------------------------------------------
                
                var situacionUsuario = ""
                
                if usuarioSuspendido {
                    situacionUsuario = "Suspendido"
                } else {
                    situacionUsuario = "Habilitado"
                }
                
                
                // --------------------------------------------------
                // MOSTRAR RESUMEN COMPLETO
                // --------------------------------------------------
                
                print("")
                print("==========================================")
                print("       RESUMEN DE PRÉSTAMO")
                print("==========================================")
                print("Código de Usuario: \(codigoUsuario)")
                print("Tipo de usuario: \(tipoUsuario)")
                print("Título del libro: \(tituloLibro)")
                print("Fecha de préstamo: \(fechaPrestamo)")
                print("Fecha límite pactada: \(fechaLimite)")
                print("Fecha de devolución: \(fechaDevolucion)")
                print("Días permitidos: \(diasPermitidos)")
                print("Días solicitados: \(diasSolicitados)")
                print("Días de atraso: \(diasAtraso)")
                
                print(
                    String(
                        format: "Multa base: S/ %.2f",
                        multaBase
                    )
                )
                
                print(
                    String(
                        format: "Multa total: S/ %.2f",
                        multaTotal
                    )
                )
                
                print("Estado del préstamo: \(estadoPrestamo)")
                print("Situación del usuario: \(situacionUsuario)")
                print("==========================================")
                
                
                // Si está suspendido mostramos el motivo
                if usuarioSuspendido {
                    
                    if tipoUsuario == "Coordinador" {
                        
                        print(
                            "Usuario suspendido: alcanzó más de 20 días de atraso."
                        )
                        
                    } else {
                        
                        print(
                            "Usuario suspendido: alcanzó 10 días de atraso y no puede realizar nuevos préstamos."
                        )
                    }
                }
            }
        }
        
        
    // ======================================================
    // OPCIÓN 4: SALIR
    // ======================================================
        
    } else if opcion == "4" {
        
        print("")
        print("==========================================")
        print("Saliendo del sistema...")
        print("¡Gracias por utilizar el sistema!")
        print("==========================================")
        
        salir = true
        
        
    // ======================================================
    // OPCIÓN NO VÁLIDA
    // ======================================================
        
    } else {
        
        print("")
        print("Error: Opción no válida.")
        print("Ingrese un número del 1 al 4.")
    }
}