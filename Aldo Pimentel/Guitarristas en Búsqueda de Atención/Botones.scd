// Ventana

~screenSize = Window.screenBounds;
~winASize = Rect(0, 0, 1500, 530);
~centeredPosA = Rect(
    (~screenSize.width - ~winASize.width) / 2,
    (~screenSize.height - ~winASize.height) / 7,
    ~winASize.width,
    ~winASize.height
);
w = Window.new("Efectos", ~centeredPosA, scroll:true).front;

////////////////////////////// PEDALERA ///////////////////////////////

~botones = [
	Button(w, Rect(90, 30, 80, 80)),
	Button(w, Rect(200, 140, 120, 120)),
    Button(w, Rect(350, 140, 120, 120)),
    Button(w, Rect(500, 140, 120, 120)),
    Button(w, Rect(200, 290, 120, 120)),
    Button(w, Rect(350, 290, 120, 120)),
	Button(w, Rect(500, 290, 120, 120)),
	Button(w, Rect(90, 140, 80, 380)),
	Button(w, Rect(200, 440, 420, 80)),
    Button(w, Rect(200, 30, 120, 80)),
	Button(w, Rect(1340, 30, 80, 80)),
    Button(w, Rect(890, 140, 120, 120)),
    Button(w, Rect(1040, 140, 120, 120)),
    Button(w, Rect(1190, 140, 120, 120)),
    Button(w, Rect(890, 290, 120, 120)),
    Button(w, Rect(1040, 290, 120, 120)),
    Button(w, Rect(1190, 290, 120, 120)),
	Button(w, Rect(1340, 140, 80, 380)),
    Button(w, Rect(890, 440, 420, 80)),
    Button(w, Rect(1190, 30, 120, 80)),
	Button(w, Rect(700, 140, 120, 80)),
	Button(w, Rect(625, 10, 260, 100)),
	Button(w, Rect(700, 240, 120, 80)),
	Button(w, Rect(700, 340, 120, 80)),
	Button(w, Rect(700, 440, 120, 80))
];

[0, 10].do { |i|
    ~botones[i].states = [["OFF", Color.black, Color.red], ["ON", Color.white, Color.green]];
};

[1, 11].do { |i|
    ~botones[i].states = [["REVERB OFF", Color.black, Color.white], ["REVERB ON", Color.black, Color.green]];
};

[2, 12].do { |i|
    ~botones[i].states = [["OVERDRIVE OFF", Color.black, Color.white], ["OVERDRIVE ON", Color.black, Color.green]];
};

[3, 13].do { |i|
    ~botones[i].states = [["FUZZ OFF", Color.black, Color.white], ["FUZZ ON", Color.black, Color.green]];
};

[4, 14].do { |i|
    ~botones[i].states = [["DELAY OFF", Color.black, Color.white], ["DELAY ON", Color.black, Color.green]];
};

[5, 15].do { |i|
    ~botones[i].states = [["TREMOLO OFF", Color.black, Color.white], ["TREMOLO ON", Color.black, Color.green]];
};

[6, 16].do { |i|
    ~botones[i].states = [["WAH OFF", Color.black, Color.white], ["WAH ON", Color.black, Color.green]];
};

[7, 17].do { |i|
    ~botones[i].states = [["PSHIFT OFF", Color.black, Color.white], ["PSHIFT ON", Color.black, Color.green]];
};

[8, 18].do { |i|
    ~botones[i].states = [["CLEAN", Color.black, Color.white]];
};

[9, 19].do { |i|
    ~botones[i].states = [["RANDOM", Color.black, Color.white], ["RANDOM", Color.black, Color.white]];
};

~botones[20].states = [["RECORD", Color.black, Color.white], ["RECORD", Color.black, Color.green]];

~botones[21].states = [["SILENCIO", Color.black, Color.white], ["¡¡¡APLAUSOS!!!", Color.black, Color.green]];

~botones[22].states = [["ROTAR", Color.black, Color.white], ["ROTAR", Color.black, Color.green]];

~botones[23].states = [["¡ROTAR!", Color.black, Color.white], ["¡¡ROTAR!!", Color.black, Color.green]];

