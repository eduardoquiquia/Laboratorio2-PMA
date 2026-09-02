# 🤖 Prompts utilizados – Laboratorio 02

## 🛠️ Herramienta de IA utilizada

ChatGPT

## 🛒 Ejercicio 6 – Carrito de compras mejorado

### 💬 Prompt utilizado

🤖 **Prompt:** Estoy trabajando en un archivo Playground de Swift en Xcode y necesito mejorar la lógica de un carrito de compras. El programa debe aplicar un descuento adicional del 5% cuando la cantidad de productos sea igual o mayor a 3, permitir el uso del cupón "DESCUENTO20" que otorgue un 20% de descuento adicional de manera acumulativa, y considerar envío gratuito cuando el monto supere los S/. 300.00; de lo contrario, se debe agregar un costo de envío de S/. 25.00. Cada línea del código debe incluir un comentario que explique específicamente su función dentro de la lógica del negocio, evitando comentarios genéricos. Toda la lógica debe encontrarse dentro de las validaciones correspondientes. Genera el resultado como código Swift listo para ejecutarse directamente en un Playground de Xcode. Como ejemplo, el descuento por cantidad podría calcularse mediante `let subtotal = precio * Double(cantidad) * (cantidad >= 3 ? 0.95 : 1.0)`, acompañado de un comentario que explique el cálculo realizado. 🧑‍💻

### ❓ ¿Funcionó a la primera?

⚠️ No completamente. En la primera versión se presentaron algunos problemas de sintaxis debido a que ciertos comentarios extensos quedaron separados incorrectamente en varias líneas dentro de Xcode. También fue necesario ajustar uno de los valores utilizados para calcular el descuento.

### 🧠 ¿La IA utilizó algo que no conocías?

💡 Sí. Se utilizaron operadores ternarios, que permiten elegir entre dos valores dependiendo de una condición mediante una sola expresión. Esto permitió simplificar algunas decisiones que normalmente podrían escribirse utilizando estructuras `if-else`.

---

## 🎮 Ejercicio 7 – Juego de adivinanza

### 💬 Prompt utilizado

🤖 **Prompt:** Estoy desarrollando un programa en Swift mediante un Playground de Xcode y necesito crear un pequeño juego de adivinanza de números. El programa debe utilizar como número secreto el valor 42 y simular un máximo de 5 intentos mediante diferentes variables, por ejemplo `intento1 = 20`. Es obligatorio utilizar un ciclo `while` para controlar los intentos y, después de cada uno, mostrar un mensaje indicando si el número ingresado es "Muy alto", "Muy bajo" o "¡Correcto!". También se debe llevar un contador de los intentos realizados y finalizar el juego cuando se encuentre el número correcto o se alcance el límite establecido. El código debe ser continuo, sencillo de ejecutar en Xcode y no debe utilizar bloques `do {}`. Como referencia, se puede utilizar una condición como `if intentoActual == numeroSecreto` para comprobar si el intento coincide con el número buscado. 🎯