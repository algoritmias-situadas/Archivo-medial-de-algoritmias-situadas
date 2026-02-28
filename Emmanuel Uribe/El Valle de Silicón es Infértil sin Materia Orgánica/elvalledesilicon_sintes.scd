//Sintes Bubbles (columna 1)
//Botones 1-4
SynthDef(\bubbles,{
	|freq 52, amp 1, gate 1, att 1, sus 1, rel 1, lag 1,
	cutofflow 300, cutoffhigh 1100, timefilt 0.2, rq 0.1, mix 0.5, room 0.5, damp 0.5,
	timepan 0.2, left (-1.0), right 1.0, out 0|
	var sig, env;
	env = EnvGen.kr(Env.asr(att,sus,rel), gate, doneAction:2); //envolvente del sinte, no de cada punto de sonido.
	sig = Dust.ar(Lag.kr(freq, lag), amp); //con esto se generan los puntos
	sig = RLPF.ar(sig, LFNoise1.kr(Lag.kr(timefilt, lag)).range(cutofflow, cutoffhigh), rq) * env; //filtro
	sig = Pan2.ar(sig, SinOsc.kr(timepan).range(left,right)); //paneo, debe estar entre un rango de -1 a 1, el 0 es centro
	Out.ar(out,FreeVerb2.ar(sig[0], sig[1], Lag.kr(mix, lag), Lag.kr(room, lag), damp)); //en la salida se pone un reverb que funciona sólo para este instrumento
}).add;

//Botones 5 y 6
SynthDef(\rampbubbles,{
	|freq 52, amp 0.5, gate 1, att 1, sus 1, rel 1, lag 1,
	cutofflow 300, cutoffhigh 1100, timeramp 0.1, timefilt 11, rq 0.1, mix 0.5, room 0.25, damp 0.5,
	timepan 0.2, left (-1.0), right 1.0, out 0|
	var sig, env;
	env = EnvGen.kr(Env.asr(att,sus,rel), gate, doneAction:2); //envolvente del sinte, no de cada punto de sonido.
	sig = Impulse.ar(Lag.kr(freq, lag), 0, amp); // aquí se genera la señal principal
	sig = RLPF.ar(sig, LFTri.kr(Lag.kr(timefilt, lag)).range(cutofflow,cutoffhigh), rq * 0.5);//esta línea genera la rampa
	sig = RLPF.ar(sig, LFTri.kr(Lag.kr(timeramp, lag)).range(cutofflow, cutoffhigh), rq) * env; //esta línea genera los puntos o burbujas
	sig = Pan2.ar(sig, SinOsc.kr(timepan).range(left,right));
	Out.ar(out, FreeVerb2.ar(sig[0], sig[1], Lag.kr(mix, lag), Lag.kr(room, lag), damp));
}).add;

//Sintes Crunchy (columna 2)
//Botones 1-4
SynthDef(\crunch,{
	|freq 52, amp 2, gate 1, att 1, sus 1, rel 1, lag 1,
	cutofflow 300, cutoffhigh 1100, timefilt 0.4, rq 0.5, mix 0.5, room 0.5, damp 0.5,
	timepan 0.2, left (-1.0), right 1.0, mod 53, grain 0.5, out 0|
	var sig, env;
	env = EnvGen.kr(Env.asr(att,sus,rel), gate, doneAction:2);//envolvente del sinte
	sig = Dust.ar(Lag.kr(freq, lag), amp); //señal principal (rugoso)
	//sig = Impulse.ar(Lag.kr(freq, lag), 0, amp); //señal principal (áspero)
	sig = RLPF.ar(sig, LFNoise1.kr(Lag.kr(timefilt, lag)).range(cutofflow, cutoffhigh), rq) * env; //se pasa por un filtro (irregular)
	//sig = RLPF.ar(sig, LFTri.kr(Lag.kr(timefilt, lag)).range(cutofflow, cutoffhigh), rq) * env; //se pasa por un filtro (ondulación)
	sig = Pan2.ar(sig, SinOsc.kr(timepan).range(left,right), VarSaw.kr(Lag.kr(mod, lag), 0, Lag.kr(grain, lag)));//se controla el paneo con una onda sinoidal de baja frecuencia y se modula la amplitud
	Out.ar(out, FreeVerb2.ar(sig[0], sig[1], Lag.kr(mix, lag), Lag.kr(room, lag), damp)); //Salida con reverb estéro sólo para este instrumento
}).add;

