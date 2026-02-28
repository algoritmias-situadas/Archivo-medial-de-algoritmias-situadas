(
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Ecosistemas en resonancia >>>>>>>>>>>>>>>>>>>>>>>>
// por Joyce Jandette
// 2025/12
// Sección: Rutina manos libres

~manosLibres = Routine({
    var maxActivos = 4;
    var freqs = [36, 43, 48, 50, 55, 57, 60, 62, 67, 69, 72, 74, 76, 79];

    if(~manosLibresActivos.isNil) {
		~manosLibresActivos = List.new;
		 ~manosLibresRunning = true;
	};

    inf.do {
        var freqMidi, freqHz, ampI, decayI, synth, viejo;

        freqMidi = freqs.choose;
        freqHz   = freqMidi.midicps;
        ampI  = rrand(0.08, 0.16);
        decayI = rrand(6, 14);

        synth = Synth(\resonance, [
            \in, ~fbBus1,
            \out, ~fbBus1,
            \freq, freqHz,
            \decay, decayI,
            \amp, ampI
        ], ~fbGroup, \addToTail);

        ~manosLibresActivos.add(synth);

        ("freq: % | amp: % | decay: % "
            .format(freqMidi, ampI.round(0.01), decayI)
        ).postln;

        if(~manosLibresActivos.size > maxActivos) {
			viejo = ~manosLibresActivos.removeAt(0);
            viejo.set(\gate, 0);
			SystemClock.sched(decayI + 5, { viejo.free; nil });
        };

        rrand(6.0, 12.0).wait;
    };
});
)