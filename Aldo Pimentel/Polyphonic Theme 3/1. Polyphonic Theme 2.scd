(
"SynthDefs.scd".loadRelative;
"PbindsRoutines.scd".loadRelative;
)

(
Routine({
	var vin, int, grano, fondo, bajo, piano, saxo, ruido, estallido, impro, zzz;
	t = TempoClock(120/60);
	vin = Synth(\vinil);
	5.wait;
	int = Synth(\trona);
	15.wait;
    grano = Synth(\grano);
	25.wait;
	60.do({ |i|
		grano.set(\na, i * (30 / 60.0), \no, i * (0.8 / 60.0));
		vin.set(\amp, 0.5 * (1-(i / 60.0)));
		0.5.wait;
	});
	vin.free;
	25.wait;
	fondo = Synth(\fondo);
	50.do({ |i|
		grano.set(\amp, 0.3 * (1 - (i / 50.0)));
		fondo.set(\amp, i * (0.7 / 50));
		0.2.wait;
	});
	grano.free;
	5.wait;
	"empieza".postln;
	~ostb.play(t);
	8.wait(t);
	piano = Pxrand([d, e, f, g, h, p], 12).play(t);
	saxo = Pxrand([i, j, k, l, o, p], 12).play(t);
	bajo = Pxrand([~ostb, a, b, c, ~de], 12).play(t);
	96.wait(t);
	Synth(\ruido);
	"impro".postln;
	impro = ~impro;
	estallido = Synth(\estfm);
	50.do({ |i|
		fondo.set(\amp, 0.7 * (1 - (i / 50.0)));
		estallido.set(\fm, i * (3.4 / 50.0) + 1.5);
		0.2.wait;
	});
	impro.play;
	fondo.free;
	50.do({ |i|
		estallido.set(\amp, 0.5 * (1 - (i / 50.0)));
		0.1.wait;
	});
	90.wait(t);
	estallido.free;
	estallido = Synth(\estfm, [\amp, 0.5, \fm, 1.5]);
	50.do({ |i|
		estallido.set(\fm, i * (3.4 / 50.0) + 1.5);
		~ampb = ~ampb -0.2;
		~amppp = ~amppp - 0.002;
		0.1.wait;
	});
	"empieza 2".postln;
	~amppp = 0;
	~ritmo = Synth(\ritmo);
	2.wait(t);
	impro.stop;
	"2".postln;
	~ampb = -100;
	~cadenab.play(t);
	~cadenap.play(t);
	~cadenas.play(t);
	~checadoruno.play;
	~checadordos.play;
	~checadortres.play;
	50.do({ |i|
		estallido.set(\amp, 0.5 * (1 - (i / 50.0)));
		0.5.wait;
	});
	estallido.free;
}).play;
)