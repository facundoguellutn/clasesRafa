# 🧾 Generador de Tarjetas de Contacto Profesionales

Este proyecto es un ejercicio práctico para aprender a construir una aplicación en **Next.js 14** que permite crear, visualizar y descargar tarjetas de contacto profesionales, ideal para mostrar como parte de un portfolio.

---

## 🎯 Objetivo

Crear una aplicación web donde el usuario pueda:
- Rellenar un formulario con su información personal.
- Generar una tarjeta digital accesible públicamente.
- Descargar su tarjeta como imagen PNG.

---

## ✅ Funcionalidades

- Formulario de contacto en `/new-card`.
- Visualización pública de tarjeta en `/card/[username]`.
- Guardado de datos con `localStorage`.
- Descarga de tarjeta como imagen con `html2canvas`.

---

## 🧰 Tecnologías utilizadas

- **Next.js 14 (App Router)**
- **React**
- **Tailwind CSS**
- **Shadcn UI**
- **html2canvas**

---

## 🧠 Consignas del ejercicio

### Parte 1: Formulario en `/new-card`

- Crear un formulario con los siguientes campos:
  - Nombre de usuario (único, será parte de la URL)
  - Nombre completo
  - Título profesional
  - Descripción breve
  - Imagen de perfil (URL)
  - Redes sociales: GitHub, LinkedIn, Twitter
- Guardar la información en `localStorage`.
- Redirigir a la ruta `/card/[username]` al enviarlo.

### Parte 2: Visualización de tarjeta en `/card/[username]`

- Crear una ruta dinámica que recupere los datos del `localStorage`.
- Mostrar la información en una tarjeta estilizada.
- Agregar un botón para descargar la tarjeta como imagen PNG.

---

## ▶️ Cómo usarlo en desarrollo

1. Cloná el repositorio:

```bash
git clone https://github.com/tu-usuario/tu-repo.git
cd tu-repo
```

2. Instalá las dependencias:

```bash
npm install
```

3. Instalá `html2canvas`:

```bash
npm install html2canvas
```

4. Corré el servidor de desarrollo:

```bash
npm run dev
```

---

## 💡 Código fuente (Solución)

### `app/new-card/page.tsx`

```tsx
"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";

const CardFormPage = () => {
  const router = useRouter();
  const [formData, setFormData] = useState({
    username: "",
    name: "",
    title: "",
    description: "",
    image: "",
    github: "",
    linkedin: "",
    twitter: "",
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    localStorage.setItem(`card-${formData.username}`, JSON.stringify(formData));
    router.push(`/card/${formData.username}`);
  };

  return (
    <div className="max-w-2xl mx-auto p-6">
      <h1 className="text-2xl font-bold mb-4">Crear Tarjeta de Contacto</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <Input name="username" placeholder="Nombre de usuario" onChange={handleChange} required />
        <Input name="name" placeholder="Nombre completo" onChange={handleChange} required />
        <Input name="title" placeholder="Título profesional" onChange={handleChange} />
        <Textarea name="description" placeholder="Descripción breve" onChange={handleChange} />
        <Input name="image" placeholder="URL de imagen de perfil" onChange={handleChange} />
        <Input name="github" placeholder="GitHub" onChange={handleChange} />
        <Input name="linkedin" placeholder="LinkedIn" onChange={handleChange} />
        <Input name="twitter" placeholder="Twitter" onChange={handleChange} />
        <Button type="submit">Generar tarjeta</Button>
      </form>
    </div>
  );
};

export default CardFormPage;
```

---

### `app/card/[username]/page.tsx`

```tsx
"use client";

import { notFound } from "next/navigation";
import Image from "next/image";
import html2canvas from "html2canvas";
import { useEffect, useRef, useState } from "react";
import { Button } from "@/components/ui/button";

const CardPage = ({ params }) => {
  const [data, setData] = useState(null);
  const cardRef = useRef(null);

  useEffect(() => {
    const stored = localStorage.getItem(`card-${params.username}`);
    if (stored) {
      setData(JSON.parse(stored));
    }
  }, [params.username]);

  const handleDownloadImage = async () => {
    if (cardRef.current) {
      const canvas = await html2canvas(cardRef.current);
      const link = document.createElement("a");
      link.download = `${params.username}-card.png`;
      link.href = canvas.toDataURL();
      link.click();
    }
  };

  if (!data) return notFound();

  return (
    <div className="max-w-xl mx-auto p-6 text-center">
      <div ref={cardRef} className="p-4 border rounded-xl shadow bg-white">
        {data.image && (
          <Image src={data.image} alt={data.name} width={120} height={120} className="rounded-full mx-auto mb-4" />
        )}
        <h1 className="text-2xl font-bold">{data.name}</h1>
        <p className="text-sm text-gray-600">{data.title}</p>
        <p className="mt-2 mb-4">{data.description}</p>
        <div className="flex justify-center space-x-4">
          {data.github && <a href={data.github}>GitHub</a>}
          {data.linkedin && <a href={data.linkedin}>LinkedIn</a>}
          {data.twitter && <a href={data.twitter}>Twitter</a>}
        </div>
      </div>
      <Button onClick={handleDownloadImage} className="mt-4">Descargar como imagen</Button>
    </div>
  );
};

export default CardPage;
```

---

## 🧪 Ideas para seguir mejorándolo

- Guardar tarjetas en una base de datos.
- Generar un enlace corto y público.
- Agregar temas visuales (oscuro, minimalista, etc.).
- Permitir subir imagen desde archivo.

---

## 📌 Licencia

MIT – Usalo, modificalo, y compartilo.