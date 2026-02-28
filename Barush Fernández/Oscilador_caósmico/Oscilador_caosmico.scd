(
s.options.numBuffers = 1024 * 512;
s.options.memSize = 8192 * 64;
s.options.numWireBufs = 64;
s.options.maxNodes = 1024 * 64;
s.options.numOutputBusChannels = 8;
s.waitForBoot({

	~numCanales = 8;

	~tamanoBufs =  128;

	~buffers= ();


	~buffers.pasado = [];
	~buffers.presente = [];
	~buffers.futuro = [];
	~buffers.indeterminado = [];
	~buffers.indeterminadoSemilla = [];


	~numCanales.do{
		~buffers.pasado = ~buffers.pasado.add(Buffer.alloc(s, ~tamanoBufs));
		~buffers.presente = ~buffers.presente.add(Buffer.alloc(s, ~tamanoBufs));
		~buffers.futuro = ~buffers.futuro.add(Buffer.alloc(s, ~tamanoBufs));
		~buffers.indeterminado = ~buffers.indeterminado.add(Buffer.alloc(s, ~tamanoBufs));
		~buffers.indeterminadoSemilla = ~buffers.indeterminadoSemilla.add(Buffer.alloc(s, ~tamanoBufs));
	};
	~memorias = []!~numCanales;

	~path = thisProcess.nowExecutingPath.dirname ++ "/";
	~pathsMemorias = [];
	~numCanales.do{|i|
		var p = ~path ++ "waves" ++ i.asString ++ "/";
		File.mkdir(p); ~pathsMemorias = ~pathsMemorias.add(p)
	};

	~busesOut = [];
	~numCanales.do{ ~busesOut = ~busesOut.add(Bus.audio(s, 1))};
	~busesIn = ~busesOut;


	~cambios = (0..(~numCanales-1));

	~escala = Scale.minor(\just);
	~rapidez = 3000;

	SynthDef(\rec, {|in 0, buf|
		var rec;
		rec = RecordBuf.ar(In.ar(in), buf, loop:1.0, doneAction:2)}
	).add;

	SynthDef(\recShape,
		{|in 0, bufS, bufR|
			var rec, shape, inn;
			inn = In.ar(in);
			shape = Shaper.ar(bufS, inn);
			rec = RecordBuf.ar(shape, bufR, loop:1.0, doneAction:2)}
	).add;


	////////////////////
	///////semilla//////
	////////////////////


	~iniciar = {
		~shape = Buffer.alloc(s, 512, 1, { |buf| buf.chebyMsg([1.5, 0, 1, 1, 0, 1, 0, 1, 0, 1]) });

		SynthDef(\shape, {
			| out, sustain=1, freq=440, speed=1, begin=0, end=1, pan, accelerate, offset, volume 1|
			var son, env;
			son = Shaper.ar(~shape, SinOsc.ar(freq, 0, SinOsc.kr(1/accelerate/4, 0, 0.5, 0.5)),0.5);
			env = EnvGen.kr(Env.perc(0.2, sustain*10), doneAction:2);
			Out.ar(out,son*env*volume);
		}).add();

		Pdef(\muestra,
			Pbind(
				\instrument, \shape,
				\dur, 1/5*4,
				\scale, Pfunc({~escala}),
				\root, 3,
				\octave, 4,
				\degree,  Pwhite(-12, 12, inf),
				\accelerate, 3,
				\volume, 0.5,
				\sustain, 1.2,
				\out, ~busesOut /*++ [0,1]*/
			)
		);


		{
			Pdef(\muestra).play;
			300.wait;
			Pdef(\muestra).stop;
		}.fork;


		////////////////////
		///////presente/////
		////////////////////


		~synthsRec = [];
		~numCanales.do{|i| ~synthsRec = ~synthsRec.add(Synth(\rec, [\buf, ~buffers.presente[i], \in, ~busesIn[i]]))};

		~numCanales.do{|i|
			var index = i;
			r{inf.do{
				~busesIn = ~busesIn.scramble;
				~synthsRec[index].set(\in, ~busesIn[index]);

				//(index.asString ++ " con " ++ ~busesIn[index].asString).postln;
				~cambios[index] = ~busesOut.indexOf(~busesIn[index]);
				rrand(10, 30).wait;
			}}.play;
		};

/*
~buffers.presente[1].plot;
*/


		////////////////////
		///////futuro///////
		////////////////////


		~numCanales.do{|i|

			var index = i;
			~synthFuturo1 = Synth(\recShape, [\bufS, ~buffers.indeterminado[index], \bufR,~buffers.futuro[index], \in, ~busesIn[i]]);
			r{
				inf.do{
					var env, sig, wt, numSegs, espera;
					case(
						{~tamanoBufs == 64},{espera = 0.1},
						{~tamanoBufs == 128},{espera = 0.1/2},
						{~tamanoBufs == 256},{espera = 0.1/4},
						{~tamanoBufs == 512},{espera = 0.1/8},
						{~tamanoBufs >= 1024},{espera = 0.1/16},


					);
					numSegs = rrand(4, 32);
					env = Env(
						(({rrand(0.0,1)}!(numSegs + 1)) * [1, -1]),
						({exprand(1, 20)}!numSegs).normalizeSum * (1/s.sampleRate*~tamanoBufs),
						\sine
					);
					sig = env.asSignal(~tamanoBufs/2);
					wt = sig.asWavetable;
					//{wt.plot}.defer;

					~buffers.indeterminadoSemilla[index].loadCollection(wt);

					~buffers.indeterminadoSemilla[index].numFrames.do{|i|
						~buffers.indeterminadoSemilla[index].copyData(~buffers.indeterminado[index], i, i, 1);
						espera.wait;
					};
					rrand(0.1, 0.5).wait;
				}
			}.play;
		};

/*
~buffers.indeterminado[0].plot;
~buffers.indeterminadoSemilla[0].plot;
~buffers.futuro[1].plot;
*/


		////////////////////
		///////pasado///////
		////////////////////


		~numG = 0!~numCanales;

		~numCanales.do{|i|
			var index = i;
			r{

				inf.do{
					var wait = rrand(1, 10.0);
					~buffers.presente[index].write(~pathsMemorias[index] ++
						~numG[index].asString ++ ".wav", "WAV", "int24",
						~buffers.presente[index].numFrames, 0, false);

					~memorias[index] = ~memorias[index].add(Buffer.read(s, ~pathsMemorias[index] ++
						~numG[index].asString ++ ".wav", bufnum:(((index+1) * 20000) + ~numG[index])));

					~numG[index] = ~numG[index]+1;


					wait.wait;

					~buffers.futuro[index].write(~pathsMemorias[index] ++
						~numG[index].asString ++ ".wav", "WAV", "int24",
					~buffers.futuro[index].numFrames, 0, false);


					~memorias[index] = ~memorias[index].add(Buffer.read(s, ~pathsMemorias[index] ++
						~numG[index].asString ++ ".wav", bufnum:(((index+1) * 20000) + ~numG[index])));

					~numG[index] = ~numG[index]+1;


					wait.wait;

					~buffers.indeterminado[index].write(~pathsMemorias[index] ++
						~numG[index].asString ++ ".wav", "WAV", "int24",
						~buffers.indeterminado[index].numFrames, 0, false);


					~memorias[index] = ~memorias[index].add(Buffer.read(s, ~pathsMemorias[index] ++
						~numG[index].asString ++ ".wav", bufnum:(((index+1) * 20000) + ~numG[index])));

					~numG[index] = ~numG[index]+1;


					wait.wait;
					~memorias[index][rrand(0, (~memorias[index].size)-1)].copyData(~buffers.pasado[index], 0, 0, ~tamanoBufs);

				}
			}.play
		};

/*
~buffers.pasado[0].plot
*/


		/////////////////////////
		///////Osciladores///////
		/////////////////////////


		SynthDef(\memorias, {|amp 1, bufpos 0, freq, out 0, ss 0, bus, buss|
			var son;
			son = VOsc3.ar(bufpos, freq, freq, freq, 0.1 );
			son = Limiter.ar(son, 0.9);
			Out.ar([out, bus, buss],son);
		}).add
	};

	~tocar = {
		~numCanales.do{|i|
			var index = i, indexS = i.asSymbol, canales = [0, 1, 0, 1, 0, 1, 0, 1];

			Pdef(indexS,
				Pmono(\memorias,
					\dur, 0.01,
					\bufpos, Pseg(Pwhite(~memorias[index][0].bufnum, Pfunc({~memorias[index][~memorias[index].size -1].bufnum}), inf), Pwhite(0, 20, inf), 'exp', inf),
					\scale, Pfunc({~escala}),
					\root, 3,
					\octave, Pdup(Pwhite(500, 3000, inf),Pwhite(3, 4, inf)),
					\degree,  Pdup(Pwhite(1, Pfunc({~rapidez}), inf),Pwhite(-12, 12, inf)),
					\out, index,
					\bus, ~busesOut[index],
					\buss, ~busesScope[index],
				)//.trace(\bufpos)
			);

			Pdef(indexS).play;
		}

	};


	//////////////
	////GUI//////
	/////////////


	w = Window("Slider2D", Window.screenBounds);
	w.background = Color.black;


	~bufferScope = Buffer.alloc(s, 4096, ~numCanales);
	~busesScope = {Bus.audio(s, 1)}!~numCanales;

	w.onClose = {
		c.stop; a.free;
	};
	c = ScopeView(w.view, w.view.bounds.insetAll(10, 10, 10, 10)).style_(2);
	if(~numCanales <= 8, {c.waveColors = (Color.new255(175,80,229,255)!2) ++ (Color.cyan!2) ++ (Color.magenta!2) ++ (Color.blue!2)}, {c.waveColors = ({Color.rand}!~numCanales)});
	c.yZoom = 1.3;
	c.bufnum = ~bufferScope.bufnum;
	c.server = s;

	a = SynthDef("scope", { |bus, bufnum|
		var z;
		z = In.ar(bus, ~numCanales);

		ScopeOut2.ar(z, bufnum, 4096, 512);
	}).play(
		args: [\bus, ~busesScope, \bufnum, ~bufferScope.bufnum],
		addAction: \addToTail
	);
	c.start;


	~oscl = {StaticText(w, Rect(Window.screenBounds.width*rrand(0.1,0.8), Window.screenBounds.height*rrand(0.1,0.8), 100, 50))}!~numCanales;

	~oscl.do{|e, i|e.stringColor = Color.white; e.string = "osc" ++ i.asString; e.align = \center;e.font_(Font(size:15));};
	~lineas = UserView(w, w.view.bounds)
	.background_(Color.clear)
	.drawFunc_({
		var p1s, p2s;

		p1s = ~oscl.collect{|e|e.bounds.center};
		Pen.width = 2;
		Pen.color = Color.white;
		~oscl.do{|e, i|Pen.line(p1s[i], p1s[~cambios[i]])};
		Pen.stroke;
	});


	r{
		inf.do{
			var w, h, ws, hs, a, b;
			w = Window.screenBounds.width.asFloat;
			h = Window.screenBounds.height.asFloat;

			a = ~oscl.collect{|e| e.bounds.origin};
			b = a.collect{|e|
				var x, y;
				if(e.x >= (w-200)){x = e.x - rrand(50, 100)}{x = e.x + rrand(-50, 50)};
				if(e.y >= (h-200)){y = e.y - rrand(50, 100)}{y = e.y + rrand(-50, 50)};
				if(e.x <= 200){x = e.x + rrand(50, 100)};
				if(e.y <= 200){y = e.y + rrand(50, 100)};
				Point(x, y)};

			600.do{|i|
				var interp;
				interp = a + ((b - a) * (i/600));
				~oscl.do{|e, i|e.moveTo(interp[i].x, interp[i].y)};
				0.001.wait;
				~lineas.refresh;

			};
			0.001.wait;
		}
	}.play(AppClock);


	~menu = PopUpMenu(w, Rect(10, 10, 90, 20))
	.items_(Scale.names)
	.value_(16);

	~menu.action = {|menu| ~escala = Scale.at(menu.item.asSymbol);~escala.postln};

	~b = Button(w, Rect(110, 10, 180, 20))
	.states_([["iniciar", Color.black, Color.white]])
	.action_({~iniciar.value});
	~c = Button(w, Rect(300, 10, 180, 20))
	.states_([["tocar", Color.black, Color.white]])
	.action_({~tocar.value});



	~mp1 = ControlSpec(2, 3000, \linear, 0.01);
	~slider = Slider(w, Rect(490, 10, 180, 20))
	.background_(Color.clear)
	.value_(1)
	.action_({
		~rapidez = ~mp1.map(~slider.value)
	});
	r{~slider.action.value;0.01.wait;}.play(AppClock);


	w.front;
	w.fullScreen;
	CmdPeriod.doOnce({ w.close });
});
)