//Botones 5 y 6
SynthDef(\rampCrunch,{
	|freq = 0.02, amp = 1, gate = 1, width = 0.5, att = 1, sus = 1, rel = 1, lag = 1,
	cutofflow = 300, cutoffhigh = 1100, timefilt = 0.4, rq = 0.5, mix = 0.5, room = 0.5, damp = 0.5,
	timepan = 0.2, left = -1.0, right = 1.0, mod = 53, modl = 173, grain = 0.5, highf = 2000, lowf = 55, out = 0|
	var sig, env;
	env = EnvGen.kr(Env.asr(att,sus,rel), gate, doneAction:2); //envolvente del sinte
	sig = Impulse.ar(Lag.kr(SinOsc.kr(freq).range(highf, lowf), lag), 0, amp); //señal principal
	sig = RLPF.ar(sig, LFTri.kr(Lag.kr(timefilt, lag)).range(cutofflow, cutoffhigh), rq) * env; //filtro
	sig = Pan2.ar(sig, SinOsc.kr(timepan).range(left,right), VarSaw.kr(Lag.kr(SinOsc.kr(freq*2,0.5).range(mod,modl), lag), 0, Lag.kr(grain, lag))); // se controla el paneo con una onda sinoidal de baja frecuencia y se modula la amplitud.
	Out.ar(out, FreeVerb2.ar(sig[0], sig[1], Lag.kr(mix, lag), Lag.kr(room, lag), damp)); //Salida con reverb estéro sólo para este instrumento
}).add;

//Sintes Wall (columna 3)
//Botones 1-4
SynthDef(\muroDeSonidoSt,{
	|freq = 52, mod = 53, amp = 0.5, gate = 1,
	width = 0.5, rq = 0.5, grain = 0.5,
	att = 1, sus = 1, rel = 1, lag = 1,
	cutofflow = 300, cutoffhigh = 1100, timefilt = 0.4,
	mix = 0.5, room = 0.5, damp = 0.5,
	timepan = 0.2, left = -1.0, right = 1.0, out = 0|

	var sig, env;
	env = EnvGen.kr(Env.asr(att,sus,rel), gate, doneAction:2); //envolvente del sinte
	sig = Pulse.ar(Lag.kr(freq, lag), width) * Lag.kr(amp, lag); //señal principal
	sig = RLPF.ar(sig, LFTri.kr(Lag.kr(timefilt, lag)).range(Lag.kr(cutofflow, lag), Lag.kr(cutoffhigh, lag)), rq) * env; //filtro
	sig = Pan2.ar(sig, SinOsc.kr(Lag.kr(timepan, lag)).range(left,right), VarSaw.kr(Lag.kr(mod, lag), 0, Lag.kr(grain, lag))); // se controla el paneo con una onda sinoidal de baja frecuencia y se modula la amplitud.
	Out.ar(out,FreeVerb2.ar(sig[0], sig[1], Lag.kr(mix, lag), Lag.kr(room, lag), damp)); //Salida con reverb estéro sólo para este instrumento
}).add;

