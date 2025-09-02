# Ejercicios Clase 1 - Introducción a SQL

## 🚀 Setup Inicial
1. Abrir [sqlsandbox.com](https://sqlsandbox.com)
2. Copiar y pegar el contenido de `sqlsandbox-setup.sql`
3. Hacer click en "Run" para crear la base de datos

---

## 🏋️ Ejercicios Guiados (En Clase)

### Ejercicio 1: Primera Consulta
```sql
-- Ver todas las películas
SELECT * FROM peliculas;
```
**¿Qué esperás ver?** Una tabla con todas las películas y todos sus datos.

### Ejercicio 2: Consultas Específicas
```sql
-- Ver solo los títulos
SELECT titulo FROM peliculas;

-- Ver títulos y directores
SELECT titulo, director FROM peliculas;

-- Ver títulos y años
SELECT titulo, año FROM peliculas;
```

### Ejercicio 3: Explorar los Datos
Tratá de responder estas preguntas mirando la tabla:
1. ¿Cuántas películas hay en total?
2. ¿Cuál es la película más antigua?
3. ¿Qué director aparece más veces?

---

## 🏠 Ejercicios Para Casa

### Ejercicio 4: Experimentar con SELECT
Tratá de escribir queries para:
```sql
-- 1. Ver solo los géneros
SELECT genero FROM peliculas;

-- 2. Ver solo las calificaciones
SELECT calificacion FROM peliculas;

-- 3. Ver título, año y calificación juntos
SELECT titulo, año, calificacion FROM peliculas;
```

### Ejercicio 5: Agregar Más Datos
Intentá agregar tus películas favoritas:
```sql
-- Ejemplo: agregar una nueva película
INSERT INTO peliculas (id, titulo, año, genero, calificacion, director) 
VALUES (11, 'Avengers', 2012, 'Action', 8.0, 'Joss Whedon');
```

### Ejercicio 6: Reflexión
**Escribí en un papel o documento:**
1. ¿Qué diferencias notás entre SQL y MongoDB?
2. ¿Para qué tipo de aplicación usarías SQL?
3. ¿Qué consultas te gustaría poder hacer con estos datos?

---

## ✅ Verificaciones

### ¿Funciona tu setup?
Corrí esta consulta. Deberías ver 10 películas:
```sql
SELECT COUNT(*) FROM peliculas;
```

### ¿Entendiste los conceptos?
- [ ] Sé qué es una tabla, fila y columna
- [ ] Entiendo la diferencia básica entre SQL y MongoDB  
- [ ] Puedo hacer una consulta SELECT básica
- [ ] Sé para qué sirve SQL en aplicaciones reales

---

## 🤔 Preguntas para Reflexionar

1. **Relacioná con tus proyectos**: ¿Cómo organizarías los datos de tu app de volley en SQL vs MongoDB?

2. **Pensá en consultas**: Si tuvieras una tabla de jugadores de volley, ¿qué información te gustaría poder consultar fácilmente?

3. **Estructura vs Flexibilidad**: ¿En qué situaciones preferirías la estructura fija de SQL vs la flexibilidad de MongoDB?

---

## 🎯 Próxima Clase: Sintaxis Básica
En la próxima clase vamos a aprender a:
- Filtrar datos con WHERE
- Ordenar con ORDER BY  
- Limitar resultados
- Buscar texto con LIKE

**¡Nos vemos en la clase 2!**