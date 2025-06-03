<?php
$conexion = new mysqli("IP_DEL_NODO2", "intranet_user", "claveSegura", "intranet");

if ($conexion->connect_error) {
    die("Error de conexión: " . $conexion->connect_error);
}

$resultado = $conexion->query("SELECT nombre, fecha FROM cumpleaños ORDER BY MONTH(fecha), DAY(fecha)");

echo "<h1>Lista de Cumpleaños</h1>";
echo "<table border='1'><tr><th>Nombre</th><th>Fecha</th></tr>";

while ($fila = $resultado->fetch_assoc()) {
    echo "<tr><td>{$fila['nombre']}</td><td>{$fila['fecha']}</td></tr>";
}

echo "</table>";
$conexion->close();
?>
