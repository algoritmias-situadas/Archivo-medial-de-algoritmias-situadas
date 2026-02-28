(
// 5. Mandar mensajes OSC de SuperCollider a Touchdesigner.

// Configurar el puerto y la dirección IP de TouchDesigner
~tdIP = "127.0.0.1"; /* Usa la IP local, si TouchDesigner está en la misma máquina */

~tdPort = 5000; /* Aquí inserta el puerto de recepción de TouchDesigner. */

// Crear un OSCFunc para enviar datos
(
~sendOSC = {
	var osc;
	osc = NetAddr(~tdIP, ~tdPort);

	// Enviar valores de prueba (ejemplo: frecuencia y amplitud)
	Routine({
		loop {
			var freq = 200 + (~freq_var);  // Frecuencia aleatoria entre 200 y 1000 Hz
			var amp = 0 + (~amp_var);   // Amplitud aleatoria entre 0.2 y 1.0

			osc.sendMsg("/freq", freq); // Enviar mensaje OSC con frecuencia
			osc.sendMsg("/amp", amp);   // Enviar mensaje OSC con amplitud

			(0.05).wait; // Esperar un tiempo aleatorio antes del siguiente mensaje
		}
	}).play;
};
);

// Ejecutar la función para empezar a enviar datos
~sendOSC.value;

)