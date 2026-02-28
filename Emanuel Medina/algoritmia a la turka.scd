"SYNTHS"

(
SynthDef(\Feedback, {arg freq = 440, cutoff = 14800, fb = 0.2, res = 0.8, amp = 0.1,  out = 0, gate = 1, pan = 0, release = 0.2, atk = 0.1, dec = 0.2;
	var env, sig;
	// envolvente adsr
	env = EnvGen.kr(Env.adsr(atk, dec, 0.1, release), gate, doneAction:2);
	// onda de sierra
	sig = SinOscFB.ar(Vibrato.kr(freq,5.5,0.009), fb);
	// filtro: RLPF es Resonant Lowpass Filter (checar su página de ayuda):
	// sus argumentos son: input, frecuencia de corte y resonancia
	sig = RLPF.ar(sig, cutoff, res);
	// finalmente sacamos la señal y la paneamos con Pan2
	Out.ar(out, Pan2.ar(sig * env * amp * 0.4, pan));
}).add;


SynthDef(\Punsante, {arg freq = 440, cutoff = 1000, fb = 0.5, res = 0.8, amp = 1,  out = 0, gate = 1, pan = 0, pw = 0.6, release = 1.4, vvel = 0.5, dep = 0.007, atq=0.01,revmix = 0.3, dec = 0.5;
	var env, sig, dry, wet, totalEnv, hasFreq;
	// envolvente adsr
	env = EnvGen.kr(Env.adsr(atq , dec, 0.1, release), gate, doneAction:2);
	// onda de sierra


    totalEnv = EnvGen.kr(Env.adsr(atq, 0.5, 0.1, release * 2), gate, doneAction: 2);
	sig = Pulse.ar(Vibrato.kr(freq, vvel, dep), pw );
	// filtro: RLPF es Resonant Lowpass Filter (checar su página de ayuda):
	// sus argumentos son: input, frecuencia de corte y resonancia
	sig = RLPF.ar(sig, cutoff, res);

	dry = Pan2.ar(sig * env * amp * 1, pan);

	wet= FreeVerb.ar(dry, 1.0, 1, 0,0.6, 0.0);

	wet = (wet * revmix) * totalEnv;
    dry = dry * (1 - revmix) * totalEnv;


	// finalmente sacamos la señal y la paneamos con Pan2
	Out.ar(out,dry + wet);
}).add;


SynthDef(\bass, {arg freq = 440, cutoff = 1000, fb = 0.5, res = 0.9, amp = 0.5,  out = 0, gate = 1, pan = 0, pw = 0.6, release = 0.02, vvel = 0.5, dep = 0.007, dec = 0.1;
	var env, sig;
	// envolvente adsr
	env = EnvGen.kr(Env.adsr(0.01, dec, 0.02, release), gate, doneAction:2);
	// onda de sierra
	sig = Pulse.ar(Vibrato.kr(freq, vvel, dep), pw );
	// filtro: RLPF es Resonant Lowpass Filter (checar su página de ayuda):
	// sus argumentos son: input, frecuencia de corte y resonancia
	sig = RLPF.ar(sig, cutoff, res);
	// finalmente sacamos la señal y la paneamos con Pan2
	Out.ar(out, Pan2.ar(sig * env * amp * 1.3, pan));
}).add;


SynthDef(\snare  , {arg out = 0, amp = 0.9, att = 0.001, rel = 0.6, ffreq = 2000, pan = 0;
	var env, snd;
	env =  Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp).kr(doneAction: 2);
	snd =  WhiteNoise.ar(
		mul: env,
		add: 0);
	snd = RLPF.ar(
		in: snd,
		freq: ffreq,
		rq: 0.97,
		mul: 0.4,
		add: 0);
	Out.ar(out, Pan2.ar(snd * amp, pan));
}).add;

