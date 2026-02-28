/*
DIÁLOGOS DE ANHYDRA
INSTALACIÓN INTERACTIVA


El símbolo ༄ indica lo que debe ejecutarse.

*/
( ༄ // RUTAS


//rutas de archivos para ambientación (importante insertar las carpetas y audios indicados)
(
~ruta = thisProcess.nowExecutingPath.dirname;
~nombres = ["ambientenocturnogrillosyranas.wav","ambienteypajarito.wav","avespequeñas.wav","avespresentes.wav","avesvariadas.wav","choquedeaguayave.wav","cigarras.wav","corrientedeagua.wav","flujodeaguayentorno.wav","grillos.wav","ligerochoquedeagua.wav","movimientoenagua.wav","pajaritocercano.wav","ambiente_cigarras.wav","ambiente_insectos.wav","ambiente_suave.wav","aves_cercanas_rio.wav","aves_grillos.wav","naturaleza_cigarra.wav"];

~bufs = ~nombres.collect{ arg x; Buffer.read (s, ~ruta ++ "/samples_paisaje_sonoro/"++ x)};

~bufE = Buffer.read(s, ~ruta  ++ "/electronica_anhydra.wav")
);

         // BUFFERS
//almacenamiento en buffers del audio que entra por los micrófonos, con ajuste de las duraciones
(
~duracion_buffs1 = Array.rand(2, 5.0, 10); //duraciones cortas para facilitar el efecto de tiempo real
~duracion_buffs2 = Array.rand(5, 1.0, 10);
~duracion_buffs3 = Array.rand(5, 1.0, 10);

~buffs1 = [
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs1[0], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs1[1], 1)
];

~buffs2 = [
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs2[0], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs2[1], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs2[2], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs2[3], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs2[4], 1)
];

~buffs3 = [
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs3[0], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs3[1], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs3[2], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs3[3], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs3[4], 1)
];



           //SYNTDEFS
//synthdefs de todas las funciones

//grabar
SynthDef(\grabar, {|buff 0, in 0|
	var inp, grab;
	inp = SoundIn.ar(in, 0.65);
	grab = RecordBuf.ar(inp, buff,loop:1);
}).add;

//reproducir
SynthDef(\reproducir, {|buff 0, vel 1, amp 1, panx 0, pany 0, out 0|
	var son;
	son = PlayBuf.ar(1, buff, vel, doneAction:2);
	Out.ar(out, Pan4.ar(son, panx, pany, amp));
}).add;

//reproducir electrónica
SynthDef(\reproducirE, {|buff 0, amp 1|
	var son;
	son = PlayBuf.ar(2, buff, BufRateScale.kr(buff), doneAction:2);
	Out.ar([0, 2], son*amp);
}).add;

//reproducir paisajes
SynthDef(\paisajes,
	{|buf, start = 0, rate = 1, loop = 0, xposf = 0, yposf = 0, dur,
	out = 0, amp = 0.5, atk = 0.1, rel = 0.5, cur = 1, gate = 1|
	var env, sig, paneo, pos;
	sig = PlayBuf.ar(2, buf, rate, 1.0, start, loop);
	env = EnvGen.kr(Env.asr(atk, 1, rel, cur), gate, doneAction: 2);
	paneo  = Pan4.ar(sig[0], SinOsc.kr(xposf), SinOsc.kr(yposf), amp);
	Out.ar(out, paneo*env);
}).add;

//efectos (reverb 100 102 108, delay 104, delayMul 106)

SynthDef(\delay, {|buff 0, vel 1, amp 1, maxd 8, delayt 0.2, decayt 5, panx 0, pany 0, in|
	var son, env;
	son = CombC.ar(In.ar(in, 2), maxd, delayt, decayt);
	son = Mix(son);
	Out.ar(0, Pan4.ar(son, panx, pany, amp));
}).add;

SynthDef(\delayMul, {|buff 0, vel 1, amp 1, maxd 8, delayt 0.2, decayt 5, panx 0, pany 0, in|
	var son, env;
	son = 5.collect{CombC.ar(In.ar(in, 2), maxd,
		Rand(delayt/1.1, delayt*1.1),
		Rand(decayt/1.1, decayt*1.1))
	}.sum;
	Out.ar(0, Pan4.ar(Mix(son), panx, pany, amp));
}).add;

SynthDef(\reverb, {|buff 0, vel 1, pan 0, amp 1, panx 0, pany 0, in 100|
	var son, env;
	son = FreeVerb.ar(In.ar(in, 2), 0.2, 0.7, 0.3);
	son = Mix(son);
	Out.ar(0, Pan4.ar(son, panx, pany,  amp));
}).add;

SynthDef(\distor, {|amp 0.3, in|
	var son, env;
	son = In.ar(in, 2).wrap.distort*0.1;
	son = Mix(son);
	Out.ar(0, PanAz.ar(4, son, LFSaw.kr(0.1, 0, 1, 1), amp));
}).add;

