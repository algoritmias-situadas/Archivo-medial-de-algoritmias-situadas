(
// Después de configurar el puerto serie y los baudios,
// se puede hacer ctrl/cmd + a y ctrl/cmd + enter para ejecutar el código.

// Ejecutar para ver los puertos seriales disponibles.
SerialPort.devices;

// Indicar el puerto serial y los baudios con los que SuperCollider y Arduino estarán en comunicación.
~puertoSerie = "COM3";
~baudios = 9600;

///////////////////////////////////////////////

// Estas líneas de código sirven sólo para asegurarnos que todo esté limpio antes de empezar.
(
s.quit;
CmdPeriod.run;
SerialPort.closeAll;
);

~port = SerialPort(~puertoSerie, ~baudios);

~numOuts = 3;

// Esta variable sólo debe ser modificada en caso de que se quieran desplazar las salidas
// (ej. utilizar las salidas del hardaware 3, 4 y 5 en lugar de las salidas 1, 2 y 3).
~firstOut = 0;

s.options.numOutputBusChannels_(~numOuts + ~firstOut);
s.options.sampleRate_(48000);
)
(
s.waitForBoot{

	// Valor Mínimo y Máximo recibido desde arduino.

	~minValue = 0;
	~maxValue = 1023;

	// Creación de buses de audio auxiliares y grupos que nos permitirán
	// hacer que los Pbinds pasen por un limitador antes de salir a la interfaz de audio.
	// Sólo por si a caso.
	s.newBusAllocators;
	~auxOut = Array.fill(~numOuts, {Bus.audio(s).index});

	~sourceGroup = Group(s);
	~bellsGroup = Group(~sourceGroup, \addAfter);
	~limiterGroup = Group(~bellsGroup, \addAfter);

	// Inicialización de los sensores a utilizar.
	~reguilete = Array.fill(~numOuts, {0});

	// Inicialización de algunos parámetros que utilizan los Pbinds.
	(
		// En dbs.
		~mainGain = -6;
		~bellsGain = -6;
		~reguileteGain = [-6, -3, -3];
	);

	~bellRelease = 5;

	~minClock = 0.7;
	~maxClock = 9;

	//////////////////////////// SYNTHDEFS //////////////////////////////////

	SynthDef(\reguiletes, {
		var sig, env;
		sig = LFTri.ar(\freq.kr(440));
		env = EnvGen.ar(Env.asr(\atk.kr(0.5), 1, \rel.kr(1)), \gate.kr(1), doneAction: 2);
		sig = sig * env;
		sig = sig * \amp.kr(1).lag(0.05);
		Out.ar(\out.kr(0), sig);
	}).add;

	SynthDef(\reguileteLow, {
		var sig, env;
		// lag nos permite crear una interpolación entre las notas.
		// Efecto conocido como glide.
		sig = Saw.ar(\freq.kr(440).lag(0.5));
		env = EnvGen.ar(Env.asr(1, 1, 5), \gate.kr(1), doneAction: 2);
		sig = sig * env;

		// El argumento freq es utilizado tanto para la frecuencia del oscilador
		// como para la frecuencia de corte del filtro.
		// Esto para siempre mantener una relación entre ambos.
		sig = LPF.ar(sig,
			\freq.kr(440)*10
			+
			\cutoff.kr(10000).lag(0.5));

		sig = sig * \amp.kr(1).lag(0.05);
		Out.ar(\out.kr(0), sig);
	}).add;

	// Síntesis FM básica.
	SynthDef(\bell, {
		var sig, env;
		var fixedFreqCarrier, fixedFreqMod, indexMod;

		fixedFreqCarrier = 400;
		fixedFreqMod = fixedFreqCarrier * 2;
		indexMod = 15;

		sig = [
			SinOsc.ar(fixedFreqCarrier*1 + SinOsc.ar(fixedFreqMod*1, mul: indexMod), mul: 0.4),
			SinOsc.ar(fixedFreqCarrier*2 + SinOsc.ar(fixedFreqMod*2, mul: indexMod), mul: 0.3),
			SinOsc.ar(fixedFreqCarrier*4 + SinOsc.ar(fixedFreqMod*4, mul: indexMod), mul: 0.2)
		];

		sig = Mix.ar(sig); // Sumamos los 3 oscilados en una única señal.
		env = EnvGen.ar(Env.perc(0.01, ~bellRelease), gate: 1, doneAction: 2);
		sig = sig * env;
		sig = sig * \amp.kr(1);
		Out.ar(\out.kr(0), sig);
	}).add;

	SynthDef(\limitador, {
		var sig;
		sig = In.ar(~auxOut[0], ~numOuts);
		sig = Limiter.ar(sig, -1.dbamp);
		Out.ar(~firstOut, sig);
	}).add;

	// s.sync nos permite continuar ejecutando el código sólo hasta que.
	// En este caso, los SynthDefs se hayan agregado.
	s.sync;

	///

	Synth(\limitador, [], ~limiterGroup);

	///////////////////////////////// PBINDS //////////////////////////////////////

	~index = Array.series(~numOuts); // [0, 1, 2]
	~root = 0;

	///

	a = Pbind(
		\instrument, \reguiletes,

		\amp, Pfunc({
			(
				(~reguileteGain[0] + ~reguilete[~index[0]].linlin(~minValue, ~maxValue, -6, 0))
				+
				~mainGain
			).dbamp
		}),

		\scale, Scale.minorPentatonic,
		\degree, Pxrand((0..5), inf), // (0..5) es igual a [0, 1, 2, 3, 4, 5]
		\root, Pfunc({~root}),
		\octave, 5,

		\group, ~sourceGroup,

		\dur, 1,

		\atk, Pfunc({~reguilete[~index[0]].linlin(~minValue, ~maxValue, 0.5, 0.01)}),
		\rel, Pfunc({~reguilete[~index[0]].linlin(~minValue, ~maxValue, 1, 0.05)}),

		\out, Pfunc({~auxOut[~index[0]]})
	);

	b = Pbind(
		\instrument, \reguiletes,
		\amp, Pfunc({
			(
				(~reguileteGain[1] + ~reguilete[~index[1]].linlin(~minValue, ~maxValue, -6, 0))
				+
				~mainGain
			).dbamp
		}),

		\scale, Scale.minorPentatonic,
		\degree, Pxrand((0..5), inf),
		\root, Pfunc({~root}),
		\octave, 4,

		\group, ~sourceGroup,

		\dur, 1,

		\atk, 0.01,
		\rel, 0.5,

		\out, Pfunc({~auxOut[~index[1]]})
	);

	// Un Pmono crea una única instancia del SynthDef.
	c = Pmono(
		\reguileteLow,
		\amp, Pfunc({
			(
				(~reguileteGain[2] + ~reguilete[~index[2]].linlin(~minValue, ~maxValue, -6, 0))
				+
				~mainGain
			).dbamp
		}),

		\scale, Scale.minorPentatonic,

		// Pdup nos permite, en este caso, mantener la nota generada
		// durante las próximas 10 instancias.
		\degree, Pdup(10, Pxrand((0..5), inf)),
		\root, Pfunc({~root}),
		\octave, 3,

		\group, ~sourceGroup,

		\dur, 1,
		\cutoff, Pfunc({~reguilete[~index[2]].linexp(~minValue, ~maxValue, 800, 6000)}),

		\out, Pfunc({~auxOut[~index[2]]})
	);

	///

	s.sync;

	///

	// Inicialización del reloj con el que correrán los Pbinds.
	~clock = Array.fill(~numOuts, {TempoClock(1)});
	~pbinds = [a, b, c].collect{|p, i| p.play(~clock[i])};

	/*
	~pbinds = [a, b, c].collect{|p, i| p.play(~clock[~index[i]])} es equivalente a poner:
	~pbinds = [
	a.play(~clock[~index[0]]),
	b.play(~clock[~index[1]]),
	c.play(~clock[~index[2]])
	];
	*/

	////////////////////////////////// ROUTINE /////////////////////////////

	// getDate nos permite obtener la hora del sistema operativo.
	~minutes = {Date.getDate.minute};
	~seconds = {Date.getDate.second};

	~cadaCuantosMinutos = 30; // Cada cuántos minutos suenan las campanadas.
	~beforeBells = 5;

	~minutesBells = Array.series(60/~cadaCuantosMinutos, 0, ~cadaCuantosMinutos).asInteger;

	/*
	Esta rutina es la encargada de:
	detener los pbinds
	transporner los pbinds
	mover los pbinds a otras salidas
	hacer sonar las campanas
	volver a reproducir los pbinds

	En este caso, todo lo anterior sucede cada 30 minutos.
	*/

	Routine{
		inf.do{
			if(~cadaCuantosMinutos > 0, {
				if(
					(~minutesBells.includes(~minutes.value))
					&&
					(~seconds.value == (60 - ~beforeBells)), {

						~numOuts.do{|i| ~pbinds[i].stop};

						/*
						Esta línea se encarga de liberar todos los SynthDefs
						en caso de que alguno llegue a quedarse sonando.

						Esto puedo pasar en cambios abruptos de tempo.
						*/
						~sourceGroup.set(\gate, 0);
						"Deteniendo pbinds".postln;

						// Transposición aleatoria
						~root = rrand(0, 5);
						// ~index cambia para que los pbinds se reproduzcan en otras salidas
						~index = ~index.scramble;

						~beforeBells.wait;

						//

						~numOuts.do{
							|i|
							Synth(\bell, [
								\out, ~auxOut[~index[i]],
								\amp, ~bellsGain.dbamp
							], ~bellsGroup);

							~bellRelease.wait;
						};
						"Reproduciendo campanas".postln;

						~pbinds = [a, b, c].collect{|p, i| p.play(~clock[~index[i]])};
						"Reproduciendo pbinds".postln;
						"-------".postln;
				});
				1.wait;
			});
		};
	}.play;

	///

	s.sync;

	///////////////// ARDUINO ////////////////

	~updateSpeed = 0.001; // En segundos.
	~arrayTemp = [];

	Routine{
		// En este loop es donde sucede la mágia.
		inf.do{
			~char = ~port.read;

			if(~char != 10, {
				~arrayTemp = ~arrayTemp.add(~char.asAscii);
			}, {
				~arduino = ~arrayTemp.join.split($ ).asInteger;
				~arrayTemp = [];
			});
		};
	}.play;

	// Esta rutina es la encargada de asignar los valores recibidos de Arduino a las variables.
	Routine{
		inf.do{
			~numOuts.do{
				|i|
				~reguilete[i] = ~arduino[i];
				~clock[i].tempo = ~arduino[i].linlin(~minValue, ~maxValue, ~minClock, ~maxClock);
			};
			~updateSpeed.wait;
		};
	}.play;

	//////////////////// REFERENCIA VISUAL - GUI /////////////////////

	~font = Font(\arial, 14);
	~background = Color.gray;

	Window.closeAll;

	~imagen = Image(thisProcess.nowExecutingPath.dirname ++ "/GUI/reguiletesGUI.png");

	w = Window("Sentir y Escuchar el Viento", Rect(750, 180, ~imagen.width, ~imagen.height), false)
	.front;

	UserView(w)
	.drawFunc_({~imagen.drawAtPoint(0@0)}) //Desde esquina superior izquierda.
	.bounds_(w.view.bounds);

	//Coordenadas para colocar los Knobs.
	~x = [50, 188, 110];
	~y = [57, 57, 203];

	~knob = Array.fill(~numOuts, {
		|i|
		Knob(w, Rect(~x[i], ~y[i], 30, 30))
		.enabled_(false);
	});

	Routine{
		inf.do{
			~numOuts.do{
				|i|
				{~knob[i].value_(~reguilete[i].linlin(~minValue, ~maxValue, 0, 1))}.defer;
			};
			~updateSpeed.wait;
		};
	}.play;

	///

	"-------".postln;
	"EJECUTÁNDOSE".postln;
	"-------".postln;
	"-------".postln;
	"-------".postln;
	"-------".postln;
	"-------".postln;
	"-------".postln;
	"-------".postln;
};
)

/*

/// En caso de querer grabar un archivo mono para cada salida, se puede utilizar el siguiente código.

(
~grabadora = Array.fill(~numOuts, {
|i|
Recorder(s).record(
thisProcess.nowExecutingPath.dirname ++
"/Grabaciones/Reguilete" ++
i ++
".wav", i, 1
);
});
);

/// Detener la grabación

~numOuts.do{|i| ~grabadora[i].stopRecording};

*/

////////