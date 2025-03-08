# Tutorial de Git y GitHub

## ¿Qué es Git?

Git es un sistema de control de versiones distribuido, creado por Linus Torvalds en 2005. Fue desarrollado inicialmente para gestionar el desarrollo del kernel de Linux. Git permite:

- Mantener un historial completo de cambios en el código
- Trabajar en paralelo con otros desarrolladores
- Revertir cambios a versiones anteriores
- Gestionar diferentes versiones del código

## ¿Qué es GitHub?

GitHub es una plataforma web que proporciona alojamiento para repositorios Git. Fue fundada en 2008 y adquirida por Microsoft en 2018. GitHub añade una capa social y de colaboración sobre Git, permitiendo:

- Alojar repositorios en la nube
- Colaborar con otros desarrolladores
- Gestionar proyectos
- Realizar seguimiento de problemas (issues)
- Revisar código mediante pull requests

## ¿Por qué fueron inventados?

### Git
- Fue creado para resolver problemas de gestión de código en proyectos grandes
- Permitir trabajo distribuido y paralelo
- Mantener la integridad del código
- Facilitar la colaboración entre desarrolladores

### GitHub
- Hacer Git más accesible
- Crear una plataforma social para desarrolladores
- Facilitar la colaboración en proyectos de código abierto
- Proporcionar herramientas adicionales para la gestión de proyectos

## Comandos básicos de Git

### Configuración inicial
```bash
# Configurar nombre de usuario
git config --global user.name "Tu Nombre"

# Configurar email
git config --global user.email "tu@email.com"
```

### Crear y gestionar repositorios
```bash
# Inicializar un repositorio nuevo
git init

# Clonar un repositorio existente
git clone <url-del-repositorio>
```

### Gestión de cambios
```bash
# Ver estado de archivos
git status

# Añadir archivos al área de preparación
git add <archivo>
git add .  # Añadir todos los archivos

# Confirmar cambios (commit)
git commit -m "Mensaje descriptivo del cambio"

# Ver historial de commits
git log
```

### Trabajar con ramas
```bash
# Crear una nueva rama
git branch <nombre-rama>

# Cambiar a una rama
git checkout <nombre-rama>

# Crear y cambiar a una nueva rama en un solo comando
git checkout -b <nombre-rama>

# Ver lista de ramas
git branch

# Fusionar ramas
git merge <nombre-rama>
```

### Sincronización con repositorio remoto
```bash
# Añadir repositorio remoto
git remote add origin <url-repositorio>

# Subir cambios
git push origin <nombre-rama>

# Obtener cambios
git pull origin <nombre-rama>
```

## Flujo de trabajo básico con Git y GitHub

1. **Crear un repositorio en GitHub**
   - Ir a GitHub.com
   - Hacer clic en "New repository"
   - Configurar nombre y opciones
   - Crear el repositorio

2. **Clonar el repositorio**
   ```bash
   git clone <url-del-repositorio>
   ```

3. **Hacer cambios**
   ```bash
   # Editar archivos
   git add .
   git commit -m "Descripción de cambios"
   git push origin main
   ```

4. **Trabajar con ramas**
   ```bash
   # Crear rama para nueva funcionalidad
   git checkout -b nueva-funcionalidad
   
   # Hacer cambios y commits
   git add .
   git commit -m "Nueva funcionalidad"
   
   # Subir rama a GitHub
   git push origin nueva-funcionalidad
   ```

5. **Crear Pull Request**
   - Ir al repositorio en GitHub
   - Hacer clic en "Pull requests"
   - Crear nuevo Pull Request
   - Seleccionar ramas
   - Describir cambios
   - Solicitar revisión

## Mejores prácticas

1. **Commits**
   - Hacer commits frecuentes y pequeños
   - Escribir mensajes descriptivos
   - Usar verbos en imperativo

2. **Ramas**
   - Mantener main/master limpia y estable
   - Crear ramas para nuevas funcionalidades
   - Eliminar ramas después de fusionar

3. **Pull Requests**
   - Describir claramente los cambios
   - Incluir contexto necesario
   - Solicitar revisiones apropiadas

## Recursos adicionales

- [Documentación oficial de Git](https://git-scm.com/doc)
- [Guías de GitHub](https://guides.github.com/)
- [GitHub Learning Lab](https://lab.github.com/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf) 