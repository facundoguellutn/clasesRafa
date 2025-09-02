# Ejercicio 3: "Pitch" de Arquitectura de Base de Datos

## 🎯 Objetivo

Traducir el conocimiento técnico sobre bases de datos en una justificación de negocio. Este ejercicio te entrena para comunicar decisiones de arquitectura a stakeholders no técnicos (como un gerente de producto, un cliente o un jefe).

---

## 📖 Escenario

Sos el desarrollador principal de la **"App de Estadísticas de Volley"**, un proyecto personal que tiene potencial para crecer. Tu Gerente de Producto (que no sabe de tecnología) te ha pedido que elijas la tecnología de base de datos y le presentes una recomendación formal.

**Características del Proyecto:**
*   **MVP Inicial**: Perfiles de jugadores, carga de estadísticas de partidos.
*   **Visión a Futuro**: Una red social para jugadores de volley amateur, con seguidores, comentarios, y potencialmente usuarios en todo el mundo.
*   **Equipo**: Sos vos solo al principio, con un presupuesto muy limitado.
*   **Tecnología**: Querés usar Next.js para el frontend y backend.

---

## 🏋️‍♀️ Tu Tarea

Escribí un "pitch" o propuesta en formato Markdown. Tu audiencia es tu gerente, así que evitá la jerga técnica excesiva y centrate en los beneficios, costos y riesgos desde una perspectiva de negocio.

Tu propuesta debe tener las siguientes secciones:

1.  **Recomendación Principal**: Indicá claramente qué base de datos elegiste (SQLite, PostgreSQL o Turso).
2.  **Resumen Ejecutivo (El Porqué en 30 segundos)**: Un párrafo corto que resuma las razones principales de tu elección en términos de negocio (velocidad, costo, futuro).
3.  **Beneficios Clave**: Una lista de 3-4 puntos explicando las ventajas de tu elección para este proyecto en particular.
4.  **Alternativas Consideradas**: Mencioná brevemente las otras dos opciones y explicá por qué no son la mejor opción *en este momento*.
5.  **Costos y Recursos**: Describí los costos esperados (en dinero y tiempo de desarrollo) para empezar y para el futuro.
6.  **Riesgos y Plan de Mitigación**: Identificá un riesgo potencial de tu elección y cómo planeas manejarlo.

---

### Formato de la Propuesta

```markdown
# Propuesta de Arquitectura de Base de Datos: App de Volley

**Para:** Gerente de Producto
**De:** [Tu Nombre], Desarrollador Principal
**Fecha:** [Fecha de Hoy]

## 1. Recomendación Principal

[Tu elección aquí]

## 2. Resumen Ejecutivo

[Tu resumen aquí]

## 3. Beneficios Clave

*   **Beneficio 1:** [Explicación]
*   **Beneficio 2:** [Explicación]
*   **Beneficio 3:** [Explicación]

## 4. Alternativas Consideradas

*   **Alternativa 1 (ej: PostgreSQL):** [Por qué no es ideal ahora]
*   **Alternativa 2 (ej: SQLite):** [Por qué no es ideal ahora]

## 5. Costos y Recursos

[Tu análisis de costos aquí]

## 6. Riesgos y Plan de Mitigación

[Tu análisis de riesgos aquí]

```

---

## 💡 Ejemplo de Solución (Pitch para Turso)

<details>
<summary>Click para ver la solución</summary>

# Propuesta de Arquitectura de Base de Datos: App de Volley

**Para:** Gerente de Producto
**De:** Rafa, Desarrollador Principal
**Fecha:** 02/09/2025

## 1. Recomendación Principal

Mi recomendación es utilizar **Turso** como nuestra base de datos principal.

## 2. Resumen Ejecutivo

Turso nos permite lanzar la aplicación de forma extremadamente rápida y barata, sin sacrificar la capacidad de crecer en el futuro. Nos da la simplicidad de una base de datos pequeña pero con el poder de una solución global, asegurando que la app sea veloz para todos los usuarios desde el día uno, sin importar dónde estén.

## 3. Beneficios Clave

*   **Velocidad de Lanzamiento (Time-to-Market):** Podemos tener la base de datos funcionando en minutos, no días. Esto nos permite centrarnos en construir las funcionalidades que los usuarios quieren, en lugar de perder tiempo en configuración de servidores.

*   **Costo Cero para Empezar:** Turso tiene un plan gratuito muy generoso que cubrirá todas nuestras necesidades para el lanzamiento inicial y los primeros meses de crecimiento. No invertimos dinero hasta que la aplicación demuestre ser exitosa.

*   **Experiencia de Usuario Superior:** La aplicación se sentirá increíblemente rápida para nuestros usuarios, ya sea que estén en Argentina, España o Japón. Esto es clave para que la gente se enganche y siga usando la app.

*   **Escalabilidad sin Esfuerzo:** Si la aplicación se vuelve viral, Turso manejará el aumento de usuarios automáticamente. No tendremos que preocuparnos por caídas del sistema o por migraciones de emergencia.

## 4. Alternativas Consideradas

*   **PostgreSQL:** Es una base de datos muy potente, pero excesiva para nuestras necesidades actuales. Sería como usar un motor de camión para un karting. Implicaría mayores costos y una complejidad de mantenimiento que nos ralentizaría mucho al principio.

*   **SQLite (local):** Es perfecto para empezar a programar, pero no sirve para una aplicación web a la que accederán múltiples usuarios. No nos permitiría lanzar la aplicación al público.

## 5. Costos y Recursos

*   **Costo Monetario Inicial:** $0. El plan gratuito de Turso es suficiente.
*   **Costo de Tiempo de Desarrollo:** Mínimo. La configuración es casi instantánea. Esto nos ahorra semanas de trabajo de un especialista en infraestructura.
*   **Costo a Futuro:** Predecible. Si superamos el plan gratuito, los costos de los planes de pago son claros y escalan con nuestro éxito.

## 6. Riesgos y Plan de Mitigación

*   **Riesgo:** Turso es una tecnología relativamente nueva en comparación con gigantes como PostgreSQL.
*   **Plan de Mitigación:** El riesgo es bajo porque Turso se basa en SQLite, un estándar universal. Si en el futuro tuviéramos algún problema con Turso, podemos exportar nuestros datos fácilmente y migrarlos a otra solución sin tener que reescribir la aplicación.

</details>
