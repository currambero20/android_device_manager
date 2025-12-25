// ... (resto de las importaciones y funciones)

// 1. Definir la URL de la API usando la variable de entorno de Vite
//    Usamos import.meta.env.VITE_API_URL, que Vercel inyecta.
//    El fallback es la ruta relativa, pero el uso de la variable de entorno es más seguro.
const API_URL = import.meta.env.VITE_API_URL || "/api/trpc";

const trpcClient = trpc.createClient({
  links: [
    httpBatchLink({
      url: API_URL, // <--- CORRECCIÓN: Usar la variable de entorno
      transformer: superjson,
      fetch(input, init ) {
        return globalThis.fetch(input, {
          ...(init ?? {}),
          credentials: "include",
        });
      },
    }),
  ],
});

createRoot(document.getElementById("root")!).render(
// ... (resto del código)

