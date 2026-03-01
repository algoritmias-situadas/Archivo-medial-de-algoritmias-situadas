## Síntesis sonora basada en números primos

Este proyecto explora la sonificación y musicalización de los números primos a través de lo que llamo *música prima*. Desarrollé un sintetizador personalizado en SuperCollider (sclang) para investigar la estructura, el comportamiento y la estética de los números primos en el sonido y la música.

El sistema implementa **espectros primos** (formas de onda construidas con armónicos primos), **afinación prima** (reafinación de notas MIDI a la frecuencia prima más cercana) y **ritmos primos** generados por contadores numéricos que activan eventos únicamente en números primos. Estos procesos rítmicos producen estructuras temporales no repetitivas y se visualizan en tiempo real mediante **espirales de Ulam**, revelando patrones geométricos en la distribución de los números primos.

El instrumento integra síntesis, afinación, ritmo y visualización en un **sistema de interpretación compatible con MIDI y teclado QWERTY**, sin necesidad de bibliotecas externas ni samples. Fue utilizado para componer una obra de música electrónica y como una exploración de investigación artística sobre la abstracción numérica en el sonido.


### Breve demostración de audio

[Escuchar](Pablo Gallegos/primenumber-music-synthesis-main/assets/audio/GaschPrimeSynth_Demo.mp3)


---

## Inicio rápido

### Requisitos

- SuperCollider  
- Controlador de teclado MIDI o teclado QWERTY  


### Ejecutar el Gasch Prime Synth

1. Abrir la carpeta `src`.
2. Abrir `src/GaschPrimeSynth.scd`.
3. Iniciar el servidor de audio:
```supercollider
s.boot;
```
4. Seleccionar el modo MIDI o QWERTY escribiendo \midi o \qwerty (línea 29 en `src/GaschPrimeSynth.scd`).
5. Conectar el teclado MIDI (NO si se utiliza el teclado QWERTY).
6. Ejecutar el bloque de código **1) INIT**.
7. Ejecutar el bloque de código **2) START**.
8. Tocar notas en el teclado.

### Nota de implementación

El _entry point_ es `src/GaschPrimeSynth.scd`, que carga todos los módulos desde subcarpetas dentro de `src/`.

---

## Estado

Este proyecto se publica como una versión funcionalmente completa del Gasch Prime Synth, desarrollada dentro de una iniciativa de investigación artística financiada por PAPIME:

**PAPIME 404525 Archivo de prácticas mediales en torno de algoritmias situadas**

---

## Solución de problemas

### No hay sonido

- Desconecta y conecta tu teclado MIDI.
- Re-ejecuta el bloque MIDI.
- Comprueba que el servidor de SuperCollider esté corriendo (`s.boot`).

### MIDI no detectado

```supercollider
MIDIClient.init;
MIDIClient.sources;
```
