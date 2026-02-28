s.options.numOutputBusChannels = 8

~numCan = 8;

//////Synths
(
SynthDef(\mar_profundo, {|amp 1, freqD 5000, freqS 1, freqPan 0.1|
	var son;
	son = OnePole.ar(GrayNoise.ar(0.16)+Dust.ar(freqD, 0.5), 0.96);
	son = son + Splay.ar(FreqShift.ar(son, freqS/(4..7)));
	son = son * Lag.kr(amp, 0.5);
	son = Mix(son);
	Out.ar(0, PanAz.ar(~numCan, son, LFNoise2.kr(freqPan, 1, 1 )))
}).add;



SynthDef(\ola_salvaje, {|amp 1|
	var son, bpf, pan;
	son = WhiteNoise.ar(
		mul: 0.14,
		add: 0.1);
	bpf = LPF.ar(in: son, freq: SinOsc.kr(9/120).range(500, 1800));
	pan = SinOsc.kr(9/120).range(-0.2, 0.2);
	Out.ar(0, Pan2.ar(bpf, pan))
}).add;


SynthDef(\ola_salvaje2, {|amp 1, release 3|
	var son, bpf, env;
	son = WhiteNoise.ar(
		mul: 0.14,
		add: 0.1);
	bpf = LPF.ar(in: son, freq: SinOsc.kr(9/120).range(500, 1800));
	env = EnvGen.kr(Env.perc(1, release), doneAction:2);
	Out.ar(0, Pan2.ar(bpf*env, 1))
}).add;


SynthDef(\llanto_profundo, {|amp 1, ss 0|
	var son;
	son = RLPF.ar(Dust.ar([300,1110]),LFNoise2.ar([0.9,2.5]).range(200,300),0.022);
	son = SelectX.ar(ss, [son, son.wrap.distort.distort*0.0009]);
	Out.ar(0, Pan2.ar(son, 0))
}).add;


SynthDef(\bell, {
	|freq=1, t60=1, pitchy=1, amp=0.25, gate=1, pos=0|
	var sig, exciter;
	//exciter = Impulse.ar(0);
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = Klank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale:freq*pitchy);
	sig = FreeVerb.ar(sig) * amp;
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(0, PanAz.ar(~numCan, sig, pos));
}).add;


