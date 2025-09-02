# Ejercicio 3: Simulación de Operaciones y Recuperación ante Desastres

## 🎯 Objetivo

Simular escenarios de gestión de bases de datos del mundo real, incluyendo la rotación de credenciales de seguridad, la creación de backups y la destrucción controlada de recursos. Esto te prepara para las responsabilidades de un operador de base de datos.

---

## 📖 Escenario

Eres el administrador de las bases de datos de tu startup. Hoy tenés que realizar varias tareas de mantenimiento y seguridad críticas para asegurar la integridad y el buen funcionamiento de los servicios.

---

## 🏋️‍♀️ Tu Tarea

Realizá las siguientes tareas usando la CLI de Turso. Escribí el comando exacto que usarías para cada paso.

### Parte 1: Simulacro de Incidente de Seguridad

**Situación**: Un desarrollador ha dejado accidentalmente un token de autenticación expuesto en un repositorio público de GitHub para la base de datos `biblioteca-personal`.

1.  **Listá todos los tokens de autenticación** para la base de datos `biblioteca-personal` para identificar el token comprometido (y cualquier otro).

    ```bash
    # Tu comando aquí
    ```

2.  **Revocá (invalida) inmediatamente TODOS los tokens** existentes para esa base de datos para cortar cualquier acceso no autorizado. (Pista: Turso no tiene un comando para revocar todos a la vez, tendrías que hacerlo uno por uno por su nombre).

    ```bash
    # Tu comando para revocar un token específico por su nombre
    ```

3.  **Creá un nuevo token**, no expirante, para que la aplicación de producción pueda volver a conectarse. Nombra a este token `prod-token-v2`.

    ```bash
    # Tu comando aquí
    ```

### Parte 2: Política de Backup y Restauración

**Situación**: La política de la empresa exige que se realice un backup completo de la base de datos de la biblioteca cada día.

4.  **Creá un backup completo** (esquema y datos) de tu base de datos `biblioteca-personal`. El resultado debe guardarse en un archivo local llamado `biblioteca_backup_YYYY-MM-DD.sql` (reemplazá con la fecha actual).

    ```bash
    # Tu comando aquí
    ```

5.  **Simulá un desastre**: Creá una nueva base de datos vacía llamada `biblioteca-desastre`.

    ```bash
    # Tu comando aquí
    ```

6.  **Restaurá el backup** que creaste en el paso 4 en la nueva base de datos `biblioteca-desastre`.

    ```bash
    # Tu comando aquí
    ```

7.  **Verificá la restauración**: Conectate a la shell de `biblioteca-desastre` y contá el número de registros en la tabla `libros` para asegurarte de que los datos se restauraron.

    ```bash
    # Tu comando aquí
    ```

### Parte 3: Limpieza de Recursos

**Situación**: El test de restauración fue un éxito y la base de datos `biblioteca-desastre` ya no es necesaria.

8.  **Destruí permanentemente** la base de datos `biblioteca-desastre`. La CLI te pedirá una confirmación; tenés que escribir el nombre completo de la base de datos para confirmar.

    ```bash
    # Tu comando aquí
    ```

9.  **Desafío**: Tu base de datos `biblioteca-personal` tiene una réplica en una región que ya no necesitas. Listá las réplicas y luego destruí una de ellas (si tenés alguna además de la primaria).

    ```bash
    # Comando para listar réplicas

    # Comando para destruir una réplica específica
    ```

---

## 💡 Solución Propuesta

<details>
<summary>Click para ver la solución</summary>

```bash
# --- PARTE 1: SIMULACRO DE SEGURIDAD ---

# 1. Listar tokens
turso db tokens list biblioteca-personal

# 2. Revocar un token (reemplazar 'nombre-del-token' con el real)
turso db tokens revoke biblioteca-personal nombre-del-token

# 3. Crear nuevo token
turso db tokens create biblioteca-personal --expiration none --name prod-token-v2


# --- PARTE 2: BACKUP Y RESTAURACIÓN ---

# 4. Crear backup (reemplazar con fecha actual)
turso db shell biblioteca-personal --command ".dump" > biblioteca_backup_2024-09-02.sql

# 5. Crear nueva DB para el desastre
turso db create biblioteca-desastre

# 6. Restaurar el backup
cat biblioteca_backup_2024-09-02.sql | turso db shell biblioteca-desastre

# 7. Verificar la restauración
turso db shell biblioteca-desastre --command "SELECT COUNT(*) FROM libros;"


# --- PARTE 3: LIMPIEZA DE RECURSOS ---

# 8. Destruir la base de datos de prueba
turso db destroy biblioteca-desastre
# (La CLI pedirá confirmación interactiva)

# 9. Desafío de réplicas
# Listar las réplicas
turso db replica list biblioteca-personal

# Destruir una réplica (ej: la de Frankfurt 'fra')
turso db replica destroy biblioteca-personal fra

```

</details>
