
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Midilink\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

//Nota: en caso de utilizar un equipo de computo con windows o linux, deberas de alguna manera instalar algun programa que te permita crear algun puerto midi virtual dentro de tu computadora que conecte Supercollider con ableton live. en ese supuesto una vez que hayas conseguido crear estos puertos deberas en la siguiente area reasignar el nombre de de estos puertos acorde a tu computadora. De igual forma si te encuentras en un equipo mac no olvides crear los buses dentro de la configuracion midi de tu equipo. una vez tengas esto listo podras disfutar de jugar con este codigo y sus posibilidades sonoras.

//Muy importante recuerda asignar los canales midi correctos en ableton para lograr que funcione de manera correcta


////SALIDAS MIDI A ABLETON////EVIAN LOS MENSAJES MIDI DE LOS PATRONES/////

(
MIDIClient.init;
~midiOut = MIDIOut.newByName("Driver IAC", "Bus 1");
~midiOut2 = MIDIOut.newByName("Driver IAC", "Bus 2");
~midiOut3 = MIDIOut.newByName("Driver IAC", "Bus 3");
~midiOut4 = MIDIOut.newByName("Driver IAC", "Bus 4");
~midiOut5 = MIDIOut.newByName("Driver IAC", "Bus 5");
~midiOut6 = MIDIOut.newByName("Driver IAC", "Bus 6");

~midiOut.latency = 0;

//////ASIGNA EL TEMPO EN EL QUE SE EJECUTARAN LOS PBIND Y RUTINAS
t = TempoClock(60/90);

//~midiOut.allNotesOff(1,2,3,4);
//~midiOut2.allNotesOff(1,2,3,4);
//~midiOut3.allNotesOff(1,2,3,4);
//~midiOut4.allNotesOff(1,2,3,4);
//~midiOut5.allNotesOff(1,2,3,4);
//~midiOut6.allNotesOff(1,2,3,4);

/////METODOS QUE EJECUTAN LOS

"materiales 3.scd".loadRelative;
"patrones 4.scd".loadRelative;
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\DIRECTORIO\\DE\\Ppars y Ptpars\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


(
	// directorio de duraciones para ptpars
~durac = 60/90 * 4; // duracion compas 2.6666666666667
~durA = ~durac * 34;
~durB = ~durac * 32;
~durC = ~durac * 2;
~durD = ~durac * 5;
~durE = ~durac * 6;
~durF = ~durac * 16;

//pdef con sus respectivos Ptpars, esto permite la reproduccion de los ptpars de una manera controlada

Pdef(\gestiele1, Ppar([~ges1, ~ges2, ~ges3, ~ges4]));

//Pdef(\loop1, Ptpar([0, ~sDrum1, 0, ~instru1a, 0, ~instru1b, 0, ~instru1c, 0, ~instru1d]));

//Pdef(\loop2, Ptpar([0, ~sDrum2, 0, ~instru2b, 0,~instru2c, ~durC, ~instru2d, ~durD, ~instru2a]));

//Pdef(\loop3, Ptpar([0,~sDrum3, 0 ,~instru3c, 0,~instru3d.finDur(~durE), 0,~instru3a, ~durC, ~instru3b.finDur(~durE)]));

//Pdef(\loop4, Ptpar([0, ~sDrum4, ~durD, ~instru4d.finDur(~durF), ~durC,~instru4a, 0,~instru4b.finDur(~durF), 3.0,~instru4c]));


//tambien se pueben usar como Ppars
Pdef(\loop1, Ppar([~sDrum1, ~instru1a, ~instru1b, ~instru1c, ~instru1d]));

Pdef(\loop2, Ppar([~sDrum2, ~instru2a, ~instru2b, ~instru2d, ~instru2c]));

Pdef(\loop3, Ppar([~sDrum3, ~instru3c, ~instru3d, ~instru3a, ~instru3b]));

Pdef(\loop4,  Ppar([~sDrum4, ~instru4d, ~instru4a, ~instru4b, ~instru4c]));



);








//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\DETECTOR\\DE\\AMPLITUDES\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SynthDef(\dethector, {arg in = 0;
	var inp, ampF, freq, hasFreq;
	inp = SoundIn.ar(in);
	ampF = Amplitude.kr(inp * 100, 0.01, 0.1);
	SendTrig.kr(Impulse.kr(5), 2, ampF);
}).add;


x = Synth(\dethector);

~amps16 = [];
~promamps16 = 0;

~amps4 = [];
~promamps4 = 0;

~ampAct = 0;

~hayamp = false;

~umbralhayamp = 0.001;

// Umbrales de amplitud para cada dinámica

~piano = 0.1;
~mesoforte = 0.3;
~forte = 0.5;
~fortissimo = 0.7;

///Oscdef convierte las señales del dethector en promedios deefiniendo los mensajes
OSCdef(\deTec, {arg msg, time, addr, port;
	~amps16 = ~amps16.add(msg[3]);
	~amps4 = ~amps4.add(msg[3]);
	~ampAct = msg[3];

	if(msg[3] > ~umbralhayamp)
	{ ~hayamp = true;}
	{~hayamp = false;};

}, \tr, s.addr);

///rutina general promedia cada 4 tiempos
~rutinaG = r{
	inf.do{
		4*4.wait;
		~promamps4 = ~amps4.sum/~amps4.size;
		~promamps4.postln;
		~amps4 = [];}
};

