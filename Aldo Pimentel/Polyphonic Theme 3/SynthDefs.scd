~path = thisProcess.nowExecutingPath.dirname ++ "/";


// Aquí cargo los samples //

~ritm = Buffer.read(s, ~path ++ "Samples/Ritmo.wav");

z = Buffer.read(s, ~path ++ "Samples/z.wav");


// Para poner reverb //

SynthDef(\rev,{
	|out 0, in 100|
	var son;
	son = FreeVerb.ar(In.ar(in, 2), 0.33, 0.5, 0.3);
	Out.ar(out, son);
}).play;


// Generador de impulsos //

SynthDef(\vinil, {
	|out 0, amp 0.5|
	var son;
	son = Dust.ar(8, amp);
	Out.ar(out, Pan2.ar(son * amp));
}).add;


// Otros synthdefs que hacen cosas diversas //

SynthDef(\trona, {
	|out 0, amp 0.05, nota 70, freq 456, dis 460|
	var tritono, mod, son, env;
	tritono = (nota + [0, 4]).midicps;
	mod = SinOsc.ar(tritono, 0.5, 0.6);
	son = ((mod * Pulse.ar(tritono[1], 0.2, 0.5)) + (LFTri.ar(tritono[0], 0.2, 0.5) * mod) +
		LFNoise0.kr(freq, 0.2)) * SinOsc.ar(LFNoise0.kr(6, freq, 256), 0.1, 3) * mod +
	    Pulse.ar((dis/4), 0.2, 0.3) + Blip.ar(freq, Line.kr(1, 18, 18), 0.6);
	env = EnvGen.kr(Env.perc(2, 2, 0.5, -3), 1, 1, 0, 10, 2);
	son = son * env;
	Out.ar(out, Pan2.ar(son * amp))
}).add;

SynthDef(\grano, {
	|out 0, amp 0.3, freq 560, wSize 0.1, pR 1.004, pD 0.008, tD 0, na 0, no 0|
	var mod, son, gran, noise, envnoise, env;
	mod = LFPulse.ar(freq * 4, 0.5);
	son = SelectX.ar(SinOsc.ar(na), [LFTri.ar(freq / 2, 0.5) * mod, mod], 1);
	gran = PitchShift.ar(son, wSize, pR, pD, tD, amp);
	son = son * gran;
	noise = PinkNoise.ar(no);
	envnoise = EnvGen.kr(Env.asr(0.001, 0.2, 1), 1);
	noise = noise * envnoise;
	son = HPF.ar(son, 200);
	son = LPF.ar(son, 1000);
	son = son + noise;
	env = EnvGen.kr(Env.adsr(0.2, 0.3, 0.8, 1), 1, doneAction:2);
	son = son * env;
	Out.ar(out, Pan2.ar(son * amp));
}).add;

SynthDef(\fondo, {
	|out 0, amp 0, fm 349|
	var son, mod, env;
	mod = LFPulse.ar(fm * 2, 0.5, amp);
	son = PinkNoise.ar(0.3) *  mod;
	env = EnvGen.kr(Env.adsr(0.2, 0.3, 0.8, 1), 1, doneAction:2);
	son = son * env;
	son = HPF.ar(son, 200);
	son = LPF.ar(son, 1000);
	Out.ar(out, Pan2.ar(son * amp));
}).add;

SynthDef(\ruido, {
	|out 0, amp 0.15, nota 77, freq 456, dis 460|
	var semitono, mod, son, env;
	semitono = (nota + [0, 1]).midicps;
	mod = SinOsc.ar(semitono, 0.5, 0.6);
	son = ((mod * Pulse.ar(semitono[0], 0.2, 0.5)) + (LFTri.ar(semitono[1], 0.2, 0.5) * mod) +
		LFNoise0.kr(freq, 0.2)) * SinOsc.ar(LFNoise0.kr(6, freq, 256), 0.1, 3) * mod +
	    SinOsc.ar((dis/5), 0.2, 0.3) + Blip.ar(nota.midicps, Line.kr(1, 36, 18), 0.5);
	env = EnvGen.kr(Env.perc(2, 1, 0.5, -3), 1, 1, 0, 5, 2);
	son = son * env;
	Out.ar(out, Pan2.ar(son * amp));
}).add;

