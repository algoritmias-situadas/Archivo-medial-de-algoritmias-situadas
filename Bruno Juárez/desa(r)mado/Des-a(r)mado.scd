s.boot;
//ejecutar de arriba a abajo en orden

~bocinas=2;
"pathi.scd".loadRelative;
"SynthDefs.scd".loadRelative;
"Pibinds.scd".loadRelative;

(x
"GRAFICOS.scd".loadRelative;
Routine{arg i;
	1.do{
		Synth(\chan1,[\in, 12, \atck, 1, \rel, 20, \tiempo,~urb.numFrames/s.sampleRate-rrand(60,90), \amp, 1.1]);
		a = ~inicio.play;
		rrand(60, 90.0).wait;
		Synth(\chan2,[\in, 19, \atck, 30, \rel, 60, \tiempo, 30, \amp, dbamp(-3)]);
		f = ~unoogranun.play;
		30.wait;
		a.stop;
		z=Synth(\chan1, [\in, 12, \atck, 5, \rel, 30, \tiempo, 120, \amp, dbamp(-3)]); //125
		b=~pianoso.play;
		30.wait;
		Synth(\chan3, [\in, 27, \atck, 35, \rel, 30, \tiempo, 60, \amp, dbamp(-3)]);//125
		w=~tuneogranundos.play;
		30.wait;
		f.stop;
		80.wait;
		Synth(\chan2, [\in, 19, \atck, 15, \tiempo, 60, \rel, 35]);//95
		k=~alerta.play;
		15.wait;
		y.stop;
		b.stop;
		Synth(\chan3, [\in, 27, \atck, 20, \tiempo,39, \rel, 1]);//60
		y=~kanye.play;
		60.wait;
		y.stop;
		Synth(\chan1, [\in, 12, \atck, 35, \tiempo, ~ariles.numFrames/s.sampleRate-30, \rel, 10]);//120
		m=~coral.play;
		35.wait;
		k.stop;
		65.wait;
		Synth(\chan3, [\in, 27, \atck, 20, \tiempo, 30, \rel, 0.1]);
		l=~locura.play;
		10.wait;
		m.stop;
		40.wait;
		l.stop;
		Synth(\chan1, [\in, 12, \atck, 0.1, \tiempo, ~augustomono.numFrames/s.sampleRate-1, \rel,1]);
		a=~agustinlara.play;
		Synth(\chan2, [\in, 19, \atck, 0.1, \tiempo, ~urb.numFrames/s.sampleRate-30, \rel, 30]);
		b=~paisaje.play;
		90.wait;
		a.stop;
		120.wait;
		b.stop;
		}}.play;
)
//la verdadera pieza, rutina para cada Pbind