// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Ecosistemas en resonancia >>>>>>>>>>>>>>>>>>>>>>>>
// por Joyce Jandette
// 2025/05
// Sección: Testimonios GUI

// basado en Ruviaro's Granular Synthesis (GUI), 2013-08-21
/*
Transp: nivel de transposición en semitonos
Dur: duración entre eventos
Reverse: probabilidad de reproducción en reversa (0-100%).
Rests: probabilidad de que ocurra un silencio (0-100%).
Overlap: números más pequeños "staccatto", números más grandes legato.
*/

(
~makeGUI_Testimonios  = { |view |

	var  transpToRate;

	// Init values
	~fragDurLo = 9; ~fragDurHi = 15;
	~restProb = 0;
	~rateLo = 1; ~rateHi = 1;
	~reverseProb = 0;
	~overlap = 0.8;
	~ampLo = 0.27; ~ampHi = 0.44;
	~panLo = -0.2; ~panHi = 0.2;
	~revt = 0.2;
	~size = 0.6;
	~revmixLo = 0.25; ~revmixHi = 0.35;
	~dt = 0.21;
	~dct = 0.2;
	~delampLo = 0.02; ~delampHi = 0.05;
	~valdur = 0.5;
	~revmix = 0.1;
	~amp = 0.5;

    // Variables globales de salida
	~numSpeakers = 2; // cambiar a número de altavoces disponibles
	~output = 2; // o 4 para MOTU!!!

	// transpSlider en semitonos
	transpToRate = {arg transp; transp.linexp(-24, 24, 0.25, 4)};

	~durSlider = EZRanger(
		parent: view,
		bounds: 530@30,
		label: "Duración  ",
		controlSpec: ControlSpec(
			minval:	0.1,
			maxval: 16,
			warp: 'exp',
			step: 0.1),
		action: {arg v;
			~fragDurLo = v.lo;
			~fragDurHi = v.hi;
		},
		initVal: [~fragDurLo, ~fragDurHi],
		labelWidth: 70)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~silencioSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "Silencio ",
		controlSpec: ControlSpec(
			minval:	0,
			maxval: 100,
			warp: 'lin',
			step: 1,
			units: "%"),
		action: {arg v;
			~restProb = v.value/100;
		},
		initVal: ~restProb,
		labelWidth: 70,
		unitWidth: 35)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~overlapSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "Overlap ",
		controlSpec: ControlSpec(
			minval:	0.5,
			maxval: 8,
			warp: 'exp',
			step: 0.1),
		action: {arg v;
			~overlap = v.value;
		},
		initVal: ~overlap,
		labelWidth: 63)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~panSlider = EZRanger(
		parent: view,
		bounds: 530@30,
		label: "Pan     ",
		controlSpec: ControlSpec(
			minval:	-1,
			maxval: ~numSpeakers - 1,
			warp: 'lin',
			step:  0.1),
		action: {arg v;
			~panLo = v.lo;
			~panHi = v.hi;
		},
		initVal: [~panLo ?? 0, ~panHi ?? (~numSpeakers - 1)],
		labelWidth: 60)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~ampSlider = EZRanger(
		parent: view,
		bounds: 530@30,
		label: "Amplitud ",
		controlSpec: ControlSpec(
			minval:	0.0,
			maxval: 1,
			warp: 'lin',
			step: 0.01,
			units: "amp"),
		action: {arg v;
			~ampLo = v.lo;
			~ampHi = v.hi;
		},
		initVal: [~ampLo, ~ampHi],
		labelWidth: 78)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~reverseSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "Revers ",
		controlSpec: ControlSpec(
			minval:	0,
			maxval: 100,
			warp: 'lin',
			step: 1,
			units: "%"),
		action: {arg v;
			~reverseProb = v.value/100;
		},
		initVal: ~reverseProb,
		labelWidth: 60,
		unitWidth: 35)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~revTimeSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "Rever Time ",
		controlSpec: ControlSpec(0.1, 7, 'exp', 0.1),
		action: { |v|
			~revt = v.value;
		},
		initVal: ~revt,
		labelWidth: 63)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~dtSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "Delay Time ",
		controlSpec: ControlSpec(0.1, 1.0, \lin, 0.01),
		action: { |v|
			~dt = v.value;
		},
		initVal: ~dt,
		labelWidth:  78)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~sizeSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "Size ",
		controlSpec: ControlSpec(0.5, 5, 'exp', 0.1),
		action: { |v|
			~size = v.value;
		},
		initVal: ~size,
		labelWidth:  63)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~dctSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "Decay ",
		controlSpec: ControlSpec(0.0, 0.99, \lin, 0.01, ""),
		action: { |v|
			~dct =v.value
		},
		initVal: ~dct,
		labelWidth: 78)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~revMixSlider = EZRanger(
		parent: view,
		bounds: 530@30,
		label: "Wet Rever ",
		controlSpec: ControlSpec(0.0, 1.0, \lin, 0.01),
		action: { |v|
			~revmixLo = v.lo;
			~revmixHi = v.hi;
		},
		initVal: [~revmixLo, ~revmixHi],
		labelWidth: 78)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~delampSlider = EZRanger(
		parent: view,
		bounds: 530@30,
		label: "Wet Delay",
		controlSpec: ControlSpec(0.0, 1.0, \lin, 0.01, ""),
		action: { |v|
			~delampLo = v.lo;
			~delampHi = v.hi;
		},
		initVal: [~delampLo, ~delampHi],
		labelWidth: 78)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~valdurSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "LENGTH \nViola-In",
		controlSpec: ControlSpec(
			minval: 0.05,
			maxval: 1.0,
			warp: 'exp',
			step: 0.01),
		action: { arg v;
			~valdur = v.value;
		},
		initVal: ~valdur,
		labelWidth: 63)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#8d9c09"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~revixSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "WET    \nViola-In",
		controlSpec: ControlSpec(
			minval: 0.01,
			maxval: 1.0,
			warp: 'lin',
			step: 0.14),
		action: { arg v;
			~revmix = v.value;
		},
		initVal: ~revmix,
		labelWidth: 63)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#8d9c09"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~gainSlider = EZSlider(
		parent: view,
		bounds: 530@30,
		label: "GAIN    \nViola-In",
		controlSpec: ControlSpec(
			minval: 0.1,
			maxval: 1.8,
			warp: 'lin',
			step: 0.01),
		action: { arg v;
			~amp = v.value;
		},
		initVal: ~amp,
		labelWidth: 63)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#8d9c09"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	~transpSlider = EZRanger(
		parent: view,
		bounds: 530@30,
		label: "Transp  ",
		controlSpec: ControlSpec(
			minval:	-24, // two octaves below
			maxval: 24, // two octaves above
			warp: 'lin',
			step: 1, // step by semitones
			units: " ST"),
		action: {arg v;
			~rateLo = transpToRate.value(v.lo);
			~rateHi = transpToRate.value(v.hi)
		},
		initVal: [0, 0],
		labelWidth: 60,
		unitWidth: 30)
	.font_(Font("Optima", 12))
	.setColors(Color.fromHexString("#08807b"),Color.black, Color(0.7,0.8,0.4),Color.fromHexString("#eb9605"), Color.white,
		Color.white, knobColor:Color.fromHexString("#d44222"));

	//	Viola-in
	// Reproduce los buffers para su salida hacia el transductor
	~violainButton = Button.new(view, 530@30)
	.states_([["PLAY VIOLA-IN    ", Color.black, Color.fromHexString("#6e1e62")]])
	.font_(Font("Optima", 12))
	.action_({
		if (~bofs.isNil or: { ~bofs.isEmpty }) {
			"Buffers no cargados aún.".warn;
			^nil;
		};
		~playRandom.();
	});

	// Subcarpetas (sustituye por tus directorios)
