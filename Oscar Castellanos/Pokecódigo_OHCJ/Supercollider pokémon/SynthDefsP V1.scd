
//SCLOrkSynths.load;

//Sinte Pokémon

//Este es un sample que al final no se utilizo y pertenece a la introducción del videojuego Pokemon XY.

~bof = Buffer.read(s, "C:/Users/Alienware/Documents/Supercollider pokémon/Pokémon-X-and-Y-Title-Theme.wav");
// b = ~bof.play

//LFNoise0.kr(rit, 0.5, 0.5),1); intercambiable con pos,1));
SynthDef (\buff, {|amp = 0.5, buf = 0, rate = 1, rit = 1, pos = 0|
	var sound, env, paneo;
	sound = Mix(PlayBuf.ar(2, buf, Line.kr(1, 1, 7)*[1,2],1,
		BufFrames.kr(buf) * pos,1)+(PlayBuf.ar(2, buf, 1, 1, BufFrames.kr(buf) * LFNoise0.ar(1,0.5,0.5),0)));
	paneo = Pan2.ar (sound, MouseX.kr(-1.0,1.0,0), amp);
	env = EnvGen.kr(Env.adsr(30.0,3.0,20,30),doneAction:2);
	Out.ar(0, paneo*env);
}).add;


// b = Synth(\buff, [\buf, ~bof])
//b.free


//Un synth de ruido blanco para hacer pruebas con los samples, desgraciadamente no tuvo oportunidad de ser usado.

SynthDef(\RuidoBlanco, {
    |out = 0, amp = 0.1|
    var signal, env;
	signal = WhiteNoise.ar(0.5);
	env = EnvGen.kr(Env.adsr(20.0,3.0,2,15),doneAction:2);
    signal = signal * amp;
    Out.ar(out, signal*env);

}).add;

// g = Synth(\RuidoBlanco, [\amp, 0.1]);
// g.free



//Mi synthdef favorito que lamentablemente no encontró cabida en esta pieza.

SynthDef(\inicio,
	{|freq = 312, amp = 1, out = 0|
	var osc, paneanismo, env;
		osc = Blip.ar(freq,MouseY.kr(1,100,1),0.3);
		paneanismo = Pan2.ar (osc, MouseX.kr(-1.0,1.0,0), amp);
		env = EnvGen.kr(Env.perc(8.0,12.0),doneAction:2);
		Out.ar(out, paneanismo*env)
}).add;

/*a = Synth(\inicio)
a.free*/

// ({PlayBuf.ar(2, ~bof, 1, Impulse.kr(0.5), ~bof.numFrames * LFNoise0.ar(1,0.5,0.5),0)}.play)



//Otro synth interesante que no tuvo lugar en la pieza.

SynthDef(\IntroTheme, {|buf, amp = 0.5, rate = 1, start = 0, loop = 1, out = 0|
    var sig, env, modRate, modAmp, pan, modPan, startPos;
    startPos = TIRand.kr(0, BufFrames.ir(buf) - 44100);
    modRate = LFNoise1.kr(0.3).range(0.8, 1.2);
    sig = PlayBuf.ar(2, buf, rate * modRate, 1, startPos, loop);
    modAmp = LFNoise1.kr(0.1).range(0.4, 0.9);
    env = EnvGen.kr(Env.perc(0.1, 1), doneAction: 2);
    modPan = LFNoise1.kr(0.5).range(-1, 1);
    pan = Pan2.ar(sig * modAmp * env * amp, modPan);
    Out.ar(out, pan);
}).add;


//Y finalmente están estos 3 synthDefs hechos para imitar el sonido 8bits de los primeros videojuegos de pokemon, se diferencian en duración y nombre por que tienen diferentes usos planeados.


SynthDef(\synth8bit, { |out = 0, freq = 440, amp = 0.5, pulseWidth = 0.5, bitDepth = 4, pan = 0, legato|
    var sig, env, crushedSig, quantizedSig;
    sig = Pulse.ar(freq, pulseWidth);
    quantizedSig = sig * (2 ** bitDepth - 1);
    quantizedSig = quantizedSig.round;
    quantizedSig = quantizedSig / (2 ** bitDepth - 1);
    env = EnvGen.kr(Env.perc(0.01, legato), doneAction: 2);
    sig = quantizedSig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;


(SynthDef(\synth8bitchords, { |out = 0, freq = 440, amp = 0.5, pulseWidth = 0.5, bitDepth = 4, pan = 0|
    var sig, env, crushedSig, quantizedSig;
    sig = Pulse.ar(freq, pulseWidth);
    quantizedSig = sig * (2 ** bitDepth - 1);
    quantizedSig = quantizedSig.round;
    quantizedSig = quantizedSig / (2 ** bitDepth - 1);
    env = EnvGen.kr(Env.perc(1, 4.2), doneAction: 2);
    sig = quantizedSig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add);


SynthDef(\synth8bitbass, { |out = 0, freq = 440, amp = 0.5, pulseWidth = 0.5, bitDepth = 4, pan = 0|
    var sig, env, crushedSig, quantizedSig;
    sig = Pulse.ar(freq, pulseWidth);
    quantizedSig = sig * (2 ** bitDepth - 1);
    quantizedSig = quantizedSig.round;
    quantizedSig = quantizedSig / (2 ** bitDepth - 1);
    env = EnvGen.kr(Env.perc(0.4, 2.2), doneAction: 2);
    sig = quantizedSig * env * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;