//Botones 5 y 6
SynthDef(\muroDeSonidoRamp,{
	|freq = 0.02, amp = 0.5, gate = 1,
	width = 0.5, att = 1, sus = 1, rel = 1,
	lag = 1, highf = 3000, lowf = 55
	cutofflow = 300, cutoffhigh = 1100, timefilt = 0.4,
	rq = 0.5, mix = 0.5, room = 0.3, damp = 0.5,
	timepan = 0.2, left = -1.0, right = 1.0,
	mod = 190, modl = 0.53, grain = 0.5, out = 0|

	var sig, env;
	env = EnvGen.kr(Env.asr(att,sus,rel), gate, doneAction:2); //envolvente del sinte
	sig = Pulse.ar(Lag.kr(LFTri.kr(Lag.kr(freq, lag)).range(highf, lowf), lag), width); //señal principal
	sig = RLPF.ar(sig, LFTri.kr(Lag.kr(timefilt, lag)).range(cutofflow, cutoffhigh), rq) * env * amp;
	sig = Pan2.ar(sig, SinOsc.kr(timepan).range(left,right), VarSaw.kr(Lag.kr(SinOsc.kr(freq*1.5, 0.5).range(mod,modl), lag), 0, Lag.kr(grain, lag))); // se controla el paneo con una onda sinoidal de baja frecuencia y se modula la amplitud.
	Out.ar(out,FreeVerb2.ar(sig[0], sig[1], Lag.kr(mix, lag), Lag.kr(room, lag), damp));
}).add;

//Cuadro izquierdo columna 1 de izq a der
//Sonido de platillo frotado
SynthDef(\clang2,
	{
		|freq=500,amp=0.1,gate=1,out=0,pan=0,boost=2,tapCarFreq=200,tapModFreq=200, tapPmIndex = 3, tapRatio = 0.5, dur=1, releaseTime=1.6|

		var audio, chimeEnv, chimeFreqEnv, tap, tapEnv;

		chimeEnv = EnvGen.kr(Env.asr(dur/0.9 , 1, releaseTime), gate, amp, doneAction:2); //se controla la envolvente con la duración del sonido
		chimeFreqEnv = EnvGen.kr(Env([TRand.kr(1,17, gate),4.3,TRand.kr(1,17, gate)],[0.005,0.005],[1,1]), gate); // se modificó esta envolvente para afectar el timbre

		audio = (1..43).collect({
			|num|
			var freqOffset, currentFreq, ampOffset, currentAmp;
			freqOffset = ((num * freq) % (num + 1)).linlin(0,num,0.95,1.05);
			ampOffset = ((num * freq) % (num + 2.5)).linlin(0,num+1,0.5,1) * TRand.kr(0.01,4.2,gate);
			currentFreq = num * freq * freqOffset * chimeFreqEnv;
			SinOsc.ar(currentFreq, 0, 0.1 * ampOffset);
		});

		audio = Mix(audio) * chimeEnv;
		tapEnv = EnvGen.kr(Env([0,1.1,0],[0.001,0.25],[0,-2]), gate, amp);
		tap = PMOsc.ar(freq.linlin(200,550,131.4,131.2) * tapCarFreq, tapModFreq, tapPmIndex, SinOsc.ar(rrand(23,101)), tapEnv);
		audio = XFade2.ar(audio, tap, tapRatio);
		audio = (audio * boost).tanh / boost;
		audio = LPF.ar(audio, (freq * 10).min(10000));
		audio = Pan2.ar(audio,pan);
		Out.ar(out,audio);
	}
).add;

//Sonidos por síntesis FM
SynthDef(\fm, {
|portHz = 200, modHz = 100, modAmp = 200, atk = 0.01, rel = 1, amp = 0.3, pan = 0, out = 0|
	var port, mod, env;
	env = EnvGen.kr(Env.perc(atk,rel), doneAction:2); //envolvente de cadas sonido (attack y release)
	mod = SinOsc.ar(modHz, mul:modAmp); //onda moduladora, frecuencia y amplitud quedan fijas
	port = SinOsc.ar(portHz + mod) * env * amp; //onda portadora con la moduladora sumada, se aplica envolvente y amplitud
	Out.ar(out, Pan2.ar(port, pan)); //paneo y salida
}).add;