SynthDef(\moth_snare,
{
|carfreq=200,mod1freq=600,mod1amt=8,mod2freq=400,mod2amt=0.9,mod3freq=200,mod3amt=0.8,jump=10,amp=0.1,out=0,pan=0,att=0.02,attCurve=2,dec=0.1,decCurve=
-3,noiseHpfFreq=440,boost=5,overallHpfFreq=500|
var env, car, mod1, mod2, mod3, beatEnv, noise, noiseEnv, audio;
env = EnvGen.kr(Env([0,1,0],[att,dec],[attCurve,decCurve]),1,amp);
beatEnv = EnvGen.kr(Env([0,1,0],[0.005,0.02],[1,-2]),1,carfreq*jump);
//beat = LFTri.ar(freq + beatEnv, 0, env);
mod3 = SinOsc.ar(mod3freq,0,mod3amt);
mod2 = SinOsc.ar(mod2freq + (mod2freq * mod3), 0, mod2amt);
mod1 = SinOsc.ar(mod1freq + (mod1freq * mod2), 0, mod1amt);
car = SinOsc.ar(carfreq + (carfreq * mod1) + beatEnv, 0, env);
noiseEnv = EnvGen.kr(Env([0,1,0],[0.04,0.25],[-3,-9]),1,amp,doneAction:2);
noise = WhiteNoise.ar(noiseEnv);
noise = HPF.ar(noise,noiseHpfFreq);
audio = car + noise;
audio = (audio * boost).tanh / boost * amp;
audio = HPF.ar(audio,overallHpfFreq);
audio = Pan2.ar(audio,pan);
Out.ar(out,audio);
}
).add;

SynthDef(\hihat2, {arg out = 0, amp = 0.91, att = 0.001, rel = 0.1, ffreq = 5000, pan = 0;
	var env, snd;
	env =  Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp).kr(doneAction: 2);
	snd =  Crackle.ar(1.9,
		mul: env,
		add: 0);
	snd = RHPF.ar(
		in: snd,
		freq: ffreq,
		rq:0.7,
		mul: 10,
		add: 0);
	Out.ar(out, Pan2.ar(snd * amp, pan));
}).add;


SynthDef(\Formant, {arg freq = 440, cutoff = 1000, for = 5000, bfor = 5000, res = 0.7, amp = 0.7,  out = 0, gate = 1, pan = 0, release = 0.21, attk = 0.01;
	var env, sig;
	// envolvente adsr
	env = EnvGen.kr(Env.adsr(attk, 0.2, 0.1, release), gate, doneAction:2);
	// onda de sierra
	sig = Formant.ar(Vibrato.kr(freq,3,0.01), for, bfor);
	// filtro: RLPF es Resonant Lowpass Filter (checar su página de ayuda):
	// sus argumentos son: input, frecuencia de corte y resonancia
	sig = RLPF.ar(sig, cutoff, res);
	// finalmente sacamos la señal y la paneamos con Pan2
	Out.ar(out, Pan2.ar(sig * env * amp * 1, pan));
}).add;
)


//armonia

(
~armonis = [
	[0,11,7, 16 ], [5, 28, 21,12], [9, 16, 17, 24, 31],[4, 19, 11, 16],
	[0, 7, 5, 14],[ 26, 21, 17, 5], [16,4,19,23], [2, 9,5, 12, 16 ],[0, 12, 21, 16 ],
	[19, 5, 9, 12 ]];

~armonis3 = [
	[0, 2, 7], [7, 12 ,14], [2, 7 ,9],[9, 17, 12, 21], [0, 9 , 4 , 12 ],  [21, 14, 7 ], [21, 17, 12 ]];

~armonis3S =
[0, 2, 7, 12 ,9, 17, 21 ,4 , 14, ];

	~armonis2 = [
	[0, 7, 9, 14, 16, 23];


~armoniaIntro =	[[0, 2],[ 7 , 4],[ 7, 12 ],[14 ,2],[ 7, 9],[ 9, 17], [12, 21],[ 0, 9 ],[ 4 , 12]];



];
~tres4 = [5, 0, 3, 1, 4, 2];
~seis8 = [5, 0, 2, 4, 1, 3];
~leg34 = (~tres4 / 10) + 0.1;
~leg68 = (~seis8 / 10) + 0.1;
~db681 = [-6, -30, -12, -8, -10, -18];
~db341 = [-6, -30, -10, -20, -8, -12];

~db98 = [-6, -20, -8, -20, -6, -20, -6, -20, -22, -6, -20, -8, -20, -6, -20, -6, -20, -22,
	-6, -20, -8, -20, -6, -20, -6, -20, -22, -6, -20, -22,-6, -20, -22,-6, -20, -22,
];

~fb98 = [0.6, 0.2, 0.6, 0.1, 0.6, 0.1, 0.7, 0.3, 0.1, 0.6, 0.2, 0.6, 0.1, 0.6, 0.1, 0.7, 0.3, 0.1, 0.6, 0.2, 0.6, 0.1, 0.6, 0.1, 0.7, 0.3, 0.1
];

~db34  = -28 +(~tres4 * 2);
~db68 = -28 + (~seis8 * 2);

t = TempoClock(160/60);
t.permanent = true;
)