~botones[24].states = [["FINAL", Color.black, Color.white], ["SHH", Color.black, Color.green]];

~botones.do { |i|
    i.font = Font("Barlow", 14);
};

~botones[21].font = Font("Barlow", 35);

~randomizer = [
	StaticText(w, Rect(350, 30, 120, 80)),
	StaticText(w, Rect(1040, 30, 120, 80)),
];

~randomizer.do { |i|
    i.background = Color.grey;
	i.align = \center;
    i.font = Font("Barlow", 14);
    i.string = "Presiona RANDOM para comenzar";
};

~escalas = [
	"ESCALA MAYOR",
	"ESCALA MENOR",
	"ESCALA MENOR ARMÓNICA",
	"ESCALA PENTATÓNICA MAYOR",
	"ESCALA PENTATÓNICA MENOR",
	"ESCALA CROMÁTICA"

];

//////////////////// ACCIONES ////////////////////

// AMPLI
~botones[0].action = {
    if (~botones[0].value == 1) {
        "AMPLI ON".postln;
		a = Synth(\ampli, [\inBus, 0]);
    } {
        "AMPLI OFF".postln;
        a.free;
    };
};

// REVERB
~botones[1].action = {
    if (~botones[1].value == 1) {
        "REVERB ON".postln;
        ~reverb = a.set(\mix, 0.5, \room, 0.8, \damp, 0.5);
    } {
        "REVERB OFF".postln;
        ~noreverb = a.set(\mix, 0, \room, 0, \damp, 0);
    };
};

// OVERDRIVE
~botones[2].action = {
    if (~botones[2].value == 1) {
        "OVERDRIVE ON".postln;
        ~overdrive = a.set(\drive, 5);
    } {
        "OVERDRIVE OFF".postln;
        ~nooverdrive = a.set(\drive, 1);
    };
};

// FUZZ
~botones[3].action = {
    if (~botones[3].value == 1) {
        "FUZZ ON".postln;
        ~fuzz = a.set(\clipLevel, 0.05, \drive, 5, \amp, 1);
    } {
        "FUZZ OFF".postln;
        ~nofuzz = a.set(\clipLevel, 1, \drive, 1, \amp, 1);
    };
};

// DELAY
~botones[4].action = {
    if (~botones[4].value == 1) {
        "DELAY ON".postln;
        ~delaya = a.set(\delayTime, 1, \delayFeedback, 10);
    } {
        "DELAY OFF".postln;
        ~nodelaya = a.set(\delayTime, 0, \delayFeedback, 0);
    };
};

// TREMOLO
~botones[5].action = {
    if (~botones[5].value == 1) {
        "TREMOLO ON".postln;
        ~tremolo = a.set(\tremoloTime, 0.1, \tremoloFeedback, 2);
    } {
        "TREMOLO OFF".postln;
        ~notremolo = a.set(\tremoloTime, 0, \tremoloFeedback, 0);
    };
};

// WAH
~botones[6].action = {|b|
    if (b.value == 1) {
        "WAH ON".postln;
        ~wah = a.set(\wahMix, 1, \wahRate, (120/60));
    } {
        "WAH OFF".postln;
        ~nowah = a.set(\wahMix, 0);
    };
};

// PSHIFT
~botones[7].action = {
	if (~botones[7].value == 1) {
		"PSHIFT ON".postln;
		~pshift = a.set(\pitchOn, 1, \pR, 1, \pD, 1, \tD, 0);
    } {
        "PSHIFT OFF".postln;
		~pshift = a.set(\pitchOn, 0, \pR, 3, \pD, 2, \tD, 3);
    };
};

// CLEAN
~botones[8].action = {
    "CLEANED".postln;
    (1..7).do { |i|
        ~botones[i].valueAction = 0;
    };
};

~ultimoTexto = nil;

~botones[9].action = {
    if (~botones[9].value == 1) {
        r({
            var elegido;
            elegido = ~escalas.choose;
            ~ultimoTexto = elegido;
            {
				~randomizer[0].string = elegido;
            }.defer;
            0.1.wait;
            {
                ~botones[9].valueAction = 0;
            }.defer;
        }).play;
    };
};

