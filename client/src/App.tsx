// client/src/App.tsx (VERSION DE AISLAMIENTO)

import Home from "./pages/Home"; // Importar solo un componente de página

function App() {
  return (
    // Solo renderizar el componente Home directamente
    <div style={{ backgroundColor: 'white', color: 'black', padding: '20px' }}>
      <Home />
    </div>
  );
}

export default App;
