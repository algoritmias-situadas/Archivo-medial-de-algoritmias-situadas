// In C(ode)

t = TempoClock(190/60).permanent = true

//Instrumentos
(
SynthDef(\marimba1, {arg freq = 440, amp = 0.4;
	var snd, env;
	env = Env.linen(0.015, 1, 0.5, amp).kr(doneAction: 2);
	snd = BPF.ar(Saw.ar(0), freq, 0.02);
	snd = BLowShelf.ar(snd, 220, 0.81, 6);
	snd = snd * env;
	Out.ar(0, Splay.ar(snd));
//By Bruno Ruviaro
//https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/marimba.scd
}).add;

SynthDef(\flute_waveguide, { arg scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 0.4;

	var kenv1, kenv2, kenvibr, kvibr, sr, cr, block;
	var poly, signalOut, ifqc;
	var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;
	var fdbckArray;

	sr = SampleRate.ir;
	cr = ControlRate.ir;
	block = cr.reciprocal;

	ifqc = freq;

	// noise envelope
	kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
	);
	// overall envelope
	kenv2 = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	aflow1 = LFClipNoise.ar( sr, kenv1 );
	kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );

	asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
	afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	fdbckArray = LocalIn.ar( 1 );

	aflute1 = fdbckArray;
	asum2 = asum1 + ( aflute1 * ifeedbk1 );

	//ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
	ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );

	apoly = ax - ( ax.cubed );
	asum3 = apoly + ( aflute1 * ifeedbk2 );
	avalue = LPF.ar( asum3, 2000 );

	aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar( fdbckArray );

	signalOut = avalue;

	OffsetOut.ar( 0, [ signalOut * kenv2, signalOut * kenv2 ] );

// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html
//by Wilson, Cottle and Collins
//also available at Bruno Ruviaro Collection https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/flute.scd
}).add;


SynthDef(\everythingrhodes,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 4.85 lfowidth= 0.5 cutoff= 2000 rq=0.5 pan = 0.0|

//Electric Piano
	var pulse, filter, env;

	pulse = Pulse.ar(freq*[1,33.5.midiratio],[0.2,0.1],[0.7,0.3]);

	env = EnvGen.ar(Env.adsr(0.0,1.0,0.8,3.0),gate,doneAction:2);

	//keyboard tracking filter cutoff
	filter = BLowPass4.ar(pulse,(cutoff*(env.squared))+200+freq,rq);

	Out.ar(out,Pan2.ar(Mix(filter)*env*amp,pan));

//By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
//http://www.sussex.ac.uk/Users/nc81/index.html
}).add;

SynthDef(\Piano_rhodeySC, {
	//FM Rhodes Synthethizer
    |
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1,
    // all of these range from 0 to 1
    vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1
    |
    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    lfoSpeed = lfoSpeed * 12;

    freq = freq * 2;

    env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
    env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
    env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
    env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

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
//By Nathan Ho aka Snappizz
//http://sccode.org/1-522
}).add;

SynthDef(\srythm, {|freq=40, out = 0|
    var son3, son4, sonf2, sonf3, env2;
    son3 = SinOsc.ar(freq, 0, 0.7);
    son4 = SinOsc.ar([240, 180], 0, 0.7);
    env2= EnvGen.kr(Env.perc(0.02, 0.4), doneAction:2);
    sonf2= Mix(son3*son4);
    sonf3 = Mix(sonf2*env2);
    Out.ar(out, Pan2.ar(sonf3))
}).add;


SynthDef(\percu,{|freq= 1400, dur=1, intensidad=0.1, attack = 0.01, out=0|
    var son1, son2, sonf, env;
    son1=Saw.ar(freq*SinOsc.kr(10, 0, 0.1), intensidad);
    son2=SinOsc.ar(247, 0, intensidad);
        env= EnvGen.kr(Env.perc(attack, 0.4), doneAction:2);
            sonf=Mix(son1*son2);
        Out.ar(out, Pan2.ar(sonf*env))
}).add;

SynthDef(\SynthLead,{|freq= 20, dur=1, intensidad=0.7, attack = 0.01, out =0|
    var son1, son2, sonf, env;
    son1=Saw.ar(freq, intensidad);
    son2=SinOsc.ar(247, 0, 0.4);
        env= EnvGen.kr(Env.perc(attack, 0.4), doneAction:2);
            sonf=Mix(son1*son2);
        Out.ar(out, Pan2.ar(sonf*env))
}).add;


