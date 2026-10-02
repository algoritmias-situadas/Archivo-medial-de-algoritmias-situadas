(
~path = thisProcess.nowExecutingPath.dirname ++ "/samples";
~alarma=Buffer.readChannel(s,~path ++ "/Alerta.wav", channels: [0]);
~axo=Buffer.read(s,~path ++ "/acordeooon.wav");
~trunk=Buffer.read(s,~path ++ "/Martillo.wav");
~urb=Buffer.read(s, ~path ++ "/UrbunMusik.wav");
~ye=Buffer.read(s,~path ++ "/KANYELOVE.wav");
~campana=Buffer.read(s,~path ++ "/CAMPANITAS.wav");
~pisos=Buffer.read(s,~path ++ "/Pisos.wav");
~ambient=Buffer.read(s,~path ++ "/LloviaAgua.wav");
~ariles=Buffer.read(s, ~path ++ "/arilesymasariles.wav");
~augusto=Buffer.read(s, ~path ++ "/AGUSTO.wav");
~augustomono=Buffer.readChannel(s, ~path ++ "/AGUSTO.wav", channels:[0]);
)
//declaración de variables globales dónde se guardarán los samples.