///////////////////////////RAÍZ DE PHI////////////////////////////
(
//////////////////////////ESCALA 416/////////////////////////////

//8 pasos de la escala (con valores en cents):
~cents = [60.773116, 98.332969, 159.106087, 219.879203, 257.439058, 318.212174, 355.772027, 416.54515];

//El siguiente bloque de código es para que la escala siga subiendo de altura después del último paso. En este caso la escala se extenderá a 16 periodos y un total de 129 degrees:
~cents2 = 416.54515 + ~cents;
~centsDos = ~cents ++ ~cents2;
~cents3= 833.0903 + ~cents;
~centsTres = ~centsDos ++ ~cents3;
~cents4 = 1249.63545 + ~cents;
~centsCuatro = ~centsTres ++ ~cents4;
~cents5 = 1666.1806 + ~cents;
~centsCinco = ~centsCuatro ++ ~cents5;
~cents6 = 2082.72575 + ~cents;
~centsSeis = ~centsCinco ++ ~cents6;
~cents7 = 2499.2709 + ~cents;
~centsSiete = ~centsSeis ++ ~cents7;
~cents8 = 2915.81605 + ~cents;
~centsOcho = ~centsSiete ++ ~cents8;
~cents9 = 3332.3612 + ~cents;
~centsNueve = ~centsOcho ++ ~cents9;
~cents10 = 3748.90635 + ~cents;
~centsDiez = ~centsNueve ++ ~cents10;
~cents11 = 4165.4515 + ~cents;
~centsOnce = ~centsDiez ++ ~cents11;
~cents12 = 4581.99665 + ~cents;
~centsDoce = ~centsOnce ++ ~cents12;
~cents13 = 4998.5418 + ~cents;
~centsTrece = ~centsDoce ++ ~cents13;
~cents14 = 5415.08695 + ~cents;
~centsCatorce = ~centsTrece ++ ~cents14;
~cents15 = 5831.6321 + ~cents;
~centsQuince = ~centsCatorce ++ ~cents15;
~cents16 = 6248.17725 + ~cents;
//centsT = cantidad total de cents
~centsT = ~centsQuince ++ ~cents16;

~centsT.cs;

////////////////PRUEBAS INICIALES CON LA ESCALA Y PBINDS////////////////////
/*
//Cada tono de la afinación se divide entre el valor una nota MIDI, que es 100 cents. \root se establece en -27.5 para que la nota 0 sea la frecuencia base (55.72809) y poder aprovechar un espectro de frecuencias más amplio que cuando \root es 0. Ya que cuando \root es 0 e intentas usar un \degree negativo,por ejemplo, -1, en vez de sonar una nota más grave, se escucha la nota límite de los agudos.

//En el siguiente ejemplo \root es igual a 0, por lo que el rango se limita a 80 notas:
(
Pbind(\scale, ~centsT/100,
	\degree, Pseq((0..79),2),
	\dur, 0.2
).play;
)

//En este ejemplo, \root es igual a -27.5, por lo que el rango se expande a 128 notas:
(
Pbind(\scale, ~centsT/100,
	\degree, Pseq((0..127),2),
	\root, -27.5,
	\dur, 0.2
).play;
)

//A continuación, las 128 notas se dividen en 4 secciones o rangos de notas. Por facilidad, a cada sección se le aignó el nombre de un instrumento de viento de madera de acuerdo a su registro (grave, medio o agudo):

//Rango 1 - Fagot (0-31) - Registro grave
(
Pbind(\scale, ~centsT/100,
	\degree, Pseq((0..31).mirror),
	\root, -27.5,
	\dur, 0.2
).play;
)

//Rango 2 - Clarinete (31-63) - Registro medio grave
(
Pbind(\scale, ~centsT/100,
	\degree, Pseq((31..63).mirror),
	\root, -27.5,
	\dur, 0.2
).play;
)

//Rango 3 - Oboe (63-95) - Registro medio agudo
(
Pbind(\scale, ~centsT/100,
	\degree, Pseq((63..95).mirror),
	\root, -27.5,
	\dur, 0.2
).play;
)

//Rango 4 - Flauta (95-127) - Registro agudo
(
Pbind(\scale, ~centsT/100,
	\degree, Pseq((95..127).mirror),
	\root, -27.5,
	\dur, 0.2
).play;
)
*/

////////////////////////////////SYNTHDEFS///////////////////////////////////

SynthDef(\fagot, {arg out=0, freq=440, cutoff=1200, res=0.3, amp=0.2, gate=1, pan=0, 	detune=0.005, subLevel=0.3,noiseLevel=0.05,mix=0.5, fEnvAmt=2000, lfoRate=2, lfoAmt=300, drive=1;
	var osc1, osc2, sub, noise, oscMix, envAmp, envFilt, lfo, filt, sig;
	osc1 = Saw.ar(freq);
	osc2 = Pulse.ar(freq * (1 + detune), 0.5);
	sub = SinOsc.ar(freq * 0.5) * subLevel;
	noise = WhiteNoise.ar(noiseLevel);
	oscMix = XFade2.ar(osc1, osc2, (mix * 2) - 1);
	sig = oscMix + sub + noise;
	envAmp = EnvGen.kr(Env.adsr(0.01, 0.15, 0.7, 0.4), gate, doneAction: 2);
	envFilt = EnvGen.kr(Env.adsr(0.02, 0.2, 0.0, 0.3), gate);
	lfo = SinOsc.kr(lfoRate) * lfoAmt;
	filt = RLPF.ar(sig, (cutoff + (envFilt * fEnvAmt) + lfo).clip(30, 20000), res.clip(0.05, 0.95));
	filt = tanh(filt * drive);
	sig = filt * envAmp * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\clarinete, {arg freq = 440, cutoff = 900, res = 0.5, amp = 1,  out = 0, gate = 1, pan = 0;
	var env, sig;
	env = EnvGen.kr(Env.adsr(0.1, 0.3, 0.5, 0.1), gate, doneAction:2);
	sig = Pulse.ar(freq, 0.5);
	sig = RLPF.ar(sig, cutoff, res);
	Out.ar(out, Pan2.ar(sig * 0.1* env * amp, pan));
}).add;

SynthDef(\oboe, {arg freq = 440, cutoff = 900, res = 0.5, amp = 1,  out = 0, gate = 1, pan = 0;
	var env, sig;
	env = EnvGen.kr(Env.adsr(0.1, 0.3, 0.5, 0.1), gate, doneAction:2);
	sig = Saw.ar(freq, 0.8);
	sig = RLPF.ar(sig, cutoff, res);
	Out.ar(out, Pan2.ar(sig * 0.1* env * amp, pan));
}).add;

SynthDef(\flauta, {arg out=0, freq=440, cutoff=1000, res=0.3, amp=0.2, gate=1, pan=0;
	var osc, filt, env, sig;
	osc = Saw.ar(freq);
	filt = RLPF.ar(osc,cutoff.clip(20, 20000),	res.clip(0.05, 0.99));
	env = EnvGen.kr(Env.adsr(0.01, 0.2, 0.7, 0.3),gate,doneAction: 2);
	sig = filt * env * amp;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

///////////////////////VARIABLES, ARRAYS Y SERIES///////////////////////////

//Tempo:
~tempo = TempoClock(110/60).permanent = true;

//Patrones (p = patrón, v = variación, f = forma)
//Patrón 1
~p1v1f1 = Pseq([68, 64, 62, 58]);
~p1v2f1 = Pseq([68, 62, 64, 62]);
~p1v3f1 = Pseq([68, 64, 62, 64]);
~p1v4f1 = Pseq([68, 58, 62, 58]);
~p1v5f1 = Pseq([68, 62, 58, 62]);
~p1f1 = [~p1v1f1, ~p1v2f1, ~p1v3f1, ~p1v4f1, ~p1v5f1];

~p1v1f2 = Pseq([68, 64, 62, 58].reverse);
~p1v2f2 = Pseq([68, 62, 64, 62].reverse);
~p1v3f2 = Pseq([68, 64, 62, 64].reverse);
~p1v4f2 = Pseq([68, 58, 62, 58].reverse);
~p1v5f2 = Pseq([68, 62, 58, 62].reverse);
~p1f2 = [~p1v1f2, ~p1v2f2, ~p1v3f2, ~p1v4f2, ~p1v5f2];

~p1v1f3 = Pseq([68, 64, 62, 58]);
~p1v2f3 = Pslide([68, 62, 64, 62]);
~p1v3f3 = Pseq([68, 64, 62, 64]);
~p1v4f3 = Pseq([68, 58, 62, 58].reverse);
~p1v5f3 = Pseq([68, 62, 58, 62]);
~p1f3 = [~p1v1f3, ~p1v2f3, ~p1v3f3, ~p1v4f3, ~p1v5f3];

~p1v1f4 = Pslide([68, 64, 62, 58]);
~p1v2f4 = Pseq([68, 62, 64, 62]);
~p1v3f4 = Pseq([68, 64, 62, 64].mirror);
~p1v4f4 = Pseq([68, 58, 62, 58]);
~p1v5f4 = Pwrand([68, 62, 58, 62],[0.4, 0.15, 0.2, 0.25]);
~p1f4 = [~p1v1f4, ~p1v2f4, ~p1v3f4, ~p1v4f4, ~p1v5f4];

~p1v1f5 = Pseq([68, 64, 62, 58]);
~p1v2f5 = Pseq([68, 62, 64, 62].stutter);
~p1v3f5 = Pslide([68, 64, 62, 64]);
~p1v4f5 = Pseq([68, 58, 62, 58].rotate);
~p1v5f5 = Pslide([68, 62, 58, 62]);
~p1f5 = [~p1v1f5, ~p1v2f5, ~p1v3f5, ~p1v4f5, ~p1v5f5];

~p1v1f6 = Pseq([68, 64, 62, 58].reverse);
~p1v2f6 = Pslide([68, 62, 64, 62]);
~p1v3f6 = Pseq([68, 64, 62, 64].mirror);
~p1v4f6 = Prand([68, 58, 62, 58]);
~p1v5f6 = Pseq([68, 62, 58, 62].rotate);
~p1f6 = [~p1v1f6, ~p1v2f6, ~p1v3f6, ~p1v4f6, ~p1v5f6];

//Patrón 2
~p2v1f1 = Pseq([72, 62, 64, 62]);
~p2v2f1 = Pseq([72, 64, 62, 64]);
~p2v3f1 = Pseq([72, 58, 62, 58]);
~p2v4f1 = Pseq([72, 62, 58, 62]);
~p2v5f1 = Pseq([72, 64, 62, 58]);
~p2f1 = [~p2v1f1, ~p2v2f1, ~p2v3f1, ~p2v4f1, ~p2v5f1];

~p2v1f2 = Pseq([72, 62, 64, 62].reverse);
~p2v2f2 = Pseq([72, 64, 62, 64].reverse);
~p2v3f2 = Pseq([72, 58, 62, 58].reverse);
~p2v4f2 = Pseq([72, 62, 58, 62].reverse);
~p2v5f2 = Pseq([72, 64, 62, 58].reverse);
~p2f2 = [~p2v1f2, ~p2v2f2, ~p2v3f2, ~p2v4f2, ~p2v5f2];

~p2v1f3 = Pseq([72, 62, 64, 62]);
~p2v2f3 = Prand([72, 64, 62, 64]);
~p2v3f3 = Pseq([72, 58, 62, 58]);
~p2v4f3 = Pseq([72, 62, 58, 62].scramble);
~p2v5f3 = Pseq([72, 64, 62, 58]);
~p2f3 = [~p2v1f3, ~p2v2f3, ~p2v3f3, ~p2v4f3, ~p2v5f3];

~p2v1f4 = Pxrand([72, 62, 64, 62]);
~p2v2f4 = Pseq([72, 64, 62, 64]);
~p2v3f4 = Pseq([72, 58, 62, 58].sort);
~p2v4f4 = Pseq([72, 62, 58, 62]);
~p2v5f4 = Pslide([72, 64, 62, 58]);
~p2f4 = [~p2v1f4, ~p2v2f4, ~p2v3f4, ~p2v4f4, ~p2v5f4];

~p2v1f5 = Pseq([72, 62, 64, 62]);
~p2v2f5 = Pwrand([72, 64, 62, 64], [0.6, 0.1, 0.20, 0.1]);
~p2v3f5 = Pseq([72, 58, 62, 58].rotate);
~p2v4f5 = Pxrand([72, 62, 58, 62]);
~p2v5f5 = Pseq([72, 64, 62, 58].pyramid);
~p2f5 = [~p2v1f5, ~p2v2f5, ~p2v3f5, ~p2v4f5, ~p2v5f5];

~p2v1f6 = Pseq([72, 62, 64, 62].scramble);
~p2v2f6 = Pxrand([72, 64, 62, 64]);
~p2v3f6 = Pseq([72, 58, 62, 58].stutter);
~p2v4f6 = Pwrand([72, 62, 58, 62], [0.45, 0.15, 0.2, 0.2]);
~p2v5f6 = Pseq([72, 64, 62, 58].pyramid);
~p2f6 = [~p2v1f6, ~p2v2f6, ~p2v3f6, ~p2v4f6, ~p2v5f6];

//Patrón 3
~p3v1f1 = Pseq([58, 62, 64, 62]);
~p3v2f1 = Pseq([58, 64, 62, 64]);
~p3v3f1 = Pseq([58, 62, 64, 68]);
~p3f1 = [~p3v1f1, ~p3v2f1, ~p3v3f1];

~p3v1f2 = Pseq([58, 62, 64, 62].reverse);
~p3v2f2 = Pseq([58, 64, 62, 64].reverse);
~p3v3f2 = Pseq([58, 62, 64, 68].reverse);
~p3f2 = [~p3v1f2, ~p3v2f2, ~p3v3f2];

~p3v1f3 = Pseq([58, 62, 64, 62]);
~p3v2f3 = Pxrand([58, 64, 62, 64]);
~p3v3f3 = Pseq([58, 62, 64, 68]);
~p3f3 = [~p3v1f3, ~p3v2f3, ~p3v3f3];

~p3v1f4 = Prand([58, 62, 64, 62]);
~p3v2f4 = Pseq([58, 64, 62, 64].reverse);
~p3v3f4 = Pseq([58, 62, 64, 68].stutter);
~p3f4 = [~p3v1f4, ~p3v2f4, ~p3v3f4];

~p3v1f5 = Pslide([58, 62, 64, 62]);
~p3v2f5 = Pseq([58, 64, 62, 64].rotate);
~p3v3f5 = Pseq([58, 62, 64, 68].slide);
~p3f5 = [~p3v1f5, ~p3v2f5, ~p3v3f5];

~p3v1f6 = Pslide([58, 62, 64, 62]);
~p3v2f6 = Pseq([58, 64, 62, 64].sort);
~p3v3f6 = Pseq([58, 62, 64, 68].slide);
~p3f6 = [~p3v1f6, ~p3v2f6, ~p3v3f6];

//Series de patrones (s = serie, f = forma)
~s1f1 = Pxrand(~p1f1);
~s2f1 = Pxrand(~p2f1);
~s3f1 = Pxrand(~p3f1);
~s1 = [~s1f1, ~s2f1, ~s3f1, ~s2f1];

~s1f2 = Pxrand(~p1f2);
~s2f2 = Pxrand(~p2f2);
~s3f2 = Pxrand(~p3f2);
~s2 = [~s1f2, ~s2f2, ~s3f2, ~s2f2];

~s1f3 = Pxrand(~p1f3);
~s2f3 = Pxrand(~p2f3);
~s3f3 = Pxrand(~p3f3);
~s3 = [~s1f3, ~s2f3, ~s3f3, ~s2f3].scramble;

~s1f4 = Pxrand(~p1f4);
~s2f4 = Pxrand(~p2f4);
~s3f4 = Pxrand(~p3f4);
~s4 = [~s1f4, ~s2f4, ~s3f4, ~s2f4].scramble;

~s1f5 = Pxrand(~p1f5);
~s2f5 = Pxrand(~p2f5);
~s3f5 = Pxrand(~p3f5);
~s5 = [~s1f5, ~s2f5, ~s3f5, ~s2f5].scramble;

~s1f6 = Pxrand(~p1f6);
~s2f6 = Pxrand(~p2f6);
~s3f6 = Pxrand(~p3f6);
~s6 = [~s1f6, ~s2f6, ~s3f6, ~s2f6].scramble;

//Número áureo:
~phi = 1+5.sqrt/2;

//d = duraciones:
~d1 = [1];
~d2 = [1, 1, 1, 3, 1, 1, 1, 3, 0.5, 0.5, 0.5, 0.5, 0.5, 3.5];
~d3 = [0.5, 0.5, 0.25, 0.75, 0.25, 0.25, 0.5, 0.75];
~d4 = [1, 1, 2, 3, 5, 8];

//a = amplitudes (en dB):
~a1 = [-1*~phi**5, -17.944271909999, -1*~phi**7]; //-17.944271909999 es igual a -1*~phi**6
~a2 = [-5*~phi, -8*~phi, -13*~phi, -21*~phi]; //Sucesión de Fibonacci 5, 8, 13, 21...
~a3 = [-5*~phi**1, -23.562305898749, -2*~phi**3, -6.8541019662497, -1*~phi**5]; //-3*~phi**2 = -23.56  -1*~phi**4 = -6.85
~a4 = [-8*~phi.sqrt/1, -13*~phi.sqrt/1, -21*~phi.sqrt/2, -34*~phi.sqrt/2, -55*~phi.sqrt/3, -89*~phi.sqrt/3]; //Sucesión Fibonacci 8, 13, 21, 34, 55, 89...
~a5 = [-12, -20, -16, -20, -14, -20, -16, -20,];

//l = articulaciones (legato):
~l1 = [1.5]; //legato
~l2 = [1]; //non-legato
~l3 = [0.5]; //staccato
~l4 = [0.25]; //staccatissimo
~l5 = [pi, pi/2, pi/3, pi/5, pi/8];
~l6 = [~phi*4, ~phi*3, ~phi*2, ~phi, ~phi/2, ~phi/3, ~phi/4];

//pan = paneo:
~pan1 = [-1, -1/2, 0, 1/2, 1];
~pan2 = [-1, -2/3, -1/3, 0, 1/3, 2/3, 1];
~pan3 = [-1, -3/4, -2/4, -1/4, 0, 1/4, 2/4, 3/4, 1];
~pan4 = [-1, -5/6, -4/6, -3/6, -2/6, -1/6, 0, 1/6, 2/6, 3/6, 4/6, 5/6, 1];
~pan5 = [-1, -7/8, -6/8, -5/8, -4/8, -3/8, -2/8, -1/8, 0, 1/8, 2/8, 3/8, 4/8, 5/8, 6/8, 7/8, 1];

///////////////////PBINDS Y DESARROLLO DE LAS SERIES////////////////////////

//fg = Fagot, s = sección. Rango de notas: 0-31, transposiciones desde -58 a -41:
~fg1 = (
	Pbind(
		\instrument, \fagot,
		\scale, ~centsT/100,
		\degree, Pseq(~s2-56, inf),
		\root, -27.5,
		\db, Pseq(~a5-17, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, Pslide((1, 15/16..1/16).mirror2, inf),
		\pan, Pxrand(~pan3, inf)
	)
);
~fg2 = (
	Pbind(
		\instrument, \fagot,
		\scale, ~centsT/100,
		\degree, Pseq(~s1-54, inf),
		\root, -27.5,
		\db, Pseq(~a5-17, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l1, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, Pslide((1, 15/16..1/16).mirror2, inf),
		\pan, Pxrand(~pan4, inf)
	)
);
~fg3 = (
	Pbind(
		\instrument, \fagot,
		\scale, ~centsT/100,
		\degree, Pseq(~s1-52, inf),
		\root, -27.5,
		\db, Pseq(~a3-15++~a1-15, inf),
		\dur, Pseq(~d2, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, ~pan1[2]
	)
);
~fg4 = (
	Pbind(
		\instrument, \fagot,
		\scale, ~centsT/100,
		\degree, Pseq(~s3-50, inf),
		\root, -27.5,
		\db, Pseq(~a5-17, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l3, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, Pxrand(~pan4, inf)
	)
);
~fg5 = (
	Pbind(
		\instrument, \fagot,
		\scale, ~centsT/100,
		\degree, Pseq(~s2-53, inf),
		\root, -27.5,
		\db, Pseq(~a5-17, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan3, inf)
	)
);
~fg6 = (
	Pbind(
		\instrument, \fagot,
		\scale, ~centsT/100,
		\degree, Pseq(~s1-56, inf),
		\root, -27.5,
		\db, Pseq(~a5-17, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l1, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan2, inf)
	)
);
~fg7 = (
	Pbind(
		\instrument, \fagot,
		\scale, ~centsT/100,
		\degree, Pseq(~s1-52, inf),
		\root, -27.5,
		\db, Pseq(~a3-19++~a1-19, inf),
		\dur, Pseq(~d2, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, ~pan2[1]
	)
);

//cl = Clarinete, s = sección. Rango de notas: 31-63, transposiciones desde -27 a -9:
~cl1s1 = (
	Pbind(
		\instrument, \clarinete,
		\scale, ~centsT/100,
		\degree, Pseq(~s6-11, inf),
		\root, -27.5,
		\db, Pseq(~a5+3, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l6, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, Pslide((1, 15/16..1/16).mirror2, inf),
		\pan, Pxrand(~pan3, inf)
	)
);
~cl2s1 = (
	Pbind(
		\instrument, \clarinete,
		\scale, ~centsT/100,
		\degree, Pseq(~s5-14, inf),
		\root, -27.5,
		\db, Pseq(~a5+4, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l5, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, Pslide((1, 15/16..1/16).mirror2, inf),
		\pan, Pxrand(~pan4, inf)
	)
);
~cl3s1 = (
	Pbind(
		\instrument, \clarinete,
		\scale, ~centsT/100,
		\degree, Pseq(~s4-17, inf),
		\root, -27.5,
		\db, Pseq(~a5+5, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l4, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, Pxrand(~pan5, inf)
	)
);
~cl4s1 = (
	Pbind(
		\instrument, \clarinete,
		\scale, ~centsT/100,
		\degree, Pseq(~s3-15, inf),
		\root, -27.5,
		\db, Pseq(~a5+6, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l3, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, Pxrand(~pan4, inf)
	)
);
~cl5s1 = (
	Pbind(
		\instrument, \clarinete,
		\scale, ~centsT/100,
		\degree, Pseq(~s2-13, inf),
		\root, -27.5,
		\db, Pseq(~a5+5, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan3, inf)
	)
);
~cl6s1 = (
	Pbind(
		\instrument, \clarinete,
		\scale, ~centsT/100,
		\degree, Pseq(~s1-11, inf),
		\root, -27.5,
		\db, Pseq(~a5+4, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l1, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan2, inf)
	)
);
~cl1s2 = (
	Pbindf(~cl1s1,
		\degree, Pseq(~s6-24, inf),
		\db, Pseq(~a5.sort+6++~a4.stutter+3, inf),
		\dur, Prand(~d2/~phi, inf),
		\legato, Prand(~l6/3, inf),
		\cutoff, Pwhite(800, 8000, inf),
		\res, Pwhite(0.0, 1.0, inf),
		\pan, Pslide(~pan5.reverse, inf)
	)
);
~cl2s2 = (
	Pbindf(~cl2s1,
		\degree, Pseq(~s5-25, inf),
		\db, Pxrand(~a5+6, inf),
		\dur, Pslide(~d2, inf),
		\legato, Pseq(~l1, inf),
		\cutoff, Pwhite(800, 8000, inf),
		\res, Pwhite(0.0, 1.0, inf),
		\pan, Pslide(~pan3.reverse, inf)
	)
);
~cl3s2 = (
	Pbindf(~cl3s1,
		\degree, Pseq(~s4-20, inf),
		\db, Pxrand(~a4+3, inf),
		\dur, Pslide(~d3, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, Pslide((500, 1000..8000), inf),
		\res, Pseq((1, 15/16..5/16).rotate, inf),
		\pan, Pslide(~pan4.reverse, inf)
	)
);
~cl4s2 = (
	Pbindf(~cl34s1,
		\degree, Pseq(~s3-17, inf),
		\db, Pwrand(~a3, [0.2, 0.25 , 0.05, 0.15, 0.35], inf),
		\dur, Pseq(~d4/4, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, Pxrand((500, 1000..8000), inf),
		\pan, Pslide(~pan2.reverse, inf)
	)
);
~cl5s2 = (
	Pbindf(~cl5s1,
		\degree, Pseq(~s2-14, inf),
		\db, Pslide(~a2.rotate+4, inf),
		\dur, Prand(~d3++~d2, inf),
		\legato, Pslide(~l2++~l3, inf),
		\cutoff, ~phi*1000,
		\pan, Pslide(~pan3.reverse, inf)
	)
);
~cl6s2 = (
	Pbindf(~cl6s1,
		\db, Pseq(~a1+3, inf),
		\legato, Pseq(~l5.pyramid, inf),
		\cutoff, Prand((500, 1000..8000), inf),
		\pan, Pslide(~pan1.reverse, inf)
	)
);
~cl1s3 = (
	Pbindf(~cl1s2,
		\degree, Pseq(~s1-21, inf),
		\dur, Psubdivide(
			Pseq(~d4, inf),
			Pseq(~d2*2, inf)),
		\pan, ~pan2[5]
	)
);
~cl2s3 = (
	Pbindf(~cl2s2,
		\degree, Pseq(~s2-19, inf),
		\db, Pslide(~a2.rotate+2, inf),
		\dur, Psubdivide(
			Pseq(~d3, inf),
			Pseq(~d1*2, inf)),
		\pan, ~pan2[5]
	)
);
~cl3s3 = (
	Pbindf(~cl3s2,
		\degree, Pseq(~s3-15, inf),
		\dur, Psubdivide(
			Pseq(~d2, inf),
			Pseq(~d4, inf)),
		\pan, ~pan2[5]
	)
);
~cl4s3 = (
	Pbindf(~ob4s2,
		\degree, Pseq(~s3-13, inf),
		\db, Pxrand(~a4-2, inf),
		\dur, Psubdivide(
			Pseq(~d3, inf),
			Pseq(~d4/2, inf)),
		\pan, ~pan2[5]
	)
);
~cl5s3 = (
	Pbindf(~ob5s2,
		\degree, Pseq(~s5-11, inf),
		\db, Pxrand(~a5-4, inf),
		\dur, Psubdivide(
			Pseq(~d3, inf),
			Pseq(~d2, inf)),
		\pan, ~pan2[5]
	)
);
~cl6s3 = (
	Pbindf(~ob6s2,
		\degree, Pseq(~s6-9, inf),
		\db, Pseq(~a5.sort-6++~a4.stutter-6, inf),
		\dur, Psubdivide(
			Pseq(~d2, inf),
			Pseq(~d1*4, inf)),
		\legato, Prand(~l1++~l2, inf),
		\pan, ~pan2[5]
	)
);

//ob = Oboe, s = sección. Rango de notas: 63-95, transposiciones desde +5 a +23:
~ob1s1 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s1+8, inf),
		\root, -27.5,
		\db, Pseq(~a5+7, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l1, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan2, inf)
	)
);
~ob2s1 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s2+10, inf),
		\root, -27.5,
		\db, Pseq(~a5+8, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan3, inf)
	)
);
~ob3s1 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s3+12, inf),
		\root, -27.5,
		\db, Pseq(~a5+9, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l3, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, Pxrand(~pan4, inf)
	)
);
~ob4s1 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s4+14, inf),
		\root, -27.5,
		\db, Pseq(~a5+10, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l4, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, Pxrand(~pan5, inf)
	)
);
~ob5s1 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s5+11, inf),
		\root, -27.5,
		\db, Pseq(~a5+9, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l5, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, Pslide((1, 15/16..1/16).mirror2, inf),
		\pan, Pxrand(~pan4, inf)
	)
);
~ob6s1 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s6+8, inf),
		\root, -27.5,
		\db, Pseq(~a5+8, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l6, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, Pslide((1, 15/16..1/16).mirror2, inf),
		\pan, Pxrand(~pan3, inf)
	)
);
~ob1s2 = (
	Pbindf(~ob1s1,
		\db, Pseq(~a1+3, inf),
		\legato, Pseq(~l5.pyramid, inf),
		\cutoff, Prand((500, 1000..8000), inf),
		\pan, Pslide(~pan1, inf)
	)
);
~ob2s2 = (
	Pbindf(~ob2s1,
		\degree, Pseq(~s2+11, inf),
		\db, Pslide(~a2.rotate+4, inf),
		\dur, Prand(~d3++~d2, inf),
		\legato, Pslide(~l2++~l3, inf),
		\cutoff, ~phi*1000,
		\pan, Pslide(~pan3, inf)
	)
);
~ob3s2 = (
	Pbindf(~ob3s1,
		\degree, Pseq(~s3+14, inf),
		\db, Pwrand(~a3, [0.2, 0.25 , 0.05, 0.15, 0.35], inf),
		\dur, Pseq(~d4/4, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, Pxrand((500, 1000..8000), inf),
		\pan, Pslide(~pan2, inf)
	)
);
~ob4s2 = (
	Pbindf(~ob4s1,
		\degree, Pseq(~s4+17, inf),
		\db, Pxrand(~a4+3, inf),
		\dur, Pslide(~d3, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, Pslide((500, 1000..8000), inf),
		\res, Pseq((1, 15/16..1/16).rotate, inf),
		\pan, Pslide(~pan4, inf)
	)
);
~ob5s2 = (
	Pbindf(~ob5s1,
		\degree, Pseq(~s5+20, inf),
		\db, Pxrand(~a5+6, inf),
		\dur, Pslide(~d2, inf),
		\legato, Pseq(~l1, inf),
		\cutoff, Pwhite(800, 8000, inf),
		\res, Pwhite(0.0, 1.0, inf),
		\pan, Pslide(~pan3, inf)
	)
);
~ob6s2 = (
	Pbindf(~ob6s1,
		\degree, Pseq(~s6+19, inf),
		\db, Pseq(~a5.sort+6++~a4.stutter+3, inf),
		\dur, Prand(~d2/~phi, inf),
		\legato, Prand(~l6/3, inf),
		\cutoff, Pwhite(800, 8000, inf),
		\res, Pwhite(0.0, 1.0, inf),
		\pan, Pslide(~pan5, inf)
	)
);
~ob1s3 = (
	Pbindf(~ob1s2,
		\degree, Pseq(~s1+16, inf),
		\dur, Psubdivide(
			Pseq(~d4, inf),
			Pseq(~d2*2, inf)),
		\pan, ~pan2[2]
	)
);
~ob2s3 = (
	Pbindf(~ob2s2,
		\degree, Pseq(~s2+14, inf),
		\db, Pslide(~a2.rotate+2, inf),
		\dur, Psubdivide(
			Pseq(~d3, inf),
			Pseq(~d1*2, inf)),
		\pan, ~pan2[2]
	)
);
~ob3s3 = (
	Pbindf(~ob3s2,
		\degree, Pseq(~s3+12, inf),
		\dur, Psubdivide(
			Pseq(~d2, inf),
			Pseq(~d4, inf)),
		\pan, ~pan2[2]
	)
);
~ob4s3 = (
	Pbindf(~ob4s2,
		\degree, Pseq(~s3+10, inf),
		\db, Pxrand(~a4-2, inf),
		\dur, Psubdivide(
			Pseq(~d3, inf),
			Pseq(~d4/2, inf)),
		\pan, ~pan2[2]
	)
);
~ob5s3 = (
	Pbindf(~ob5s2,
		\degree, Pseq(~s5+8, inf),
		\db, Pxrand(~a5-4, inf),
		\dur, Psubdivide(
			Pseq(~d3, inf),
			Pseq(~d2, inf)),
		\pan, ~pan2[2]
	)
);
~ob6s3 = (
	Pbindf(~ob6s2,
		\degree, Pseq(~s6+6, inf),
		\db, Pseq(~a5.sort-6++~a4.stutter-6, inf),
		\dur, Psubdivide(
			Pseq(~d2, inf),
			Pseq(~d1*4, inf)),
		\legato, Prand(~l1++~l2, inf),
		\pan, ~pan2[2]
	)
);

//fl = Flauta. Rango de notas: 95-127, transposiciones desde +37 a +55:
~fl1 = (
	Pbind(
		\instrument, \flauta,
		\scale, ~centsT/100,
		\degree, Pseq(~s1+40, inf),
		\root, -27.5,
		\db, Pseq(~a5-15, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l1, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan2, inf)
	)
);
~fl2 = (
	Pbind(
		\instrument, \flauta,
		\scale, ~centsT/100,
		\degree, Pseq(~s2+40, inf),
		\root, -27.5,
		\db, Pseq(~a5-15, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l2, inf),
		\cutoff, 900,
		\res, 0.5,
		\pan, Pxrand(~pan3, inf)
	)
);
~fl3 = (
	Pbind(
		\instrument, \flauta,
		\scale, ~centsT/100,
		\degree, Pseq(~s1+40, inf),
		\root, -27.5,
		\db, Pseq(~a5-15, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l3, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, Pxrand(~pan4, inf)
	)
);
~fl4 = (
	Pbind(
		\instrument, \flauta,
		\scale, ~centsT/100,
		\degree, Pseq(~s2+40, inf),
		\root, -27.5,
		\db, Pseq(~a5-15, inf),
		\dur, Pseq(~d1/4, inf),
		\legato, Pseq(~l4, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, Pxrand(~pan5, inf)
	)
);
~fl5 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s1+40, inf),
		\root, -27.5,
		\db, Pseq(~a5-15, inf),
		\dur, Psubdivide(
			Pseq(~d4, inf),
			Pseq(~d2*2, inf)),
		\legato, Pseq(~l5, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, ~pan2[4],
	)
);
~fl6 = (
	Pbind(
		\instrument, \oboe,
		\scale, ~centsT/100,
		\degree, Pseq(~s2+40, inf),
		\root, -27.5,
		\db, Pseq(~a5-18, inf),
		\dur, Psubdivide(
			Pseq(~d3, inf),
			Pseq(~d1*2, inf)),
		\legato, Pseq(~l6, inf),
		\cutoff, Pslide((900, 1200..5400).mirror2, inf),
		\res, 0.5,
		\pan, ~pan2[4]
	)
);

/////////////////////ESTRUCTURACIÓN DE LOS PBINDS///////////////////////////

//Fagot
~fg = Ptpar([
	0, ~fg1.finDur(19),
	19, ~fg2.finDur(16),
	35, ~fg3.finDur(75),
	110, ~fg4.finDur(16),
	126, ~fg3.finDur(43),
	169, ~fg5.finDur(33),
	202, ~fg3.finDur(20),
	222, ~fg6.finDur(20),
	242, ~fg3.finDur(120)
]);
//Clarinete
~cl = Ptpar([
	8, ~cl1s1.finDur(16),
	24, ~cl2s1.finDur(20),
	44, ~cl3s1.finDur(23),
	67, ~cl4s1.finDur(22),
	89, ~cl5s1.finDur(24),
	113, ~cl6s1.finDur(21),
	134, ~cl1s2.finDur(19),
	153, ~cl2s2.finDur(16),
	202, ~cl5s2.finDur(20),
	222, ~cl6s2.finDur(17),
	239, ~cl1s3.finDur(24),
	263, ~cl2s3.finDur(25),
	288, ~cl3s3.finDur(23),
	311, ~cl4s3.finDur(24),
	335, ~cl5s3.finDur(16),
	351, ~cl6s3.finDur(19)
]);
//Oboe
~ob = Ptpar([
	0, ~ob1s1.finDur(19),
	19, ~ob2s1.finDur(16),
	35, ~ob3s1.finDur(24),
	59, ~ob4s1.finDur(23),
	82, ~ob5s1.finDur(25),
	107, ~ob6s1.finDur(24),
	131, ~ob1s2.finDur(17),
	148, ~ob2s2.finDur(20),
	168, ~ob3s2.finDur(15),
	183, ~ob4s2.finDur(18),
	201, ~ob5s2.finDur(16),
	217, ~ob6s2.finDur(19),
	236, ~ob1s3.finDur(21),
	257, ~ob2s3.finDur(24),
	281, ~ob3s3.finDur(22),
	303, ~ob4s3.finDur(23),
	326, ~ob5s3.finDur(20),
	346, ~ob6s3.finDur(24)
]);
//Flauta
~fl = Ptpar([
	44, ~fl1.finDur(48),
	110, ~fl2.finDur(16),
	169, ~fl3.finDur(33),
	222, ~fl4.finDur(20),
	281, ~fl5.finDur(24),
	305, ~fl6.finDur(32)
]);

///////////////////////REPRODUCIR//////////////////////////////

Ppar([~fg, ~cl, ~ob, ~fl], 1).play(~tempo);
)