SynthDef(\prayer_bell, { | t_trig = 1, sing_switch = 0, freq = 2434, amp = 0.1, decayscale = 1, lag = 10, i_doneAction = 8, out = 0|
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
  Out.ar(out, sig*0.1);
}).add;


SynthDef(\amsynth,
			{   | out = 0, freq = 440, freq_modulator = 300, amp = 0.9, amp_modulator = 0.5,
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

SynthDef(\hihat2, {arg out = 0, amp = 4, att = 0.001, rel = 0.2, ffreq = 12000, pan = 0;
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

SynthDef(\sustra2, {arg freq = 440, cutoff = 2800, res = 0.9, amp = 1,  out = 0, gate = 1, pan = 0, release = 0.82;
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
    Out.ar(out, Pan2.ar(snd, 0, amp));
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

}).add;

SynthDef(\noisy, {arg out = 0, freq = 440, amp = 0.2, pan = 0.5;
	var snd, env;
	env = Env.perc(0.02, 0.1).kr(doneAction: 2);
	snd = Mix(LFPulse.ar(
		freq: freq * [1, 5/2],
		iphase: 0.0,
		width: 0.5,
		mul: amp));
	snd = snd * env ;
	Out.ar(out, Pan2.ar(snd, pan));
//By Bruno Ruviaro
//https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/noisy.scd
}).add;


SynthDef(\sawSynth, { arg freq = 440, amp = 0.1, att = 0.1, rel = 2, lofreq = 1000, hifreq = 3000;
    var env, snd;
    env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);
    snd = Saw.ar(freq: freq * [0.99, 1, 1.001, 1.008], mul: env);
	snd = LPF.ar(
		in: snd,
		freq: LFNoise2.kr(1).range(lofreq, hifreq)
	);
    snd = Splay.ar(snd);
    Out.ar(0, snd);
// Basic saw synth for chords and bass
//By Bruno Ruviaro
//http://sccode.org/1-54H
}).add;

SynthDef(\blips1, {arg out = 0, freq = 25, numharm = 10, atk = 0.01, rel = 1, amp = 0.1, pan = 0.5, beatsPercentage = 1.001;
	var snd, env;
	env = Env.perc(atk, rel, amp).kr(doneAction: Done.freeSelf);
	snd = LeakDC.ar(Mix(Blip.ar([freq, freq*beatsPercentage], numharm, env)));
	Out.ar(out, Pan2.ar(snd, pan));

//80's like synth
//By Bruno Ruviaro
//https://github.com/brunoruviaro/SynthDefs-for-Patterns/blob/master/blips.scd
//Edits by Zé Craum
}).add;

// adapted from a post by Neil Cosgrove (other three are original)
SynthDef(\clap_electro, {
    |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;

SynthDef(\hihat_electro, {
    |out = 0, pan = 0, amp = 0.3|
    var click, clickAmp;
    var noise, noiseAmp;
    var snd;

    // noise -> resonance -> expodec envelope
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.3, curve: -8), doneAction: 2);
    noise = Mix(BPF.ar(ClipNoise.ar, [4010, 4151], [0.15, 0.56], [1.0, 0.6])) * 0.7 * noiseAmp;

    snd = noise;

    Out.ar(out, Pan2.ar(snd, pan, amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;

SynthDef(\snare_electro, {
    |out = 0, pan = 0, amp = 0.3|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.15), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

    Out.ar(out, Pan2.ar(snd, pan, amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;

SynthDef(\kick_electro, {
    |out = 0, pan = 0, amp = 0.3|
    var body, bodyFreq, bodyAmp;
    var pop, popFreq, popAmp;
    var click, clickAmp;
    var snd;

    // body starts midrange, quickly drops down to low freqs, and trails off
    bodyFreq = EnvGen.ar(Env([261, 120, 51], [0.035, 0.08], curve: \exp));
    bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), doneAction: 2);
    body = SinOsc.ar(bodyFreq) * bodyAmp;
    // pop sweeps over the midrange
    popFreq = XLine.kr(750, 261, 0.02);
    popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
    pop = SinOsc.ar(popFreq) * popAmp;
    // click is spectrally rich, covering the high-freq range
    // you can use Formant, FM, noise, whatever
    clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
    click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

    snd = body + pop + click;
    snd = snd.tanh;

    Out.ar(out, Pan2.ar(snd, pan, amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;

)

//////////////////////////////////////////////////////////////////////////////////////////////
/////////Los famosos Pbinds////////



//Tempo
(
v = Scale.choose.postln
(
~tempo = Pfunc({
    Pbind(
        \instrument, [\marimba1, \everythingrhodes, \Piano_rhodeySC, \srythm, \percu,
                    \amsynth, \clang, \risset2, \sustra, \sustra2, \kalimba, \kick_electro, \snare_electro, \hihat_electro, \clap_electro, \blips1, \sawSynth, \noisy].choose,
        \degree, 1,
        \dur, 1,
        \legato, 0.3,
		\pan, [-1, 0, 1].choose,
		//\out, (0..7).choose,
    )
}).asStream;


//Tema inicial

~inicial = Pfunc({
    Pbind(
        \instrument, [\marimba1, \everythingrhodes, \Piano_rhodeySC, \percu, \clang,
                    \risset2, \sustra, \sustra2, \kalimba, \hihat2, \kick_electro, \snare_electro, \hihat_electro, \clap_electro, \blips1, \sawSynth, \noisy].choose,
        \scale, v,
		\octave, [3, 4, 5, 6].choose,
        \root, 2,
        \degree, Pseq([0, 4, 3, 4, \r, 5, 3, 2, 2, 1], inf),
        \dur, Pseq([1, 1, 0.5, 0.5, 0.5, 1.5, 1, 0.5, 0.5, 1], inf),
        \legato, 0.5,
		\pan, [-1, 0, 1].choose,
		//\out, (0..7).choose,
    )
}).asStream;


//Variaciones

~mel = [Pwrand([0, -1, -3, 2, \r], [2, 1, 1, 1, 4].normalizeSum),
	Pwrand([2, -3, \r], [1, 1, 4].normalizeSum),
	Pwrand([3, 1, \r], [1, 1, 4].normalizeSum),
	Pwrand([6, 4, 2, -1, \r], [1, 3, 1, 4].normalizeSum),
	Pwrand([2, \r], [1, 4].normalizeSum),
	Pwrand([1, -1, \r], [1, 1, 4].normalizeSum),
	Pwrand([3, 0, \r], [2, 1, 4].normalizeSum),
	Pwrand([2, 0, -3, \r], [1, 1, 1, 4].normalizeSum),
	Pwrand([4, 0, \r], [2, 1, 4].normalizeSum),
	Pwrand([2, \r], [1, 4].normalizeSum),
	Pwrand([1, \r], [1, 2].normalizeSum),
	Pwrand([2, -1, \r], [1, 1, 4].normalizeSum),
	Pwrand([5, 0, \r], [2, 1, 4].normalizeSum),
	Pwrand([5, 2, -1, \r], [2, 1, 1, 4].normalizeSum),
	Pwrand([2, \r], [1, 4].normalizeSum),
	Pwrand([1, -2, \r], [1, 1, 4].normalizeSum),
	Pwrand([3, 1, 0, \r], [2, 1, 1, 4].normalizeSum),
	Pwrand([-1, \r], [1, 4].normalizeSum),
	Pwrand([3, 0, \r], [1, 1, 4].normalizeSum),
	Pwrand([2, 0, \r], [2, 1, 4].normalizeSum),
	Pwrand([2, -3, \r], [2, 1, 4].normalizeSum),
	Pwrand([3, 1, 0, \r], [1, 2, 1, 4].normalizeSum),
	Pwrand([-1, \r], [1, 4].normalizeSum),
	Pwrand([2, -1, \r], [1, 1, 4].normalizeSum)
];

~durM = [0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.25, 0.5, 0.25];


~variProb = Pfunc({
    Pbind(
        \instrument, [\marimba1, \Piano_rhodeySC, \percu, \clang,
                    \risset2, \sustra, \sustra2, \kalimba, \hihat2,
                    \flute_waveguide, \kick_electro, \snare_electro, \hihat_electro, \clap_electro, \blips1, \sawSynth, \noisy].choose,
        \degree, Pseq(~mel, inf),
        \scale, v,
        \root, 2,
        \octave, [2, 3, 4, 5, 6, 7].choose,
        \dur, Pseq(~durM * [0.5, 1, 1.5, 2].choose, inf),
        \legato, 0.4,
		\pan, [-1, 0, 1].choose,
		//\out, (0..7).choose,
    )
}).asStream;
);
)


//Estructura de la rola (Evaluar cada vez que se vaya a tocar para que sea diferente)
(
~estructuraPtpar = Ptpar([
    0.0, Pfindur(48, ~variProb.next),
    16.0, Pfindur(64, ~variProb.next),
    32.0, Pfindur(256, ~tempo.next),
    48.0, Pfindur(128, ~inicial.next),
	64.0, Pfindur(128, ~variProb.next),
	80.0, Pfindur(64, ~variProb.next),
	96.0, Pfindur(128, ~inicial.next),
	112.0, Pfindur(128, ~variProb.next),
	128.0, Pfindur(64, ~tempo.next),
	156.0, Pfindur(128, ~variProb.next),
	156.0, Pfindur(64, ~tempo.next),
	156.0, Pfindur(128, ~variProb.next),
	156.0, Pfindur(64, ~inicial.next),
	172.0, Pfindur(156, ~variProb.next),
	188.0, Pfindur(32, ~inicial.next),
	224.0, Pfindur(32, ~variProb.next),
	224.0, Pfindur(96, ~tempo.next),
	240.0, Pfindur(64, ~variProb.next),
	240.0, Pfindur(32, ~variProb.next),
	256.0, Pfindur(128, ~variProb.next),
	256.0, Pfindur(64, ~variProb.next),
	282.0, Pfindur(96, ~tempo.next),
	298.0, Pfindur(64, ~variProb.next),
	298.0, Pfindur(128, ~tempo.next),
	298.0, Pfindur(64, ~inicial.next),
	314.0, Pfindur(96, ~variProb.next),
	330.0, Pfindur(128, ~tempo.next),
	346.0, Pfindur(82, ~inicial.next),
	362.0, Pfindur(48, ~variProb.next),
	370.0, Pfindur(32, ~inicial.next),
	386.0, Pfindur(32, ~variProb.next),
	386.0, Pfindur(96, ~tempo.next),
	402.0, Pfindur(64, ~variProb.next),
	410.0, Pfindur(32, ~variProb.next),
	410.0, Pfindur(128, ~variProb.next),
	418.0, Pfindur(64, ~variProb.next),
	434.0, Pfindur(96, ~tempo.next),
	434.0, Pfindur(64, ~variProb.next),
	450.0, Pfindur(128, ~tempo.next),
	450.0, Pfindur(64, ~inicial.next),
	454.0, Pfindur(64, ~inicial.next),
	458.0, Pfindur(128, ~inicial.next),
	462.0, Pfindur(48, ~inicial.next),
	466.0, Pfindur(64, ~inicial.next),
	466.0, Pfindur(64, ~tempo.next),
	466.0, Pfindur(128, ~variProb.next),
	474.0, Pfindur(64, ~tempo.next),
	474.0, Pfindur(128, ~variProb.next),
	482.0, Pfindur(64, ~inicial.next),
	514.0, Pfindur(156, ~variProb.next),
	530.0, Pfindur(32, ~inicial.next),
	546.0, Pfindur(32, ~variProb.next),
	546.0, Pfindur(96, ~tempo.next),
	562.0, Pfindur(64, ~variProb.next),
	570.0, Pfindur(32, ~variProb.next),
	578.0, Pfindur(128, ~variProb.next),
	578.0, Pfindur(64, ~variProb.next),
	594.0, Pfindur(96, ~tempo.next),
	610.0, Pfindur(64, ~variProb.next),
	610.0, Pfindur(128, ~tempo.next),
	626.0, Pfindur(64, ~inicial.next),
	634.0, Pfindur(96, ~variProb.next),
	650.0, Pfindur(96, ~variProb.next),
	650.0, Pfindur(128, ~tempo.next),
	666.0, Pfindur(82, ~inicial.next),
	672.0, Pfindur(48, ~variProb.next),
]);
)

//The actual piece ;)
(
~estructuraPtpar.play(t);

//s.record;
)
s.scope

s.stopRecording
~estructuraPtpar.stop;


