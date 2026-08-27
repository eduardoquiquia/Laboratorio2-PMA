import Foundation

// ==========================================
// SISTEMA GESTOR DE PRÉSTAMO DE LIBROS
// VERSIÓN INTERACTIVA - SWIFT PLAYGROUND
// ==========================================

// ==========================================
// FUNCIONES PARA VALIDAR DATOS
// ==========================================

// Pedir un texto que no esté vacío
func pedirTexto(_ mensaje: String) -> String {
    while true {
        print(mensaje, terminator: " ")
        
        guard let respuesta = readLine() else {
            print("")
            print("No se pudo recibir la entrada.")
            print("Verifique que esté ejecutando el Playground con la consola habilitada.")
            exit(0)
        }
        
        let texto = respuesta.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !texto.isEmpty {
            return texto
        }
        
        print("Error: debe ingresar un valor válido.")
    }
}

// Convertir texto a una fecha
func convertirFecha(_ texto: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")
    formatter.isLenient = false
    
    return formatter.date(from: texto)
}

// Mostrar una fecha con formato dd/MM/yyyy
func mostrarFecha(_ fecha: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")
    
    return formatter.string(from: fecha)
}

// Pedir una fecha válida
func pedirFecha(_ mensaje: String) -> Date {
    while true {
        print(mensaje, terminator: " ")
        
        if let entrada = readLine(),
           let fecha = convertirFecha(entrada) {
            return fecha
        }
        
        print("Error: ingrese una fecha válida con el formato dd/MM/yyyy.")
    }
}

// ==========================================
// LISTA DE LIBROS DISPONIBLES
// ==========================================

let libros = [
    "El Principito",
    "Cien años de soledad",
    "Don Quijote de la Mancha",
    "1984",
    "La ciudad y los perros",
    "Harry Potter y la piedra filosofal",
    "El Hobbit",
    "Crónica de una muerte anunciada",
    "Orgullo y prejuicio",
    "Romeo y Julieta",
    "La Odisea",
    "La Ilíada",
    "Fahrenheit 451",
    "Drácula",
    "Frankenstein",
    "El nombre del viento",
    "Los juegos del hambre",
    "El código Da Vinci",
    "Matar a un ruiseñor",
    "Rayuela"
]

// ==========================================
// INICIO DEL PROGRAMA
// ==========================================

print("==========================================")
print("   SISTEMA GESTOR DE PRÉSTAMO DE LIBROS")
print("==========================================")
print("")

// ==========================================
// INGRESO DEL NOMBRE DEL USUARIO
// ==========================================

let usuario = pedirTexto("Ingrese el nombre del usuario:")

// ==========================================
// SELECCIÓN DEL TIPO DE USUARIO
// ==========================================

let tipoUsuario: String

while true {
    print("")
    print("===== TIPO DE USUARIO =====")
    print("1. Alumno")
    print("2. Docente")
    print("3. Administrador")
    print("Seleccione una opción:", terminator: " ")
    
    let opcion = readLine()
    
    if opcion == "1" {
        tipoUsuario = "Alumno"
        break
    } else if opcion == "2" {
        tipoUsuario = "Docente"
        break
    } else if opcion == "3" {
        tipoUsuario = "Administrador"
        break
    } else {
        print("Error: opción inválida. Seleccione 1, 2 o 3.")
    }
}

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
} else {
    diasPermitidos = 10
    multaBase = 3.00
}

// ==========================================
// SELECCIÓN DEL LIBRO
// ==========================================

var tituloLibro = ""

while tituloLibro.isEmpty {
    
    print("")
    print("===== LIBROS DISPONIBLES =====")
    
    for indice in 0..<libros.count {
        print("\(indice + 1). \(libros[indice])")
    }
    
    print("")
    print("Seleccione el número del libro:", terminator: " ")
    
    if let entrada = readLine(),
       let opcionLibro = Int(entrada),
       opcionLibro >= 1,
       opcionLibro <= libros.count {
        
        tituloLibro = libros[opcionLibro - 1]
        
    } else {
        print("Error: el libro seleccionado no existe.")
    }
}

// ==========================================
// INGRESO DE LA FECHA DE PRÉSTAMO
// ==========================================

let fechaPrestamo: Date

while true {
    
    let fecha = pedirFecha(
        "Ingrese la fecha de préstamo (dd/MM/yyyy):"
    )
    
    let fechaIngresada = Calendar.current.startOfDay(for: fecha)
    let fechaActual = Calendar.current.startOfDay(for: Date())
    
    if fechaIngresada <= fechaActual {
        fechaPrestamo = fecha
        break
    } else {
        print("Error: la fecha de préstamo no puede ser posterior a la fecha actual.")
    }
}

// ==========================================
// INGRESO DE LOS DÍAS DEL PRÉSTAMO
// ==========================================

let diasSolicitados: Int

while true {
    
    print("")
    print("===== DÍAS DEL PRÉSTAMO =====")
    print("Tipo de usuario: \(tipoUsuario)")
    print("Máximo permitido: \(diasPermitidos) días")
    print("")
    print("¿Cuántos días desea tener el libro?", terminator: " ")
    
    if let entrada = readLine(),
       let dias = Int(entrada) {
        
        if dias <= 0 {
            
            print("Error: debe solicitar como mínimo 1 día.")
            
        } else if dias > diasPermitidos {
            
            print(
                "Error: un \(tipoUsuario) solo puede solicitar " +
                "préstamos por un máximo de \(diasPermitidos) días."
            )
            
        } else {
            
            diasSolicitados = dias
            break
        }
        
    } else {
        print("Error: debe ingresar un número entero válido.")
    }
}

