// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// 4) MIDI
//-----------------------------------------------------------------------------------------------------------------------
(
MIDIClient.init;
MIDIIn.connectAll;

// Prime Sequence Mode
~voicesRut      = IdentityDictionary.new;  // note -> Routine
~voicesRutColor = IdentityDictionary.new;  // note -> Color Index

// Single Note Mode
~voicesSust      = IdentityDictionary.new; // note -> Synth (Sustain)
~voicesSustColor = IdentityDictionary.new; // note -> Color Index
~voicesSustCell  = IdentityDictionary.new; // note -> Cell Index

// For gain control
~activeNotes = 0;

MIDIdef.noteOn(\primeOn, { |vel, note|
	var freqPrimo, baseAmp, ampScale, r, synth, freqNorm;
	var mults, allMults, num;
	var seq;
	var synthNamePerc, synthNameSust;
	var colorIdx;
	var cellIndex;

	// Asign Natural/Complex Prime Frequency to MIDI Note Frequency
	freqPrimo = ~nearestPrimeFreq.(note.midicps);
	~activeNotes = (~activeNotes ? 0) + 1; // Update active note counter

	// Normalize active notes amps by frequency
	freqNorm = (freqPrimo / 440).max(0.25);
	ampScale = ( (~activeNotes * freqNorm).sqrt ).reciprocal;
	baseAmp   = vel.linlin(1, 127, 0.05, 1.0) * ampScale;

	// Init synths
	synthNamePerc = if(~useComplex.not, { \primeSynthNormalPerc }, { \primeSynthComplexPerc });
	synthNameSust = if(~useComplex.not, { \primeSynthNormalSustain }, { \primeSynthComplexSustain });

	if(~useRoutine.not) {
		// ---------------------- SINGLE NOTE MODE ----------------------
		synth = Synth(synthNameSust, [
			\freq,    freqPrimo,
			\amp,     baseAmp,
			\volbus,  ~volBus.index,
			\outbus,  ~mainBus.index,
			\relTime, ~relTime,
			\gate,    1
		]);
		~voicesSust[note] = synth;

		// Coloring
		colorIdx = ~nextColorIndex;
		~nextColorIndex = (~nextColorIndex + 1) % ~primeColors.size;
		~voicesSustColor[note] = colorIdx;
		// Finding free cells
		cellIndex = (0..(~visN-1)).detect { |i|
			~voicesSustCell.values.includes(i).not
		};
		if(cellIndex.isNil) { cellIndex = 0 };
		~voicesSustCell[note] = cellIndex;
		~visColorIx[cellIndex] = colorIdx;
		{
			if(~visView.notNil) { ~visView.refresh };
		}.defer;
	} {
		// ---------------------- PRIME SEQUENCE MODE ----------------------
		// Refresh canvas
		~visColorIx = Array.fill(~visN, -1);
		~visIndex   = 0;
		{
			if(~visView.notNil) { ~visView.refresh };
		}.defer;

		allMults = if(~useComplex.not) {
			~primeHarm_normal;
		} {
			~primeHarm_complex;
		};
		num = min(~cantHarm, allMults.size);
		mults = allMults.copyRange(0, num-1);

		// Prime Sequence Harmonic Rotation
		seq = Pseq(freqPrimo * mults, inf).asStream;
		// Coloring
		colorIdx = ~nextColorIndex;
		~nextColorIndex = (~nextColorIndex + 1) % ~primeColors.size;

		r = Routine {
			var newIndex, baseWait, waitTime;

			~durRut.do { |i|
				var val = ~lista[i];
				var isPrimeLike = false;

				if(~useComplex.not) {
					if(val.isPrime) {
						isPrimeLike = true;
						Synth(synthNamePerc, [
							\freq,    seq.next,
							\amp,     baseAmp,
							\volbus,  ~volBus.index,
							\outbus,  ~mainBus.index,
							\relTime, ~relTime
						]);
					};
				} {
					if(~complexPrimeSet.includes(val)) {
						isPrimeLike = true;
						Synth(synthNamePerc, [
							\freq,    seq.next,
							\amp,     baseAmp,
							\volbus,  ~volBus.index,
							\outbus,  ~mainBus.index,
							\relTime, ~relTime
						]);
					};
				};

				newIndex = (~visIndex + 1) % ~visN;
				if(newIndex == 0) {
					~visColorIx = Array.fill(~visN, -1);
					{
						if(~visView.notNil) { ~visView.refresh };
					}.defer;
				};

				~visIndex = newIndex;
				if(isPrimeLike) {
					~visColorIx[~visIndex] = colorIdx;
					{
						if(~visView.notNil) { ~visView.refresh };
					}.defer;
				};

				// Base wait time determined my frequency and velocity constant
				baseWait = freqPrimo.reciprocal * ~velConst;
				// Failsafe
				waitTime = max(baseWait, 0.005);
				waitTime.wait;
			};
		}.play;

		~voicesRut[note]      = r;
		~voicesRutColor[note] = colorIdx;
	};
});

MIDIdef.noteOff(\primeOff, { |vel, note|
	var r = ~voicesRut[note];
	var s = ~voicesSust[note];
	var cell;

	~activeNotes = max(0, ((~activeNotes ? 1) - 1)); // Update active note counter
	// Stop routine
	if (r.notNil) {
		r.stop;
		~voicesRut.removeAt(note);
		~voicesRutColor.removeAt(note);
	};
	// Stop note and wipe cell
	if (s.notNil) {
		s.set(\gate, 0);
		~voicesSust.removeAt(note);
		cell = ~voicesSustCell[note];
		if(cell.notNil) {
			~visColorIx[cell] = -1;
			~voicesSustCell.removeAt(note);
			~voicesSustColor.removeAt(note);
			{
				if(~visView.notNil) { ~visView.refresh };
			}.defer;
		};
	};
});
)
