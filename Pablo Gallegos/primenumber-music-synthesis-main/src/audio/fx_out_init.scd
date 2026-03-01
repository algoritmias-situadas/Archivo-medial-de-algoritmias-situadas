// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// 1) BUS, FX, OUT, REC
//-----------------------------------------------------------------------------------------------------------------------
(
// FX & OUT INIT
if(~eqSynth.notNil and: { ~eqSynth.isRunning }) {
	~eqSynth.free;
};

~eqSynth = Synth(\primeEQ, [
	\inbus, ~mainBus,
	\outbus, ~finalBus.index,
	\revMix, 0.2,
	\lowFreq, 200,
	\lowGain, 0,
	\midFreq, 1000,
	\midGain, 0,
	\mhFreq, 4000,
	\mhGain, 0,
	\highFreq, 10000,
	\highGain, 0
], addAction:\addToHead);

if(~outputSynth.notNil and: { ~outputSynth.isRunning }) {
	~outputSynth.free;
};

~outputSynth = Synth(\primeOutput, [\inbus, ~finalBus.index], addAction:\addToTail);
)