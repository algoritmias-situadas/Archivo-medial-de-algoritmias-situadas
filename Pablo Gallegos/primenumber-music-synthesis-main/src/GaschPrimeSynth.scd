/*
Título: Gasch Prime Synth
Desarrollador: Pablo Gallegos Noreña, a.k.a. Gasch

Descripción:
Sintetizador basado en números primos que integra:
●	Ondas primas (espectros de armónicos primos)
●	Notas con frecuencia prima
●	Secuencias rítmicas primas con visualización en tiempo real (espirales de Ulam)
●	Cambios de modo y base numérica
●	Controles de timbre, secuencia y ecualización
●	Compatibilidad teclado MIDI o QWERTY
●   NO bibliotecas externas ni samples

Ejecución:
Paso 1: Seleccionar modo MIDI o QWERTY, escribiendo \midi o \qwerty (línea 29)
Paso 2: Conectar dispositivo MIDI (o no, en el caso QWERTY)
Paso 3: Ejecutar bloque 1) INIT
Paso 4: Ejecutar bloque 2) START
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
s.boot;

// ------------------------------------------------------
// 1) INIT
// ------------------------------------------------------
(
// SELECT MODE (\midi \qwerty)
~gpsInputMode = \qwerty;

~gpsRoot = thisProcess.nowExecutingPath.dirname;
~gpsLoad = { |rel| (~gpsRoot +/+ rel).load };

// BUS, FX, OUT, REC
~gpsLoad.("audio/bus_fx_out_rec.scd");

// PRIME (synthdefs, harmonics/amps, tuning)
~gpsLoad.("primes/complex_primes.scd");
~gpsLoad.("primes/harmonics_amps.scd");
~gpsLoad.("primes/prime_synthdefs.scd");
~gpsLoad.("primes/prime_tuning.scd");

// VISUALS (ulam spiral)
~gpsLoad.("visual/ulam_spiral.scd");
)


// ------------------------------------------------------
// 2) START
// ------------------------------------------------------
(
if(~gpsInputMode == \midi) {
	// MIDI ENGINE
	~gpsLoad.("performance/midi_engine.scd");
	~gpsLoad.("ui/gui_midi.scd");
} {
	if(~gpsInputMode == \qwerty) {
		// QWERTY ENGINE
		~gpsLoad.("performance/qwerty_engine.scd");
		~gpsLoad.("ui/gui_qwerty.scd");
	} {
		"Invalid input mode.".postln;
	};
};
)