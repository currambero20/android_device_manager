// client/src/App.tsx (VERSION DE AISLAMIENTO DE PROVEEDORES)

import Home from "./pages/Home"; // Solo importar Home

function App() {
  return (
    // Renderizar Home directamente, sin ningún proveedor
    <Home /> 
  );
}

export default App;
