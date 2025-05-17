# Evaluación 4: Validaciones, `fetch`, `try/catch` y manejo de formularios

Esta evaluación está enfocada en identificar errores comunes, completar código, entender validaciones y el flujo correcto de trabajo con peticiones `fetch`, manejo de formularios y uso de `try/catch` en React.

## Parte 1: Completar el código

1. Completa el siguiente `useEffect` para que haga una petición `GET` a `/api/user` solo una vez al montar:

```tsx
useEffect(() => {
  const fetchData = async () => {
    try {
      const res = await fetch("/api/user");
      if (!res.ok) throw new Error("Fallo la petición");
      const data = await ___________;
      setUser(data);
    } catch (error) {
      console.error("Error al cargar el usuario:", error);
    }
  };
  fetchData();
}, [__________]);
```

2. Completa la siguiente función `handleSubmit` para validar campos vacíos antes de hacer `POST`:

```tsx
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  if (!email || !password) {
    return alert("Todos los campos son obligatorios");
  }
  try {
    const res = await fetch("/api/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email, password }),
      ___________: "include"
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.message);
    // login exitoso
  } catch (error) {
    console.error(error);
  }
};
```

## Parte 2: Identificar errores o completitud

3. ¿Qué le falta o está mal en este fragmento de `fetch`?

```tsx
const res = await fetch("/api/update", {
  method: "PUT",
  body: { name: "Juan" }
});
```

4. Corrige este fragmento para que verifique si la petición fue exitosa antes de procesar el JSON:

```tsx
const res = await fetch("/api/productos");
const data = await res.json();
console.log(data);
```

5. ¿Qué problema hay en este formulario controlado?

```tsx
<input type="text" value={name} onChange={() => setName(name)} />
```

6. ¿Cuál es el problema de usar `useEffect` así?

```tsx
useEffect(async () => {
  const res = await fetch("/api/items");
}, []);
```

## Parte 3: Múltiple opción con código

7. En una petición que requiere autenticación con cookies, debes:

* A) No hacer nada, se envían automáticamente
* B) Usar `credentials: 'include'` en fetch
* C) Agregar `{ withCredentials: true }`
* D) Usar `mode: 'no-cors'`

8. Para enviar un objeto JSON correctamente con `fetch`, debes:

* A) Convertir el objeto a string con `JSON.stringify`
* B) Usar `FormData`
* C) Enviar el objeto directamente como body
* D) No es necesario definir headers

9. ¿Cuál es la razón para que este `fetch` devuelva `undefined`?

```tsx
const data = fetch("/api").then((res) => res.json());
console.log(data);
```

* A) No está usando `await`
* B) La URL está mal
* C) Falta el header
* D) El body no está en JSON

## Parte 4: Desarrollo breve

10. Escribe una función completa en React que:

* Valide que todos los campos estén completos
* Use `fetch` con `POST`
* Maneje errores con `try/catch`
* Use `credentials: 'include'`

11. Describe qué hace `res.ok` en una respuesta `fetch`.

12. ¿Cuándo se debería usar `PUT` en lugar de `POST`?

13. ¿Por qué es importante envolver fetch en `try/catch` incluso si usás `.then()` y `.catch()`?

14. Explica cómo usar `onChange` para manejar inputs controlados de forma dinámica (ej. muchos campos).

---

**Fin de la Evaluación 4**
