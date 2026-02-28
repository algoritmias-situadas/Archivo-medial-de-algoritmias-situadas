// Selecciona cantidad de entradas y salidas

(
s.options.numInputBusChannels = 8;
s.options.numOutputBusChannels = 8;
s.reboot;
)

// Carga los archivos y ejecuta el GUI

(
"Guitarras.scd".loadRelative;
"Detector de alturas y ataques.scd".loadRelative;
"Botones.scd".loadRelative;
"Arremedar y aplausos.scd".loadRelative;
)

~wait = 2;