SynthDef(\kalimba, {
    |out = 0, freq = 440, amp = 0.1, mix = 0.1, pos = 0|
    var snd;
    // Basic tone is a SinOsc
    snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.005, Rand(2.5, 3.5), 1, -8), doneAction: 2);
    // The "clicking" sounds are modeled with a bank of resonators excited by enveloped pink noise
    snd = (snd * (1 - mix)) + (DynKlank.ar(`[
        // the resonant frequencies are randomized a little to add variation
        // there are two high resonant freqs and one quiet "bass" freq to give it some depth
        [240*ExpRand(0.9, 1.1), 2020*ExpRand(0.9, 1.1), 3151*ExpRand(0.9, 1.1)],
        [-7, 0, 3].dbamp,
        [0.8, 0.05, 0.07]
    ], PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01))) * mix);
    Out.ar(out, PanAz.ar(~numCan, snd, pos, amp));
}).add;


(
SynthDef(\poemaPlayer, { |buf, amp = 1, pan = 0|
    var sig;

    sig = PlayBuf.ar(
        numChannels: 2,
        bufnum: buf,
        rate: BufRateScale.kr(buf),
        doneAction: 2
    );

    sig = sig * amp;
    sig = Pan2.ar(sig, pan);

    Out.ar(0, sig);
}).add;
)
)
//////Patrones

(
Pdef(\mar_profundo,
	Pmono(\mar_profundo,
		\dur, 0.01,
		\freqD, 5000,
		\freqS, 0.5,
		\amp, Pseg(Array.rand(7, 0.0, 0.7), 1.5, repeats:inf),
	)
);

Pdef(\mar_profundo1,
	Pmono(\mar_profundo,
		\dur, 0.01,
		\freqD, 0,
		\freqS, 0.5,
		\amp, Pseg(Array.rand(7, 0.0, 0.7), 1.5, repeats:inf),
	)
);


Pdef(\ola_salvaje,
	Pmono(\ola_salvaje,
		\dur, 0.01,
	)
);



Pdef(\llanto_profundo,
	Pmono(\llanto_profundo,
		\dur, 0.01,
		\ss, Pseg(Array.rand(7, 0.0, 1), 2, repeats:inf),
		\amp, Pseg(Array.rand(7, 0.0, 0.7), 1.5, repeats:inf),
	)
);
)


//Método para secuenciar secuencias
(
~melodia1=Pseq([28.6,21.2,15], 1);
~melodia2=Pseq([27,22,18,22], 1);
~melodia3=Pseq([24, 26, 28, 27, 24], 1);
~melodia4=Pseq([-5,1.6,8.2,4.4,11], 1);
~melodia5=Pseq([8.2,4.4,8.2,-5,1.6], 1)
)


//Pdefs para rutina
(
Pdef(\bell1,
Pbind(
	\instrument, \bell,
	\scale,Scale.iwato,
		\degree, Prand([~melodia2], inf), \dur,0.5, \amp,Pseq([0.13,0.18,0.199,0.101,0.08],20),\t60, 1, \amp, 0.01, \pos, Pwhite(0.0, 2, inf)));

Pdef(\kalimba1,
Pbind(
	\instrument, \kalimba,
		\degree, Prand([~melodia4,~melodia5], inf), \dur,0.5,\amp, Pseq([0.23,0.14,0.10,0.185,0.06],25),\pos, Pwhite(0.0, 2, inf)));

Pdef(\bell2,
Pbind(
	\instrument, \bell,
		\scale,Scale.iwato,
		\degree, Pseq([~melodia1,~melodia3], 8), \dur,1,\amp,Pseq([0.025,0.021,0.025,0.02],6), \t60, 9,
		\pitchy, 1.5, \pos, Pwhite(0.0, 2, inf)));
)


//Buffers
(
~poemaR = Array.new;
~poemaP = Array.new;
~poemaA = Array.new;
~poemaJ = Array.new;

~folderR = PathName.new("C:/Users/Ricardo/Documents/Audacity/Samples Mar en Duelo/Samples/R");
~folderP = PathName.new("C:/Users/Ricardo/Documents/Audacity/Samples Mar en Duelo/Samples/P");
~folderA = PathName.new("C:/Users/Ricardo/Documents/Audacity/Samples Mar en Duelo/Samples/A");
~folderJ = PathName.new("C:/Users/Ricardo/Documents/Audacity/Samples Mar en Duelo/Samples/J");
)


(
~folderR.entries.do { |path|
	if(path.extension == "wav") {
		~poemaR = ~poemaR.add(Buffer.read(s, path.fullPath));
	}
};

~folderP.entries.do { |path|
	if(path.extension == "wav") {
		~poemaP = ~poemaP.add(Buffer.read(s, path.fullPath));
	}
};

~folderA.entries.do { |path|
	if(path.extension == "wav") {
		~poemaA = ~poemaA.add(Buffer.read(s, path.fullPath));
	}
};

~folderJ.entries.do { |path|
	if(path.extension == "wav") {
		~poemaJ = ~poemaJ.add(Buffer.read(s, path.fullPath));
	}
};
)


//~poemaP.size;  //Para verificar que estén cargados


////RUTINA FINAL
(
r {
	~poemaR.do { |buf|
    Synth(\poemaPlayer, [
          \buf, buf,
          \amp, 1.3,
		  \pan, rrand(-1.0, 1.0)
    ]);
    buf.duration.wait;
};
	3.wait;
	Pdef(\ola_salvaje).play;
    rrand(5.0,10.0).wait;
	Pdef(\mar_profundo).play;
    rrand(8.0, 12.0).wait;
    8.wait;
    Pdef(\llanto_profundo).play;
    rrand(10.0, 16.0).wait;
    Pdef(\mar_profundo1).play;
    rrand(4.0, 6.0).wait;
	10.wait;
	Pdef(\mar_profundo1).stop;
	2.wait;
	Pdef(\ola_salvaje).stop;
	3.wait;
	Pdef(\mar_profundo).stop;
    rrand(9.0, 11.0).wait;
	~poemaP.do { |buf|
    Synth(\poemaPlayer, [
          \buf, buf,
          \amp, 1.4,
          \pan, rrand(-1.0, 1.0)
    ]);
    buf.duration.wait;
};
	Pdef(\llanto_profundo).stop;
	2.wait;
	Pdef(\kalimba1).play;
    2.wait;
	Pdef(\bell1).play;
    4.wait;
	Pdef(\bell2).play;
    15.wait;
	~poemaA.do { |buf|
    Synth(\poemaPlayer, [
          \buf, buf,
          \amp, 1.8,
          \pan, rrand(-1.0, 1.0)
    ]);
    buf.duration.wait;
};
    Pdef(\kalimba2).stop;
	5.wait;
	Pdef(\mar_profundo).play;
	Pdef(\kalimba1).stop;
	5.wait;
    rrand(10.0, 15.0).wait;
    ~poemaJ.do { |buf|
    Synth(\poemaPlayer, [
          \buf, buf,
          \amp, 1.4,
          \pan, rrand(-1.0, 1.0)
    ]);
    buf.duration.wait;
};
	Pdef(\bell2).stop;
	10.wait;
	Pdef(\mar_profundo).stop;
}.play;
)
