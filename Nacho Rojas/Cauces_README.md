README

CAUCES

1. Ejecutar este bloque de código en el startup file de SuperCollider para configurar la interfaz de audio, el número de entradas y salidas y los parámetros del búfer:
(
ServerOptions.devices; (te permite ver las opciones de interfaces conectadas)

o = Server.default.options;

s.options.numOutputBusChannels = 4;
s.options.numInputBusChannels = 4;

Server.default.options.memSize=2**20;
Server.default.options.numWireBufs=64;
Server.default.options.numBuffers=256;

o.inDevice_("nombre de la interfaz");
o.outDevice_("nombre de la interfaz");
)

2. Guardar el startup file y reiniciar SuperCollider.

3. Abrir el archivo de la pieza y seguir las instrucciones del código y la partitura.