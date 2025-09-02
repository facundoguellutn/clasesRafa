# Ejercicio 2: Análisis de Escenarios de Despliegue

## 🎯 Objetivo

Aplicar los conceptos de la clase para analizar diferentes escenarios de proyectos y tomar una decisión informada sobre qué arquitectura de base de datos es la más adecuada. Deberás justificar tu elección basándote en criterios técnicos y de negocio.

---

## 📖 Instrucciones

Para cada uno de los siguientes tres escenarios, elegí la opción de base de datos que consideres más apropiada entre:

*   **SQLite (local)**
*   **PostgreSQL (auto-alojado o gestionado)**
*   **Turso**

Luego, escribí una justificación detallada para tu elección, considerando los siguientes cuatro criterios:

1.  **Costo y Mantenimiento**: ¿Cuál es el costo total de propiedad (dinero y tiempo)? ¿Quién se encarga del mantenimiento?
2.  **Escalabilidad**: ¿Qué pasa si la aplicación crece de 100 a 100,000 usuarios?
3.  **Concurrencia y Performance**: ¿Cómo maneja la carga de múltiples usuarios? ¿Qué tan rápida necesita ser la respuesta?
4.  **Complejidad de Desarrollo**: ¿Qué tan fácil es para un desarrollador o un equipo pequeño empezar y trabajar con ella?

---

## 🏋️‍♀️ Escenarios

### Escenario 1: Aplicación de Notas Personales

*   **Descripción**: Una aplicación de escritorio (para Windows y macOS) que permite a los usuarios tomar notas en formato markdown. Las notas se guardan localmente en la computadora del usuario. Ocasionalmente, la aplicación podría sincronizar las notas con un servicio en la nube como backup, pero el 99% del uso es offline.
*   **Usuarios**: 1 (el dueño de la computadora).
*   **Requisito Clave**: Debe funcionar sin conexión a internet y ser muy rápida al iniciar.

**Tu Elección:**

```markdown
**Base de Datos Recomendada:**

**Justificación:**

1.  **Costo y Mantenimiento:**

2.  **Escalabilidad:**

3.  **Concurrencia y Performance:**

4.  **Complejidad de Desarrollo:**
```

### Escenario 2: Dashboard de Logística en Tiempo Real

*   **Descripción**: Una empresa de logística necesita un dashboard web interno para rastrear su flota de 500 camiones en tiempo real. La base de datos recibe miles de actualizaciones de ubicación por minuto. El dashboard debe mostrar la posición actual y el historial de rutas. La disponibilidad y la precisión son críticas.
*   **Usuarios**: ~20 operadores de logística, consultando datos constantemente.
*   **Requisito Clave**: Alta capacidad de escritura (ingesta de datos) y consultas complejas para análisis de rutas. Debe ser extremadamente confiable.

**Tu Elección:**

```markdown
**Base de Datos Recomendada:**

**Justificación:**

1.  **Costo y Mantenimiento:**

2.  **Escalabilidad:**

3.  **Concurrencia y Performance:**

4.  **Complejidad de Desarrollo:**
```

### Escenario 3: Herramienta Interna de Gestión de Vacaciones

*   **Descripción**: Una startup de 100 empleados necesita una herramienta web simple para que los empleados soliciten vacaciones y los gerentes las aprueben. El uso es esporádico (picos a fin de año, pero bajo el resto del tiempo).
*   **Usuarios**: 100 empleados, con no más de 5-10 usándola simultáneamente.
*   **Requisito Clave**: Debe ser barata, muy fácil de desarrollar y mantener por un equipo pequeño sin un DevOps dedicado.

**Tu Elección:**

```markdown
**Base de Datos Recomendada:**

**Justificación:**

1.  **Costo y Mantenimiento:**

2.  **Escalabilidad:**

3.  **Concurrencia y Performance:**

4.  **Complejidad de Desarrollo:**
```

---

## 💡 Soluciones Sugeridas

<details>
<summary>Click para ver las soluciones</summary>

### Escenario 1: Aplicación de Notas Personales

**Base de Datos Recomendada:** SQLite (local)

**Justificación:**

1.  **Costo y Mantenimiento:** Costo cero. El mantenimiento es inexistente, ya que la base de datos es un simple archivo que vive junto a la aplicación.
2.  **Escalabilidad:** No es un requisito. La base de datos solo necesita escalar al volumen de notas de un solo usuario, lo cual SQLite maneja sin problemas.
3.  **Concurrencia y Performance:** La concurrencia es de un solo usuario, el punto fuerte de SQLite. La performance será la más alta posible al ser una lectura de disco local sin latencia de red.
4.  **Complejidad de Desarrollo:** Es la opción más simple. No hay que gestionar conexiones, credenciales ni servidores. Es ideal para una aplicación de escritorio standalone.

### Escenario 2: Dashboard de Logística en Tiempo Real

**Base de Datos Recomendada:** PostgreSQL (Gestionado, ej: AWS RDS, o auto-alojado si hay equipo DevOps)

**Justificación:**

1.  **Costo y Mantenimiento:** El costo será significativo, pero es un requisito del negocio. Se necesita un equipo o un servicio gestionado para mantener la alta disponibilidad, lo que implica un costo operacional alto. El mantenimiento es constante y crítico.
2.  **Escalabilidad:** Es la principal fortaleza de PostgreSQL. Puede manejar un volumen masivo de escrituras y lecturas, y se puede escalar verticalmente (servidores más potentes) u horizontalmente (con replicación).
3.  **Concurrencia y Performance:** PostgreSQL está diseñado para una alta concurrencia de escritura y lectura. Sus características avanzadas de indexación y su planificador de consultas son necesarios para los análisis de rutas complejos.
4.  **Complejidad de Desarrollo:** La complejidad es alta. Requiere configurar un servidor robusto, gestionar la seguridad y optimizar el rendimiento. No es una tarea para un desarrollador junior sin supervisión.

### Escenario 3: Herramienta Interna de Gestión de Vacaciones

**Base de Datos Recomendada:** Turso

**Justificación:**

1.  **Costo y Mantenimiento:** El costo inicial es cero gracias al generoso plan gratuito, que probablemente sea suficiente para los 100 empleados. El mantenimiento es nulo, lo cual es perfecto para un equipo pequeño sin DevOps.
2.  **Escalabilidad:** Aunque el uso es bajo, si la empresa crece a 500 empleados, Turso escala automáticamente sin necesidad de intervención.
3.  **Concurrencia y Performance:** Maneja sin problemas la concurrencia de 5-10 usuarios. La performance en el Edge, aunque no es crítica aquí, asegura que la aplicación se sienta rápida para todos los empleados, estén donde estén.
4.  **Complejidad de Desarrollo:** Es extremadamente simple. El equipo de desarrollo puede usar la misma sintaxis de SQLite que ya conoce, obtener una URL de conexión y empezar a trabajar en minutos. Es la forma más rápida de llevar la aplicación a producción.

</details>
