// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Ecosistemas en resonancia >>>>>>>>>>>>>>>>>>>>>>>>
// por Joyce Jandette
// 2025/12
// Sección: Sistema de Feedback GUI

// Inicialización MIDI
// Se limpian definiciones previas y se conecta a todos los dispositivos MIDI

MIDIdef.freeAll;
MIDIClient.init;
MIDIIn.connectAll;


(
~makeGUI_SF = { |view |
var font, fonti, meterWindow, nodeWindow;

	~eq     = nil;
	~inicio = nil;
	~ring   = nil;
	~phase  = nil;
	~reso1  = nil;
	~reso2  = nil;
	~rms    = nil;
	~dis1   = nil;
	~dis2   = nil;
	~dis3   = nil;
	~pulse0 = nil;
	~pulse1 = nil;
	~pulse2 = nil;
	~pulse3 = nil;
	~paisajeSynth = nil;

	// Variables globales para control por sliders y potenciometros
	~amps = Array.fill(16, 0.0);  //amplitudes (sliders)
	~peris = Array.fill(16, 0.0);  // Parametros (knobs)
	~perisNorm = Array.fill(16, 0.0);   // valores normalizados 0..1 para GUI
	~pcatch = Array.fill(16, false);  // Knobs capturados

	font = Font("Optima", 12);
	fonti = Font("Optima", 10);

// ------------------------------------------------------------------------------------------------------------ METTER/NODE
// ------------------------ Monitorización ----------------------
// METTER
	~meterButton = Button(view, Rect(30, 310, 60, 30))
	.states_([
		["Meter", Color.black, Color.fromHexString("#6e1e62")],
        ["Meter", Color.white, Color.fromHexString("#eb9605")]
    ])
	.font_(font)
    .action_({ |v|
		if (v.value == 1) {
			meterWindow = s.meter;
        } {
            if (meterWindow.notNil) {
				meterWindow.close;
				meterWindow = nil;
            };
        };
    });

// NODE TREE
	~nodeButton = Button(view, Rect(30, 275, 60, 30))
    .states_([
        ["Node Tree", Color.black, Color.fromHexString("#6e1e62")],
        ["Node Tree", Color.white, Color.fromHexString("#eb9605")]
    ])
    .font_(font)
    .action_({ |v|
        if (v.value == 1) {
            nodeWindow = s.plotTree;
        } {
            if (nodeWindow.notNil) {
                nodeWindow.close;
				nodeWindow = nil;
            };
        };
    });

// ----------------------------------------------------------------------------------------------------------Botón0/IN MIC
	~boton0 = Button(view, Rect(30 + (0 * 65), 30, 60, 50))
	.font_(font)
    .states_([
	["In \nMic", Color.black, Color.fromHexString("#8d9c09")],
		["Off \nMic", Color.white, Color.fromHexString("#db4b23")]
    ])
    .value_(0)
    .action_({ |b|
    if (b.value == 1) {
         ~inputMic = Synth(\inputMic, [\out, ~inBus,  \copyOut, ~analysisBus],target: ~inputGroup);
    } {
        ~inputMic.free
    };
};);

// ----------------------------------------------------------------------------------------------------------Botón1-Inicio
// On/Off Inicio
	~boton1 = Button(view, Rect(30 + (1 * 65), 30, 60, 50))
	.font_(font)
    .states_([
		["Play \nInicio", Color.black, Color.fromHexString("#08807b")],
		["Stop \nInicio", Color.white, Color.fromHexString("#fb4848")]
	])
    .value_(0)
    .action_({ |b|
		if (b.value == 1) {
			~inicio = Synth(\inicio, [\in, ~inBus, \out,~fbBus1, \amp, ~amps[0]], target: ~inputGroup, addAction:\addToTail );
		} {
			~inicio.set(\gate, 0);
		};
	};);

// Slider Inicio
	~slider1 = Slider(view, Rect(40 + (1 * 65), 90, 35, 130))
    .background_(Color(0.7,0.8,0.4))
    .knobColor_(Color.fromHexString("#d44222"))
    .orientation_(\vertical)
    .value_(0)
    .action_({ |s|
		var val = s.value;
		~amps[0] = val;
		if (~inicio.notNil) {
			~inicio.set(\amp, val);
		};
		~sliderLabel1.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

// Texto slider Inicio
~sliderLabel1 = StaticText(view, Rect(40 + (1 * 65), 220, 40, 20))
    .string_(~slider1.value.round(0.01).asString)
    .stringColor_(Color.fromHexString("#d44222"))
    .font_(fonti)
    .align_(\center);

// ----------------------------------------------------------------------------------------------------------EQ
	~botoneq = Button(view, Rect(30, 93, 60, 50))
    .font_(font)
    .states_([
	["In \nEQ", Color.black, Color.fromHexString("#8d9c09")],
        ["Off \nEQ", Color.white, Color.fromHexString("#db4b23")]
    ])
    .value_(0)
	.action_({ |b|
        if (b.value == 1) {
			~eq = Synth(\eq, [ \in, ~fbBus1, \out, ~fbBus2, \mix, ~peris[0], \globalCentroid, ~ctrlBuses.globalCentroid,\globalFlatness, ~ctrlBuses.globalFlatness], target: ~fbGroup, addAction: \addToHead);
        } {
            ~eq.set(\gate, 0);
        };
    });

	~pote1 = Knob(view, Rect(40, 150, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
	    Color.fromHexString("#d44222"),
        Color.red.alpha_(0.3),
        Color.black
	])
    .value_(0)
    .mode_(\vert)
    .action_({ |p|
	var val = p.value;
	var real = ~periSpecs[0].map(val);
	~peris[0] = real;
		real.postln;
		if (~eq.notNil) {
			~eq.set(\mix, real);
        };
    });

	~potelabel1 = StaticText(view,Rect(41,170,37,60))
	.string_("WET")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(Font("Monaco", 10))
    .align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón2-Ringmod
// On/Off Ring
	~boton2 = Button(view, Rect(30 + (2 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nRing", Color.black, Color.fromHexString("#08807b")],
		["Stop \nRing", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~ring = Synth(\ringmod, [\in, ~fbBus2, \out,~fbBus1, \amp, ~amps[1],\filtFreq, ~peris[1]], target: ~fbGroup,  addAction:\addToTail);
		} {
			~ring.set(\gate, 0);
		};
	};);

// Slider Ring
	~slider2 = Slider(view, Rect(170, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[1] = val;
		if (~ring.notNil) {
			~ring.set(\amp, val);
		};
		~sliderLabel2.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel2 = StaticText(view, Rect(170, 220, 40, 20))
	.string_(~slider2.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote2 = Knob(view, Rect(170, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[1].map(val);
		~peris[1] = real;
		real.postln;
		if (~ring.notNil) {
			~ring.set(\filtFreq, real);
		};
	});


	~potelabel2 = StaticText(view,Rect(170,260,37,60))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón3-Phaser
// On/Off Phaser
	~boton3 = Button(view, Rect(30 + (3 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nPhaser", Color.black, Color.fromHexString("#08807b")],
		["Stop \nPhaser", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~phase = Synth(\phaser, [\in, ~fbBus2, \out,~fbBus1, \amp, ~amps[2], \wet, ~peris[2], \systemChaos, ~ctrlBuses.systemChaos], target: ~fbGroup,  addAction:\addToTail);
		} {
			~phase.set(\gate, 0);
		};
	};);

// Slider Phaser
	~slider3 = Slider(view, Rect(235, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[2] = val;
		if (~phase.notNil) {
			~phase.set(\amp, val);
		};
		~sliderLabel3.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel3 = StaticText(view, Rect(235, 220, 40, 20))
	.string_(~slider3.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote WET
	~pote3 = Knob(view, Rect(235, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)  // valor inicial razonable
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[2].map(val);
		~peris[2] = real;
		real.postln;
		if (~phase.notNil) {
			~phase.set(\wet, real);
		};
	});

~potelabel3 = StaticText(view,Rect(235,260,37,60))
   .string_("WET")
   .stringColor_(Color.fromHexString("#d44222"))
   .font_(font)
   .align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón4-Reso1
// On/Off Resonance 1
	~boton4 = Button(view, Rect(30 + (4 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nReso 1", Color.black, Color.fromHexString("#08807b")],
		["Stop \nReso 1", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~reso1 = Synth(\resonance, [\in, ~fbBus2, \out,~fbBus1, \freq, 69.midicps, \amp, ~amps[3], \decay,~peris[3], \globalRMS, ~ctrlBuses.globalRMS], target: ~fbGroup,  addAction:\addToTail);
		} {
			~reso1.set(\gate, 0); // Detener el patrón
		};
	};);

// Slider Resonance 1
	~slider4 = Slider(view, Rect(300, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[3] = val;
		if (~reso1.notNil) {
			~reso1.set(\amp, val);
		};
		~sliderLabel4.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel4 = StaticText(view, Rect(300, 220, 40, 20))
	.string_(~slider4.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Decay
	~pote4 = Knob(view, Rect(300, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)  // valor inicial razonable
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[3].map(val);
		~peris[3] = real;
		real.postln;
		if (~reso1.notNil) {
			~reso1.set(\decay, real);
		};
	});

	~potelabel4 = StaticText(view,Rect(235,260,170,60))
	.string_("DECAY")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// Cambio de frecuencias
	~botonfreq1 = Button(view, Rect(300, 310, 50, 30))  // debajo de potelabel4
	.font_(font)
	.states_([
		["A4", Color.white, Color.fromHexString("#eb9605")],
		["E4", Color.white, Color.fromHexString("#eb9605")],
		["C#4", Color.white, Color.fromHexString("#eb9605")],
		["C4", Color.white, Color.fromHexString("#eb9605")],
		["A#3", Color.white, Color.fromHexString("#eb9605")]
	])
	.value_(0)
	.action_({ |b|
        var freqValues = [69, 64, 61, 60, 58];
		var freqVal = freqValues[b.value].midicps;
		if (~reso1.notNil) {
			~reso1.set(\freq, freqVal);
		};
	});

// ----------------------------------------------------------------------------------------------------------Botón5-Reso2
//On/Off Resonance 2
	~boton5 = Button(view, Rect(30 + (5 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nReso 2", Color.black, Color.fromHexString("#08807b")],
		["Stop \nReso 2", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~reso2 = Synth(\resonance, [\in, ~fbBus2, \out,~fbBus1, \freq, 48.midicps, \amp, ~amps[4], \decay,~peris[4], \globalRMS, ~ctrlBuses.globalRMS], target: ~fbGroup,  addAction:\addToTail);
		} {
			~reso2.set(\gate, 0);
		};
	};);

// Slider Resonance 2
	~slider5 = Slider(view, Rect(365, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[4] = val;
		if (~reso2.notNil) {
			~reso2.set(\amp, val);
		};
		~sliderLabel5.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

~sliderLabel5 = StaticText(view, Rect(365, 220, 40, 20))
    .string_(~slider5.value.round(0.01).asString)
    .stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Decay
	~pote5 = Knob(view, Rect(365, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)  // valor inicial razonable
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[4].map(val);
		~peris[4] = real;
		real.postln;
		if (~reso2.notNil) {
			~reso2.set(\decay, real);
		};
	});

	~potelabel5 = StaticText(view, Rect(365, 280, 50, 20))
	.string_("DECAY")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// Cambio de frecuencias
	~botonfreq2 = Button(view, Rect(365, 310, 50, 30))
	.font_(font)
	.states_([
		["B0", Color.white, Color.fromHexString("#eb9605")],
		["C#1", Color.white, Color.fromHexString("#eb9605")],
		["F#2", Color.white, Color.fromHexString("#eb9605")],
		["B2", Color.white, Color.fromHexString("#eb9605")],
		["C3", Color.white, Color.fromHexString("#eb9605")],
		["G3", Color.white, Color.fromHexString("#eb9605")]
	])
	.value_(0)
	.action_({ |b|
		var freqValues = [23, 25, 42, 47, 48, 55];
		var freqVal = freqValues[b.value].midicps;
		if (~reso2.notNil) {
			~reso2.set(\freq, freqVal);
		};
	});

// ----------------------------------------------------------------------------------------------------------Botón 6-RMS
// On / Off RMS
	~boton6 = Button(view, Rect(30 + (6 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nRMS ", Color.black, Color.fromHexString("#08807b")],
		["Stop \nRMS ", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~rms = Synth(\rms, [\in, ~fbBus2, \out,~fbBus1, \inAmp0, ~amps[5], \filtQ, ~peris[5], \systemChaos, ~ctrlBuses.systemChaos], target: ~fbGroup,  addAction:\addToTail);
		} {
			~rms.set(\gate, 0); // Detener el patrón
		};
	};);

// Slider RMS
	~slider6 = Slider(view, Rect(430, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[5] = val;
		if (~rms.notNil) {
			~rms.set(\inAmp0, val);
		};
		// actualizar valor mostrado
		~sliderLabel6.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel6 = StaticText(view, Rect(430, 220, 40, 20))
	.string_(~slider6.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote dyndB
	~pote6 = Knob(view, Rect(430, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[5].map(val);
		~peris[5] = real;
		real.postln;
		if (~rms.notNil) {
			~rms.set(\filtQ, real);
		};
	});

	~potelabel6 = StaticText(view, Rect(430, 280, 50, 20))
	.string_("filtQ")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón 7-Dis1
// On/Off  Disonance 1
	~boton7 = Button(view, Rect(30 + (7 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nDis 1", Color.black, Color.fromHexString("#08807b")],
		["Stop \nDis 1", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~dis1 = Synth(\disonance, [\in, ~fbBus2, \out,~fbBus1, \amp, ~amps[6],\freqm, ~peris[6], \globalRMS, ~ctrlBuses.globalRMS], target: ~fbGroup,  addAction:\addToTail);
		} {
			~dis1.set(\gate, 0); // Detener el patrón
		};
	};);

// Slider Disonance 1
	~slider7 = Slider(view, Rect(	495, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[6] = val;
		if (~dis1.notNil) {
			~dis1.set(\amp, val);
		};
		~sliderLabel7.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel7 = StaticText(view, Rect(495, 220, 40, 20))
	.string_(~slider7.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote7 = Knob(view, Rect(495, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[6].map(val);
		~peris[6] = real;
		real.postln;
		if (~dis1.notNil) {
			~dis1.set(\freqm, real);
		};
	});

	~potelabel7 = StaticText(view, Rect(495, 280, 50, 20))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón 8-Dis2
//On/Off Disonance 2
	~boton8 = Button(view, Rect(30 + (8 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nDis 2", Color.black, Color.fromHexString("#08807b")],
		["Stop \nDis 2", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~dis2 = Synth(\disonance, [\in, ~fbBus2, \out,~fbBus1, \freq, 200, \amp, ~amps[7], \freqm, ~peris[7], \globalRMS, ~ctrlBuses.globalRMS], target: ~fbGroup,  addAction:\addToTail);
		} {
			~dis2.set(\gate, 0); // Detener el patrón
		};
	};);

//Slider Disonance 2
	~slider8 = Slider(view, Rect(560, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[7] = val;
		if (~dis2.notNil) {
			~dis2.set(\amp, val);
		};
		~sliderLabel8.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel8 = StaticText(view, Rect(560, 220, 40, 20))
	.string_(~slider8.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote8 = Knob(view, Rect(560, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)  // valor inicial razonable
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[7].map(val);
		~peris[7] = real;
		real.postln;
		if (~dis2.notNil) {
			~dis2.set(\freqm, real);
		};
	});

	~potelabel8 = StaticText(view, Rect(560, 280, 50, 20))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón 9-Dis3
// On/ Off Disonance 3
	~boton9 = Button(view, Rect(30 + (9 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nDis 3", Color.black, Color.fromHexString("#08807b")],
		["Stop \nDis 3", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~dis3 = Synth(\disonance, [\in, ~fbBus2, \out,~fbBus1, \freq, 300, \amp, ~amps[8], \freqm, ~peris[8], \globalRMS, ~ctrlBuses.globalRMS], target: ~fbGroup,  addAction:\addToTail);
    } {
			~dis3.set(\gate, 0);
		};
	};);

// Slider Disonance 3
	~slider9 = Slider(view, Rect(625, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[8] = val;
		if (~dis3.notNil) {
			~dis3.set(\amp, val);
		};
		~sliderLabel9.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel9 = StaticText(view, Rect(625, 220, 40, 20))
	.string_(~slider9.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote9 = Knob(view, Rect(625, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[8].map(val);
		~peris[8] = real;
		real.postln;
		if (~dis3.notNil) {
			~dis3.set(\freqm, real);
		};
	});

	~potelabel9 = StaticText(view, Rect(625, 280, 50, 20))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón 10-Pulse0
// On / Off Pulse 0
	~boton10 = Button(view, Rect(30 + (10 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nPulse 0", Color.black, Color.fromHexString("#08807b")],
		["Stop \nPulse 0", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~pulse0 = Synth(\pulse,[\in, ~fbBus2, \out,~fbBus1, \amp, ~amps[9], \freqm, ~peris[9]], target: ~fbGroup,  addAction:\addToTail);
		} {
			~pulse0.set(\gate, 0); // Detener el patrón
		};
	};);

// Slider Pulse 0
	~slider10 = Slider(view, Rect(690, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[9] = val;
		if (~pulse0.notNil) {
			~pulse0.set(\amp, val);
		};
		// actualizar valor mostrado
		~sliderLabel10.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel10 = StaticText(view, Rect(690, 220, 40, 20))
	.string_(~slider10.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote10 = Knob(view, Rect(690, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[9].map(val);
		~peris[9] = real;
		real.postln;
		if (~pulse0.notNil) {
			~pulse0.set(\freqm, real);
		};
    });

	~potelabel10 = StaticText(view, Rect(690, 280, 50, 20))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón 11-Pulse1
// On/ Off Pulse 1
	~boton11 = Button(view, Rect(30 + (11 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nPulse 1", Color.black, Color.fromHexString("#08807b")],
		["Stop \nPulse 1", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~pulse1 = Synth(\pulse, [\in, ~fbBus1, \out,~fbBus2, \amp, ~amps[10], \freqm, ~peris[10], \systemChaos, ~ctrlBuses.systemChaos], target: ~fbGroup,  addAction:\addToTail);
		} {
			~pulse1.set(\gate, 0);
		};
	};);

// Slider Pulse 1
	~slider11 = Slider(view, Rect(755, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[10] = val;
		if (~pulse1.notNil) {
			~pulse1.set(\amp, val);
		};
		~sliderLabel11.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel11 = StaticText(view, Rect(755, 220, 40, 20))
	.string_(~slider11.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote11 = Knob(view, Rect(755, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color
		.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[10].map(val);
		~peris[10] = real;
		real.postln;
		if (~pulse1.notNil) {
			~pulse1.set(\freqm, real);
		};
	});

	~potelabel11 = StaticText(view, Rect(755, 280, 50, 20))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón 12--Pulse2
	~boton12 = Button(view, Rect(30 + (12 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nPulse 2", Color.black, Color.fromHexString("#08807b")],
		["Stop \nPulse 2", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~pulse2 = Synth(\pulse, [\in, ~fbBus1, \out,~fbBus2, \amp, ~amps[11], \freqm, ~peris[11], \systemChaos, ~ctrlBuses.systemChaos], target: ~fbGroup,  addAction:\addToTail);
		} {
			~pulse2.set(\gate, 0); // Detener el patrón
		};
	};);

// Slider Pulse 2
	~slider12 = Slider(view, Rect(820, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[11] = val;
		if (~pulse2.notNil) {
			~pulse2.set(\amp, val);
		};
		~sliderLabel12.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel12 = StaticText(view, Rect(820, 220, 40, 20))
	.string_(~slider12.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote12 = Knob(view, Rect(820, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[11].map(val);
		~peris[11] = real;
		real.postln;
		if (~pulse2.notNil) {
			~pulse2.set(\freqm, real);
		};
	});

	~potelabel12 = StaticText(view, Rect(820, 280, 50, 20))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);

// ----------------------------------------------------------------------------------------------------------Botón 13-Pulse3
// On / Off Pulse 3
	~boton13 = Button(view, Rect(30 + (13 * 65), 30, 60, 50))
	.font_(font)
	.states_([
		["Play \nPulse 3", Color.black, Color.fromHexString("#08807b")],
		["Stop \nPulse 3", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~pulse3 = Synth(\pulse, [\in, ~fbBus1, \out,~fbBus2, \amp, ~amps[12], \freqm, ~peris[12], \systemChaos, ~ctrlBuses.systemChaos], target: ~fbGroup,  addAction:\addToTail);
		} {
			~pulse3.set(\gate, 0);
		};
	};);

// Slider Pulse 3
	~slider13 = Slider(view, Rect(885, 90, 35, 130))
	.background_(Color(0.7,0.8,0.4))
	.knobColor_(Color.fromHexString("#d44222"))
	.orientation_(\vertical)
	.value_(0)
	.action_({ |s|
		var val = s.value;
		~amps[12] = val;
		if (~pulse3.notNil) {
			~pulse3.set(\amp, val);
		};
		~sliderLabel13.string = ((val ? 0).ampdb.round(0.1)).asString ++ " dB";
	});

	~sliderLabel13 = StaticText(view, Rect(885, 220, 40, 20))
	.string_(~slider13.value.round(0.01).asString)
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);

// Pote Frecuencia moduladora
	~pote13 = Knob(view, Rect(885, 240, 39, 39)) //
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)  // valor inicial razonable
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[12].map(val);
		~peris[12] = real;
		real.postln;
		if (~pulse3.notNil) {
			~pulse3.set(\freqm, real);
		};
	});
	~potelabel13 = StaticText(view, Rect(885, 280, 50, 20))
	.string_("MOD")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(font)
	.align_(\center);


// ------------------------------------------------------------------------------------------------------Botón/RUTINA
// On / Off Manos Libres

	~btnRutina = Button(view, Rect(1060 - 120, 92, 70, 130))
	.states_([
		[" ON \nManos \nLibres", Color.black, Color.fromHexString("#6e1e62")],
		[" Off \nManos \nLibres", Color.white, Color.fromHexString("#eb9605")]
	])
    .action_({ |btn|
		if(btn.value == 1) {
			"PLAY MANOS LIBRES".postln;
			~manosLibresRunning = true;
			~manosLibres.reset;
			~manosLibres.play(SystemClock);
		} {
            "STOP MANOS LIBRES".postln;
			~manosLibres.stop;
			~limpiarManosLibres.();
		};
	});

// ------------------------------------------------------------------------------------------------------Botón/Salida
// On / Off Salida

	~botonOut = Button(view, Rect(30 + (14 * 65), 30, 90, 50))
	.font_(font)
	.states_([
		["Play \nSalida", Color.black, Color.fromHexString("#08807b")],
		["Stop \nSalida", Color.white, Color.fromHexString("#fb4848")]
	])
	.value_(0)
	.action_({ |b|
		if (b.value == 1) {
			~salida = Synth(\salida, [\in, ~fbBus1,  \out,~outBus, \amp4, ~peris[13], \amp, ~peris[14]], ~outGroup, \addToTail);
		} {
			~salida.set(\gate, 0); // Detener el patrón
		};
	};);

// Pote Gain Salida
	~pote14 = Knob(view, Rect(965, 240, 39, 39))
	.color_([
		Color(0.7,0.8,0.4),
		Color.fromHexString("#d44222"),
		Color.red.alpha_(0.3),
		Color.black
	])
	.value_(0)
	.mode_(\vert)
	.action_({ |p|
		var val = p.value;
		var real = ~periSpecs[13].map(val);
		~peris[13] = real;
		real.postln;
		if (~salida.notNil) {
			~salida.set(\amp4, real);
		};
	});

	~potelabel14 = StaticText(view, Rect(960, 280, 50, 20))
	.string_("OUT GAIN")
	.stringColor_(Color.fromHexString("#d44222"))
	.font_(fonti)
	.align_(\center);



//************************************************************************************************************ IASI

	~startBtn = Button(view, Rect(1040, 30, 90, 50))
	.font_(font)
	.states_([
		["INICIAR\nRUTINA", Color.black, Color.fromHexString("#08807b")]
	])
	.action_({
		if(~iasiRoutine.notNil and: { ~iasiRoutine.isPlaying.not }, {
			"PLAY RUTINE...".postln;
			~iasiPlayInit.value;
			~iasiRoutine.play(SystemClock);
		});
	});

~stopBtn = Button(view, Rect(1040, 90, 90, 50))
	.font_(font)
	.states_([
		["DETENER\nRUTINA", Color.white, Color.fromHexString("#fb4848")]
	])
	.action_({
		if(~iasiRoutine.notNil and: { ~iasiRoutine.isPlaying }, {
			"STOP RUTINE...".postln;
			~iasiRoutine.stop;
		});
	});

	// Etiqueta para mostrar la iteración actual
	~iasiIterLabel = StaticText(view, Rect(1040, 150, 90, 20))
	.font_(font)
	.string_("Iter: ")
	.align_(\center)
	.background_(Color.fromHexString("#eb9605"))
	.stringColor_(Color.white);


// --------------------------------------------------------------------------------------------------------------MIDI
//******************************************************************************************** ShiftButton

	~currentLayer = 0;
	~scatch = Array.fill(16, false); // Sliders capturados
	~pcatch = Array.fill(16, false);


MIDIdef.cc(\shiftToggle, { |val, num|
	if (num == 46 and: { val > 64 }) {
		~currentLayer = (~currentLayer + 1) % 2;

		// Resetear 'catch' de la capa activa
		(~currentLayer == 0).if({
			(0..7).do { |i| ~scatch[i] = false; ~pcatch[i] = false; };
			"Cambiando a capa: 0–7".postln;
		}, {
			(8..15).do { |i| ~scatch[i] = false; ~pcatch[i] = false; };
			"Cambiando a capa: 8–15".postln;
		});
	};
});

//************************************************************************************************* Definición de botones

	MIDIdef.cc(\buttons, {|val, cnum|
		//	[\cntl, cnum, val].postln;
		switch(cnum,
			32, { if (val == 127) { {~boton1.valueAction = ~boton1.value.switch(0, 1, 1, 0);}.defer}},
			33, { if (val == 127) { {~boton2.valueAction = ~boton2.value.switch(0, 1, 1, 0);}.defer}},
			34, { if (val == 127) { {~boton3.valueAction = ~boton3.value.switch(0, 1, 1, 0);}.defer}},
			35, { if (val == 127) { {~boton4.valueAction = ~boton4.value.switch(0, 1, 1, 0);}.defer}},
			36, { if (val == 127) { {~boton5.valueAction = ~boton5.value.switch(0, 1, 1, 0);}.defer}},
			37, { if (val == 127) { {~boton6.valueAction = ~boton6.value.switch(0, 1, 1, 0);}.defer}},
			38, { if (val == 127) { {~boton7.valueAction = ~boton7.value.switch(0, 1, 1, 0);}.defer}},
			39, { if (val == 127) { {~boton8.valueAction = ~boton8.value.switch(0, 1, 1, 0);}.defer}},
			41, { if (val == 127) { {~boton0.valueAction = ~boton0.value.switch(0, 1, 1, 0);}.defer}},
			42, { if (val == 127) { {~botonOut.valueAction =~botonOut.value.switch(0, 1, 1, 0);}.defer}},
			43, { if (val == 127) { {~btnRutina.valueAction = ~btnRutina.value.switch(0, 1, 1, 0);}.defer}},
			45, { if (val == 127) { {~botoneq.valueAction = ~botoneq.value.switch(0, 1, 1, 0);}.defer}},
			48, { if (val == 127) { {~boton9.valueAction = ~boton9.value.switch(0, 1, 1, 0);}.defer}},
			49, { if (val == 127) { {~boton10.valueAction = ~boton10.value.switch(0, 1, 1, 0);}.defer}},
			50, { if (val == 127) { {~boton11.valueAction = ~boton11.value.switch(0, 1, 1, 0);}.defer}},
			51, { if (val == 127) { {~boton12.valueAction = ~boton12.value.switch(0, 1, 1, 0);}.defer}},
			52, { if (val == 127) { {~boton13.valueAction = ~boton13.value.switch(0, 1, 1, 0);}.defer}},
			54, { if (val == 127) { {~violainButton.valueAction =~violainButton.value.switch(0, 1, 1, 0);}.defer}},
			55, { if (val == 127) { {~testisButton.valueAction =~testisButton.value.switch(0, 1, 1, 0);}.defer}},
			58, { if (val == 127) { {~nodeButton.valueAction = ~nodeButton.value.switch(0, 1, 1, 0);}.defer}},
			59, { if (val == 127) { {~meterButton.valueAction = ~meterButton.value.switch(0, 1, 1, 0);}.defer}},
			67, { if (val == 127) { {~botonfreq1.valueAction = (~botonfreq1.value + 1) % 5; }.defer}}, // 5 valores
			68, { if (val == 127) { {~botonfreq2.valueAction = (~botonfreq2.value + 1) % 6; }.defer}},// 6 valores
			69, { if (val == 127) { {~botonpoly.valueAction = (~botonpoly.value + 1) % 4; }.defer}}, // 4 valores
			70, { if (val == 127) { {~violaoutButton.valueAction =~violaoutButton.value.switch(0, 1, 1, 0);}.defer}},
			71, { if (val == 127) { {~paisajeButton.valueAction =~paisajeButton.value.switch(0, 1, 1, 0);}.defer}},
		);
	});


	//************************************************************************************************** Definición de Sliders

	~ampSpec = ControlSpec(0.001, 1.0, \lin, 0.01);
	~sliders = Array.fill(16, nil);


	~sliders = [~slider1, ~slider2, ~slider3, ~slider4, ~slider5, ~slider6, ~slider7, ~slider8, ~slider9, ~slider10, ~slider11, ~slider12, ~slider13, nil, nil, nil];

	~ampsSynths = [  // Asocia cada índice con un Synth variable
		~eq, ~ring, ~phase, ~reso1, ~reso2,~rms, ~dis1, ~dis2, ~dis3, ~pulse0, ~pulse1, ~pulse2, ~pulse3,  nil, nil, nil];



	MIDIdef.cc(\sliders, { |val, cnum|
		var index;

		// Solo CC 16–28 (14 sliders)
		if (cnum >= 0 and: { cnum <= 15 }) {
			index = if(~currentLayer == 0, { cnum }, { cnum + 8 });  // capa 0: 0–7, capa 1: 8–15

			if (index >= 0 and: { index < ~amps.size }) {
				var normVal = val / 127;
				var mappedVal = ~ampSpec.map(normVal);
				var guiVal = ~amps[index] ?? { 0.0 };  // fallback seguro
				var threshold = 0.01;

				if (~scatch[index] or: { (normVal - guiVal).abs < threshold }) {
					~amps[index] = mappedVal;
					~scatch[index] = true;

					AppClock.sched(0.0, {
						if (~sliders[index].notNil) {
							{ ~sliders[index].valueAction = normVal }.try;
					};
					nil
				});
			} {
				("wait slider " ++ index ++
					"| " ++ guiVal.round(0.1) ++
					"| " ++ normVal.round(0.1)).postln;
			};
		};
	};
}, chan: 0);


//*************************************************************************************************** Definición de Knobs
	~potes = Array.fill(16, nil);

	~periSpecs = [
		ControlSpec(0, 1, \lin, 0.01),       //  0: \mix
		ControlSpec(300, 700, \lin, 1),      //  1: \filtFreq
		ControlSpec(0, 1, \lin, 0.01),       //  2: \wet
		ControlSpec(4, 12, \exp, 0.1),       //  3: \decay
		ControlSpec(4, 12, \exp, 0.1),       //  4: \decay
		ControlSpec(0.15, 0.8, \lin, 0.01),  //  5: \filtQ
		ControlSpec(0.1, 500, \exp, 0.1),    //  6: \freqm
		ControlSpec(0.1, 500, \exp, 0.1),    //  7: \freqm
		ControlSpec(0.1, 500, \exp, 0.1),    //  8: \freqm
		ControlSpec(0.1, 500, \exp, 0.1),    //  9: \freqm
		ControlSpec(0.1, 500, \exp, 0.1),    // 10: \freqm
		ControlSpec(0.1, 500, \exp, 0.1),    // 11: \freqm
		ControlSpec(0.1, 500, \exp, 0.1),    // 11: \freqm
		ControlSpec(0.001, 1.0, \lin, 0.01), // 13: \amp4
	] ++ Array.fill(0, { ControlSpec(0, 1, \lin, 0.01)});  // rellenar para que no de error

	~potes =[~pote1, ~pote2, ~pote3, ~pote4, ~pote5, ~pote6, ~pote7, ~pote8, ~pote9, ~pote10, ~pote11, ~pote12, ~pote13, ~pote14, nil, nil];
	~potesCCs = [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29];


	// Asignación unificada para knobs (CC 16–28) + shiftMode

	~midiKnobsDef = MIDIdef.cc(\knobs, { |val, cnum, chan, src|
		var index;
		if (cnum >= 16 and: { cnum <= 28 }) {
			index = if(~currentLayer == 0, { cnum - 16 }, { cnum - 16 + 8 });
			if (index < ~periSpecs.size) {
				var normVal = val.linlin(0, 127, 0.0, 1.0);
				var mappedVal = ~periSpecs[index].map(normVal);
				var guiNorm = ~perisNorm[index];
				var threshold = 0.01;
				if (~pcatch[index] or: { (normVal - guiNorm).abs < threshold }) {
					~peris[index] = mappedVal;
					~perisNorm[index] = normVal;
					~pcatch[index] = true;
					// Actualizar GUI (AppClock + try)
					AppClock.sched(0.0, {
						if (~potes[index].notNil) {
							{ ~potes[index].valueAction = normVal }.try;
						};
						nil
					});
					// Enviar al synth
					switch(index,
						0,  { if (~eq.notNil)      { ~eq.set(\mix, mappedVal) } },
						1,  { if (~ring.notNil)    { ~ring.set(\filtFreq, mappedVal) } },
						2,  { if (~phase.notNil)   { ~phase.set(\wet, mappedVal) } },
						3,  { if (~reso1.notNil)   { ~reso1.set(\decay, mappedVal) } },
						4,  { if (~reso2.notNil)   { ~reso2.set(\decay, mappedVal) } },
						5, { if (~rms.notNil)     { ~rms.set(\filtQ, mappedVal) } },
						6,  { if (~dis1.notNil)    { ~dis1.set(\freqm, mappedVal) } },
						7,  { if (~dis2.notNil)    { ~dis2.set(\freqm, mappedVal) } },
						8,  { if (~dis3.notNil)    { ~dis3.set(\freqm, mappedVal) } },
						9,  { if (~pulse0.notNil)  { ~pulse0.set(\freqm, mappedVal) } },
						10,  { if (~pulse1.notNil)  { ~pulse1.set(\freqm, mappedVal) } },
						11, { if (~pulse2.notNil)  { ~pulse2.set(\freqm, mappedVal) } },
						12, { if (~pulse3.notNil)  { ~pulse3.set(\freqm, mappedVal) } },
						13, { if (~salida.notNil)  { ~salida.set(\amp4, mappedVal) } }
					);
				} {
					("wait Knob " ++ index ++
                    "| " ++ guiNorm.round(0.2) ++
						"| " ++ normVal.round(0.2)).postln;
				};
			};
		};
	}, chan: 0);

//******************************************************************************************** Definición de SkipJack

	~updateGUI = SkipJack({
    ~sliders.do { |slider, i|
        if (slider.notNil and: { ~amps[i].notNil }) {
            { slider.value = ~amps[i] }.try;  // SIN .valueAction
        };
    };
    ~potes.do { |pote, i|
        if (pote.notNil and: { ~perisNorm[i].notNil }) {
            { pote.value = ~perisNorm[i] }.try;
        };
    };
}, 0.015, name: "wui").play;
};
)





