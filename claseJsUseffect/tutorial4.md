# Tutorial: Usando Axios en React

## ¿Qué es Axios?
Axios es una biblioteca de cliente HTTP basada en promesas que funciona tanto en el navegador como en Node.js. Es una alternativa más potente y flexible al tradicional `fetch`.

## Ventajas de Axios sobre Fetch
- Transformación automática de datos JSON
- Interceptores de solicitudes y respuestas
- Cancelación de solicitudes
- Protección automática contra XSRF
- Soporte para progreso de carga
- Mejor manejo de errores
- Timeouts incluidos
- Compatible con todos los navegadores modernos

## Instalación

Para instalar Axios en tu proyecto React, ejecuta uno de estos comandos:

```bash
npm install axios
# o
yarn add axios
```

## Uso Básico

### Importación
```javascript
import axios from 'axios';
```

### Métodos principales
```javascript
// GET request
axios.get(url)
  .then(response => console.log(response.data))
  .catch(error => console.error(error));

// POST request
axios.post(url, data)
  .then(response => console.log(response.data))
  .catch(error => console.error(error));

// PUT request
axios.put(url, data)
  .then(response => console.log(response.data))
  .catch(error => console.error(error));

// DELETE request
axios.delete(url)
  .then(response => console.log(response.data))
  .catch(error => console.error(error));
```

## Ejemplo Práctico

Aquí hay un ejemplo completo de un componente React que usa Axios para obtener y mostrar datos de una API:

```jsx
import React, { useState, useEffect } from 'react';
import axios from 'axios';

function UserList() {
  const [users, setUsers] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Crear una función async para hacer la petición
    const fetchUsers = async () => {
      try {
        const response = await axios.get('https://jsonplaceholder.typicode.com/users');
        setUsers(response.data);
        setLoading(false);
      } catch (err) {
        setError('Error al cargar los usuarios');
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  if (loading) return <div>Cargando...</div>;
  if (error) return <div>{error}</div>;

  return (
    <div>
      <h1>Lista de Usuarios</h1>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.name} - {user.email}</li>
        ))}
      </ul>
    </div>
  );
}

export default UserList;
```

## Configuración Avanzada

### Crear una instancia de Axios
```javascript
const api = axios.create({
  baseURL: 'https://api.ejemplo.com',
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer tu-token'
  }
});
```

### Interceptores
```javascript
// Interceptor de solicitud
axios.interceptors.request.use(
  config => {
    // Modificar la configuración antes de enviar la solicitud
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

// Interceptor de respuesta
axios.interceptors.response.use(
  response => {
    // Cualquier código de estado entre 2xx activará esta función
    return response;
  },
  error => {
    // Cualquier código de estado fuera del rango 2xx activará esta función
    return Promise.reject(error);
  }
);
```

## Manejo de Errores
```javascript
axios.get('/api/data')
  .then(response => {
    console.log(response.data);
  })
  .catch(error => {
    if (error.response) {
      // La solicitud fue realizada y el servidor respondió con un código de estado
      console.log(error.response.data);
      console.log(error.response.status);
      console.log(error.response.headers);
    } else if (error.request) {
      // La solicitud fue realizada pero no se recibió respuesta
      console.log(error.request);
    } else {
      // Algo sucedió al configurar la solicitud
      console.log('Error', error.message);
    }
  });
```

## Cancelación de Solicitudes
```javascript
const CancelToken = axios.CancelToken;
const source = CancelToken.source();

axios.get('/api/data', {
  cancelToken: source.token
}).catch(error => {
  if (axios.isCancel(error)) {
    console.log('Solicitud cancelada:', error.message);
  } else {
    // Manejar error
  }
});

// Cancelar la solicitud
source.cancel('Operación cancelada por el usuario.');
```

## Mejores Prácticas

1. **Centraliza las llamadas API**: Crea un archivo separado para todas tus llamadas API.
2. **Usa instancias de Axios**: Crea una instancia configurada para tu API.
3. **Maneja los errores adecuadamente**: Implementa un manejo de errores consistente.
4. **Usa interceptores cuando sea necesario**: Para modificar solicitudes/respuestas globalmente.
5. **Implementa timeouts**: Para evitar solicitudes que nunca se resuelven.

## Ejemplo de Servicio API Centralizado

```javascript
// api.js
import axios from 'axios';

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL,
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json'
  }
});

export const userService = {
  getUsers: () => api.get('/users'),
  getUserById: (id) => api.get(`/users/${id}`),
  createUser: (userData) => api.post('/users', userData),
  updateUser: (id, userData) => api.put(`/users/${id}`, userData),
  deleteUser: (id) => api.delete(`/users/${id}`)
};

export default api;
```

Este tutorial cubre los aspectos más importantes de Axios en React. Recuerda siempre consultar la [documentación oficial de Axios](https://axios-http.com/) para más detalles y actualizaciones.
