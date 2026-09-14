import { useEffect, useState } from 'react'
import './App.css'

function App() {
  const [healthStatus , setHealthStatus] = useState("checking...");

  useEffect(() => {
    fetch("http://localhost:8080/health")
      .then((response) => response.json())
      .then((data) => setHealthStatus(data.status))
      .catch((error) => {
        console.error("Error fetching health status:", error);
        setHealthStatus("error");
      });
  }, []);

  return (
    <>
      <h1>Rekindle</h1>
      <p>Health Status: {healthStatus}</p>
    </>
  )
}

export default App