//rutina con casos en los que debe de disparar los loops
~rotine4 = r{
    inf.do{
        ~hayamp.postln;
        ~ampAct.postln;
        ~promamps16.postln;
        ~promamps4.postln;

		4.wait(t); // Espera 4 tiempos

        case(

            { ~promamps4  < ~piano }, {

				Pdef(\gestiele1).play;
				Pdef(\loop1).stop;
				Pdef(\loop2).stop;
				Pdef(\loop3).stop;
				Pdef(\loop4).stop;
				"gestos".postln
            },

			{ (~promamps4 > ~piano) &&  (~promamps4 < ~mesoforte)}, {

				Pdef(\gestiele1).stop;
				Pdef(\loop3).play;
				Pdef(\loop2).stop;
				Pdef(\loop1).stop;
				Pdef(\loop4).stop;

            },

			{ (~promamps4 > ~mesoforte) && (~promamps4 < ~forte)}, {
				Pdef(\gestiele1).stop;
				Pdef(\loop1).stop;
				Pdef(\loop2).play;
				Pdef(\loop3).stop;
				Pdef(\loop4).stop;

			},

			{ (~promamps4 > ~forte) && (~promamps4 < ~fortissimo) }, {

				Pdef(\gestiele1).stop;
				Pdef(\loop1).stop;
				Pdef(\loop2).stop;
				Pdef(\loop4).play;
				Pdef(\loop3).stop;

			},

			{ ~promamps4 > ~fortissimo }, {
				Pdef(\gestiele1).stop;
				Pdef(\loop1).stop;
				Pdef(\loop2).stop;
				Pdef(\loop3).stop;
				Pdef(\loop1).play;

			}

	);

	};
    // Actualizar la GUI
    { ~updateStatus.() }.defer;
};


//////GUI//////////////////


//ventana de control
w = Window("TheR.A.", Rect(200, 200, 600, 400)).front;
w.view.decorator = FlowLayout(w.view.bounds);

// Botón de inicio
Button(w, Rect(0,0,280,50))
.states_([["INICIAR PATCH", Color.red(0.7), Color.green(0.7)]])
.action_({
	// Iniciar OSCdef y rutinas


	~deter = OSCdef(\deTec, {arg msg, time, addr, port;
		~amps16 = ~amps16.add(msg[3]);
		~amps4 = ~amps4.add(msg[3]);
		~ampAct = msg[3];

		~rutinaG.play(t);

		if(msg[3] > ~umbralhayamp)
		{ ~hayamp = true;}
		{~hayamp = false;};…


	}, \tr, s.addr);
	~monitorRoutine = [~rotine16, ~rotine4].do(_.play(t));
	"Patch iniciado".postln;
});
Button(w, Rect(0,0,280,50))
.states_([["TempoClock", Color.blue(0.7), Color.yellow(0.7)]])
.action_({
	t = TempoClock(60/90);
	"clockclockiado".postln;
});
// Botón de parada
Button(w, Rect(0,0,280,50))
.states_([["DETENER PATCH", Color.white, Color.black]])
.action_({
	~deter.free;
	~rotine4.stop;
	~rutinaG.stop;
	Pdef(\gestiele1).stop;
	Pdef(\loop1).stop;
	Pdef(\loop2).stop;
	Pdef(\loop3).stop;
	Pdef(\loop4).stop;

	4.do{|i|
		i.postln;
		~midiOut.allNotesOff(i);
		~midiOut2.allNotesOff(i);
		~midiOut3.allNotesOff(i);
		~midiOut4.allNotesOff(i);
		~midiOut5.allNotesOff(i);
		~midiOut6.allNotesOff(i);
	};
	"Patch detenido".postln;

});




// Sliders para umbrales
EZSlider(w, 280@30, "Umbral hay amp", \amp.asSpec,
    { |ez1| ~umbralhayamp = ez1.value },
  ~umbralhayamp ? 0.00
).value= 0.1;

EZSlider(w, 280@30, "Umbral Piano", \amp.asSpec,
    { |ez2| ~piano = ez2.value },
    ~piano ? 0.00
).value= 0.2;

EZSlider(w, 280@30, "Umbral mesoforte", \amp.asSpec,
    { |ez3| ~mesoforte = ez3.value },
    ~mesoforte ? 0.00
).value= 0.4;

EZSlider(w, 280@30, "Umbral forte", \amp.asSpec,
    { |ez4| ~forte = ez4.value },
    ~forte ? 0.00
).value= 0.6;

EZSlider(w, 280@30, "Umbral fortissimo", \amp.asSpec,
    { |ez5| ~fortissimo = ez5.value },
    ~fortissimo ? 0.00
).value= 0.8;

// Visualizador de estado
~statusText = StaticText(w, 280@20)
.string_("Estado: Inactivo")
.align_(\center)
//.name_(\estado);
.background_(Color.grey(0.8));

~updateStatus = {
    var status;
    if(~hayamp.not) {
        status = "Sin señal de audio";
    } {
        case(
            { ~promamps4 < ~piano }, { status = "Pianissimo: Gestos" },
            { (~promamps4 > ~piano) &&  (~promamps4 < ~mesoforte) }, { status = "Piano: Loop 3" },
            { (~promamps4 > ~mesoforte) && (~promamps4 < ~forte) }, { status = "Mezzoforte: Loop 1" },
            {(~promamps4 > ~forte) && (~promamps4 < ~fortissimo)}, { status = "Forte: Loop 2" },
            { ~promamps4 > ~fortissimo }, { status = "Fortissimo: Loop 4" }
        );
    };
    ~statusText.string = "Estado: " + status + " | Amp: " + ~ampAct.round(0.001);
};

~statusRoutine = Routine({
    inf.do {
        ~updateStatus.();
		4.wait(t);
    }
}).play(AppClock);
)