SynthDef(\fmlong, {
|portHz = 200, atk = 0.01, rel = 1, amp = 0.3, pan = 0, gate = 1, out = 0|
	var port, mod, env;
	env = EnvGen.kr(Env.asr(atk,0.7,rel), gate, doneAction:2); //envolvente de cadas sonido (attack, sustain y release)
	mod = SinOsc.ar(MouseY.kr(30,7500,1), mul:MouseX.kr(100,300)); //onda portadora, frecuenca y amplitud se controlan con el mouse.
	port = SinOsc.ar(portHz + mod) * env * amp; //onda portadora con la moduladora sumada, se aplica envolvente y amplitud
	Out.ar(out, Pan2.ar(port, pan)); //paneo y salida
}).add;

//Sonidos de bajo
SynthDef(\bajo, {
	|freq 60, att 0.3, dec 0.3, rel 3, gate 1, amp 0.15, out 0|
	var env, sig;
	env = EnvGen.ar(Env.adsr(att, dec, 0.7, rel), gate, doneAction:2);
	sig = SinOsc.ar(freq, 0, amp) * env;
	Out.ar(out, [sig,sig]);
}).add;

/*
SynthDef(\bajo, {
	|freq, dc 0.01, amp 0.2, out 0, gate 1, rq 0.31, att 0.3, rel 1, dur|
	var sig, env;
env = EnvGen.ar(Env.adsr(att, dur * 0.71, 0.4, rel), gate, doneAction:2);
	sig = Pulse.ar([freq, freq-(freq * dc)], 0.1,  2);
	sig = RLPF.ar(sig, Line.kr(freq * 19, freq * 13, dur), rq)  * env * amp;
	Out.ar(out, sig.distort.tanh);
}
).add;
*/

//Campanas
SynthDef(\clang, //sinte tomado de: https://sccode.org/1-57k
	{
		|freq=200,amp=0.68,gate=1,out=0,pan=0,boost=2,tapCarFreq=200,tapModFreq=200, tapPmIndex = 3, tapRatio = 0.5, releaseTime=1.6|
		var audio, chimeEnv, chimeFreqEnv, tap, tapEnv;

		chimeEnv = EnvGen.kr(Env.perc(0.05, releaseTime), gate, amp, doneAction:2);
		chimeFreqEnv = EnvGen.kr(Env([TRand.kr(0.1,17, gate),4.3,TRand.kr(0.1,17, gate)],[0.005,0.005],[2,-2]), gate); // se modificó esta envolvente para afectar el timbre
		audio = (1..20).collect({
			|num|
			var freqOffset, currentFreq, ampOffset, currentAmp;
			freqOffset = ((num * freq) % (num + 1)).linlin(0,num,0.95,1.05);
			ampOffset = ((num * freq) % (num + 2)).linlin(0,num+1,0.5,1) * TRand.kr(0.4,1.2,gate);
			currentFreq = num * freq * freqOffset * chimeFreqEnv;
			SinOsc.ar(currentFreq, 0, 0.1 * ampOffset);
		});
		audio = Mix(audio) * chimeEnv;
		tapEnv = EnvGen.kr(Env([0,1.1,0],[0.001,0.25],[0,-2]), gate, amp);
		tap = PMOsc.ar(freq.linlin(200,550,131.4,131.2) * tapCarFreq, tapModFreq, tapPmIndex, SinOsc.ar(130), tapEnv);
		audio = XFade2.ar(audio, tap, tapRatio);
		audio = (audio * boost).tanh / boost;
		audio = LPF.ar(audio, (freq * 10).min(10000));
		audio = Pan2.ar(audio,pan);
		Out.ar(out,audio);
	}
).add;

