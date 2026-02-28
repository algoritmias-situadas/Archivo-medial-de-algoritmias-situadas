// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// 5) GUI
//-----------------------------------------------------------------------------------------------------------------------
(
var w,
	leftPanel, rightPanel, topRow,
	sliderVol, txtVol,
	sliderHarmSeq, txtHarmSeq,
	sliderNHarm, txtNHarm,
	sliderConst, txtConst,
	sliderDur, txtDur,
	btnModo, primeVals, primeListBig,
	btnRoutine,
	txtJitter, sliderJitter, jitterMax,
	txtRel, sliderRel, relMin, relMax,
	// Reverb
	txtRevMix, sliderRevMix,
	// EQ
	sliderLow, sliderMid, sliderMidHigh, sliderHigh,
	txtLowVal, txtMidVal, txtMidHighVal, txtHighVal,
	lblLow, lblMid, lblMidHigh, lblHigh,
	// Titles
	txtTimbreTitle, txtSeqTitle, txtEQTitle,
	// Ulam Spiral
	txtVis, visView,
	// EQ Panel
	eqPanel,
	// EQ Layout
	sliderWidth, sliderHeight, totalWidth, spacing,
	x1, x2, x3, x4, topY, nameY, valueY,
	// REC
	recRow, btnRec;

// Slider lists
primeVals    = [1, 2, 3, 5, 7, 11, 13, 17, 19];
primeListBig = [1] ++ (2..65521).select(_.isPrime);
jitterMax    = 1.0;
// Release ranges
relMin = 0.01;
relMax = 1.0;
// EQ Layout
sliderWidth  = 50;
sliderHeight = 80;
totalWidth   = 440;
spacing      = (totalWidth - (4 * sliderWidth)) / 5;
x1 = spacing;
x2 = x1 + sliderWidth + spacing;
x3 = x2 + sliderWidth + spacing;
x4 = x3 + sliderWidth + spacing;
nameY  = 0;
topY   = nameY + 18 + 5;
valueY = topY + sliderHeight + 8;

// Main Window
w = Window("Gasch Prime Synth", Rect(200, 200, 1180, 780));
w.view.background = Color.grey(0.9);

// Left Panel for Faders
leftPanel = CompositeView(w, Rect(10, 10, 460, 740));
leftPanel.background = Color.clear;
leftPanel.decorator = FlowLayout(leftPanel.bounds);

// -------- MODE BUTTONS --------
topRow = CompositeView(leftPanel, Rect(0, 0, 440, 90));
topRow.background = Color.clear;

// Natural/Complex Primes Button
btnModo = Button(topRow, Rect(0, 10, 210, 70));
btnModo.states = [
	["Natural Primes", Color.white, Color.new255(0, 110, 255)],
	["Complex Primes", Color.black, Color.new255(255, 170, 0)]
];
btnModo.value = if(~useComplex, 1, 0);
btnModo.action = { |b| ~useComplex = (b.value == 1) };

// Mode Button
btnRoutine = Button(topRow, Rect(220, 10, 210, 70));
btnRoutine.states = [
	["Prime Sequence Mode", Color.white, Color.new255(0, 170, 0)],
	["Single Note Mode", Color.white, Color.new255(200, 0, 0)]
];
btnRoutine.value = if(~useRoutine, 0, 1);
btnRoutine.action = { |b|
	~useRoutine = (b.value == 0);
	~visColorIx = Array.fill(~visN, -1); // Clean visuals
	~visIndex   = 0;
	{ if(~visView.notNil) { ~visView.refresh } }.defer;

	if(~useRoutine.not) {
		~voicesRut.valuesDo({ |r| r.stop });
		~voicesRut.clear;
		~voicesRutColor.clear;
	};
};

// -------- VOLUME FADER --------
txtVol = StaticText(leftPanel, Rect(0,0,440,20));
txtVol.string = "Volume: " ++ ~volBus.getSynchronous;

sliderVol = Slider(leftPanel, Rect(0,0,440,20));
sliderVol.value = 0.1;
sliderVol.action = { |sl|
	~volBus.set(sl.value);
	txtVol.string = "Volume: " ++ sl.value.round(0.001);
};

// ---------------- TIMBRE TITLE ----------------
txtTimbreTitle = StaticText(leftPanel, Rect(0,0,440,24));
txtTimbreTitle.string = "TIMBRE";
txtTimbreTitle.font = Font("Monaco", 15);
txtTimbreTitle.align = \left;

// -------- SPECTRAL HARMONICS FADER --------
txtNHarm = StaticText(leftPanel, Rect(0,0,440,20));
txtNHarm.string = "Active Spectral Prime Harmonics: " ++ ~nHarm;

sliderNHarm = Slider(leftPanel, Rect(0,0,440,20));
sliderNHarm.value = ((~nHarm - 3) / (50 - 3));
sliderNHarm.action = { |sl|
	~nHarm = (sl.value * (50 - 3)).round + 3;
	~updateAmps.();
	txtNHarm.string = "Active Spectral Prime Harmonics: " ++ ~nHarm;
};

// -------- JITTER FADER --------
txtJitter = StaticText(leftPanel, Rect(0,0,440,20));
txtJitter.string = "Harmonics' Amplitudes Jitter: " ++ ~jitterAmt.round(0.001);

sliderJitter = Slider(leftPanel, Rect(0,0,440,20));
sliderJitter.value = (~jitterAmt / jitterMax).clip(0,1);
sliderJitter.action = { |sl|
	~jitterAmt = sl.value * jitterMax;
	txtJitter.string = "Harmonics' Amplitudes Jitter: " ++ ~jitterAmt.round(0.001);
	~updateAmps.();
};

// -------- RELEASE FADER --------
txtRel = StaticText(leftPanel, Rect(0,0,440,20));
txtRel.string = "Release time (s): " ++ ~relTime.round(0.01);

sliderRel = Slider(leftPanel, Rect(0,0,440,20));
sliderRel.value = ((~relTime - relMin) / (relMax - relMin)).clip(0,1);
sliderRel.action = { |sl|
	~relTime = relMin + (relMax - relMin) * sl.value;
	txtRel.string = "Release time (s): " ++ ~relTime.round(0.01);
};

// -------- REVERB FADER --------
txtRevMix = StaticText(leftPanel, Rect(0,0,440,20));
txtRevMix.string = "Reverb (DRY/WET): 0.13";

sliderRevMix = Slider(leftPanel, Rect(0,0,440,20));
sliderRevMix.value = 0.13;
sliderRevMix.action = { |sl|
	var mix = sl.value.clip(0,1);
	txtRevMix.string = "Reverb (DRY/WET): " ++ mix.round(0.01);
	if(~eqSynth.notNil) { ~eqSynth.set(\revMix, mix); };
};

// ---------------- PRIME SEQUENCE TITLE ----------------
txtSeqTitle = StaticText(leftPanel, Rect(0,0,440,24));
txtSeqTitle.string = "PRIME SEQUENCE";
txtSeqTitle.font = Font("Monaco", 15);
txtSeqTitle.align = \left;

// -------- SEQUENCE VELOCITY FADER --------
txtConst = StaticText(leftPanel, Rect(0,0,440,20));
txtConst.string = "Sequence Velocity: " ++ ~velConst;

sliderConst = Slider(leftPanel, Rect(0,0,440,20));
sliderConst.value = (~velConst - 1) / 19;

sliderConst.action = { |sl|
	~velConst = (sl.value * 19).round + 1;
	txtConst.string = "Sequence Velocity: " ++ ~velConst;
};

// -------- PRIME HARMONICS PER SEQUENCE FADER --------
txtHarmSeq = StaticText(leftPanel, Rect(0,0,440,20));
txtHarmSeq.string = "Prime Harmonics Per Sequence: " ++ ~cantHarm;

sliderHarmSeq = Slider(leftPanel, Rect(0,0,440,20));
sliderHarmSeq.value = primeVals.indexOf(~cantHarm) / (primeVals.size - 1);
sliderHarmSeq.action = { |sl|
	var idx = (sl.value * (primeVals.size - 1)).round;
	~cantHarm = primeVals[idx];
	txtHarmSeq.string = "Prime Harmonics Per Sequence: " ++ ~cantHarm;
};

// -------- SEQUENCE DURATION FADER --------
txtDur = StaticText(leftPanel, Rect(0,0,440,20));
txtDur.string = "Sequence Duration: " ++ ~durRut;

sliderDur = Slider(leftPanel, Rect(0,0,440,20));
sliderDur.value = primeListBig.indexOf(~durRut) / (primeListBig.size - 1);
sliderDur.action = { |sl|
	var idx = (sl.value * (primeVals.size - 1)).round;
	~durRut = primeListBig[idx];
	txtDur.string = "Sequence Duration: " ++ ~durRut;
};

// ---------------- EQUALIZER TITLE ----------------
txtEQTitle = StaticText(leftPanel, Rect(0,0,440,24));
txtEQTitle.string = "EQUALIZER";
txtSeqTitle.font = Font("Monaco", 15);
txtEQTitle.align = \left;

eqPanel = CompositeView(leftPanel, Rect(0,0,440,230));
eqPanel.background = Color.clear;

// -------- 200 HZ FADER --------
lblLow = StaticText(eqPanel, Rect(x1 - 25, nameY, sliderWidth + 50, 18));
lblLow.align = \center;
lblLow.string = "200 Hz";

sliderLow = Slider(eqPanel, Rect(x1, topY, sliderWidth, sliderHeight));
sliderLow.orientation = \vertical;
sliderLow.value = 0.5;

txtLowVal = StaticText(eqPanel, Rect(x1 - 25, valueY, sliderWidth + 50, 18));
txtLowVal.align = \center;
txtLowVal.string = "0.0 dB";

sliderLow.action = { |sl|
	var db = (sl.value * 2 - 1) * 18;
	txtLowVal.string = db.round(0.1).asString ++ " dB";
	if(~eqSynth.notNil) { ~eqSynth.set(\lowGain, db); };
};

// -------- 1000 HZ FADER --------
lblMid = StaticText(eqPanel, Rect(x2 - 25, nameY, sliderWidth + 50, 18));
lblMid.align = \center;
lblMid.string = "1000 Hz";

sliderMid = Slider(eqPanel, Rect(x2, topY, sliderWidth, sliderHeight));
sliderMid.orientation = \vertical;
sliderMid.value = 0.5;

txtMidVal = StaticText(eqPanel, Rect(x2 - 25, valueY, sliderWidth + 50, 18));
txtMidVal.align = \center;
txtMidVal.string = "0.0 dB";

sliderMid.action = { |sl|
	var db = (sl.value * 2 - 1) * 18;
	txtMidVal.string = db.round(0.1).asString ++ " dB";
	if(~eqSynth.notNil) { ~eqSynth.set(\midGain, db); };
};

// -------- 4000 HZ FADER --------
lblMidHigh = StaticText(eqPanel, Rect(x3 - 25, nameY, sliderWidth + 50, 18));
lblMidHigh.align = \center;
lblMidHigh.string = "4000 Hz";

sliderMidHigh = Slider(eqPanel, Rect(x3, topY, sliderWidth, sliderHeight));
sliderMidHigh.orientation = \vertical;
sliderMidHigh.value = 0.5;

txtMidHighVal = StaticText(eqPanel, Rect(x3 - 25, valueY, sliderWidth + 50, 18));
txtMidHighVal.align = \center;
txtMidHighVal.string = "0.0 dB";

sliderMidHigh.action = { |sl|
	var db = (sl.value * 2 - 1) * 18;
	txtMidHighVal.string = db.round(0.1).asString ++ " dB";
	if(~eqSynth.notNil) { ~eqSynth.set(\mhGain, db); };
};

// -------- 10000 HZ FADER --------
lblHigh = StaticText(eqPanel, Rect(x4 - 25, nameY, sliderWidth + 50, 18));
lblHigh.align = \center;
lblHigh.string = "10000 Hz";

sliderHigh = Slider(eqPanel, Rect(x4, topY, sliderWidth, sliderHeight));
sliderHigh.orientation = \vertical;
sliderHigh.value = 0.5;

txtHighVal = StaticText(eqPanel, Rect(x4 - 25, valueY, sliderWidth + 50, 18));
txtHighVal.align = \center;
txtHighVal.string = "0.0 dB";

sliderHigh.action = { |sl|
	var db = (sl.value * 2 - 1) * 18;
	txtHighVal.string = db.round(0.1).asString ++ " dB";
	if(~eqSynth.notNil) { ~eqSynth.set(\highGain, db); };
};

// Right Panel for Ulam Spiral
rightPanel = CompositeView(w, Rect(500, 10, 660, 740));
rightPanel.background = Color.clear;
rightPanel.decorator = FlowLayout(rightPanel.bounds);

txtVis = StaticText(rightPanel, Rect(0,0,640,20));
txtVis.string = "ULAM SPIRAL";
txtVis.font = Font("Monaco", 15);
visView = UserView(rightPanel, Rect(0,0,640,640));
~visView = visView;
visView.background = Color.white;
visView.clearOnRefresh = true;

visView.drawFunc = { |view|
	Pen.use {
		var b = view.bounds;
		var width  = b.width;
		var height = b.height;
		var cellW = width  / ~visSide;
		var cellH = height / ~visSide;

		Pen.fillColor = Color.white;
		Pen.fillRect(Rect(0, 0, width, height));

		~visN.do { |i|
			var coord = ~visCoords[i];
			var clrIx = ~visColorIx[i];
			var x = coord.x * cellW;
			var y = coord.y * cellH;
			var rect = Rect(x, y, cellW, cellH);

			Pen.fillColor = if(clrIx >= 0,
				{ ~primeColors[clrIx] },
				{ Color.black.alpha_(0.08) }
			);
			Pen.fillRect(rect);
			Pen.strokeColor = Color.black.alpha_(0.1);
			Pen.strokeRect(rect);
		};
	};
};

// Inferior Row for REC Button
recRow = CompositeView(rightPanel, Rect(0, 0, 640, 40));
recRow.background = Color.clear;
btnRec = Button(recRow, Rect(640-60, 5, 50, 30));
btnRec.states = [
	["REC", Color.white, Color.black], // OFF
	["REC", Color.white, Color.red]    // REC
];
btnRec.value = if(~isRecording, 1, 0);

// ---------------- Recording Location ----------------
btnRec.action = { |b|
	if(b.value == 1) {
		// REC
		if(~isRecording.not) {
			var dir, fname, fullPath;

			// Create Folder in Desktop
			dir = Platform.userHomeDir ++ "/Desktop/GaschPrimeSynth_Recordings";
			File.mkdir(dir);
			fname = "GaschPrimeSynth_REC_" ++ Date.localtime.stamp ++ ".wav";
			fullPath = (dir ++ "/" ++ fname).standardizePath;
			~recFilePath = fullPath;

			("Recording at: " ++ fullPath).postln;

			if(~recSynth.notNil) { ~recSynth.free; ~recSynth = nil; };
			if(~recBuf.notNil) {
				~recBuf.close;
				~recBuf.free;
				~recBuf = nil;
			};
			~recBuf = Buffer.alloc(s, 65536, 2);
			~recBuf.write(
				fullPath,
				"wav",
				"int16",
				0, 0, true
			);

			// REC Synth after EQ
			~recSynth = Synth(\primeRecorder, [
				\bufnum, ~recBuf.bufnum,
				\inbus,  ~finalBus.index
			], ~eqSynth, \addAfter);
			~isRecording = true;
		};
	} {
		// STOP REC
		if(~isRecording) {
			if(~recSynth.notNil) {
				~recSynth.free;
				~recSynth = nil;
			};
			if(~recBuf.notNil) {
				~recBuf.close;
				~recBuf.free;
				~recBuf = nil;
			};
			("Grabación terminada: " ++ (~recFilePath ? "desconocido")).postln;
			~isRecording = false;
		};
	};
};

w.front;
~visView.refresh;
)
