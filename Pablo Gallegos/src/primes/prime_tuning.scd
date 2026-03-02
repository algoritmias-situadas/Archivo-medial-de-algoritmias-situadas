// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// Nearest-prime tuning: maps a frequency (Hz) to nearest prime frequency
//-----------------------------------------------------------------------------------------------------------------------
(
~nearestPrimeFreq = { |freq|
	var f = freq.round.asInteger;

	if(~useComplex.not) {
		// Natural Mode
		var up  = f.nextPrime;
		var dn  = f.prevPrime;

		if(dn.isNil) {
			up
		} {
			if((up - f).abs < (f - dn).abs) { up } { dn }
		};

	} {
		// Complex Mode (nearest prime in ~primoscomplejos)
		var closest = ~primoscomplejos[0];
		var minDiff = (closest - f).abs;

		~primoscomplejos.do { |p|
			var d = (p - f).abs;
			if(d < minDiff) {
				minDiff = d;
				closest = p;
			};
		};
		closest;
	};
};
)
