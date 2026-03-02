// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// Prime harmonic lists + amplitude model (1/p with jitter) + instrument mode/parameter defaults
//-----------------------------------------------------------------------------------------------------------------------
(
// SPECTRAL PRIME HARMONICS
~maxHarm = 50;  // Max harmonics
~nHarm   = 30;  // Active harmonics

// PRIME HARMONIC LISTS
~updateHarmonics = {
	// Natural Primes
	~primeHarm_normal = [1] ++ (0..(~maxHarm-1)).collect(_.nthPrime);
	// Complex Primes (assumes ~primoscomplejos already built)
	~primeHarm_complex = [1] ++ ~primoscomplejos.copyRange(0, ~maxHarm-1);
};
~updateHarmonics.(); // init lists

// JITTER & AMPS UPDATE
~jitterAmt = 0.0;

~updateAmps = {
	var len    = ~maxHarm + 1;
	var active = ~nHarm.clip(1, ~maxHarm); // Active Harmonics

	~amps_normal  = Array.fill(len, 0.0);
	~amps_complex = Array.fill(len, 0.0);
	~amps_normal[0]  = 1.0;
	~amps_complex[0] = 1.0;

	// ACTIVE PRIME HARMONICS
	(1..active).do { |i|
		var pn = ~primeHarm_normal[i];
		var pc = ~primeHarm_complex[i];
		var jitterN = 1 + rrand(~jitterAmt.neg, ~jitterAmt);
		var jitterC = 1 + rrand(~jitterAmt.neg, ~jitterAmt);
		~amps_normal[i]  = (1 / pn) * jitterN;
		~amps_complex[i] = (1 / pc) * jitterC;
	};

	~amps_normal  = ~amps_normal.normalizeSum;
	~amps_complex = ~amps_complex.normalizeSum;

	// Rebuild synthdefs so Klang uses updated harmonic/amp tables
	~buildSynthDefs.();
};
~updateAmps.(); // init amps (also rebuilds synthdefs)

// MODES (defaults)
~useComplex  = false; // false = Natural Primes, true = Complex Primes
~useRoutine  = true;  // true = Prime Sequence, false = Single Note

// INIT VALUES (defaults)
~lista = (0, 1..65521);
~lista = ~lista.mirror;

~cantHarm = 7;    // Prime Sequence Harmonics
~velConst = 7;    // Prime Sequence Velocity
~durRut   = 65521; // Prime Sequence Duration
~relTime  = 0.9;  // Synth Release Time
)
