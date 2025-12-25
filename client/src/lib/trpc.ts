// client/src/lib/trpc.ts

import { createTRPCReact } from '@trpc/react-query';
import type { AppRouter } from '../../../server/_core/router'; // Ajuste la ruta si es necesario

// La URL de la API debe obtenerse de la variable de entorno inyectada por Vite/Vercel
// Usamos import.meta.env.VITE_API_URL que definimos en vite.config.ts
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api';

export const trpc = createTRPCReact<AppRouter>( );

// ... (resto de la configuración del cliente TRPC)

export const trpcClient = trpc.createClient({
  links: [
    // ... (otros links)
    httpBatchLink({
      url: API_URL, // Usar la URL de la API
      // ... (otras configuraciones )
    }),
  ],
});