// AMPLI B
~botones[10].action = {
    if (~botones[10].value == 1) {
        "AMPLI ON".postln;
		b = Synth(\ampli, [\inBus, 1]);
    } {
        "AMPLI OFF".postln;
        b.free;
    };
};

// REVERB B
~botones[11].action = {
    if (~botones[11].value == 1) {
        "REVERB ON".postln;
        ~reverbb = b.set(\mix, 0.5, \room, 0.8, \damp, 0.5);
    } {
        "REVERB OFF".postln;
        ~noreverbb = b.set(\mix, 0, \room, 0, \damp, 0);
    };
};

// OVERDRIVE B
~botones[12].action = {
    if (~botones[12].value == 1) {
        "OVERDRIVE ON".postln;
        ~overdriveb = b.set(\drive, 5);
    } {
        "OVERDRIVE OFF".postln;
        ~nooverdriveb = b.set(\drive, 1);
    };
};

// FUZZ B
~botones[13].action = {
    if (~botones[13].value == 1) {
        "FUZZ ON".postln;
        ~fuzzb = b.set(\clipLevel, 0.05, \drive, 5, \amp, 1);
    } {
        "FUZZ OFF".postln;
        ~nofuzzb = b.set(\clipLevel, 1, \drive, 1, \amp, 1);
    };
};

// DELAY B
~botones[14].action = {
    if (~botones[14].value == 1) {
        "DELAY ON".postln;
        ~delayb = b.set(\delayTime, 1, \delayFeedback, 10);
    } {
        "DELAY OFF".postln;
        ~nodelayb = b.set(\delayTime, 0, \delayFeedback, 0);
    };
};

// TREMOLO B
~botones[15].action = {
    if (~botones[15].value == 1) {
        "TREMOLO ON".postln;
        ~tremolob = b.set(\tremoloTime, 0.1, \tremoloFeedback, 2);
    } {
        "TREMOLO OFF".postln;
        ~notremolob = b.set(\tremoloTime, 0, \tremoloFeedback, 0);
    };
};

// WAH B
~botones[16].action = {
    if (~botones[16].value == 1) {
        "WAH ON".postln;
        ~wahb = b.set(\wahMix, 1, \wahRate, (120/60));
    } {
        "WAH OFF".postln;
        ~nowahb = b.set(\wahMix, 0);
    };
};

// RECORD B
~botones[17].action = {
	if (~botones[17].value == 1) {
		"PSHIFT ON".postln;
		~pshiftb = b.set(\pitchOn, 1, \pR, 1, \pD, 1, \tD, 0);
    } {
        "PSHIFT OFF".postln;
		~pshiftb = b.set(\pitchOn, 0, \pR, 3, \pD, 2, \tD, 3);
    };
};

// CLEAN B
~botones[18].action = {
    "CLEANED".postln;
    (11..17).do { |i|
        ~botones[i].valueAction = 0;
    };
};

~ultimoTextob = nil;

~botones[19].action = {
    if (~botones[19].value == 1) {
        r({
            var elegido;
            elegido = ~escalas.choose;
            ~ultimoTextob = elegido;
            {
				~randomizer[1].string = elegido;
            }.defer;
            0.1.wait;
            {
                ~botones[19].valueAction = 0;
            }.defer;
        }).play;
    };
};

~botones[20].action = {
    if (~botones[20].value == 1) {
        "RECORD ON".postln;
         //~turnOn.value;
		~onsetDetect = Synth(\onsetDetector, [\inBus, 0, \slowLag, 2.0, \minDur, 1, \thresh, 0.25], ~grO);
    } {
		//~turnOff.value;
        "RECORD OFF".postln;
    };
};

~botones[21].action = {
	if (~botones[21].value == 1) {
        r({
			3.wait;
			Routine({
				~ampla = [];
				~apla = Synth(\ataquesamp);
				6.wait;
				~apla.free;
				~aplausos = ~ampla.sum/~ampla.size;
				~aplausos.postln;
				AppClock.sched(0, {
					var str = ~aplausos.round(0.0001).asString;
					~ganaplauso.string_(str);
				});

			}).play;
			7.wait;
            {
				~botones[21].valueAction = 0;
            }.defer;
        }).play;
	}{
	};
};