//Pads
SynthDef(\pad, {
	|freq 100, amp 0.3, w1 0.5, w2 0.11, att 0.5, rel 1, gate 1, cutoffh 1500, cutoffl 500, res 0.1, lag 0.1, out 0|
	var sig, env, width, mod, pos;
	env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction:2); //envolvente del sinte
	width = Line.kr(w1, w2, \dur.kr(1, lag)); // el ancho de la onda cambia a lo largo de la duración del sonido
	sig = Pulse.ar(freq, width) * env * amp/2; // señal principal
	sig = sig + Pulse.ar(freq-(freq* rrand(0.015,0.075)), width) * env * amp/2; //señal añadida ligeramente desafinada
	sig = RLPF.ar(sig, XLine.kr(cutoffl, cutoffh, \dur.kr(1, lag)), res); //el filtro se abre a lo largo de la duración del sonido
	pos = LFTri.kr(\dur.kr(1, lag)*(1/2)).range(-1,1); //paneo controlado por una onda triangular en relación a la duración del sonido
	Out.ar(out, Pan2.ar(sig, pos));
}).add;

//FM knobs
SynthDef(\fmlong2, {
|portHz = 200, modHz = 100, modAmp = 200, atk = 0.01, rel = 1, amp = 0.3, pan = 0, gate = 1, lag = 0.1|
	var port, mod, env;
	env = EnvGen.kr(Env.asr(atk,0.7,rel), gate, doneAction:2); //envolvente del sinte
	mod = SinOsc.ar(Lag.kr(modHz, lag), mul:Lag.kr(modAmp, lag)); //onda moduladora con amplitud variable
	port = SinOsc.ar(Lag.kr(portHz, lag) + mod) * env * amp; //se suma con la onda portadora
	Out.ar(0, Pan2.ar(port, pan)); //paneo y salida
}).add;

//Cuadro derecho columna 2 de izq a der
//grabar para granulador
SynthDef(\grabar, {|buff 0, in 0, volmic 0.85|
	var inp, grab;
	inp = SoundIn.ar(in, volmic); //señal del mmicro
	grab = RecordBuf.ar(inp, buff, loop:1); //grabar en un buffer
}).add;

// Granulación
SynthDef(\granular, {|amp 1.83, pos 0, durg 1, rate 1, rit 1, buff 0, pan 0, out 0|
	var son;
	son = TGrains.ar(2, //canales
		Impulse.kr(rit), //trigger
		buff, //buffer
		rate, BufFrames.kr(buff)/BufSampleRate.kr(buff)*pos, // normaliza la duración de los buffers
		durg, //duración del grano
		pan, //paneo
		0.9, //amp
		4);
	Out.ar(out, son);
}).add;

//dusty
SynthDef(\dusty, {
	|rel = 5.0, gate = 1, fr = 0.3, max = 7.1, densmin = pi, densmax = 282.743, amp = 5, out = 0|
	var sig, env, att, lag;
	att = rrand(0.03, 3.141); //tiempo de entrada del sonido
	lag = rrand(0.1, 0.81); //retardo en respuesta
	env = EnvGen.kr(Env.asr(att,1,5), gate, doneAction:2); //envolvente del sinte
	sig = Dust2.ar([MouseX.kr(densmin, densmax, 1, lag), MouseX.kr(densmin, densmax, 1, lag)]) * amp;
	sig = BPF.ar(sig, SinOsc.kr(LFNoise0.kr(3).range(fr,max,1)).range(100,1800), MouseY.kr(0.01,0.9,1), 1) * env; //ancho de banda controlado con el mouse
	Out.ar(out, FreeVerb2.ar(sig[0], sig[1], 0.5, 0.6));
}).add;

//noisey
SynthDef(\ruido_filt, {
	|lowfreq = 200, highfreq =15000, time = 31, gate = 1, out = 0|
	var sig, env;
	env = EnvGen.kr(Env.asr(7, 0.5, 7), gate, doneAction:2); //envolvente del sinte
	sig = WhiteNoise.ar(0.8); //señal principal ruido blanco
	sig = BPF.ar(sig,MouseX.kr(200,highfreq,1),MouseY.kr(0.01,0.99,1)); //filtro pasa banda controlado con el mouse
	sig = sig * env * 0.3;
	Out.ar(out,sig!2);
}).add;

