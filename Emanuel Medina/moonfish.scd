


//SINTES (ejecutar)//



(
SynthDef(\prayer_bell, { | t_trig = 1, sing_switch = 0, freq = 2434, amp = 0.5, decayscale = 1, lag = 10, i_doneAction = 8, out = 0|
  var sig, input, first, freqscale, mallet, sing;
  freqscale = freq / 2434;
  freqscale = Lag3.kr(freqscale, lag);
  decayscale = Lag3.kr(decayscale, lag);
  mallet = LPF.ar(Trig.ar(t_trig, SampleDur.ir)!2, 10000 * freqscale);
  sing = LPF.ar(
    LPF.ar(
      {
        PinkNoise.ar * Integrator.kr(sing_switch * 0.001, 0.999).linexp(0, 1, 0.01, 1) * amp
      } ! 2,
      2434 * freqscale
    ) + Dust.ar(0.1), 10000 * freqscale
  ) * LFNoise1.kr(0.5).range(-45, -30).dbamp;
  input = mallet + (sing_switch.clip(0, 1) * sing);
  sig = DynKlank.ar(`[
    [
      (first = LFNoise1.kr(0.5).range(2424, 2444)) + Line.kr(20, 0, 0.5),
      first + LFNoise1.kr(0.5).range(1,3),
      LFNoise1.kr(1.5).range(5435, 5440) - Line.kr(35, 0, 1),
      LFNoise1.kr(1.5).range(5480, 5485) - Line.kr(10, 0, 0.5),
      LFNoise1.kr(2).range(8435, 8445) + Line.kr(15, 0, 0.05),
      LFNoise1.kr(2).range(8665, 8670),
      LFNoise1.kr(2).range(8704, 8709),
      LFNoise1.kr(2).range(8807, 8817),
      LFNoise1.kr(2).range(9570, 9607),
      LFNoise1.kr(2).range(10567, 10572) - Line.kr(20, 0, 0.05),
      LFNoise1.kr(2).range(10627, 10636) + Line.kr(35, 0, 0.05),
      LFNoise1.kr(2).range(14689, 14697) - Line.kr(10, 0, 0.05)
    ],
    [LFNoise1.kr(1).range(-10, -5).dbamp,LFNoise1.kr(1).range(-20, -10).dbamp,LFNoise1.kr(1).range(-12, -6).dbamp,LFNoise1.kr(1).range(-12, -6).dbamp,-20.dbamp, -20.dbamp, -20.dbamp,
-25.dbamp, -10.dbamp, -20.dbamp, -20.dbamp, -25.dbamp],
    [20 * freqscale.pow(0.2),20 * freqscale.pow(0.2),5,5, 0.6,0.5,0.3,0.25,0.4,0.5,0.4,0.6] * freqscale.reciprocal.pow(0.5)
  ], input, freqscale, 0, decayscale);
  DetectSilence.ar(sig, doneAction: 2 );
  Out.ar(out, sig*0.3);
}).add;


SynthDef(\amsynth,
			{   | out = 0, freq = 440, freq_modulator = 300, amp = 0.1, amp_modulator = 0.3,
				envlen=0.01, spread=0.5, center=0.0 |
				var carrier = amp*SinOsc.ar(freq);
				var modulator = amp_modulator*SinOsc.ar({freq_modulator});
				var envelope = EnvGen.kr(Env.perc(envlen, 1, 4), doneAction:2);
				Out.ar(out, Splay.ar(envelope*carrier*modulator!2, spread, 1, center));
		}).add;

SynthDef(\clang, {|freq=200,amp=0.1,gate=1,out=0,pan=0,boost=2,tapCarFreq=200,tapModFreq=200, tapPmIndex = 3, tapRatio = 0.5, releaseTime=0.8|
		var audio, chimeEnv, chimeFreqEnv, tap, tapEnv;
		chimeEnv = EnvGen.kr(Env([0,1,0.8,0],[0.001,0.005,releaseTime],[0,-2,-2]), gate, amp, doneAction:2);
		chimeFreqEnv = EnvGen.kr(Env([2,4.3,5],[0.005,0.005],[2,-2]), gate);
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



SynthDef(\risset2, {|out = 0, pan = 0, freq = 400, amp = 0.1, att = 0.01, rel = 0.82, gate = 1|
		var amps = #[1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
		var durs = #[1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
		var frqs = #[0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
		var dets = #[0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];
		var doneActionEnv = EnvGen.ar(Env.linen(0, att+rel, 0), gate, doneAction: 2);
		var src = Mix.fill(11, {|i|
			var env = EnvGen.ar(Env.perc(att, rel * durs[i], amps[i], att.explin(0.005, 4, -4.5, 0)), gate);
			SinOsc.ar(freq*frqs[i] + dets[i], 0, amp*env);
		});
		src = src * doneActionEnv * 0.5; // make sure it releases node after the end.
		Out.ar(out, Pan2.ar(src, pan));
	}).add;




SynthDef(\sustra, {arg freq = 440, cutoff = 2800, res = 0.9, amp = 1,  out = 0, gate = 1, pan = 0, release = 0.82;
	var env, sig;
	// envolvente adsr
	env = EnvGen.kr(Env.adsr(0.001, 0.3, 0.5, release), gate, doneAction:2);
	// onda de sierra
	sig = SinOsc.ar(freq * LFTri.ar(freq * 3.00,0.9,1));
	// filtro: RLPF es Resonant Lowpass Filter (checar su página de ayuda):
	// sus argumentos son: input, frecuencia de corte y resonancia
	sig = RLPF.ar(sig, cutoff, res);
	// finalmente sacamos la señal y la paneamos con Pan2
	Out.ar(out, Pan2.ar(sig * env * amp * 0.8, pan));
}).add;

SynthDef(\sustra2, {arg freq = 440, cutoff = 3800, res = 0.2, amp = 0.1,  out = 0, gate = 1, pan = 0, release = 0.82;
	var env, sig;
	// envolvente adsr
	env = EnvGen.kr(Env.adsr(0.001, 0.3, 0.5, release), gate, doneAction:2);
	// onda de sierra
	sig = SinOsc.ar(freq);
	// filtro: RLPF es Resonant Lowpass Filter (checar su página de ayuda):
	// sus argumentos son: input, frecuencia de corte y resonancia
	sig = RLPF.ar(sig, cutoff, res);
	// finalmente sacamos la señal y la paneamos con Pan2
	Out.ar(out, Pan2.ar(sig * env * amp * 0.8, pan));
}).add;

SynthDef(\hihat, {arg out = 0, amp = 0.13, att = 0.01, rel = 0.1, ffreq = 4000, pan = 0;
	var env, snd;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = WhiteNoise.ar;
	snd = HPF.ar(in: snd, freq: ffreq, mul: env);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

SynthDef(\moth_fm,
	{
		|amp=0.01,out=0,pan=0,carfreq=200,mod1freq=200,mod1amt=0.1,mod2freq=200,mod2amt=0.1,mod3freq=200,mod3amt=0.1,att=0.005,attCurve=0,dec=0.1,decCurve=0,hpfFreq=2000|
		var car, mod1, mod2, mod3, env, audio;
		env = EnvGen.kr(Env([0,1,0],[att,dec],[attCurve,decCurve]),1,amp,doneAction:2);
		mod3 = SinOsc.ar(mod3freq,0,mod3amt);
		mod2 = SinOsc.ar(mod2freq + (mod2freq * mod3), 0, mod2amt);
		mod1 = SinOsc.ar(mod1freq + (mod1freq * mod2), 0, mod1amt);
		car = SinOsc.ar(carfreq + (carfreq * mod1), 0, env);
		car = HPF.ar(car,hpfFreq);
		audio = Pan2.ar(car,pan);
		Out.ar(out,audio);
	}
).add;


SynthDef(\rhodey_sc, {
    |
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.01,
    // all of these range from 0 to 1
    vel = 0.2, modIndex = 0.2, mix = 0.7, lfoSpeed = 0.4, lfoDepth = 0.1
    |
    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    lfoSpeed = lfoSpeed * 12;

    freq = freq * 2;

    env1 = EnvGen.ar(Env.adsr(0.5, 0.01, 0.0, 0.01, curve: \lin));
    env2 = EnvGen.ar(Env.adsr(0.41, 0.01, 0.0, 0.01, curve: \lin));
    env3 = EnvGen.ar(Env.adsr(0.5, 0.01, 0.0, 0.01, curve: \lin));
    env4 = EnvGen.ar(Env.adsr(0.41, 0.01, 0.0, 0.01, curve: \lin));

    osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
    osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
    osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
    osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
    snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

    // using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
    snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;

SynthDef(\hat, { arg amp = 1, startPan = -1, endPan = 1, pitchVariation = 0, release = 0.1;
  var whiteNoise = WhiteNoise.ar(mul: Env.perc(releaseTime: release, curve: -7).kr(doneAction: 2));
  Out.ar(0, Pan2.ar(BBandPass.ar(whiteNoise, freq: pitchVariation, bw: 1), pos: Line.kr(startPan, endPan, 4)) * amp);
}).add;

SynthDef(\hihat2, {arg out = 0, amp = 0.1, att = 0.001, rel = 0.2, ffreq = 12000, pan = 0;
	var env, snd;
	env =  Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp).kr(doneAction: 2);
	snd =  WhiteNoise.ar(
		mul: env,
		add: 0);
	snd = LPF.ar(
		in: snd,
		freq: ffreq,
		mul: 0.4,
		add: 0);
	Out.ar(out, Pan2.ar(snd * amp, pan));
}).add;

SynthDef(\kalimba, {
    |out = 0, freq = 440, amp = 0.1, mix = 0.1|
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
    Out.ar(out, Pan2.ar(snd, 0, amp ));
}).add;

SynthDef(\fm, {
		arg freq=500, mRatio=1, cRatio=1,
		index=1, iScale=5, cAtk=4, cRel=(-4),
		amp=0.2, atk=0.01, rel=3, pan=0,
		out=0, fx=0, fxsend=(-25);
		var car, mod, env, iEnv;

		//index of modulation
		iEnv = EnvGen.kr(
			Env(
				[index, index*iScale, index],
				[atk, rel],
				[cAtk, cRel]
			)
		);

		//amplitude envelope
		env = EnvGen.kr(Env.perc(atk,rel,curve:[cAtk,cRel]),doneAction:2);

		//modulator/carrier
		mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
		car = SinOsc.ar(freq * cRatio + mod) * env * amp;

		car = Pan2.ar(car, pan);

		//direct out/reverb send
		Out.ar(out, car);

}).add;)




//ARMONIAS (ejecutar)//



(
~armonis = [
	[0, 7, 9, 14, 16, 23], [0, 2, 9, 16, 21, 28], [0, 7, 14, 16, 21, 23, 30],
	[4, 11, 12, 19, 24], [4, 11, 18, 19, 26], [4, 5, 12, 19, 24]
];
~tres4 = [5, 0, 3, 1, 4, 2];
~seis8 = [5, 0, 2, 4, 1, 3];
~leg34 = (~tres4 / 10) + 0.1;
~leg68 = (~seis8 / 10) + 0.1;
~db681 = [-6, -30, -12, -8, -10, -18];
~db341 = [-6, -30, -10, -20, -8, -12];

~db34  = -28 +(~tres4 * 2);
~db68 = -28 + (~seis8 * 2);






t = TempoClock(160/60);
t.permanent = true;
)



//PBINDS BASE (ejecutar) //

(

~patFM = Pbind(
			\instrument, \fm,
			\dur, 3,
	\degree, Pdup(2,Pxrand([0, 7, 9, 14, 16, 23],inf)),
	        \scale, Scale.chromatic,
	\octave, Pn(Pwhite(2,3), Pwhite(5, 22)),
			\index, 1.5,
	        \mRatio, 5,
			\iScale, Pseq([Pgeom(1.2,1.2,6)],inf),
			\atk, 3,

			\rel,  0.01,
			\cAtk, 1.5,
			\cRel, 0.01,

			\pan, Pseq(Array.interpolation(64,0,1).lincurve(0,1,0,1,8),inf) * Pseq([1,-1],inf),

	\strum, Pwrand([0.0090, 0.125, 0.250], [0.90, 0.05, 0.05], inf),
);


~sustra = Pbind(
	\instrument, \sustra   ,
	\degree,Pdup(3,Prand([0, 7, 9, 14, 16, 23],inf)),
	\scale, Scale.chromatic,

  // \octave, Pn(Pwhite(7, 8), Pwhite(5, 22)),
	\dur, 0.50,

	\realease, 0.2,
    \root, 7,
	\cutoff, Pwhite(300.0, 1000),
	\res, 0.9,
	\decayscale, Pwhite(0.1, 1),
	\db,  Pseq(~db68 ++ ~db68 ++ ~db34 ++ ~db34++ ~db34 , inf),

	\pan, Pif(Pfunc{|e| e.strum == 0}, 0, Prand([-1.0, 1], inf)),
	\legato, Pseq([Pn(~leg68, 2), Pn(~leg34, 2)], inf),


);
~hihat1 = Pbind(
	\instrument,\hihat2,
	\scale, Scale.chromatic,
	 \octave, Pwrand([5, 7], [0.70, 0.30], inf),
  // \octave, Pn(Pwhite(7, 8), Pwhite(5, 22)),
	\dur, 0.5,
	\rel, Pbrown(0.05,0.2),
	\db,  Pseq(~db68 ++ ~db68 ++ ~db34 ++ ~db34++ ~db34 , inf),
	\octave, Pwrand([4,5], [0.70, 0.30], inf),
    \pan, 0.5,

);

~hat1 = Pbind(
	\instrument,\hat,
	\scale, Scale.chromatic,
	 \octave, Pwrand([5, 7], [0.70, 0.30], inf),
  // \octave, Pn(Pwhite(7, 8), Pwhite(5, 22)),
	\dur, 0.5,

	\db,  Pseq(~db68 ++ ~db68 ++ ~db34 ++ ~db34++ ~db34 , inf),
	\octave, Pwrand([4,5], [0.70, 0.30], inf),
    \pan, 0.5,

);

~medio1 = Pbind(
	\instrument, \sustra2,
	\degree, Pif(Pfunc{|e| e.instrument == \sustra2}, Prand(~armonis, inf), Prand([0,7,9,4,2])).trace,
	\scale, Scale.chromatic,
	 \octave, Pwrand([4,5], [0.70, 0.30], inf),
  // \octave, Pn(Pwhite(7, 8), Pwhite(5, 22)),
	\dur, 0.5,
	\release, 0.1,
    \root, 7,
	\cutoff, Pwhite(300.0, 1000),
	\res, 0.9,
	\decayscale, Pwhite(0.1, 1),
	\db,  Pseq(~db68 ++ ~db68 ++ ~db34 ++ ~db34++ ~db34 , inf),
	\strum, Pwrand([0.0, 0.125, 0.250],[0.80, 0.10, 0.10], inf),
	\pan, Pif(Pfunc{|e| e.strum == 0}, 0, Prand([-1.0, 1], inf)),
	\legato, Pseq([Pn(~leg68, 2), Pn(~leg34, 2)], inf),

);

~hihat2 = Pbind(
	\instrument,\hihat,
	\scale, Scale.chromatic,
	 \octave, Pwrand([4, 7], [0.70, 0.30], inf),
  // \octave, Pn(Pwhite(7, 8), Pwhite(5, 22)),
	\dur, 0.5,
	\rel, Pbrown(0.05,0.3),
	\res, Pwhite(0.01, 0.9),
	\decayscale, Pwhite(0.1, 1),
	\db,  Pseq(~db68 ++ ~db68 ++ ~db34 ++ ~db34++ ~db34  , inf),
	\ffreq,Pbrown(4000,5000,100,inf),
	\octave, Pwrand([4,5], [0.70, 0.30], inf),
	\pan, -0.4,

);
)


//VARIACIONES PBINDSF (ejecutar) //


((
~patFM1 = Pbindf(~patFM,\cRel, Pwhite(0.1,0.8,inf),
		\pan, Pseq([-0.7,0.7],inf),
		\octave,3,
	\degree, Prand([4, 11, 18, 19, 26],inf));


~patFM4 = Pbindf(~patFM,\realease, Pseq([0.1,0.2,0.30,0.45,0.50,0.65], inf),
                          \atk, 0.1,
			\dur, 0.5,
		\rel,  0.03,
			\pan, 0.5,

	);
~patFM2 = Pbindf(~patFM,\cRel, Pwhite(0.1,0.2,inf),
	\pan, 0.5,
	\index, 1.5,
	        \mRatio, 1,

			\atk, 1.5,
\dur, 3,
		\rel,  0.01,
			\cAtk, 1.5,
		\octave, 4,
			\cRel, 0.01,
	\degree,Pslide([0, 7, 9, 14, 16, 23,4, 11, 12, 19, 24],inf,4,1));



~moth = Pbindf(~hihat2, \instrument, \moth_fm,
	\amp, 0.1,
			\carfreq, 6000 * Pgauss(1,0.03,inf),
	\mod1freq, Pbrown( 883 ,2200, 100, inf),
			\mod1amt, 0.6,
			\mod2freq, 283,
			\mod2amt, 0.7,
			\mod3freq, 487,
			\mod3amt, 0.8,
			\att, 0.003,
			\attCurve, 2,
	\dec, 0.13,
			\decCurve, -7,);

~intro2 = Pbind(
	\instrument,\hihat2,
	\scale, Scale.chromatic,
	 \octave, Pwrand([5, 7], [0.70, 0.30], inf),
  // \octave, Pn(Pwhite(7, 8), Pwhite(5, 22)),
	\dur, 0.5,
	\rel, Pbrown(0.05,0.2),
	\db,  Pseq(~db68 ++ ~db68 ++ ~db34 ++ ~db34++ ~db34 , inf),
	\octave, Pwrand([4,5], [0.70, 0.30], inf),
    \pan, 0.5,

);

~drumsGrupo = Ptpar([0.0,~m,6,~m,24,~m]);


~m = Ppar([Pxrand([~hihat2,~hihat1,~moth])]);

~intro = Pbind(
	\instrument, Pwrand([\sustra, \prayer_bell],  [0.93,  0.7], inf).trace,
	\degree, Pif(Pfunc{|e| e.instrument == \sustra}, Prand(~armonis, inf),Prand([0,7,9,4,2],inf)).trace,
	\scale, Scale.chromatic,
	 \octave, Pwrand([4,5,6, 7], [0.30,0.20,0.40,0.10], inf),
  // \octave, Pn(Pwhite(7, 8), Pwhite(5, 22)),
	\dur, 0.5,


	\root, Pn(Pwrand([0,7],[0.9,0.10],inf)),
	\cutoff, Pwhite(300.0, 7000),
	\res, Pwhite(0.5, 0.8),
	\decayscale, Pwhite(0.5, 1),
	\db,  Pseq((~db68 ++ ~db68 ++ ~db34 ++ ~db34++ ~db34) -2 , inf),
	\strum, Pwrand([0.0, 0.125, 0.250], [0.80, 0.10, 0.10], inf),
	\pan, Pif(Pfunc{|e| e.strum == 0}, 0, Prand([-1.0, 1], inf)),
	\legato, 1.7,
	);

~sustra1 = Pbindf(~sustra,\realease, Pseq([0.1,0.2,0.30,0.45,0.50,0.65], inf),

		                  \pan, 0.5, );

	~sustra2 = Pbindf(~sustra, \octave, 4,);

~sustraArpegio = Pbindf( ~sustra,\dur, Pseq([Pn(0.25,18),Rest(4)],inf),
	\degree,Pslide([0, 7, 9, 14, 16, 23,4, 11, 12, 19, 24],inf,4,1));

~fm = Pbindf(~sustra,\instrument,\rhodey_sc,
	\octave,  3,
		\dur,6,
		\degree,Pxrand([0,2,4,11, 7, 9, 14, 16],inf),
		\pan, Pseq([-0.7,0.61],inf),);

		~kalimba1 = Pbindf(~sustra, \instrument,\kalimba,

		);


	~sustra4 = Pbindf(~sustra ,\instrument, \sustra2,
		\pan, -0.7,
	);

	~sustra3 = Pbindf(~fm ,\instrument, Pseq([\amsynth,\risset2],inf),
		\dur, Pseq ([3,1,1,1],inf),
		\octave,Pseq ([4,7], inf),
		\db, Pseq ([0,-44],inf),
		\degree, Pxrand([0,7,4,14],inf),
);
))




		//the actual piece//






                    q.stop



(

q = Ptpar([0.0,~drumsGrupo.finDur(240),240,~fm.finDur(140),120,~patFM1.finDur(114),36.05,~sustra.finDur(220),180,~patFM4.finDur(60),48.1,~sustra1.finDur(220),0.00,~sustra2.finDur(120),240,~patFM2.finDur(96),240,~moth.finDur(96),240,~kalimba1.finDur(96),240,~sustraArpegio.finDur(90),240,~sustra3.finDur(96),348,~medio1.finDur(156),348,~sustraArpegio.finDur(24),348,~sustra3.finDur(12),342,~patFM4.finDur(96),348,~kalimba1.finDur(128),408,~drumsGrupo.finDur(96),240,~sustra4.finDur(96),498,~patFM2.finDur(6),504,~intro.finDur(120),552,~drumsGrupo.finDur(72),636,~intro.finDur(6),648,~intro.finDur(6)]).play(t)

)

//nota: en la parte final la cantidad de notas tocadas por prayer bell esta reducida porque consumia muchos recursos, pero en la grabacion la cantidad es normal //

