# Práctica 04 - Base de Datos NoSQL / Relacional: Casos de Prueba de E-Commerce

Este repositorio contiene la implementación, respaldos y documentación técnica correspondiente a la **Práctica 04** de la materia de Bases de Datos. El objetivo principal es validar el flujo transaccional, la gestión de roles, el control de inventario y la integridad referencial mediante 5 casos de prueba completos dentro de una plataforma de comercio electrónico.

---

## 📊 Documentación y Artefactos de Base de Datos

Puedes consultar el diseño estructural de la base de datos directamente en el navegador a través de los siguientes enlaces interactivos:

* 📐 **[Diagrama Entidad-Relación (ER)](https://jorgeeloygonzalezlopez.github.io/practicas_BND_240456/Practica-04/Backups/diagrama_er.html)**
* 📖 **[Diccionario de Datos](https://jorgeeloygonzalezlopez.github.io/practicas_BND_240456/Practica-04/Backups/diccionario_datos.html)**

---

## 🧪 Escenarios y Casos de Prueba Implementados

A continuación, se detallan los flujos ejecutados para comprobar la lógica de negocio y las reglas de integridad en la base de datos:

### 1. Caso de Prueba 1: "Compra Exitosa, sin modificaciones"
Flujo estándar de adquisición de productos desde el registro de un nuevo cliente hasta la entrega final.
* **Registro y Conexión:** Un nuevo usuario se registra con el rol `user_not_registered` utilizando la conexión de base de datos `AppWeb` o `AppMobile`.
* **Catálogo y Carrito:** Se verifica la disponibilidad sobre ~10,000 productos activos, se crea 1 carrito y se añaden 5 productos con cantidades variadas.
* **Orden y Logística:** Se genera la orden de compra y se vincula el domicilio de envío del cliente.
* **Pago y Roles:** Se registra una tarjeta de débito (cuenta simulada de 16 dígitos en su tabla dependiente). Al efectuar el pago único, el sistema activa el rol `buyer` para el usuario.
* **Cierre:** El sistema autoriza la transacción bancaria, marca la orden como *Atendida* y finaliza con la entrega en domicilio.

### 2. Caso de Prueba 2: "Compra con detalles en el último pago, reclamación y reenvío"
Validación de pagos diferidos, manejo de rechazos bancarios y gestión postventa (devoluciones).
* **Carrito y Orden:** Un usuario existente selecciona 10 productos aleatorios (1 a 5 unidades c/u) y genera la orden de compra.
* **Logística Alterna:** Se registra una dirección de envío distinta a su hogar (ej. *Dirección de Trabajo*).
* **Pagos Parciales:** Se registra una tarjeta de crédito (16 dígitos) configurada a 6 pagos mensuales (activando el rol `buyer`).
* **Incidencia Bancaria:** El sistema autoriza los primeros 5 pagos y rechaza el 6to bajo el motivo *"Límite excedido de crédito"*.
* **Postventa:** La orden se procesa y entrega. Posteriormente, el usuario reporta un producto dañado y el sistema gestiona la devolución y el reenvío de la unidad en buen estado.

### 3. Caso de Prueba 3: "Compra exitosa con cancelación parcial, ajuste y reembolso parcial"
Prueba de modificación de órdenes activas y recalculo financiero.
* **Carrito y Orden:** Un usuario registrado agrega 3 productos de la misma categoría (1 a 10 unidades c/u) y genera el pedido.
* **Logística y Pago:** Envío dirigido a una dirección etiquetada como *"Casa Papás"*. Se vincula una tarjeta digital (*Spin*, 16 dígitos) y se registra un pago único por el total.
* **Cancelación Parcial:** Tras marcarse la orden como *Atendida*, el cliente cancela 1 de los productos.
* **Ajuste y Entrega:** El sistema actualiza el detalle de la orden, procesa el reembolso proporcional al producto cancelado y envía el resto del pedido al domicilio.

### 4. Caso de Prueba 4: "Compra exitosa del mismo proveedor con entrega en punto de recolección"
Flujo enfocado en consolidación de proveedor y logística de última milla fallida en domicilio.
* **Carrito y Orden:** Un usuario existente selecciona 3 productos pertenecientes al mismo proveedor (1 a 3 unidades c/u) y confirma la orden.
* **Logística y Pago:** Se asigna el domicilio principal del cliente y se registra un método de pago vía transferencia *SPEI* (referencia de 16 dígitos) liquidado en una sola exhibición.
* **Entrega Alternativa:** La orden es atendida y enviada; al no encontrarse nadie en el domicilio para recibirla, el paquete es redirigido y recolectado exitosamente por el cliente en un punto de recolección.

### 5. Caso de Prueba 5: "Compra fallida por falta de inventario"
Validación de control de stock y reversión de beneficios aplicados.
* **Carrito y Orden:** Un usuario registrado añade 1 producto (1 a 5 unidades) y genera la orden de compra hacia su domicilio.
* **Método de Pago:** Se aplica un *Cupón de Regalo* como método de pago.
* **Cancelación por Stock:** Al procesar la orden, el sistema detecta insuficiencia de inventario, marca la orden como *No Atendida*, cancela la operación y reasigna/restaura el saldo del cupón utilizado al usuario.

---

## 📁 Estructura del Proyecto

```text
practicas_BND_240456/
├── Practica-04/
│   ├── Backups/
│   │   ├── diagrama_er.html          # Modelo Entidad-Relación interactivo
│   │   └── diccionario_datos.html    # Definición de tablas, atributos y restricciones
│   ├── queries/                      # Consultas y validación de casos de prueba
│   ├── scrips/                       # Scripts de creación y carga de datos
│   └── README.md                     # Documentación de la Práctica 04
└── readme.md                         # Documentación general de la asignatura