//PBIND//

(
~introSynth = Pbind(
	\instrument,\Feedback,
	\degree, Prand(~armoniaIntro,inf).trace,
	\scale, Scale.chromatic,
	\strum, Pwrand([0.0, 1], [0.10, 0.9], inf),
   \octave, Pn(Pwhite(4, 5), Pwhite(5, 22)),
	\dur, 0.5,
//\cutoff, Pwhite(300.0, 3000),
	//\res, 0.0,
	\release, 0.1,
	\db,  Pseq(~db98 , inf),
	\pw, Pwhite(0.1,1,inf),
	\pan, 0,



);

~bass1  = Pbind(
   \instrument,\bass,
	\degree, Prand(~armonis3S,inf),
	\scale, Scale.chromatic,
    \octave, 5,
	\dur, 0.5,
	\release, 0.01,
	\legato, 1,
	\db,  Pseq(~db98 , inf),
	\pw, Pwhite(0.1,1,inf),
	\res, 0.9,
	\cutoff, Pwhite(500, 600, inf),
	\amp, 0.2,

);


~introPulse = Pbind(
	\instrument, \Punsante,
	\degree, Prand(~armonis3S,inf).trace,
	\scale, Scale.chromatic,
	\strum, Pwrand([2, 4], [0.10, 0.9], inf),
   \octave, Pn(Pwhite(5, 6), Pwhite(5, 22)),
	\dur, Pwrand([0.5,Rest(0.5)],[0.70,0.30],inf),
	\vvel, Pwrand([1,8,4],[0.4,0.3,0.3],inf),
	\dep, Prand([0.007,0.001,0.009],inf),
	\release, 1.8,
    \root, 0,
	\cutoff, Pwhite(3000, 4000),
	//\res, 0.0,
	\db,  Pseq(~db98 , inf),
	\pw, Pwhite(0.1,1,inf),
	);

~introFormant = Pbind(
	\instrument, \Formant,
	\degree, Prand(~armonis3S,inf).trace,
	\scale, Scale.chromatic,
	\strum, Pwrand([2, 4], [0.10, 0.9], inf),
   \octave, Pn(Pwhite(5, 6), Pwhite(5, 22)),
	\dur, Pwrand([0.5,Rest(0.5)],[0.60,0.40],inf),
	\vvel, Pwrand([1,8,4],[0.4,0.3,0.3],inf),
	\dep, Prand([0.007,0.001,0.009],inf),
	\release, 1.8,
    \root, 0,
    \cutoff, Pwhite(300.0, 3000),
	//\res, 0.0,
	\db,  Pseq(~db98 , inf),
	\pw, Pwhite(0.1,1,inf),
	  \for, Pwhite(3000, 4000),
	\bfor,Pwhite(3000, 9000),
	\pan, Pif(Pfunc{|e| e.strum == 0}, 0, Prand([-1.0, 1], inf))

);
~sinte = Pbind(
	\instrument, Pwrand([\Feedback, \Punsante, \Formant ],  [0.5,  0.3, 0.2 ], inf).trace,
	\degree, Pif(Pfunc{|e| e.instrument == \Feedback}, Prand(~armonis3S,inf),Prand([0,7,9,4,2],inf)).trace,
	\scale, Scale.chromatic,
	\strum, Pwrand([0.0, 0.50], [0.5, 0.5], inf),
   \octave, Pn(Pwhite(5, 6), Pwhite(5, 22)),
	\dur, 0.5,
	\for, Pwhite( 500,2000,inf),
	\bfor,Pwhite(3000, 9000),
	\release, Prand([0.09, 0.2,0.1],inf),
    \root, 0,
	\fb, 2,
	\atk, 0.01,
    //\cutoff, Pwhite(400, 500),
	\res, 0.1,

	\db,  Pseq(~db98 , inf),
	\pw, Pwhite(0.1,1,inf),
	\pan, Pif(Pfunc{|e| e.strum == 0}, 0, Prand([-1.0, 1], inf)),
	\fb, Prand([1.3,0.3,0.7,0.5],inf),
);

~hihat1 = Pbind(
	\instrument,\hihat2,
	\scale, Scale.chromatic,
		\dur, Pwrand([0.5,Rest(0.5)],[0.85,0.15],inf),
\db,  Pseq(~db98 , inf),
	\strum, Pwrand([0.0, 0.50], [0.80, 0.20], inf),
	\octave, Pwrand([4,5], [0.70, 0.30], inf),
    \pan, 0.5,
		\rel, Pwrand([0.2,0.7,0.1,0.4],[0.2,0.2,0.4,0.2],inf),
		\ffreq, Pwhite(3000, 5000,inf),
	);

	~snare2 = Pbind(
	\instrument,\moth_snare,
	\scale, Scale.chromatic,
    \dur, Prand([0.5,Rest(0.5),Rest(0.5),0.5,Rest(0.5),0.5,Rest(0.5),0.5,0.5],inf),
    \db, Pseq(~db98 , inf),
        \pan, -0.3,
		\rel, Pwrand([0.2,0.7,0.3],[0.4,0.2,0.4],inf),

	);
)



