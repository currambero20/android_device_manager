import { createRoot } from "react-dom/client";
import App from "./App";
import "./index.css";

// COMENTAR TEMPORALMENTE LA LÓGICA DE TRPC Y REACT QUERY
// const queryClient = new QueryClient();
// const API_URL = import.meta.env.VITE_API_URL || "/api/trpc";
// const trpcClient = trpc.createClient({ /* ... */ });

createRoot(document.getElementById("root")!).render(
  // Renderizar solo el componente App
  <App />
);
