// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// 1) BUS, FX, OUT, REC
//-----------------------------------------------------------------------------------------------------------------------
(
// BUS
~volBus = Bus.control(s, 1);
~volBus.set(0.1);
~mainBus = Bus.audio(s, 2);
~finalBus = Bus.audio(s, 2);

// FX: REVERB & EQ
SynthDef(\primeEQ, { |inbus, outbus=0,
	revMix=0.13,
	lowFreq=200,    lowGain=0,
	midFreq=1000,   midGain=0,
	mhFreq=4000,    mhGain=0,
	highFreq=10000, highGain=0
|
	var dry, fx, sig, pos;
	dry = In.ar(inbus, 2);
	fx = FreeVerb2.ar(
		dry[0], dry[1],
		1.0,    // internal mix
		0.9,    // room size
		1.0     // damping
	);
	// Crossfade DRY/FX:
	pos = (revMix * 2) - 1;
	sig = XFade2.ar(dry, fx, pos);
	// EQ
	sig = BLowShelf.ar(sig, lowFreq, 1, lowGain);
	sig = BPeakEQ.ar(sig, midFreq, 1, midGain);
	sig = BPeakEQ.ar(sig, mhFreq, 1, mhGain);
	sig = BHiShelf.ar(sig, highFreq, 1, highGain);
	Out.ar(outbus, sig);
}).add;

// Synth OUT (0)
SynthDef(\primeOutput, { |inbus|
	var sig = In.ar(inbus, 2);
	Out.ar(0, sig);
}).add;

// REC
SynthDef(\primeRecorder, { |bufnum, inbus=0|
	var in = In.ar(inbus, 2);
	DiskOut.ar(bufnum, in);
}).add;
~isRecording = false;
~recFilePath = nil;
~recBuf      = nil;
~recSynth    = nil;
)