~voices_paths = [
    "/Users/joyce/Documents/Feedback/Patches/Finales/voices/1. Intro/",
    "/Users/joyce/Documents/Feedback/Patches/Finales/voices/2. Desarrollo/",
    "/Users/joyce/Documents/Feedback/Patches/Finales/voices/3. Final/"
];

~voices_labels = ["1. Barbecho", "2. Siembre", "3. Cosecha"];

// Valor inicial
~path = ~voices_paths[0];

// Menu de seleción de subcarpeta de audios
~subcarpeta = PopUpMenu.new(view, Rect(10, 50, 300, 24))
    .items_(~voices_labels)
    .font_(Font("Optima", 12))
    .background_(Color.fromHexString("#eaeaea"))
    .stringColor_(Color.black)
    .action_({ |menu|
        ~path = ~voices_paths[menu.value];
        ("Carpeta seleccionada (~path): " ++ ~path).postln;
    });

	// Botón para cargar los audios de las subcarpetas
~testisButton = Button.new(view, Rect(320, 50, 210, 24))
    .states_([["TESTIMONIOS    ", Color.black, Color.fromHexString("#6e1e62")]])
    .font_(Font("Optima", 12))
    .action_({
        ~bofs.notNil.if { ~bofs.do(_.free) };
        if (~path.isNil) {
            "No hay carpeta seleccionada. Selecciona una en el Menú".warn;
            ^nil;
        };
        ~nombres = PathName.new(~path).files.collect(_.fileName).select { |f| f.toLower.endsWith(".wav") };
        if (~nombres.isEmpty) {
            ("No se encontraron .wav en: " ++ ~path).postln;
            ^nil;
        };
        ~bofs = ~nombres.collect { |x| Buffer.read(s, ~path ++ x) };
        "Buffers cargados: %".format(~bofs.size).postln;
    });

	// Viola-out
	~violaoutButton = Button.new(view, 530@30)
	.states_([["PLAY VIOLA-OUT    ", Color.black, Color.fromHexString("#6e1e62")], ["STOP", Color.black,
		Color.fromHexString("#db4b23")]])
	.font_(Font("Optima", 12))
	.action_({arg button;
		if (button.value == 1) {
			// START
			if (~bofs.isNil or: { ~bofs.isEmpty }) {
				"Buffers no cargados aún.".warn;
				button.value = 0;
				^nil;
			};
			~player = ~pattern.play;
			("Tocando de " ++ ~bofs.size ++ " archivos").postln;
		} {
			if (~player.notNil) {
				~player.stop;
				~player = nil;
			};
		};
	});

	// Play Paisaje
	// Reproduce un archivo de audio como soporte fijo

	~paisajeButton = Button.new(view, 260@30)
	.font_(Font("Optima", 12))
	.states_([
		["Play Paisaje", Color.black, Color.fromHexString("#6e1e62")],
		["STOP", Color.black, Color.fromHexString("#db4b23")]])
	.value_(0)
	.action_({ |b|
		if(b.value == 1) {
			~paisajeSynth = Synth(\paisajeTestis, [\bufnum, ~paisaje.bufnum, \amp, ~amps[15]]);
		} {
			~paisajeSynth.set(\gate, 0);
			//~paisajeSynth = nil;
		};
	};);


	//  Slider Paisaje
	// Control de amplitúd del archivo de soporte fijo

	~sliders[15] = Slider.new(view, Rect(260, 60, 220, 30)) // Slider PaisajeVol
	.background_(Color(0.7, 0.8, 0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.value_(~amps[15])
	.orientation_(\horizontal)
	.action_({ |s|
	var val = s.value;
	if (val.notNil) {
		~amps[15] = val;
		if (~paisajeSynth.notNil) {
			~paisajeSynth.set(\amp, ~ampSpec.map(val));
		};
		if (~paisajeLabel.notNil) {
			~paisajeLabel.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
		};
	};
});

// Label
~paisajeLabel = StaticText(view, Rect(260, 85, 15, 25))
	.string_(~ampSpec.map(~sliders[15].value).ampdb.round(0.1).asString ++ " dB")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(Font("Optima", 10))
	.align_(\center);

// MIDIdef - Declaración MIDI para el control de amplitud desde controlador midi

	~amps = ~amps ?? { Array.fill(16, 0.0) };
	~scatch = ~scatch ?? { Array.fill(16, false) };
	~pcatch = ~pcatch ?? { Array.fill(16, false) };
	~sliders = ~sliders ?? { Array.fill(16, nil) };
	~ampSpec = ~ampSpec ?? { ControlSpec(0.001, 1.0, \lin, 0.01) };

	MIDIdef.cc(\sliderPaisaje, { |val, cnum|
		if (cnum == 15 and: { ~currentLayer == 1 }) {
			var index = 15;
			var normVal = val / 127;
			var mappedVal = ~ampSpec.map(normVal);
			var guiVal = ~amps[index];
			var threshold = 0.01;

        if (~scatch[index] or: { (normVal - ~ampSpec.unmap(guiVal)).abs < threshold }) {
            ~amps[index] = mappedVal;
            ~scatch[index] = true;

            AppClock.sched(0.0, {
                if (~paisajeSlider.notNil) {
                    ~paisajeSlider.value = normVal;
                };
            });

            if (~paisajeSynth.notNil) {
                ~paisajeSynth.set(\amp, mappedVal);
            };
        } {
            ("[Esperando catch] Paisaje Slider | GUI: " ++ guiVal.round(0.01) ++
			" | Físico: " ++ normVal.round(0.01)).postln;
        };
    };
}, chan: 0);


//************************************************************************************************* Randomness
// Inicializar historial vacío
~recentBufsByFolder = IdentityDictionary.new; // key: path, value: List
// Función de selección aleatoria de buffers evitando repeticiones
~selectRandomBuffer = {
    var buf, remaining, recent, maxRecentLocal;
    recent = ~recentBufsByFolder[~path] ?? { List.new };
    ~recentBufsByFolder[~path] = recent;
    maxRecentLocal = (~bofs.size * 0.9).asInteger.max(1); // evitar repetir el 90% de la carpeta
    remaining = ~bofs.size - recent.size;
    if (remaining > 0) {
        buf = ~bofs.reject({ |b| recent.includes(b) }).choose;
    } {
        recent.clear; // reinicia cuando se han usado casi todos
        buf = ~bofs.choose;
    };
    recent.add(buf);
    if (recent.size > maxRecentLocal) { recent.removeAt(0) };
    buf
};

//************************************************************************************************* Play  Viola-out / Pbind
// Declarar SynthDef Viola-out
	SynthDef(\testisviolaout, {|
		buf, start = 0, rate = 1, loop = 0, reverse = 1, gate = 1,
		amp, atk = 0.1, rel = 0.1, cur = 1, sustain = 1, pan = 0,
		revt = 1, size = 1, revmix, dt = 0.2, dct = 1, delamp |
		var sig, env, dry, dly, verb, wet;
		sig = PlayBuf.ar(1, buf, rate * reverse, 1.0, start, loop, 2);
		env = EnvGen.kr(Env.linen(atk, (sustain - atk - rel).max(0.01), rel, curve: cur),gate, 2);
		sig = sig * env * amp;
		dry = sig;
		dly = CombC.ar(sig, 0.2, dt, dct) * delamp;
		verb = FreeVerb.ar(sig, revmix, size, 0.5);
		wet = dly + verb;
		sig = dry + Mix(wet);
		Out.ar(~output, PanAz.ar(~numSpeakers, sig, pan));
	}).add;

	// Declarar Pbind
	~pattern = Pbind(
		\instrument, \testisviolaout,
		\buf, Pfunc { ~selectRandomBuffer.() },
		\fragDur, Pwhite(Pfunc({~fragDurLo}), Pfunc({~fragDurHi})),
		\dur, Pkey(\fragDur) / Pfunc({ ~overlap }),
		\start, Pfunc { |e|
			var buf, fragDur, start;
			buf = e[\buf];
			fragDur = e[\fragDur];
			start = ((buf.duration - fragDur).max(0).rand * buf.sampleRate).asInteger;
		},
		\makeRest, Pif(Pfunc({ ~restProb.coin }), Rest(), 0),
		//\legato, Pfunc({~overlap}),
		\sustain, Pkey(\fragDur),
		\rate, Pwhite(Pfunc({~rateLo}), Pfunc({~rateHi})),
		\reverse, Pif(Pfunc({ ~reverseProb.coin }), -1, 1),
		\amp, Pwhite(Pfunc({~ampLo}), Pfunc({~ampHi})),
		\pan, Pwhite(Pfunc({~panLo}), Pfunc({~panHi})),
		\revt, Pfunc({~revt}),
		\size, Pfunc({~size}),
		\revmix, Pwhite(Pfunc({~revmixLo}), Pfunc({~revmixHi})),
		\dt, Pfunc({~dt}),
		\dct, Pfunc({~dct}),
		\delamp, Pwhite(Pfunc({~delampLo}), Pfunc({~delampHi})),
		\atk, 0.01,
		\rel, Pwhite(1.5, 2, inf),
		\cur, Pwhite(-2.0, 2.0, inf)
	);

//************************************************************************************************* Play  Viola-in / Función
	// Declarar SynthDef Viola-in;
	SynthDef(\testisviolain, {
		|buf, start 0, rate 1, loop 0, dur 1,
		out 0, amp 0, atk 0.01, rel 0.1, cur 1, revt 1, size 1, revmix 0 |
		var sig, env, envDur, playDur, verb;
		playDur = (BufDur.ir(buf) - (start / BufSampleRate.ir(buf))).clip(0.01, inf);
		envDur = dur.clip(0.01, playDur);
		sig = PlayBuf.ar(1, buf, rate, 1.0, start, loop, 2);
		env = EnvGen.kr(Env.linen(atk, (envDur - atk - rel).max(0.01), rel, curve: cur), doneAction: 2);
		sig = sig * env * amp;
		verb = JPverb.ar(sig, revt, 0, size, 0.707) * revmix;
		sig = sig + verb;
		Out.ar(out, sig);
	}).add;


		// Reproduce los buffers de manera aleatoria. Un buffer cada vez que se presiona el botón

	~playRandom = {
		var buf, dur, start, maxStart;
		buf = ~selectRandomBuffer.();
		if (~valdur >= 1.0) {
			dur = buf.duration;
			start = 0;
		} {
			dur = (buf.duration * ~valdur).clip(0.05, buf.duration);
			maxStart = (buf.duration - dur).max(0);
			start = (maxStart.rand * buf.sampleRate).asInteger;
		};

		// Instanciar Synth (en vez de patrón, lanzar 1 cada vez)
		~violain = Synth(\testisviolain, [
			\buf, buf,
			\out, 0,
			\start, start,
			\dur, dur,
			\atk, 0.01,
			\rel, 0.5,
			\cur, -4,
			\amp, ~amp,
			\revt, 0.1,
			\size, 1,
			\revmix, ~revmix,
		]);
	};

//************************************************************************************************* Play  Soporte fijo
	// Sección para leer, reproducir y espacializar la reporducción de un archivo de soporte fijo.

	~paisaje = Buffer.read(s, "/Users/joyce/Documents/Feedback/Patches/Finales/Voces re-existentes.wav"); // cambia con tu proio archivo

	SynthDef(\paisajeTestis, {
		|bufnum, out = 1, amp = 0, gate = 1, rate = 1, rotSpeed = 0.05|
		var sig, env, sigL, sigR, posL, posR, rot, sig8;
		env = EnvGen.kr(Env.asr(3, 1, 3), gate, doneAction: 2);
		sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * rate, loop: 1);
		sigL = sig[0];
		sigR = sig[1];
		rot = LFSaw.kr(rotSpeed, 0, 1, 1);
		posL = rot.wrap(0, 2) - 1;
		posR = (rot + 0.25).wrap(0, 2) - 1;
		sigL = PanAz.ar(2, sigL, posL);
		sigR = PanAz.ar(2, sigR, posR);
		sig8 = (sigL + sigR) * amp * env;
		Out.ar(~output, sig8);
	}).add;
};
)