//PBINDF//
(
~introsynthf = Pbindf(~introSynth,
		\instrument,\Feedback,
		\strum, 0,
		\octave,4,
		\fb, Pseq(~fb98,inf),

);

~outrosynthf = Pbindf(~introsynthf,
		\instrument,\Feedback,
		\degree,Pdup(Pseq([6,1,1,1,6,1,1,1,6,1,1,1,1,1,1,1,1,1,1,1,1],inf),Pxrand(~armonis,inf)),

);

~introsynthf2 = Pbindf(~introSynth,
        \instrument,\Feedback,
		\strum, 0,
		\fb, Pseq(~fb98,inf),
	    \degree, Pxrand(~armonis3,inf).trace,
		\octave,5,
	);

~introsynthf3 = Pbindf(~introsynthf2,

		\strum, 0,
	\octave,Prand([4,5],inf),
	\vvel, Pwrand([1,8,4],[0.4,0.3,0.3],inf),
	\dep, Prand([0.007,0.01,0.2],inf),


);

~sintem = Pbindf(~sinte,
	\instrument, Pwrand([\Feedback, \Punsante, ],  [0.3,  0.7 ], inf).trace,
	\degree, Prand([0,11,7, 16 ,5, 28,21,12, 9, 17, 24, 31, 4, 16],inf),
	\cutoff, Pwhite(500,4000,inf),
	\res,0.4,
	\attk,0.02,
	\atq,0.1,
	\vvel, Pwrand([1,8,4],[0.4,0.3,0.3],inf),
	\dep, Prand([0.007,0.001,0.009],inf),
	\pw, Prand([0.9,0.8,1],inf),
    \strum,0,
	\revmix, 0.7,
	\amp, 0.61,

);

~sintep = Pbindf(~sinte,
	\instrument, \Punsante,
	\cutoff, Pwhite(3000,4000,inf),
	\res,0.4,
	\attk,0.02,
	\atq,0.1,
	\pw, Prand([0.9,0.8,1],inf),
	\dur, 0.5,
	\strum,  0,
	 \db, Pseq(~db98 , inf),
	\vvel, Pwrand([1,8,4],[0.4,0.3,0.3],inf),
	\dep, Prand([0.007,0.001,0.009],inf),
	\pan,0,
	\revmix, 0.7,
	\amp, 0.9,

);

~sintemf = Pbindf(~sinte,
	\instrument, \Formant,
	\cutoff, Pwhite(500,2000,inf),
	\res,0.4,
	\attk,0.02,
	\atq,0.1,
	\amp, 0.3,

);



~introFeed = Pbindf(~introFormant,
    \instrument,\Feedback,
	\octave,Prand([4,6],inf),
	\atk,Prand([0.1,0.03],inf),
	\fb, 0.8,

);

~introPulse2 = Pbindf(~introPulse,
	\degree, Prand(~armonis3,inf).trace,
	 \octave, Pn(Pwhite(4, 6), Pwhite(5, 22)),
	\release, Prand([2.7,1.8,0.5],inf),
	\pan, Prand([-0.5, 0.5], inf)
);


~sinte2 = Pbindf(~sinte,
	 \degree, Pif(Pfunc{|e| e.instrument == \Feedback}, Prand(~armonis,inf),Prand([0,7,9,4,2],inf)).trace,
	\release, Prand([1.5,1.8,1],inf),
	\pan, Pif(Pfunc{|e| e.strum == 0}, 0, Prand([-1.0, 1], inf))
);

	~sintef = Pbindf(~sinte,
	\instrument,\Feedback,
	\degree, Prand(~armonis,inf),
	\strum, Prand([0.02,0],inf),
	\octave,5,
	\atk, 0.02,
	\cutoff, 10000,
	\release, Prand([0.5,1.8,1],inf),
	\pan, Pif(Pfunc{|e| e.strum == 0}, 0, Prand([-1.0, 1], inf))


);

~sintef2 = Pbindf(~sintef,
	\degree, Prand(~armonis3,inf),
	\octave,6,
    \cuttoff,5000,
	\fb, 0.4,




);

~sinte3 = Pbindf(~sinte2,
\degree, Prand(~armonis,inf).trace,
	  \cuttoff,10000,
);

~introPulse3 = Pbindf(~introPulse,
	\release, Prand([0.1, 0.7,0.4,1,1.2],inf),
	\degree,Pdup(Pseq([2,2,2,1,1,1,2,2,2,1,1,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1],inf),Pxrand(~armonis3S,inf)),
	\dur, 0.5,
	\strum,0 ,
	\octave,6 ,
	\pan, 0,
	\db,  Pseq(~db98 , inf),
	\amp, 0.9,
);

~outroPulse3 = Pbindf(~introPulse3,
	\degree,Pdup(Pseq([2,2,2,1,1,1,2,2,2,1,1,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1],inf),Pxrand([0,2,4,7,9],inf)),
	\octave,7,
	\vvel, Pwrand([1,8,4],[0.4,0.3,0.3],inf),
	\dep, Prand([0.007,0.001,0.009],inf),
	\release, Prand([1.9, 2.4,0.4,1,1.2],inf),
	\cutoff, Pwhite(1000,2000,inf),
	\dec, Pwrand([0.5,1.5],[0.7,0.3],inf),
	\revmix, 0.5,
);



~sinteFull = Pbindf(~sinte,
	\instrument, Pwrand([\Feedback, \Punsante, \Formant ],  [0.7,  0.15, 0.15 ], inf).trace,
	\degree, Pif(Pfunc{|e| e.instrument == \Feedback}, Prand(~armonis,inf),Prand([0,7,9,4,2],inf)).trace,
	\release, Prand([0.01, 0.5,0.1,1.5,1,2.5],inf),
	\octave, Pn(Pwhite(4, 6), Pwhite(5, 22)),
	  \cuttoff,10000,
);

~sinteFull2 = Pbindf(~sinteFull,
	\degree, Prand(~armonis,inf),
	\strum, Pwrand([0.5 ,1],[0.6,0.4],inf),
);

~hihat2 = Pbindf(~hihat1,
\dur,0.5,

);

~outroPulse2 = Pbindf(~introPulse2,
	\degree, Prand(~armonis,inf).trace,
	\strum, 0,
	\dur, 0.5,
	\atq, 0.02,
	\release, 0.15,
	\pan,0,
	\octave, 5,

);
~outrofeed3 = Pbindf(~introPulse2,
	\instrument, \Feedback,
	\degree, Prand([0,11,7, 16 ,5, 28,21,12, 9, 17, 24, 31, 4],inf),
	\atk, 0.01,
	\release, 2.5,
	\fb, 0.5,
	\strum, Prand([0.02,1],inf),
	\dur, 0.5,
	\octave, Pwrand([5,6],[0.7,0.3],inf),
	\dec, 0.5,
);
	~bass2  = Pbind(
   \instrument,\bass,
	\degree, Prand([0,2,11,7, 16 ,5,12, 4],inf),
	\release,0.1,
	\octave, 3,
	\dec, 0.2,
	\dur,0.5,
	\db,  Pseq(~db98 , inf),
);


~sintealt = Pbindf(~sinte,
\octave, Pn(Pwhite(5, 6), Pwhite(5, 22)),

);
)

