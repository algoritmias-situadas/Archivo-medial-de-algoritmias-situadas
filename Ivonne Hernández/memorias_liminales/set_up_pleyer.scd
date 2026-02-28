(
x = Synth(\detectorAmp);

OSCdef(\buffer, {
	arg msg, time, addr, port;
	var ampli;
	ampli = msg[3];
	// ampli.round(0.001).post; ":   flag - ".post; ~flag.postln; /* Esta línea Función para comprobar el Funciónmiento del monitoreo. Si no vas a comprobar por favor déjala comentada. :)*/

	if (~flag)

	/* Esta función evalúa si la variable flag está activa (true) o inactiva (false). El primer conjunto de llaves se ejecuta cuando la flag está activa y la segunda cuando es falsa. */

	{ /* Este corchete se evalúa cuando la flag está activa. */

		/* */

		if (ampli > ~umbralActivacion)
		{
			/* El micrófono recibe señal y enciende la variable ~revIsOn. Esa variable detona un if que cambia los valores de  */
			"** El microfóno recibió señal **".postln;
			~revIsOn = true;
			if (~revIsOn) {~revIsOn = false; ~freq_var = exprand(0.001, 800).round(0.01); ~amp_var = exprand(0.001, 0.999).round(0.001); /*("freq: " ++ ~freq_var).postln; ("amp: " ++ ~amp_var).postln*/};

			if (~seccion_inmuta.value and: ~inmutaIsPlaying.not and: ~wait_seccion.not and: ~mutaIsPlaying.not)
			{
				~flag = false;
				~inmutaIsPlaying = true;
				~contador_seccional = Process.elapsedTime + ~seccion_dur.value;
				"Función 3 - Se activa atmósfera inmutable.".postln;

				~play_fijo = Synth(\playBufFinal, [\buffer, ~bofs[~bofs_seccion.value], \timeatk, ~seccion_dur.value * 0.001, \timesus, ~seccion_dur.value * 0.998, \timerel, ~seccion_dur.value * 0.001, \out, 0],  target: ~sourceGrp);

				if (~contador_seccion == 16) {~ending = true;};

				("Se ha iniciado la sección" + ~seccion_name.value + "está activa").postln;
			};

			if (~seccion_inmuta.value.not and: ~wait_parte.not and: ~ending.not)
			{
				if (~atmosPlaying.not and: ~wait_atmos.not)
				{
					~flag = false;
					"Función 4 - Se activa atmósfera mutable".postln;
					~mutaIsPlaying = true;
					~contador_partal = Process.elapsedTime;
					~contador_atmos = Process.elapsedTime + ~seccion_dur.value;
					~contador_partes = ~bofs_seccion.value + 1;
					~contador_tracks = 0;
					~bofs_limit = ~bofs_seccion.value + ~audios_seccion.value;
					~atmosPlaying = true;
					~wait_atmos = true;

					~play_atmos = Synth(\playBufFinal, [\buffer, ~bofs[~bofs_seccion.value], \timeatk, ~seccion_dur.value * 0.001, \timesus, ~seccion_dur.value * 0.998, \timerel, ~seccion_dur.value * 0.001, \out, 0],  target: ~sourceGrp);

					("Se ha iniciado la sección" + ~seccion_name.value + "está activa").postln;
				};

				if (~seccion_inmuta.value.not and: ~mutaIsPlaying and: ~atmosPlaying and: ~wait_parte.not)
				{

					if ((~contador_partal < Process.elapsedTime) and: (~contador_partes < ~bofs_limit))
					{
						"Función 5 - Se activa buff de voz para atmósfera mutable".postln;
						~mutaIsPlaying = true;

						("Se ha iniciado el buffer " ++ ~contador_partes ++ " con una duración de: " ++  ~seccion_par_dur.value.at(~contador_tracks)).postln;
						("Track num: " ++ ~contador_tracks).postln;

						~play_part = Synth(\playBufFinal, [\buffer, ~bofs[~contador_partes], \timeatk, ~seccion_par_dur.value.at(~contador_tracks) * 0.001, \timesus, ~seccion_par_dur.value.at(~contador_tracks) * 1, \timerel, ~seccion_par_dur.value.at(~contador_tracks) * 0.001, \out, 0],  target: ~sourceGrp);

						if (~contador_partes == 102) {
							~play_atmos.release(0.5); "Función 9 - se detiene la atmósfera de subitamente.".postln;
						};

						if ((~contador_partes - 1) > 0) {("Buffer duración: " ++ ~seccion_par_dur.value.at(~contador_tracks)).postln};

						~contador_partal = Process.elapsedTime + ~seccion_par_dur.value.at(~contador_tracks) + 1;
						~contador_partes = ~contador_partes + 1;
						~contador_tracks = ~contador_tracks + 1;
						~flag = false;

					};

					if ((~contador_partal < Process.elapsedTime) and: (~contador_partes == ~bofs_limit))
					{
						"Función 8 - No hay más buffs, termina atmósfera y se cambia".postln;
						(~contador_partal < Process.elapsedTime).postln;
						(~contador_partes == ~bofs_limit).postln;
						~sectionEnd = true;
						if (~contador_seccion == 15) {"Función 10 - Pasa a 16 de manera normal".postln;} {~play_atmos.release(3.5)};
					}
				}
			};

			if (~inmutaIsPlaying.not and: ~wait_seccion and: ~ending.not)
			{
				~wait_seccion = false;
				~flag = false;
				"Función 6 - Cambio de atmósfera (desde inmutable)".postln;
			};

			if (~mutaIsPlaying.not and: ~wait_atmos)
			{
				~wait_parte = false;
				~wait_parte = false;
				~wait_atmos = false;
				~flag = false;
				"Función 7 - Cambio de atmósfera (desde mutable)".postln;
			};

		}
		{
			~flag = false;
			// (~tiempo_global - ~tiempo_cielo).postln
		};
	};

	if (~contador_seccional < Process.elapsedTime and: ~inmutaIsPlaying)
	{
		~inmutaIsPlaying  = false;
		~wait_seccion = true;
		~contador_seccion = ~contador_seccion + 1;
		"Función 1 - Termina atmósfera inmutable".postln;
		~contador_seccion.postln;
	};

	if ((~contador_atmos < Process.elapsedTime and: ~mutaIsPlaying) or: (~sectionEnd and: (~contador_partal < Process.elapsedTime)))
	{
		~mutaIsPlaying  = false;
		~atmosPlaying = false;
		~wait_atmos = true;
		~wait_parte = true;
		~sectionEnd = false;
		~contador_seccion = ~contador_seccion + 1;
		"Función 2 - Termina atmósfera mutable".postln;
	};

	if (ampli > ~umbralInicio and: ~flag.not) {
		if((~contador_seccional > Process.elapsedTime) or: ~ending.not)
		{
			// "Función 0 - Activar flag".postln;
			// "INICIA".postln;
			~flag = true;
			~tiempo_global = Process.elapsedTime;
			// [~flag, ~tiempo].postln;
		}
		{
			"Función 11 - FIN DE LA PIEZA".postln;
			~freq_var = -200;
			~amp_var = 0;
			Server.killAll;
		}
	};
}, \tr, s.addr);

)