// ==========================================
// CÁLCULO DE LA FECHA LÍMITE
// ==========================================

let fechaLimite = Calendar.current.date(
    byAdding: .day,
    value: diasSolicitados,
    to: fechaPrestamo
)!

// ==========================================
// CONSULTAR SI EL LIBRO FUE DEVUELTO
// ==========================================

var libroDevuelto = false

while true {
    
    print("")
    print("===== DEVOLUCIÓN DEL LIBRO =====")
    print("¿El libro ya fue devuelto?")
    print("1. Sí")
    print("2. No")
    print("Seleccione una opción:", terminator: " ")
    
    let opcion = readLine()
    
    if opcion == "1" {
        
        libroDevuelto = true
        break
        
    } else if opcion == "2" {
        
        libroDevuelto = false
        break
        
    } else {
        
        print("Error: opción inválida. Seleccione 1 o 2.")
    }
}

// ==========================================
// FECHA DE DEVOLUCIÓN
// ==========================================

var fechaDevolucion: Date? = nil

if libroDevuelto {
    
    while true {
        
        let fecha = pedirFecha(
            "Ingrese la fecha de devolución (dd/MM/yyyy):"
        )
        
        let fechaPrestamoDia = Calendar.current.startOfDay(
            for: fechaPrestamo
        )
        
        let fechaDevolucionDia = Calendar.current.startOfDay(
            for: fecha
        )
        
        if fechaDevolucionDia < fechaPrestamoDia {
            
            print(
                "Error: la fecha de devolución no puede ser " +
                "anterior a la fecha de préstamo."
            )
            
        } else {
            
            fechaDevolucion = fecha
            break
        }
    }
}

// ==========================================
// FECHA UTILIZADA PARA CALCULAR EL ATRASO
// ==========================================

let fechaActual = Calendar.current.startOfDay(for: Date())

let fechaParaCalcularAtraso: Date

if let fechaDevolucion = fechaDevolucion {
    
    fechaParaCalcularAtraso = Calendar.current.startOfDay(
        for: fechaDevolucion
    )
    
} else {
    
    fechaParaCalcularAtraso = fechaActual
}

// ==========================================
// CÁLCULO DE DÍAS DE ATRASO
// ==========================================

var diasAtraso = 0

if fechaParaCalcularAtraso > fechaLimite {
    
    let diferencia = Calendar.current.dateComponents(
        [.day],
        from: fechaLimite,
        to: fechaParaCalcularAtraso
    )
    
    diasAtraso = diferencia.day ?? 0
}

// ==========================================
// CÁLCULO DE MULTA PROGRESIVA
// ==========================================

var multaTotal = 0.0

if diasAtraso > 0 {
    
    print("")
    print("===== DETALLE DE MULTA =====")
    
    for dia in 1...diasAtraso {
        
        var multaDia = multaBase
        
        // Día 1 al 3: multa normal
        if dia >= 1 && dia <= 3 {
            multaDia = multaBase
        }
        
        // Día 4 al 6: 50% adicional
        if dia >= 4 && dia <= 6 {
            multaDia = multaBase * 1.50
        }
        
        // Día 7 en adelante: 100% adicional
        if dia >= 7 {
            multaDia = multaBase * 2.00
        }
        
        multaTotal += multaDia
        
        let fechaDiaAtraso = Calendar.current.date(
            byAdding: .day,
            value: dia,
            to: fechaLimite
        )!
        
        print(
            "Día \(dia) - \(mostrarFecha(fechaDiaAtraso)) - " +
            "Multa: S/ \(String(format: "%.2f", multaDia)) - " +
            "Acumulado: S/ \(String(format: "%.2f", multaTotal))"
        )
    }
}

// ==========================================
// ESTADO DEL PRÉSTAMO
// ==========================================

let estado: String

if libroDevuelto {
    
    if diasAtraso > 0 {
        estado = "Devuelto con atraso"
    } else {
        estado = "Devuelto"
    }
    
} else {
    
    if diasAtraso > 0 {
        estado = "Atrasado"
    } else {
        estado = "En préstamo"
    }
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
// FECHA DE DEVOLUCIÓN PARA MOSTRAR
// ==========================================

let fechaDevolucionTexto: String

if let fechaDevolucion = fechaDevolucion {
    
    fechaDevolucionTexto = mostrarFecha(fechaDevolucion)
    
} else {
    
    fechaDevolucionTexto = "No devuelto"
}

// ==========================================
// INFORMACIÓN FINAL
// ==========================================

print("")
print("==========================================")
print("===== SISTEMA DE PRÉSTAMO DE LIBROS =====")
print("==========================================")
print("Título: \(tituloLibro)")
print("Usuario: \(usuario)")
print("Tipo de usuario: \(tipoUsuario)")
print("Fecha de préstamo: \(mostrarFecha(fechaPrestamo))")
print("Fecha límite: \(mostrarFecha(fechaLimite))")
print("Fecha de devolución: \(fechaDevolucionTexto)")
print("Días permitidos: \(diasPermitidos)")
print("Días solicitados: \(diasSolicitados)")
print("Días de atraso: \(diasAtraso)")
print("Multa base: S/ \(String(format: "%.2f", multaBase))")
print("Multa total: S/ \(String(format: "%.2f", multaTotal))")
print("Estado: \(estado)")
print("Situación del usuario: \(situacion)")

// ==========================================
// MENSAJE DE SUSPENSIÓN
// ==========================================

if diasAtraso >= 10 {
    
    print("")
    print(
        "Usuario suspendido: alcanzó 10 días de atraso " +
        "y no puede realizar nuevos préstamos."
    )
    
} else {
    
    print("")
    print("Usuario habilitado.")
}

print("==========================================")

