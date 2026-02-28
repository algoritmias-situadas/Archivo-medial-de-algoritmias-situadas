
<h1 style="text-align:center;">La viola autoresonante como ecosistema sonoro</h1>

<h3 style="text-align:center;">Composición algorítmica con sistemas de feedback</h3>

> *En medio del daño, no buscamos volver al pasado,  
> sino crear algo nuevo con lo que queda.  
> Como un ensamble, restaurar es componer  
> relaciones vivas con atención, cuidado y presencia.*  
> — Anna Tsing

![](https://s3.hedgedoc.org/hd1-demo/uploads/406a2c6b-62b8-4847-abbb-0e0d55e8b9d6.png)
Imagen:[ Feedback Musicianship Network](https://https://feedback-musicianship.pubpub.org/)


## Resumen

Este repositorio documenta el desarrollo de un ecosistema autorresonante diseñado para explorar prácticas musicales basadas en la interdependencia, la agencia distribuida y una relacionalidad no antropocéntrica. El núcleo del sistema es un bucle de retroalimentación electroacústica ampliado mediante procesamiento digital en tiempo real con *SuperCollider*, en dialogo con un archivo oral expandido. Inspirado en trabajos de Agostino Di Scipio, Scott McLaughlin, Adam Pultz Melbye y Alvin Lucier.
Aunque este proyecto surge del trabajo con una viola y un archivo oral *(S@nar)* específicos, el código está diseñado para ser adaptable a otros instrumentos acústicos, superficies resonantes y materiales sonoros. No es una obra cerrada, sino una invitación a experimentar con sistemas de feedback desde tu propio contexto material y conceptual.

---
## Tabla de contenidos

- [Estructura del repositorio](#estructura-del-repositorio)
- [Requisitos técnicos](#requisitos-técnicos)
- [Instalación](#instalación)
- [Guía de inicio rápido](#guía-de-inicio-rápido)
- [Arquitectura del sistema](#arquitectura-del-sistema)
- [Mapeo MIDI](#mapeo-midi-korg-nanokontrol2)
- [Nota ética ](#nota-ética)
- [Documentación completa](#documentación-completa)
- [Contacto y colaboración](#contacto-y-colaboración)
- [Licencia](#licencia)


## Estructura del repositorio

### Patches
```1_SF_GUI.scd``` - Interfaz principal (feedback)
```2_TESTIS_GUI.scd``` - Sampler granular (testimonios)
```3_MANOS_LIBRES_ROUTINE.scd``` -  Rutina autónoma
```4_FB_SYNTHDEFS.scd``` - Definiciones de síntesis
```ias.scd``` - Rutina IASI (inspirada en A. Lucier)

> **💡 Importante**: Antes de ejecutar, edita las rutas absolutas en `main.scd` para que apunten a tus propios directorios de audio y patches.

## Requisitos técnicos

### Hardware (recomendado)

| Componente | Especificaciones | Notas |
|------------|------------------|-------|
| Instrumento acústico | Viola, violín, caja, mesa, etc. | Cualquier superficie resonante |
| Pastilla piezoeléctrica | Ej. Adeline AD-35 | O micrófono de contacto |
| Transductor vibrátil | Dayton DAEX25FHE-4 (24W, 4Ω) | Otros transductores compatibles |
| Interfaz de audio | Mín. 1 entrada / 1 salida | Ej. Zoom H4n Pro |
| Amplificador | Clase D (opcional) | Ej. PAM8610 12V |
| Altavoces | --- | Opcional |
| Controlador MIDI | Korg NanoKontrol2 | Opcional, mapeo incluido |

**Nota**: El sistema puede funcionar en **modo simulado** (micrófono + altavoz), útil para pruebas y desarrollo.

### Software

- **SuperCollider** ≥ 3.12 ([descargar](https://supercollider.github.io/))
- **Sistema operativo**: macOS, Linux o Windows
- **UGen externo**: `AnalogPhaser` (instalable vía Quarks → `sc3-plugins`)

---

## Instalación

### 1. Instalar SuperCollider
Descarga e instala desde [supercollider.github.io](https://supercollider.github.io/)

### 2. Instalar sc3-plugins
```supercollider
// En SuperCollider, ejecuta:
Quarks.install("sc3-plugins");
Server.default.reboot;
```

### 3. Preparar archivos de audio (opcional)
Si deseas usar el sampler granular, coloca tus archivos `.wav` o `.aiff` en las carpetas `voices/1. Intro/`, `voices/2. barbecho/`, etc.

---

## Guía de inicio rápido

### Configuración de hardware

1. **Instala el piezo**: debajo del diapasón, en el cordal, o dentro del cuerpo (por las efes)
2. **Adhiere el transductor**: en la espalda del instrumento, ligeramente debajo del puente
3. **Conecta**:
   - Piezo → entrada 
   - Transductor → salida (opcional, via amplificador)
   - Altavoces → opcional, para refuerzo multicanal)

### Diagrama de conexiones (sugeridas)

![](https://s3.hedgedoc.org/hd1-demo/uploads/d075f1f1-726c-4422-b3e9-f0de1649dd50.jpg)

### Ejecución del código

1. Abre `main.scd` en SuperCollider
2. **Edita las rutas** en la sección `// Carga de patches`
3. Ejecuta el bloque completo (`Cmd+Enter` o `Ctrl+Enter`)
4. La GUI se abrirá automáticamente

### Primeros pasos

1. **Activa la entrada**: presiona botón `In Mic` (GUI o MIDI CC 41)
2. **Inicia el feedback**: presiona `Play Inicio` (MIDI CC 32)
3. **Ajusta ganancias**: usa los sliders hasta que aparezca el efecto Larsen
4. **Explora módulos**: activa `EQ`, `Ring`, `Resonance`, etc.
5. **Experimenta**: toca el instrumento, mueve los transductores, ajusta parámetros

> ⚠️ **Advertencia**: El feedback puede generar volúmenes altos repentinamente. Comienza con ganancias bajas y ajusta poco a poco.

---

## Arquitectura del sistema

![](https://s3.hedgedoc.org/hd1-demo/uploads/7b9ad028-9867-4438-a30b-57ee548b1738.png)




### Módulos DSP disponibles

| Módulo | Función | Parámetros principales |
|--------|---------|------------------------|
| `\inputMic` | Entrada con filtrado | Ganancia |
| `\inicio` | Feedback puro (Larsen) | Ganancia |
| `\eq` | Ecualización adaptativa 16 bandas | Mix |
| `\ringmod` | Modulación de anillo | Frecuencia moduladora |
| `\phaser` | Phaser analógico | Wet |
| `\resonance` | Resonadores armónicos (x2) | Frecuencia, decay |
| `\rms` | Generador de irregularidad | Threshold, chaos amount |
| `\disonance` | Batimientos y rugosidad (x2) | Frecuencias, profundidad |
| `\pulse` | Ritmicidad irregular (x4) | Frecuencia, amplitud |
| `\salida` | Distribución espacial | Ganancia multicanal |

---

## Mapeo MIDI (Korg NanoKontrol2)

| CC | Función | Acción |
|----|---------|--------|
| 0–12 | Sliders | Ganancia de módulos feedback |
| 15 | Slider | Ganancia paisaje (soporte fijo) |
| 16–29 | Knobs | Parámetros (freq, wet, decay, etc.) |
| 32–39 | Botones | Activar/desactivar módulos principales |
| 41 | Botón | Toggle `\inputMic` |
| 42 | Botón | Toggle salida multicanal |
| 43 | Botón | **Manos Libres** (rutina autónoma) |
| 45 | Botón | Toggle `\eq` |
| 46 | Botón | **Shift** (cambiar capa de control) |
| 48–52 | Botones | Módulos adicionales (dis2, pulse) |
| 54 | Botón | Salida a transductor |
| 55 | Botón | Cargar testimonios (sampler) |
| 58–59 | Botones | Monitoreo (Node Tree / Meter) |
| 67–69 | Botones | Cambio de frecuencias resonantes |
| 70 | Botón | Salida multicanal paisaje |
| 71 | Botón | Activar paisaje sonoro |

> **Nota**: El mapeo es completamente opcional. Puedes usar solo la GUI o adaptar el código a tu propio controlador.

---

## Nota ética 

Este sistema fue concebido en diálogo con ***S@nar***, un archivo oral colectivo que recoge testimonios sobre violencia pedagógica en educación musical formal. Por razones éticas y por respeto a quienes compartieron sus voces, **los audios originales NO se incluyen en este repositorio público**.

Sin embargo, el código está diseñado de manera abierta y adaptable. Te invito a:

- **Reemplazar las carpetas de audio** (`/voices/1. Intro/`, etc.) con tus propios registros sonoros: entrevistas, grabaciones de campo, poemas, o cualquier material que tenga significado en tu práctica
- **Explorar con otros materiales**: el sampler granular funciona con cualquier archivo de audio
- **Contactarme directamente** si deseas conocer más sobre el archivo *S@nar* y explorar posibilidades de acceso consensuado e informado

**Este proyecto no busca reproducir sonidos, sino cultivar prácticas de escucha relacional.**

---

## Documentación completa

Para una comprensión detallada del proyecto, consulta el documento completo en `docs/manual.pdf`, que incluye:

- Marco teórico 
- Descripción técnica 
- Estrategias compositivas y metodología de activación
- Referencias y Registros 

---

## Contacto y colaboración

¿Tienes preguntas, sugerencias, comentarios o deseas compartir tu experiencia con el sistema? Escríbeme:

**joycejandettte@gmail.com**


---

## Licencia

[Por definir]

---

## Agradecimientos

A las colaboradoras del proyecto *S@nar* por sus voces y experiencias. A la comunidad de *SuperCollider* por abrir el código. A las genealogías del feedback experimental por inspirar este trabajo. A esta viola por con-moverme.

---

**Última actualización**: Enero 2026