//granulación
SynthDef(\granular, {|amp 1.2, pos 0, durg 1, rate 1, rit 1, buff 0, pan 0|
	var son;
	son = TGrains.ar(4, Impulse.kr(rit), buff, rate, BufFrames.kr(buff)/BufSampleRate.kr(buff)*pos, durg, pan, 0.8, 0.1);
	Out.ar(0, son);
}).add;

SynthDef(\granuB, {|gate 1, buff 0, rate 1, start 0, ws 0.4, pitchRatio 1, pd 0.4, td 0.3, atk 0.1, rel 1, cur 0, amp 1,  panx 0, pany 0, legato 0.6, dur 1, out 0|
	var son, env, buffers, paneo;
	buffers = PlayBuf.ar(1, buff, rate, 1, loop:1);
	son = PitchShift.ar(buffers, ws, pitchRatio, pd, td);
    env = EnvGen.ar(Env.asr(atk,1,rel, cur), gate, doneAction: 2);
	paneo = Pan4.ar(son, panx, pany, amp);
	Out.ar(0, paneo*env*amp)
}).add;

//detector
SynthDef(\detecta, {|in 0, in2 1, in3 2|
	var inp, inp2, inp3, ampF, ampF2, ampF3, freq, hasFreq;
	inp = SoundIn.ar(in);
	inp2 = SoundIn.ar(in2);
	inp3 = SoundIn.ar(in3);

	ampF = Amplitude.kr(inp);
	ampF2 = Amplitude.kr(inp2);
	ampF3 = Amplitude.kr(inp3);
	SendReply.kr(Impulse.kr(5), values:[ampF, ampF2, ampF3]);
}).add;


          // PBINDS
//pbinds para configurar las funciones de reproducción y efectos

~reproducir1 = Pbind(\instrument, \reproducir,
	\vel, 1,
	\buff, Prand(~buffs1,inf),
	\dur, Pwhite(0.5,1.0, inf),
	\out, 100,
);

~reproducir2 = Pbind(\instrument, \reproducir,
	\vel, 1,
	\buff, Prand(~buffs2,inf),
	\dur, Pwhite(0.5,1.0, inf),
	\out, [102, 104, 106],
);

~reproducir3 = Pbind(\instrument, \reproducir,
	\vel, 1,
	\buff, Prand(~buffs3,inf),
	\dur, Pwhite(0.5,1.0, inf),
	\out, [108, 110],
);

(
Pdef(\paisajes, Pbind(\instrument, \paisajes,
	\buf, Pxrand(~bufs, inf),
	\start, Pbrown(0.1, 0.95, 0.05),
	\dur, Pwhite(1, 3),
	\amp, Pwhite(0.19, 0.25),
	\loop, 1,
	\xposf, Pwhite(-0.1, 0.15), //en x y y ajustar paneos de los samples de paisaje
	\yposf, Pwhite(-0.15, 0.1),
	\cur, Pwhite(-2.0, 2.5),
	\rel, Pwhite(10, 20),
	\atk, Pwhite(0.1, 3.5),
)));

//Pmonos para efectos (aquí se ajustan los parámetros de los efectos)
~delay = Pmono(\delay,
	\delayt, Pwhite(1, 3),
	\decayt, Pwhite(3, 6),
	\in, 104,
	\panx, Pwhite(-1.0, 1.0),
	\pany, Pwhite(-1.0, 1.0),
	\amp, 7
);
~delayMul = Pmono(\delayMul,
	\delayt, Pwhite(1, 2),
	\decayt, Pwhite(3, 6),
	\in, 106,
	\panx, Pwhite(-1.0, 1.0),
	\pany, Pwhite(-1.0, 1.0),
	\amp, 5
);
~reverb1 = Pmono(\reverb,
	\in, 100,
	\mix, Pwhite(0.7, 0.9),
	\room, Pwhite(0.5, 1),
	\panx, Pwhite(-1.0, 1.0),
	\pany, Pwhite(-1.0, 1.0),
	\amp, 7
);
~reverb2 = Pmono(\reverb,
	\in, 102,
	\mix, Pwhite(0.7, 0.9),
	\room, Pwhite(0.5, 1),
	\panx, Pwhite(-1.0, 1.0),
	\pany, Pwhite(-1.0, 1.0),
	\amp, 7
);
~reverb3 = Pmono(\reverb,
	\in, 108,
	\mix, Pwhite(0.7, 0.9),
	\room, Pwhite(0.5, 1),
	\panx, Pwhite(-1.0, 1.0),
	\pany, Pwhite(-1.0, 1.0),
	\amp, 7
);

//patrones de granulación
~granuB1 = Pbind(\instrument, \granuB,
	\buff, Prand(~buffs2, inf),
	\dur, Pwhite(0.02, 10),
	\amp, Pwhite(2, 3),
	\loop, 1,
	\ws, Pwhite(0.02, 0.4),
	\pitchRatio, Pwhite(-1.5, 4.5),
	\pd, Pwhite(0.5, 30),
	\panx, Pwhite(-1.0, 1.0),
	\pany, Pwhite(-1.0, 1.0),
	\cur, Pwhite(-3.0, 2.8),
	\rel, Pwhite(2.4, 4.0),
	\atk, Pwhite(0.01, 2.40),
	\stretch, Pmeanrand(0.1, 4, inf);
);

