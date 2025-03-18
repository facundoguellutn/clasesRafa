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

## Gestión de Historial y Restauración

### Listar todos los cambios hechos
Para ver una lista de todos los cambios hechos en el repositorio, usa:
```bash
git log --oneline --decorate --graph --all
```

Si solo quieres ver los cambios recientes de una manera más simple:
```bash
git log --pretty=oneline
```

### Ver todos los commits
Para ver todos los commits en el historial del repositorio:
```bash
git log
```

Si deseas ver un historial más corto y en una sola línea por commit:
```bash
git log --oneline
```

### Restaurar a un commit específico
Si necesitas volver a un commit anterior, puedes usar:
```bash
git checkout <id-del-commit>
```

Para deshacer los cambios y volver a un estado anterior de manera permanente:
```bash
git reset --hard <id-del-commit>
```

Si solo quieres deshacer los cambios sin perder el historial:
```bash
git revert <id-del-commit>
```

Ten en cuenta que `git reset --hard` eliminará cualquier cambio no confirmado, así que úsalo con precaución.

## Recursos Adicionales

- [Documentación oficial de Git](https://git-scm.com/doc)
- [Documentación oficial de GitHub](https://docs.github.com/es)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Tutorial Interactivo de Git](https://learngitbranching.js.org/)
- [Tutorial Completo de Git para Principiantes](https://v0.dev/chat/git-tutorial-para-amigos-8vlirRVCRf6?b=b_rOe0cAhuRSq) - Una guía detallada y amigable para aprender Git desde cero, con ejemplos prácticos y ejercicios.

