//________________________________________________________________________________________
// 1. Activar el Server. Línea 23-56. Sigue en 62.

(
Server.killAll;
s = Server.local;

s.options.numOutputBusChannels = 2; // Salidas
s.options.numInputBusChannels = 8;  // Entradas

s.options.memSize = 1688576;
s.options.numBuffers = 1024*16;
s.options.maxNodes = 1024*64;

// Para definir Entradas

o = Server.default.options;
o.inDevice_("ASIO : US-20x20 ASIO");
o.outDevice_("ASIO : US-20x20 ASIO");

// o.inDevice_("ASIO : MiniFuse ASIO Driver"); // Caruros PC
// o.inDevice_("MME : Microphone (Logitech Webcam C92");
// o.outDevice_("ASIO : MiniFuse ASIO Driver"); // Caruros PC

// o = Server.default.options;
//o.inDevice_( "MME : Microphone (Scarlett 2i2 USB)"); //Tarjeta local
//o.inDevice_("Windows WASAPI : Microphone (Fast Track)"); // (INPUT)
// o.inDevice_("MME : Micrófono (Fast Track)");

//o.inDevice_( "MME : Micrófono (MobilePre)");
// o.outDevice_("Windows WASAPI : Speakers (Fast Track)"); // Para interfaz externa (OUTPUT)
// o.outDevice_("  MME : Altavoces (MobilePre)"); // Para audifonos
// o.outDevice_("MME : Altavoz (Conexant SmartAudio HD"); //Para altavoz de compu
// o.outDevice_("4 - PA248QV (AMD High Definitio"); // Compu escriotorio

s.options.sampleRate = 48000;
//o.outDevice_("MME : Speakers (Scarlett 2i2 USB)");
s.waitForBoot({s.recChannels = 2; s.makeWindow; "Joooorrrrrge, ponte a trabajar".postln});

s.meter;
);