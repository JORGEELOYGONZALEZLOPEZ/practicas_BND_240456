<div align="center">

# 🛒 Práctica 03: E-Commerce en la Nube (MySQL VPS)
### Manipulación de Datos, Relaciones, Procedimientos, Funciones y Eventos Remotos

![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![VPS](https://img.shields.io/badge/Cloud-VPS_Remote-0080FF?style=for-the-badge&logo=linux&logoColor=white)
![Archify](https://img.shields.io/badge/Docs-Archify_MERE-8A2BE2?style=for-the-badge)
![Status](https://img.shields.io/badge/Estado-Completado-2EA44F?style=for-the-badge)

**Asignatura:** Bases de Datos en la Nube | **Carrera:** Ingeniería en Tecnologías de la Información e Innovación Digital  
**Docente:** M.T.I. Marco A. Ramírez Hernández | **Periodo:** Septiembre - Diciembre 2026

[📖 Diccionario de Datos](https://jorgeeloygonzalezlopez.github.io/practicas_BND_240456/Practica-03/backups/diccionario_erp_25.html) •
[🗺️ Diagrama MERE Interactivo](https://jorgeeloygonzalezlopez.github.io/practicas_BND_240456/Practica-03/backups/diagrama_explorador.html) •
</div>

---

## 🎯 Objetivo del Proyecto

Implementar, administrar y operar de forma remota una base de datos relacional de **E-Commerce** desplegada en un **Servidor Privado Virtual (VPS)**[cite: 15]. El desarrollo integra 25 tablas normalizadas, auditoría automatizada mediante triggers y vistas de trazabilidad, control de acceso basado en roles remotos (RBAC), rutinas SQL parametrizables para población masiva de datos y documentación técnica interactiva[cite: 15, 16, 18].

---

## 🌐 Exploradores y Documentación Web

| Recurso Interactivo | Descripción | Acceso Directo |
| :--- | :--- | :---: |
| **📖 Diccionario de Datos** | Especificación completa de las 25 tablas, tipos de datos, llaves (`PK`/`FK`) y restricciones[cite: 15, 18]. | [**Abrir Web ↗**](https://jorgeeloygonzalezlopez.github.io/practicas_BND_240456/Practica-03/backups/diccionario_erp_25.html) |
| **🗺️ Diagrama y Explorador (MERE)** | Modelo Entidad-Relación Extendido con filtros por módulo, relaciones y muestras de datos[cite: 12, 15, 18]. | [**Abrir Web ↗**](https://jorgeeloygonzalezlopez.github.io/practicas_BND_240456/Practica-03/backups/diagrama_explorador.html) |
| **🏠 Portal de Respaldos** | Índice principal de versiones `.sql` progresivas y evidencias de la práctica[cite: 12, 18]. | [**Abrir Web ↗**](https://jorgeeloygonzalezlopez.github.io/practicas_BND_240456/Practica-03/backups/index.html) |

---

## 🏗️ Arquitectura e Implementación

### 1. Modelo Relacional e Integridad (25 Tablas)
* Integración de **25 tablas operativas y de auditoría** (`tb_users`, `tb_people`, `tb_products`, `tb_carts`, `tb_buyer_orders`, `tb_cancellations`, `tb_logs`, etc.)[cite: 15].
* Validación estricta de llaves primarias, foráneas, restricciones de integridad referencial y disponibilidad remota en MySQL[cite: 15].

### 2. Auditoría y Trazabilidad (`72 Triggers` + `25 Vistas`)
* **72 Triggers Automatizados:** Eventos `AFTER INSERT`, `AFTER UPDATE` y `AFTER DELETE` aplicados a las 24 tablas operativas, registrando en `tb_logs` la tabla afectada, operación, usuario remoto, fecha y detalle del cambio[cite: 15, 16].
* **25 Vistas SQL:**
  * `24 Vistas de Trazabilidad`: Cruce directo entre cada tabla operativa y `tb_logs` para auditar movimientos por usuario[cite: 16].
  * `1 Vista de Negocio`: **Productos por Categoría**, clasificando categorías, subcategorías y disponibilidad (`status`)[cite: 16].

### 3. Seguridad y Control de Acceso Remoto (RBAC)
Configuración de cuentas remotas en el VPS con roles predeterminados y privilegios granulares sobre las 24 tablas operativas[cite: 16]:

| Rol | Nivel de Acceso / Responsabilidad |
| :--- | :--- |
| `superadmin` | Control total de esquema, rutinas, auditoría y ejecución de simulaciones masivas[cite: 16, 17]. |
| `admin` | Administración operativa y gestión general del catálogo y usuarios[cite: 16]. |
| `support` | Consulta y seguimiento operativo para atención e incidencias[cite: 16]. |
| `seller` | Gestión e inserción remota de productos en inventario (`seller1`, `seller2`)[cite: 16, 17]. |
| `buyer` | Operaciones de carrito, órdenes de compra y seguimiento de envíos[cite: 15, 16]. |
| `common_user` | Navegación autenticada y gestión básica de perfil[cite: 16]. |
| `user_not_registered` | Consulta pública restringida de catálogo[cite: 16]. |

---

## ⚙️ Rutinas SQL y Simulación Masiva de Datos

> **Automatización SQL:** Desarrollo de un **Procedimiento Almacenado General Parametrizable** (con parámetros obligatorios, opcionales y comodines), apoyado por **funciones auxiliares** (generación de fechas de nacimiento, aleatoriedad controlada y distribución probabilística) y **eventos programados**[cite: 16].

### 👥 Población Masiva de Usuarios (`7,500 registros` vía `superadmin`)
Ejecución remota garantizando consistencia relacional entre `tb_users` y `tb_people`[cite: 17]:

| Escenario | Volumen | Criterios de Simulación |
| :--- | :---: | :--- |
| **Test 1** | `500` | Usuarios de género masculino originarios de Estados Unidos[cite: 17]. |
| **Test 2** | `2,000` | Usuarios de diversos países con rango de edad entre **19 y 30 años**[cite: 17]. |
| **Test 3** | `5,000` | Distribución probabilística: **80% activas (`b'1'`)** y **20% inactivas (`b'0'`)**[cite: 17]. |

### 📦 Población de Productos por Vendedores Remotos (`+7,000 registros`)
Inserción distribuida entre categorías y subcategorías (mínimo 5 productos por categoría), incluyendo artículos descontinuados (`status = b'0'`)[cite: 17]:
* **`seller1`:** `5,000` productos registrados remotamente[cite: 17].
* **`seller2`:** `2,000` productos registrados remotamente[cite: 17].

---

## 📦 Checklist de Entregables

- [x] **Base de Datos E-Commerce:** 25 tablas integradas y validadas en VPS remoto[cite: 15, 18].
- [x] **Auditoría Completa:** 72 triggers funcionales alimentando `tb_logs`[cite: 16, 18].
- [x] **Vistas SQL:** 24 vistas de trazabilidad + 1 vista de Productos por Categoría[cite: 18].
- [x] **Seguridad RBAC:** Scripts de usuarios remotos, 7 roles, privilegios y roles predeterminados[cite: 18].
- [x] **Automatización SQL:** Procedimiento general parametrizable, funciones auxiliares y eventos[cite: 18].
- [x] **Simulación de Datos:** 7,500 usuarios base (Tests 1–3) y +7,000 productos (`seller1` y `seller2`)[cite: 17, 18].
- [x] **Validación e Integridad:** Consultas SQL de auditoría, conteos y cero registros huérfanos[cite: 17, 18].
- [x] **Documentación y Versionado:** Respaldos progresivos `.sql`, MERE/Diccionario (Archify) y rama `Practica-03` fusionada a `main`[cite: 14, 18].