//la pieza
(
n = Ptpar([0,~introsynthf.finDur(18),18,~introsynthf2.finDur(18),36,~snare2.finDur(216),36,~introsynthf.finDur(18),54,~introsynthf2.finDur(18),72,~hihat1.finDur(72),72,~introFormant.finDur(144),72,~introsynthf3.finDur(211.5),144,~introPulse.finDur(72),216,~introPulse2.finDur(60),252,~introPulse3.finDur(36),288,~bass1.finDur(72),288,~sintemf.finDur(72),288,~sintem.finDur(72),216,~hihat2.finDur(72),288,~sintef2.finDur(72),360,~sintef.finDur(36),396,~sinteFull.finDur(72),396,~hihat2.finDur(180),396,~snare2.finDur(180),468,~sinteFull2.finDur(108),468,~bass2.finDur(108),468,~outrosynthf.finDur(108),576,~outrosynthf.finDur(4.5),580.5,~outroPulse2.finDur(4.5),585,~outrosynthf.finDur(4.5),589.5,~outroPulse2.finDur(4.5),594,~outrosynthf.finDur(4.5),598.5,~outroPulse2.finDur(4.5),603,~outrosynthf.finDur(4.5),607.5,~sintep.finDur(40.5),607.5,~outroPulse2.finDur(4.5),607.5,~hihat2.finDur(40.5),612,~outrofeed3.finDur(72.5),612,~snare2.finDur(36),612,~bass2.finDur(36),612,~outrosynthf.finDur(4.5),616.5,~outroPulse2.finDur(4.5),621,~outrosynthf.finDur(4.5),625.5,~outroPulse2.finDur(4.5),630,~outrosynthf.finDur(4.5),634.5,~outroPulse2.finDur(4.5),639,~outrosynthf.finDur(4.5),643.5,~outroPulse2.finDur(4.5),648,~outrosynthf.finDur(36),648,~outroPulse3.finDur(36.5)]).play(t)

)




//pruebas, no ejecutar
,612,~outrosynthf.finDur(4.5),616.5,~outroPulse2.finDur(4.5),621,~outrosynthf.finDur(4.5),625.5,~outroPulse2.finDur(4.5),630,~outrosynthf.finDur(4.5),634.5,~hihat2.finDur(4.5),639,~outroPulse2.finDur(4.5),


180,~sinte.finDur(72),216,~hihat1.finDur(108),252,~sinte2.finDur(72),324,~sinte3.finDur(72),324,~hihat2.finDur(72)

q = ~sinteFull2.play(t)
d = ~sustra.stop

Klang
q = Ptpar([0.0,~outrosynthf.finDur(4.5),589.5,~outroPulse2.finDur(4.5),594,~outrosynthf.finDur(4.5),598.5,~outroPulse2.finDur(4.5),603,~outrosynthf.finDur(4.5),607.5,~outroPulse2.finDur(4.5)]).play(t)
v v
 \cutoff, Pwhite(400, 500)