~botones[22].action = {
    if (~botones[22].value == 1) {
        "ROTAR".postln;
		~rotaciones = Routine({
			~rotarUno = Routine({
				var canalActual;
				canalActual= 0;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[0].set(\out, canalActual);
					~wait.wait;
				};
			}).play;

			~rotarDos = Routine({
				var canalActual;
				canalActual= 1;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[1].set(\out, canalActual);
					~wait.wait;
				};
			}).play;

			~rotarTres = Routine({
				var canalActual;
				canalActual= 2;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[2].set(\out, canalActual);
					~wait.wait;
				};
			}).play;

			~rotarCuatro = Routine({
				var canalActual;
				canalActual= 3;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[3].set(\out, canalActual);
					~wait.wait;
				};
			}).play;

			~rotarCinco = Routine({
				var canalActual;
				canalActual= 4;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[4].set(\out, canalActual);
					~wait.wait;
				};
			}).play;

			~rotarSeis = Routine({
				var canalActual;
				canalActual= 5;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[5].set(\out, canalActual);
					~wait.wait;
				};
			}).play;

			~rotarSiete = Routine({
				var canalActual;
				canalActual= 6;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[6].set(\out, canalActual);
					~wait.wait;
				};
			}).play;

			~rotarOcho = Routine({
				var canalActual;
				canalActual= 7;
				inf.do {
					canalActual = (canalActual + 1) % 8;
					~sintes[7].set(\out, canalActual);
					~wait.wait;
				};
			}).play;
		}).play;
	} {
		"ROTAR OFF".postln;
		~rotacionesoff = Routine({
			~rotarUno.stop;
			~rotarDos.stop;
			~rotarTres.stop;
			~rotarCuatro.stop;
			~rotarCinco.stop;
			~rotarSeis.stop;
			~rotarSiete.stop;
			~rotarOcho.stop;
			~sintes[0].set(\out, 0);
			1.wait;
			~sintes[1].set(\out, 1);
			1.wait;
			~sintes[2].set(\out, 2);
			1.wait;
			~sintes[3].set(\out, 3);
			1.wait;
			~sintes[4].set(\out, 4);
			1.wait;
			~sintes[5].set(\out, 5);
			1.wait;
			~sintes[6].set(\out, 6);
			1.wait;
			~sintes[7].set(\out, 7);
		}).play;
	};
};

~botones[23].action = {
    if (~botones[23].value == 1) {
		"MÁS RÁPIDO".postln;
		~rapido = Routine({
			60.do { |i|
				~wait = i.linexp(0, 59, 2, 0.1);
				("Nuevo wait: " ++ ~wait).postln;
				6.wait;
			};
		}).play;
    } {
        "BÁJALE A TU PEDO".postln;
    };
};

~botones[24].action = {
    if (~botones[24].value == 1) {
		"FINAL".postln;
		~finalF = Routine({
			~files = PathName(~folder).entries.select { |a| a.extension == "wav" };
			~buffers = ~files.collect { |a| Buffer.read(s, a.fullPath) };
			~canalBurla = 0;
			~burlasjeje = Synth(\burlaPlayer);
			~rutina = Routine {
				inf.do {
					var file = ~files.choose;
					file.postln;
					Buffer.readChannel(s, file.fullPath, channels: [0], action: { |buf|
						Synth(\burlaPlayer, [
							\buf, buf,
							\out, ~canalBurla,
							\rate, [0.25, 0.5, 1, 2, 4].choose,
							\amp, rrand(0.2, 0.6)
						]);
						~canalBurla = (~canalBurla + 1) % 8;
					});
					(rrand(2, 3)).wait;
				}
			}.play;
			120.wait;
			~rutina.stop;
			"acabando".postln;
			25.wait;
			~sintes[0].release;
			2.wait;
			~sintes[1].release;
			2.wait;
			~sintes[2].release;
			2.wait;
			~sintes[3].release;
			2.wait;
			~sintes[4].release;
			2.wait;
			~sintes[5].release;
			2.wait;
			~sintes[6].release;
			2.wait;
			~sintes[7].release;
			~burlasjeje.stop;

		}).play;
    } {
        "ZZZ".postln;
    };
};