SynthDef(\estfm, {
	|out 0, amp 0.7, freq 349, fm 1.5|
    var est, mod, env, son;
    est = Decay2.ar(Impulse.ar(0), 0.01, 4) * LPF.ar(WhiteNoise.ar(amp + 0.2), freq * 4);
    mod = SinOsc.ar(freq + SinOsc.ar(freq * fm, 0, freq * 0.5), 0, amp * 0.4);
    env = EnvGen.kr(Env.asr(0.5, 1, 2), doneAction: 2);
    son = (est + mod) * env;
    son = FreeVerb.ar(son, 0.5, 0.7, 0.6);
    Out.ar(out, Pan2.ar(son));
}).add;


// Timbre del bajo //

SynthDef(\bass, {
    |out 100, amp -6, freq 60|
    var son, env;
    son = LFPulse.ar(freq, 0, 0.5) + SinOsc.ar(freq * 2, 0, 0.3);
    son = LPF.ar(son, 500);
    son = son.distort;
    env = EnvGen.kr(Env.perc(0.01, 1), 1, doneAction:0);
	son = son * env;
	Out.ar(out, Pan2.ar(son * dbamp(amp), 0));
	DetectSilence.ar(son, 0.0001, 1.5, 2);
}).add;


// Timbre del piano //

SynthDef(\piano, {
	|out 100, amp -6, freq 440|
	var mod, son, env;
	mod = SinOsc.ar(freq * 4, 0.5, 0.4);
	son = LFSaw.ar(freq, 0.5) * mod;
	son = HPF.ar(son, 200);
	son = LPF.ar(son, 4000);
	env = EnvGen.kr(Env.perc(0.05, 1), 1, doneAction:0);
	son = son * env;
	Out.ar(out, Pan2.ar(son * dbamp(amp), -0.7));
	DetectSilence.ar(son, 0.0001, 4, 2);
}).add;


// Timbre del saxofón //

SynthDef(\sax, {
	|out 100, amp -6, gate 1, freq 440, vibA 0.01, vibF 5.0, filT 0.01, bw 2, atk 0.2, rel 1.5|
	var num, harms, son, env;
	num = 16;
	harms = Array.series(num, 1, 1) * Array.exprand(num, 0.995, 1.001);
	son = SinOsc.ar(freq * SinOsc.kr(Rand(1.0, vibF), 0, Rand(0.001, vibA), 1) * harms, mul:Array.geom(num, 1, 0.63));
	son = Splay.ar(son);
	son = BBandPass.ar(son, freq * XLine.kr(0.1,4,filT), bw);
	env = EnvGen.kr(Env.perc(atk, rel), 1, doneAction:0);
	son = son * env;
	son = HPF.ar(son, 150);
	son = LPF.ar(son, 6000);
	Out.ar(out, Pan2.ar(son * dbamp(amp), 0.7));
	DetectSilence.ar(son, 0.0001, 4, 2);
}).add;


// Timbre para las armonías de fondo //

SynthDef(\colchon, {
	|out 0, freq 440, amp 0.2|
    var son, env, reverb, hammer, body;
	hammer = Decay2.ar(Impulse.ar(0), 0.01, 0.1) * (amp * 0.5);
    body = SinOsc.ar(freq * [1, 2], 0, amp * 0.2);
	son = Mix(hammer + body);
    env = EnvGen.kr(Env.perc(0.01, 5), doneAction: 2);
	son = son * env;
    reverb = FreeVerb.ar(son, 0.3, 0.6, 0.7);
    son = Pan2.ar(reverb);
    Out.ar(out, son);
}).add;


// Reproducir sample de batería //

SynthDef(\ritmo, {
	|out 0, amp 1|
    Out.ar(0, PlayBuf.ar(2, ~ritm, BufRateScale.kr(~ritm)) * amp);
}).add;


// Reproducir sample de Polyphonic Theme I //

SynthDef(\zzz,{
	|out 0, amp 0.8, wSize 0.3, pR 1.03, pD 0, tD 0, rate 1, start 0|
	var son, gran, env;
	son = PlayBuf.ar(2, z, rate, 1, start);
	gran = PitchShift.ar(son, wSize, pR, pD, tD, amp);
	env= EnvGen.ar(Env.asr(0.0001, amp, 1), 1, doneAction:2);
	Out.ar(out, Pan2.ar(gran * env * amp, LFDNoise1.ar(0.7, 1, 0)));
}).add;