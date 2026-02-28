README  

Diálogos de Anhydra

1.- Ejecutar SuperCollider y configurar tu interfaz de audio desde startup file:

ServerOptions.devices; // para ver qué opciones tiene el server
o = Server.default.options;

s.options.numOutputBusChannels = 4;
s.options.numInputBusChannels = 4;

Server.default.options.numBuffers = 2048;
Server.default.options.numWireBufs = 512;
Server.default.options.memSize = 2**20;

o.inDevice_("nombre de tu interfaz de audio");
o.outDevice_("nombre de tu interfaz de audio");

2.- Guardar startup file y reiniciar SuperCollider.

4.- Abrir el archivo Diálogos_de_Anhydra.scd, configurar rutas de archivos y seguir las instrucciones del código. 