//custom X
SynthDef(\instrumentoX, {
	|fx = 17,fy = 19, rlf = 39, rhf = 83, rln = 11 rhn =400, am = 1, amp = 0.09, att = 0.81, rel = 0.83, gate = 1, out = 0|
	var x, y, env, sig, pos;
	x = SinOsc.kr(fx).range(rlf,rhf); //frecuencia
	y = SinOsc.kr(fy).range(rln,rhn); //número de armónicos
	env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction:2); //envolvente
	pos = SinOsc.kr(1/am).range(-1.0, 1); //paneo inversamente proporcional a la modulación am
	sig = Blip.ar(x,y,LFTri.kr(am) * amp) * env; //señal principal con blip y modulación am
	Out.ar(out, Pan2.ar(sig, pos))};
).add;

//granulador caos
SynthDef(\grainc, {
	|att 0.25, rel 0.5, gate 1, amp 1, out 0|
	var sig, pan, env;
	env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction:2);
	pan = LFNoise1.kr(1).range(-1.0,1.0);
	sig = GrainBuf.ar(
		2,
		Dust.ar([MouseX.kr(0.2,41),MouseY.kr(0.2,41)]),
		LFNoise1.kr([0.3,0.3]).exprange(0.2,MouseX.kr(0.03,3.1)),
		~bofs_mono[rrand(0,4),rrand(0,4)],
		rrand(0.66,1.33),
		rrand(0.111,0.991),
		2,
		pan) * env * amp * -9.dbamp;
	Out.ar(out, Pan2.ar(sig, pan));
}
).add;

//granulador ritmo
SynthDef(\grainr, {
	|att 0.25, rel 0.5, gate 1, amp 1, out 0|
	var sig, pan, env;
	env = EnvGen.ar(Env.asr(att, 1, rel), gate, doneAction:2);
	pan = LFNoise1.kr(1).range(-1.0,1.0);
	sig = GrainBuf.ar(
		2,
		Impulse.ar([MouseX.kr(0.2,41),MouseY.kr(0.2,41)]),
		LFNoise1.kr([0.3,0.3]).exprange(0.2,MouseX.kr(0.03,3.1)),
		~bofs_mono[rrand(0,4),rrand(0,4)],
		rrand(0.66,1.33),
		rrand(0.111,0.991),
		2,
		pan) * env * amp * -9.dbamp;
	Out.ar(out, Pan2.ar(sig, pan));
}
).add;

//granulador custom
SynthDef(\grannycust, {
	|amp 0.55, dens 3, dur 0.1, rate 1, pos 0.1, gate 1, out 0|
	var sig, env;
	env = EnvGen.ar(Env.asr(0.25, 1, 0.75), gate, doneAction:2);
	sig = GrainBuf.ar(2, //número de canales
		Dust.ar([dens, dens]), //trigger
		[dur, dur], //duración
		~bofs_mono[rrand(5,6),rrand(5,6)], //buffer
		rate,
		pos
	) * amp * env;
	Out.ar(out, sig);
}).add;

//máquina 2
SynthDef(\jelicopter,
	{
		|rq = 0.3, out = 0, amp = (-6)|
	var sig, env, dur, pan, fpan, freq, mod, cutoff;
	freq = rrand(49.0,71);
	mod = rrand(11.0,17);
	cutoff = rrand(600,1100);
	dur = rrand(71.1, 111);
	fpan = rrand(0.1,5);
	pan = LFTri.kr(fpan).range(-1.0, 1);
	sig = Saw.ar(freq, 0.2);
	sig = sig + VarSaw.ar(XLine.kr(freq*2, freq, dur, doneAction:2), 0,
			LFTri.kr(XLine.kr(0.1,0.9,dur)).range(0.01,0.49), 0.2); //width, amp
	sig = sig * SinOsc.kr(Line.kr(23,2,dur)).range(0.01,1);
	env = EnvGen.ar(Env.new([0,1,0],[3,dur-3]));
	sig = RLPF.ar(sig, cutoff, rq);
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig,  pan, amp.dbamp))
}).add;