~granuB2 = Pbind(\instrument, \granuB,
	\buff, Prand(~buffs3, inf),
	\dur, Pwhite(0.02, 10),
	\amp, Pwhite(2, 3),
	\loop, 1,
	\ws, Pwhite(0.02, 0.4),
	\pitchRatio, Pwhite(-1.5, 4.5),
	\pd, Pwhite(0.5, 30),
	\panx, Pwhite(-1.0, 1.0),
	\pany, Pwhite(-1.0, 1.0),
	\cur, Pwhite(-3.0, 2.8),
	\rel, Pwhite(2.4, 4.0),
	\atk, Pwhite(0.01, 2.40),
	\stretch, Pmeanrand(0.1, 4, inf);
);

~granular = Pmono(\granular,
	\dur, Pwhite(0.01, 0.7, inf),
	\buff, Prand(~buffs1, inf),
	\rit, Prand([15, 25, 30], inf),
	\rate, Pwhite(0.01, 0.95,inf),
	\pos, Pwhite(0, 1, inf),
	\durg, Pwhite(0.01, 2, inf),
	\amp, 6,
	\pan, Pwhite(0, 2.0, inf),
);


          // DETECTOR​
//detector con umbral de tiempo y amplitud para activar la electrónica fija y desactivar el paisaje sonoro
(
//variables
~flag = false;
~umbralAmp = 0.0015; // amplitud mínima
~umbralT = 0.05;    // tiempo mínimo sobre umbral
~tiempo = 0;
~playOn = false;   // bloqueo luego del disparo

//detector
OSCdef(\deTec, { |msg, time, addr, port|
	var ampli, ampli2, ampli3;
	ampli = msg[3]; //mensajes para monitorear en la post window la amplitud recibida
	ampli2 = msg[4];
	ampli3 = msg[5];

	msg.postln;

	// debug info
	ampli.round(0.001).post; " ::: flag: ".post; ~flag.postln;
	ampli2.round(0.001).post; " ::: flag: ".post; ~flag.postln;
	ampli3.round(0.001).post; " ::: flag: ".post; ~flag.postln;

	//si ya está sobre el umbral, ahora verificar que se mantenga
	if (~flag) { \alcanzado.postln;
		if ((ampli > ~umbralAmp) or: (ampli2 > ~umbralAmp) or: (ampli3 > ~umbralAmp)) {

			if ((Process.elapsedTime - ~tiempo) > ~umbralT) {
				\victoria.postln;

				//disparo de electrónica
				if (~playOn.not) {
					Synth(\reproducirE, [\buff, ~bufE]);
					~playOn = true;
					Pdef(\paisajes).stop;
					"✅ Electrónica activada".postln; //aviso en la post window de la activación

					//bloqueo del detector por 20 min mientras corre la electrónica
					SystemClock.sched(1200, {
						~playOn = false;
						"⏳ Detector reactivado".postln;
						Pdef(\paisajes).play;
					});
				};

				//reset del detector
				~flag = false;
				~tiempo = 0;
			};

		} { //reiniciar proceso
			~flag = false;
			~tiempo = 0;
		};
	};

	//si cruza el umbral y no está en flag, marca iniciar
	if ((ampli > ~umbralAmp) or: (ampli2 > ~umbralAmp) or: (ampli3 > ~umbralAmp) and: ~flag.not) {
		~flag = true;
		~tiempo = Process.elapsedTime;
		[~flag, ~tiempo].postln;
	};

}, \reply, s.addr);

)
)


//importante: siempre ejecutar grabar y reproducir al final de todo


//llamado para grabar en los buffers
(   //GRABAR
Synth(\grabar, [\buff, ~buffs1[0], \in, 0]);
Synth(\grabar, [\buff, ~buffs1[1], \in, 0]);

Synth(\grabar, [\buff, ~buffs2[0], \in, 1]);
Synth(\grabar, [\buff, ~buffs2[1], \in, 1]);
Synth(\grabar, [\buff, ~buffs2[2], \in, 1]);
Synth(\grabar, [\buff, ~buffs2[3], \in, 1]);
Synth(\grabar, [\buff, ~buffs2[4], \in, 1]);

Synth(\grabar, [\buff, ~buffs3[0], \in, 2]);
Synth(\grabar, [\buff, ~buffs3[1], \in, 2]);
Synth(\grabar, [\buff, ~buffs3[2], \in, 2]);
Synth(\grabar, [\buff, ~buffs3[3], \in, 2]);
Synth(\grabar, [\buff, ~buffs3[4], \in, 2]);
)


//activación de todos los procesos
(    //REPRODUCIR
Pdef(\paisajes).play;

~reproducir1.play;
~reproducir2.play;
~reproducir3.play;

~delay.play;
~reverb1.play;
~reverb2.play;
~reverb3.play;
k = Synth(\distor, [\in, 110, \amp, 0.0035]);

~granuB1.play;
~granuB2.play;
~granular.play;

x = Synth(\detecta);
)



