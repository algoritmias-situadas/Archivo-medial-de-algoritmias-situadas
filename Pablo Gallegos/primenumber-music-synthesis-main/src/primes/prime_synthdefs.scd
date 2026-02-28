// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// Prime-based Klang synth definitions (Normal/Complex × Perc/Sustain)
//-----------------------------------------------------------------------------------------------------------------------
(
~buildSynthDefs = {

	// Natural Primes Percusive Synth --------------------
	SynthDef(\primeSynthNormalPerc, { |freq=100, amp=1, relTime=0.3, volbus, outbus|
		var sig, env, click, envClick, master, harmonics, amps;

		master = In.kr(volbus);
		harmonics = ~primeHarm_normal;
		amps      = ~amps_normal;

		sig = Klang.ar(`[harmonics, amps], freq);

		click = SinOsc.ar(freq * 2, 0, 0.25);
		envClick = EnvGen.kr(Env.perc(0.005, 0.02));
		click = click * envClick;

		env = EnvGen.kr(
			Env.perc(0.02, relTime),
			1,
			doneAction:2
		);

		sig = (sig + click) * env * amp * master * 0.1;
		Out.ar(outbus, sig ! 2);
	}).add;

	// Natural Primes Sustain Synth --------------------
	SynthDef(\primeSynthNormalSustain, { |freq=100, amp=1, gate=1, relTime=0.3, volbus, outbus|
		var sig, env, click, envClick, master, harmonics, amps;

		master = In.kr(volbus);
		harmonics = ~primeHarm_normal;
		amps      = ~amps_normal;

		sig = Klang.ar(`[harmonics, amps], freq);

		click = SinOsc.ar(freq * 2, 0, 0.25);
		envClick = EnvGen.kr(Env.perc(0.005, 0.02));
		click = click * envClick;

		env = EnvGen.kr(
			Env.asr(0.02, 1.0, relTime),
			gate,
			doneAction:2
		);

		sig = (sig + click) * env * amp * master * 0.1;
		Out.ar(outbus, sig ! 2);
	}).add;

	// Complex Primes Percusive Synth --------------------
	SynthDef(\primeSynthComplexPerc, { |freq=100, amp=1, relTime=0.3, volbus, outbus|
		var sig, env, click, envClick, master, harmonics, amps;

		master = In.kr(volbus);
		harmonics = ~primeHarm_complex;
		amps      = ~amps_complex;

		sig = Klang.ar(`[harmonics, amps], freq);

		click = SinOsc.ar(freq * 2, 0, 0.25);
		envClick = EnvGen.kr(Env.perc(0.005, 0.02));
		click = click * envClick;

		env = EnvGen.kr(
			Env.perc(0.02, relTime),
			1,
			doneAction:2
		);

		sig = (sig + click) * env * amp * master * 0.1;
		Out.ar(outbus, sig ! 2);
	}).add;

	// Complex Primes Sustain Synth --------------------
	SynthDef(\primeSynthComplexSustain, { |freq=100, amp=1, gate=1, relTime=0.3, volbus, outbus|
		var sig, env, click, envClick, master, harmonics, amps;

		master = In.kr(volbus);
		harmonics = ~primeHarm_complex;
		amps      = ~amps_complex;

		sig = Klang.ar(`[harmonics, amps], freq);

		click = SinOsc.ar(freq * 2, 0, 0.25);
		envClick = EnvGen.kr(Env.perc(0.005, 0.02));
		click = click * envClick;

		env = EnvGen.kr(
			Env.asr(0.02, 1.0, relTime),
			gate,
			doneAction:2
		);

		sig = (sig + click) * env * amp * master * 0.1;
		Out.ar(outbus, sig ! 2);
	}).add;
};

~buildSynthDefs.(); // initial synthdefs
)
