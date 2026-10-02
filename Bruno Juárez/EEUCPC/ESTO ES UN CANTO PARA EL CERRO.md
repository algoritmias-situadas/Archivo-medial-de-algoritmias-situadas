# Esto es un canto para el cerro

## Descripción
Sistema interactivo para voz, cerro y computadora.

---

## Requerimientos Técnicos

### Para la Interpretación en Vivo
1. **Computadora:** Capaz de ejecutar SuperCollider.
2. **Interfaz de audio:** Mínimo 2 canales de entrada.
3. **Microfonía:**
   * 1 Micrófono dinámico (para la voz).
   * 1 Micrófono de condensador (para el ambiente).
4. **Monitoreo:** Bocina o sistema de monitoreo de audio (preferentemente estéreo).
5. **Cableado:** Cables de conexión según la interfaz (XLR, TRS, etc.).
6. **Software & Material:** Patch de SuperCollider, set de partituras.
7. **Registro:** Cámara de video y tripié.

### Para la Instalación
1. Una mesa.
2. Una pantalla o monitor.
3. Sistema de reproducción estereofónico.
4. El archivo de video grabado durante la interpretación.
5. Set de partituras en físico.
6. Ficha informativa.

---

## Estructura del Proyecto

* `traducción.sc`: Archivo de librería. **Debe añadirse a la librería de SuperCollider** antes de correr el código principal.
* `EstoEsUnCantoParaElCerro.scd`: Código maestro del sistema interactivo.
* `GUIZzz.scd`: Código de carga relativa dedicado a la organización de la interfaz gráfica de usuario (GUI) y la asignación de acciones para sus botones.
* `OSCesss.scd`: Código de carga relativa para la declaración y configuración del protocolo OSC en SuperCollider, necesario para el análisis de parámetros en tiempo real.
* `SYNTHDEFS.scd`: Código de carga relativa que almacena los *synthdefs* necesarios para la pieza.

---

## Instrucciones de Uso

### Modo Interpretación
1. Copia el archivo `traducción.sc` a tu carpeta de extensiones de usuario de SuperCollider (`Platform.userExtensionDir`).
2. Abre `EstoEsUnCantoParaElCerro.scd`.
3. Enciende el servidor (`s.boot`) habiendo seleccionado previamente la interfaz de audio, micrófonos y altavoces correspondientes.
4. Selecciona todo el código (`Ctrl + A` / `Cmd + A`) y ejecútalo (`Ctrl + Enter` / `Cmd + Enter`).
5. **Registro:** Se recomienda grabar la salida de audio de SuperCollider durante toda la interpretación (por ejemplo, utilizando `s.record`).
6. **Partitura:** Revisa el archivo adjunto en el repositorio con el nombre de la pieza para consultar los detalles y la estructura de interpretación por partes.

### Modo Instalación
1. Conecta la pantalla/monitor y el sistema de audio a la computadora.
2. Distribuye las partituras impresas y la ficha informativa sobre la mesa.
3. Proyecta el video grabado en bucle (*loop*) durante el tiempo que dure la exhibición.

---

## Consideraciones Contextuales
* **Interpretación:** Es preferible realizar la interpretación al aire libre en un cerro o entorno natural similar.
* **Instalación:** De ser posible, se sugiere montar la instalación en un espacio abierto o con vista hacia un relieve natural.

---

## Créditos
**Bruno Juárez Salinas (Bru-ce)**  
*2025* — Licenciatura en Música y Tecnología Artística (MyTA)  
ENES Morelia, UNAM.