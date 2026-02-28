
SynthDef(\reed, {
    |out = 0, freq = 440, amp = 0.1, gate = 1, atk = 0.3, rel= 0.3, pan = 0|
    var snd, blow;
    // pulse with modulating width
    snd = Pulse.ar((Rand(-0.03, 0.05) + freq.cpsmidi).midicps, 0.48 + LFNoise1.kr(0.06, 0.1), 0.8);
    // add a little "grit" to the reed
    snd = Disintegrator.ar(snd, 0.5, 0.7);
    // a little ebb and flow in volume
    snd = snd * LFNoise2.kr(5, 0.05, 1);
    // use the same signal to control both the resonant freq and the amplitude
    blow = EnvGen.ar(Env.asr(atk, 1.0, rel), gate, doneAction: 2);
    snd = snd + BPF.ar(snd, blow.linexp(0, 1, 2000, 2442), 0.3, 3);
    // boost the high end a bit to get a buzzier sound
    snd = BHiShelf.ar(snd, 1200, 1, 3);
    snd = snd * blow;
    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

SynthDef(\melos,{|gate=1,freq =440, out =0, amp = 0.9, atk = 0.1, rel = 0.5, pan = 0|
	var cuerda2,env;
		cuerda2=Limiter.ar(SinOsc.ar(freq,0,0.5)+
				Saw.ar(freq,0.1,0.3)+
					RLPF.ar(
				LFCub.ar(freq,0.1,0.4)+
				LFTri.ar(freq,0.1,0.5),
					Phasor.kr(Impulse.kr(1),60,10000),
					0.5),
			0.9);
	env=EnvGen.ar(Env.asr(atk,amp, rel),gate,doneAction:2);
	Out.ar(out,Pan2.ar(cuerda2*env,pan))
}).add;


// Pbind(
// 	\instrument, \melo2,
// 	\amp, 0.7,
// 	\dur, 0.25,
// 	\legato, 1,
// 	\root, 1,
// 	\atk, Pwhite(0.05, 0.4),
// 	\rel, Pwhite(0.2, 1),
// 	\degree, Pseq([-7, -3, 0, 2, -7, -2, 0, 3, -7, -1, 1, 4], inf)
// ).play;


SynthDef(\bup, {
	arg out=0,freq=440,pan = 0, ffreq=840,famp=1,fq=1,
	    fatk = 0.01, fdec = 0.1,
	    atk = 0.01, dec = 0.1, rel = 0.1,
	    amp=0.5,gate=1, len=0.2,lag=0.1;

	var synth,ampEnv,filtEnv;

	filtEnv = EnvGen.kr(
		       Env.adsr(fatk,fdec,releaseTime:0.05),
                       gate,
		       freq*famp,
		       freq*2);
	ampEnv = EnvGen.kr(
		       Env.adsr(atk,dec,0.5, rel),
		       gate,
                       doneAction:2);
	synth = Mix.new([
		LFSaw.ar(Lag.kr([freq*2,freq],lag),[0,pi],amp),
		LFTri.ar(Lag.kr([freq,freq*2],lag),[pi,0],amp)
	]).sum;
//	synth = synth * ampEnv;
	synth = RLPF.ar(synth,filtEnv,fq);
	Out.ar(out,Pan2.ar(synth*ampEnv, pan));
}).add;

// Pbind(\instrument, \bup,
// 	\degree, Pwhite(-12,12),
// 	\scale, Scale.choose,
// 	\pan, -1,
// 	\dur, Prand([0.25, 0.5, 0.125], inf)
// ).play


SynthDef(\plucking, {arg out = 0, amp = 0.1, freq = 440, decay = 5, coef = 0.1, pan = 0;
	var env, snd;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);
	snd = Pluck.ar(
		in: WhiteNoise.ar(1),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: coef);
	Out.ar(out, Pan2.ar(snd*amp, pan));
}).add;





SynthDef(\dx11,///op4--->op3-->op2--->op1
	{
		|
		freq=440, out =0, amp = 0.75, pan = 0,
		op1att=0.001,op1dec=5.250,op1amt=1,op1tune=0,
		op2att=0.001,op2dec=1.250,op2amt=1,op2tune=0,
		op3att=0.001,op3dec=1.250,op3amt=3,op3tune=0,
		op4att=0.001,op4dec=1.250,op4amt=1,op4tune=0,feedbackamt=0|
		var env1,env2,env3,env4,op1,op2,op3,op4,signal;

		env4=EnvGen.ar(Env([0,1,0],[op4att,op4dec],[0,-5]),doneAction:0);
		op4=SinOscFB.ar(freq+op4tune.midicps,env4*feedbackamt, 0.7);
		op4=op4*env4;
		op4=op4*op4amt;
		env3=EnvGen.ar(Env([0,1,0],[op3att,op3dec],[0,-5]),doneAction:0);
		op3=SinOsc.ar(freq+op3tune.midicps,op4, 0.5);
		op3=op3*env3;
		op3=op3*op3amt;
		env2=EnvGen.ar(Env([0,1,0],[op2att,op2dec],[0,-5]),doneAction:0);
		op2=SinOsc.ar(freq+op2tune.midicps,op3, 0.5);
		op2=op2*env2;
		op2=op2*op2amt;
		env1=EnvGen.ar(Env([0,1,0],[op1att,op1dec],[0,-5]),doneAction:2);
		op1=SinOsc.ar(freq+op1tune.midicps,op2, 0.5);
		op1=op1*env1;
		signal=op1*op1amt;
		signal=Pan2.ar(signal*amp, pan);
		Out.ar(out,signal);
}).add;



// Pbind(\instrument, \dx11,
// 	\degree, Pwhite(-12,12),
// 	\scale, Scale.choose,
// 	\dur, Prand([0.25, 0.5, 0.125], inf)
// ).play


SynthDef(\bell, {
	|freq=1, out = 0, t60=1, pitchy=1, amp=0.25, pan = 0, gate=1|
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
//	sig = FreeVerb.ar(sig) * amp;
	DetectSilence.ar(sig , 0.001, 0.5, doneAction:2);
	Out.ar(out, Pan2.ar(sig*amp, pan));
}).add;



// Pbind(
// 	\instrument, \bell,
// 	\freq, Pseq( (60..72), 1).midicps,
// 	\t60, Prand([1,0.5], inf),
// 	\pitchy, 4,
// 	\dur, 0.25,
// 	\amp, 0.15
// ).play;


// marimba
// Pbind(
// 	\instrument, \bell,
// 	\freq, Pseq( (60..72), 1).midicps,
// 	\t60, 0.5,
// 	\pitchy, 1,
// 	\dur, 0.25
// ).play;
//
// Pbind(
// 	\instrument, \bell,
// 	\freq, Pseq( (60..72), 1).midicps,
// 	\t60, 9,
// 	\pitchy, 1,
// 	\dur, 1
// ).play;

SynthDef(\piano_MDA, {
	//Piano synth based on Mda Plugin
    |out = 0, freq= 440, gate= 1, vel= 80, decay= 0.8, release= 0.8, hard= 0.4, velhard= 0.8, muffle= 0.8, velmuff= 0.8, velcurve= 0.8, stereo= 0.2, tune= 0.5, random= 0.1, stretch= 0.1, sustain= 0, mul= 1, add= 0, amp = 0.5|
    var snd;
    snd = MdaPiano.ar(freq, gate, vel, decay, release, hard, velhard, muffle, velmuff, velcurve, stereo, tune, random, stretch, sustain, mul, add);
    snd = snd * EnvGen.kr(Env.asr(0, 1, 0.1), gate, doneAction: 2);
    Out.ar(out, snd * amp);
//by ????
}).add;