////////////////////////////////////////// TABLERO ///////////////////////////////////////////////

~winBSize = Rect(0, 0, 1500, 250);
~centeredPosB = Rect(
    (~screenSize.width - ~winBSize.width) / 2,
    (~screenSize.height - ~winBSize.height) / 1.01,
    ~winBSize.width,
    ~winBSize.height
);

v = Window.new("Tablero", ~centeredPosB, scroll:true).front;

// Temporizador

z = Button(v, Rect(600, 40, 40, 40));
z.states = [["START", Color.black, Color.white], ["STOP", Color.white, Color.red]];
z.font = Font("Barlow", 12);


~contadores = [
	StaticText(v, Rect(200, 10, 150, 150)),
	StaticText(v, Rect(1150, 10, 150, 150))
];


~contadores.do { |i|
    i.background = Color.black;
	i.align = \center;
    i.font = Font("Digital Counter 7", 80);
	i.stringColor = Color.red;
    i.string = "0";
};

~sumadores = [
	Button(v, Rect(130, 35, 40, 40)),
	Button(v, Rect(130, 95, 40, 40)),
	Button(v, Rect(1330, 35, 40, 40)),
	Button(v, Rect(1330, 95, 40, 40))
];

[0, 2].do { |i|
	~sumadores[i].states = [["+", Color.black, Color.white]];
};

[1, 3].do { |i|
	~sumadores[i].states = [["-", Color.black, Color.white]];
};

~sumadores.do { |i|
    i.font = Font("Barlow", 20);
};

~puntos = [0, 0];

~sumadores[0].action = {
    ~puntos[0] = ~puntos[0] + 1;
    ~contadores[0].string = ~puntos[0].asString;
};

~sumadores[1].action = {
    ~puntos[0] = ~puntos[0] - 1;
    ~contadores[0].string = ~puntos[0].asString;
};

~sumadores[2].action = {
    ~puntos[1] = ~puntos[1] + 1;
    ~contadores[1].string = ~puntos[1].asString;
};

~sumadores[3].action = {
    ~puntos[1] = ~puntos[1] - 1;
    ~contadores[1].string = ~puntos[1].asString;
};

~timer = StaticText(v, Rect(650, 40, 200, 200));
~timer.string = "--";
~timer.background = Color.black;
~timer.align = \center;
~timer.font = Font("Digital Counter 7", 120);
~timer.stringColor = Color.red;

~ganaplauso = StaticText(v, Rect(700, 0, 100, 40));

~ganaplauso.background = Color.gray;
~ganaplauso.align = \center;
~ganaplauso.font = Font("Barlow", 15);

{|btn20|
    btn20.action = { |z|
        if (z.value == 1) {
            if (~timerRoutine.notNil and: { ~timerRoutine.isPlaying }) {
                "Ya hay un conteo en curso.".postln;
                ^nil;
            };

            "EMPIEZA CONTEO".postln;
            ~stopFlag = false;
			~startRec.();
            ~timerRoutine = Routine {
                (30..0).do { |i|
                    if (~stopFlag) {
                        "CONTEO CANCELADO".postln;
                        {
                            ~timer.string = "--";
                            z.valueAction = 0;
                        }.defer;
                        ^nil;
                    };

                    {
                        ~timer.string = i.asString;
                    }.defer;

                    1.wait;
                };

                {
                    ~stopRec.();
					"FINAL".postln;
					~timer.string = "--";
					~botones[0].valueAction = 0;
					~botones[10].valueAction = 0;
					(1..7).do { |i|
						~botones[i].valueAction = 0;
					};
					(11..17).do { |i|
						~botones[i].valueAction = 0;
					};
					z.valueAction = 0;
                    ~timerRoutine = nil;
                }.defer;
            }.play(AppClock);

        } {
            if (~timerRoutine.notNil and: { ~timerRoutine.isPlaying }) {
                "DETENIDO".postln;
				~stopRec.();
				~timer.string = "--";
				~timerRoutine.stop;
				~timerRoutine = nil;
                ~stopFlag = true;
            };
        };
    };
}.(z);