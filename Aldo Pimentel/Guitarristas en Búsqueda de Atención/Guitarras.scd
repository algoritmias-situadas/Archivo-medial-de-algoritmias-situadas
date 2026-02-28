~busamp = Bus.audio(s, 1);

// Amplificador
SynthDef(\ampli, {
	|inBus 0, drive 1, clipLevel 1, mix 0, room 0, damp 0, delayTime 0, delayFeedback 0, tremoloTime 0, tremoloFeedback 0, thresh -20, slopeBelow 1, slopeAbove 0.5, clampTime 0.01, relaxTime 0.1, wahMix 0, wahFreq 400, wahDepth 2000, wahRate 1, wahRes 0.9, pitchOn 0, wSize 0.2, pR 1, pD 1, tD 0, amp 1|

    var inp, shapeTable, dist, verb, fuzz, delay, tremolo, lfo, wah, wahmixed, compander, limiter, finalSignal, pitch, mixed;

	inp = SoundIn.ar(inBus);

	// Color de ampli
	inp = inp.tanh * drive;

	// Pitch shift
	pitch = PitchShift.ar(inp, wSize, pR, pD, tD);
	inp = SelectX.ar(pitchOn.clip(0, 1), [inp, pitch]);

	// Distorsión
	shapeTable = Buffer.alloc(s, 512, 1, { |buf| buf.chebyMsg([0.5,0.6,1,0.2,1,1], false)});
    dist = Shaper.ar(shapeTable, inp * drive);

	// Fuzz
	fuzz = inp.clip2(clipLevel);

	// Reverb
	verb = FreeVerb.ar(fuzz, mix, room, damp);

	// Delay
	delay = CombN.ar(verb, 2, delayTime, delayFeedback);
	delay = delay + verb;

	// Tremolo
	tremolo = CombN.ar(delay, 2, tremoloTime, tremoloFeedback);
	tremolo = tremolo + delay;
	inp = tremolo;

	// Wah
	lfo = SinOsc.kr(wahRate, 0, wahDepth, wahFreq + wahDepth);
    wah = RLPF.ar(inp, lfo, wahRes);
    wahmixed = ((1 - wahMix) * inp) + (wahMix * wah);

	// Compresor
	compander = Compander.ar(wahmixed, wahmixed, 0.5, 0.8, 0.5, 0.01, 0.1);

    // Limitador para evitar picos
    limiter = Limiter.ar(wahmixed, 0.99);
	finalSignal = limiter * amp;
	//Out.ar(0, Pan2.ar(finalSignal));
	Out.ar(~busamp, finalSignal);
}).add;

{ Out.ar(0, In.ar(~busamp, 1).dup) }.play;