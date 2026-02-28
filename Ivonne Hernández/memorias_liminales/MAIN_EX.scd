/*
Prototipo Instalación Ex Fabrica TExtil"
Enero 2025
*/

//________________________________________________________________________________________

/*

INSTRUCCIONES

1. ACTIVAR SERVER Y DEFINIR ENTRADAS Y SALIDAS DE AUDIO
2. CARGAR BUFFERS
3. CARGAR SYNTHDEF DE BUFFERS
4. CARGAR PBINDS DE BUFFERS
5. CARGAR INPUT MIC, SYNTH DELAY Y REVERB

*/

// 1. Activar el Server.
/* +++++++++ CORRE LA LÍNEA 22. ++++++++++++++ */
"set_up_server.scd".loadRelative;

// ________________________________________________________________________________________

/* +++++++++

1. EJECUTA EL BLOQUE DE CÓDIGO DE 33 A 42.
2. SI DA *** ERROR: SynthDef detectorAmp not found*** PULSA CTRL + .
3. EJECUTA NUEVAMENTE EL BLOQUE DE CÓDIGO DE 33 A 42.

++++++++++++++ */
(
// 2. Cargar Buffers.
"set_up_bufs.scd".loadRelative;
// 3. Variables de incio, generar buses, alocar grupos, definir synths.
"set_up_environment.scd".loadRelative;
// 4. Analizador de tiempo de variables.
"set_up_pleyer.scd".loadRelative;
// 5. Mandar mensajes OSC de SuperCollider a Touchdesigner.
"set_up_OSC.scd".loadRelative;
)