//buffer máquina 4
SynthDef(\buffmono, {|buf, start = 0, rate = 1, loop = 0, pan = 0, dur,
	out = 0, amp = 0.9, atk = 0.1, rel = 0.5, cur =1, gate = 1|
	var env, sig, paneo;
	sig = PlayBuf.ar(1, buf, rate * BufRateScale.kr(buf), 1.0, start, loop);
	env = EnvGen.kr(Env.asr(atk, 1, rel, cur), gate, doneAction: 2);
	paneo = Line.kr(pan, pan.neg, dur*Rand(0.5, 2));
	Out.ar(out, Pan2.ar(sig.tanh, paneo, amp) * env);
}).add;

//máquina 5
SynthDef(\cross4, {
	|ampout (-66), speed 1, gate 1, at 0.3, rel 0.7, out 0, peak 0.33,
	amr 11, frr 13|
	var freq1, freq2, sig1, sig2, mix, amp1, amp2, pan, width, env;
	env = EnvGen.ar(Env.asr(at, 1, rel), gate, doneAction:2);
	width = LFNoise0.kr(LFNoise0.kr(speed).range(0.2, 11)).range(0.01, 0.49);
	amp1 = LFNoise0.kr(LFNoise0.kr(speed).range(0.03, amr)).range(0.1, 17);
	amp2 = LFNoise0.kr(LFNoise0.kr(speed).range(0.03, amr)).range(0.1, 17);
	freq1 = LFNoise0.kr(LFNoise0.kr(speed).range(0.03, frr)).exprange(11.1, 10000);
	freq2 = LFNoise0.kr(LFNoise0.kr(speed).range(0.03, frr)).exprange(11.1, 10000);
	sig1 = LFSaw.ar(freq1) * amp1;
	sig2 =  Pulse.ar(freq2, width, sig1) * amp2;
	sig1 = sig1 * sig2;
	mix = (sig1 + sig2) * 0.025 * ampout.dbamp * env;
	pan = LFNoise1.kr(LFNoise1.kr(1).range(0.2,5)).range(-1.0,1);
	Out.ar(out, Limiter.ar(Pan2.ar(mix.tanh, pan), peak));
}).add;

SynthDef(\cross5, {
	|ampout (-66), speed 1, out 0, gate 1, at 0.3, rel 0.7, peak 0.33,
	amr 11, frr 13|
	var freq1, freq2, sig1, sig2, mix, amp1, amp2, pan, width, env;
	env = EnvGen.ar(Env.asr(at, 1, rel), gate, doneAction:2);
	width = LFNoise1.kr(LFNoise1.kr(speed).range(0.2, 11)).range(0.01, 0.49);
	amp1 = LFNoise1.kr(LFNoise1.kr(speed).range(0.03, amr)).range(0.1, 17);
	amp2 = LFNoise1.kr(LFNoise1.kr(speed).range(0.03, amr)).range(0.1, 17);
	freq1 = LFNoise1.kr(LFNoise1.kr(speed).range(0.03, frr)).exprange(11.1, 10000);
	freq2 = LFNoise1.kr(LFNoise1.kr(speed).range(0.03, frr)).exprange(11.1, 10000);
	sig1 = LFSaw.ar(freq1) * amp1;
	sig2 =  Pulse.ar(freq2, width, sig1) * amp2;
	sig1 = sig1 * sig2;
	mix = (sig1 + sig2) * 0.02 * ampout.dbamp * env;
	pan = LFNoise1.kr(LFNoise1.kr(1).range(0.2,5)).range(-1.0,1);
	Out.ar(out, Limiter.ar(Pan2.ar(mix.tanh, pan), peak));
}).add;
