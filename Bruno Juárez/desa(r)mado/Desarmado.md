# Des-a(r)mado

## Descripción
Pieza algorítmica que emula por aleatoriedad las sonoridades del transitar de un lugar a otro para dar cuenta que dentro de lo ordinario siempre existe algo extraordinario.

---

## Requerimientos Técnicos
1. **Sistema de reproducción:** Estereofónico.
2. **Sistema Operativo:** Windows (plataforma donde se probó el código).
3. **Software:** [SuperCollider](https://supercollider.github.io/) (versión 3.13, no requiere extensiones ni *Quarks* adicionales).
4. **Archivos:** Carpeta del proyecto adjunta en este repositorio.

---

## Estructura del Proyecto
Los archivos deben mantenerse en el orden y estructura de la carpeta adjunta:

* `samples/`: Carpeta con las muestras de audio utilizadas por el código. **No requiere manipulación manual**, el script la reconoce automáticamente al ejecutarse.
* `Des-a(r)mando.scd`: Archivo maestro para la reproducción de la pieza.
* `GRAFICOS.scd`: Archivo de carga relativa dedicado exclusivamente al factor gráfico de la pieza.
* `pathi.scd`: Archivo de carga relativa para el registro de la ruta de acceso a los *samples*.
* `Pibinds.scd`: Archivo de carga relativa con los patrones (`Pbind`) requeridos para la pieza.
* `SynthDefs.scd`: Archivo de carga relativa para cargar los *synthdefs* necesarios.

---

## Instrucciones de Uso

1. Abre el archivo principal `Des-a(r)mando.scd`.
2. Ejecuta el código de SuperCollider línea por línea, de arriba hacia abajo.
3. **Nota sobre la interfaz:** Si la ventana de gráficos cubre la pantalla de SuperCollider, cambia de ventana para terminar de ejecutar el código.
4. **Automatización:** La reproducción empieza al ejecutar el código y finalizará automáticamente sin requerir intervención.

> ⚠️ **IMPORTANTE:** No muevas ni renombres la carpeta `samples/` en ningún momento. De lo contrario, el código no podrá localizar los archivos de audio y no reproducirá sonido.

---

## Créditos
**Bruno Juárez Salinas (Bru-ce)**  
*2024* — Licenciatura en Música y Tecnología Artística (MyTA)  
ENES Morelia, UNAM.