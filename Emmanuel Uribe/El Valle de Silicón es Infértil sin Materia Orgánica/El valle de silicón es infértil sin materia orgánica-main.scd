////////////////////////////////////////El valle de silicón es infértil sin materia orgánica\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////emmanuel_uribe 2024-2025\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

MIDIIn.connectAll;

//parámetros de control MIDI
~paramFm = {}!4; // amp, porthz, modhz, modamp
~paramG ={}!4;
~paramX = {}!4;

//Patrones rítmicos
~dos = Pseq([0.5],2); //octavos
~tres = Pseq([1/3],3); //trecillos
~cuatro = Pseq([1/4],4); //dieciseisavos
~cinco = Pseq([1/5],5); //quintillos
~siete = Pseq([1/7],7); //sietillos
~nueve = Pseq([1/9],9); // nonillow
~once = Pseq([1/11],11); //oncillos
~dos1 = Pseq([Rest(0.5), 0.5]);
~tres1 = Pseq([Rest(1/3), 1/3, 1/3]);
~tres2 = Pseq([Rest(1/3), Rest(1/3), 1/3]);
~tres3 = Pseq([Rest(1/3), 1/3, Rest(1/3)]);
~cuatro1 = Pseq([Rest(0.25),0.25,0.25,0.25]);
~cuatro2 = Pseq([0.25,Rest(0.5),0.25,0.25]);
~cuatro3 = Pseq([0.25,0.25,Rest(0.25),0.25]);
~cuatro4 = Pseq([0.25,Rest(0.5),0.25]);
~cinco1 = Pseq([Rest(1/5),Pseq([1/5],4)]);
~cinco2 = Pseq([Rest(1/5),Pseq([1/5],2),Rest(1/5),1/5]);
~cinco3 = Pseq([1/5,Rest(1/5),Pseq([1/5],3)]);
~cinco4 = Pseq([Rest(1/5),1/5,Rest(1/5),1/5,Rest(1/5)]);
~cinco5 = Pseq([1/5,Rest(1/5),1/5,Rest(1/5),1/5]);

//Alturas tetracordes
~i = [7,5,9,0].scramble;
~ii = [4,0,9,8].scramble;
~iii = [10,8,4,2].scramble;
~iv = [1,2,6,10].scramble;
~v = [6,11,1,3].scramble;
~vi = [1,3,7,5].scramble;

//Cargar samples
~nombres_mono =[
	"T0884-droping stuff.wav",
	"T_0241-maquinaria.wav",
	"Globo- Muestra 1(-48db).wav",
	"Botella plástica vacía- Muestra 1 (nube de puntos).wav",
	"TASCAM_0080.wav",
	"TASCAM_0789.wav",
	"TASCAM_0790.wav",
	"cortos1.wav", //7
	"cortos2.wav", //8
	"cortos3.wav", //9
	"cortos4.wav", //10
	"fierroscortos1.wav", //11
];
~path_mono = thisProcess.nowExecutingPath.dirname++"/Audios/"; //este código busca los audios en la misma carpeta que se encuentra el patch
//~path_mono= "C:/Users/LENOVO/Documents/Respaldo 2024/improvable/improvable2024/Audios/"; //Este código busca los audios en la ubicación absoluta de la carpeta dentro de la computadora. Cambiar la ruta entre comillas por la ruta de la carpeta que contiene los samples.

~bofs_mono = ~nombres_mono.collect{|nom|
	Buffer.readChannel(s, ~path_mono ++ nom, channels:[0])
};

//Granulador audio en vivo
~duracion_buffs1 = Array.rand(2, 11.0, 23); //variable con dos tiempos elegidos entre el rango indicado

~buffs1 = [ //grabar en ciclos con las duraciones elegidas en dos buffers diferentes
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs1[0], 1),
	Buffer.alloc(s, s.sampleRate * ~duracion_buffs1[1], 1)
];

//Cargar sintes y patrones
"elvalledesilicon_sintes.scd".loadRelative;
"elvalledesilicon_patrones.scd".loadRelative;

///////imitador de ritmos
~almacen = [];

SynthDef(\ataques, {arg in = 0, umbral = 0.5, relax = 1.6, min = 16;
    var inp, onsets, chain, amp;
    inp = SoundIn.ar(in);
    amp  = Amplitude.kr(inp);
    chain =  FFT(LocalBuf(512), inp);
    onsets = Onsets.kr(chain, umbral, \rcomplex, relax, 0.1, min);
//    onsets = Onsets.kr(chain, MouseX.kr(0,1.0), \rcomplex);
    SendTrig.kr(onsets, 2, amp);
}).add;

OSCdef(\detectPatt, {arg msg, time, addr, port;
//	[msg, time, addr, port].postln;
	msg[3].postln;
	~almacen = ~almacen.add(time);
}, \tr, s.addr);

// esto es para prender y apagar manualmente
//~at = Synth(\ataques, [\umbral, 0.85, \relax, 2.5, \min, 20]);
//OSCdef(\detectPatt).disable;

~rutina = r {
	~almacen = [];
	\comienza.postln;
	~at = Synth(\ataques, [\umbral, 0.85, \relax, 2.5, \min, 20]);
	0.05.wait;
	OSCdef(\detectPatt).enable;
	rrand(11,19).wait;
//	OSCdef(\detectPatt).clear;
	~at.free;
	\yaestuvo.postln;
	~almacen.postln;
	// aqui puedes decidir si redondeas o no
	//~durs= ~almacen.differentiate.round(0.125)[1..];
	~durs= ~almacen.differentiate[1..];//comenta esta línea y descomenta la de arriba para redondear a valores de dieciseisavo con el cuarto a 60bpm
	rrand(11,19).wait;
	p.stop
};

//~rutina.reset; //volver a escuchar
//~rutina.play; //escuchar

//////////////////////////////////////////////////////////////////////////////////
/////////////INTERFAZ GRÁFICA
//Ventana
w = Window.new("Tecnologías musicales y experimentación sonora para incitar la creatividad", Rect(100, 100, 805, 440)).front;
// w.background = Color.rand(1, 0.9);
w.background = Color.new255(011, 013, 015);
w.onClose_({s.freeAll;});

//Divisiones de la ventana
~c1 = CompositeView(w, Rect(5, 5, 795, 40));
~c1.background =  Color(0.21, 0.51, 0.09, 0.1);
~c1.decorator = FlowLayout(~c1.bounds);

~c2 = CompositeView(w, Rect(5, 50, 333, 260));
~c2.background =  Color(0.1, 0.2, 0.43, 0.5);
~c2.decorator = FlowLayout(~c2.bounds, 5@5, 5@5);

~c3 = CompositeView(w, Rect(350, 50, 450, 260));
~c3.background =  Color(0.2, 0.25, 0.3, 0.5);
~c3.decorator = FlowLayout(~c3.bounds, 15@5, 5@5);

~c4 = CompositeView(w, Rect(5, 325, 790, 110));
~c4.background =  Color(0.25, 0.2, 0.35, 0.5);
~c4.decorator = FlowLayout(~c4.bounds, 10@10, 15@15);

//División para título
~c1.decorator.shift(150, 0);
~ttl= StaticText(~c1, 600@40);
~ttl.stringColor=Color.white;
~ttl.font=Font("monospace", 25);
~ttl.string_("El valle de silicón es infértil sin materia orgánica");

//Medidas botones y knobs
~bzise=100;
~knobsize=35;
~bot = []!42;
~knob = []!28;

//Texto en los botones
~n = ["Bubbles", "Crunchy", "Wall"];
~noms = ~n.collect{|x| ["High " ++ x, "Mid " ++ x, "Bass " ++ x, "FR " ++ x, "Ramp " ++ x, "Cust " ++ x]}.flop.flatten; //esta función recolecta el primer array para agregar diferentes inicios y almacenar los textos resultantes en otro array que acomoda en subarrays del array madre. El flop acomoda los arrays según el nuevo texto raiz y el flatten compacta quitando todos los subarrays.

~resto = ["Inv Clang", "Granny Caos", "Escuchar", "Auto Granny", "TFM Caos","Granny R", "Imitar",  "Machine 1", "Seq Bass",  "Grabar", "Nueva escucha", "Machine 2", "Seq Camp", "LiveS Granny","Dusty", "Machine 3", "Tetracordes", "LiveR Granny", "Noise", "Machine 4", "Cust FM", "Cust Granny", "Cust X",  "Machine 5"];

//División de la ventana para acomodar los botones
~c2.decorator.shift(5, 5);
//Sección izquierda
~bot1 = ~noms.collect{|x, i| var bot;
        bot = Button(~c2, ~bzise@35).states_([
                [x ++ " OFF", Color.white, Color.gray(0.2)],
                [x ++ " ON", Color.black, Color(0.2, 0.8)]
        ]).font_(Font("Optima", 11));
        if ((i>1) and: ((i+1)%3== 0)) {~c2.decorator.nextLine; ~c2.decorator.shift(5,2)};
	bot;
};
//Sección derecha
~c3.decorator.shift(5, 5);
~bot2 = ~resto.collect{|x, i| var bot;
	if ( (i == 4) or: (i==10) or: (i==11) or: (i==19)) {//condicional es para los botones con un estado
                bot = Button(~c3, ~bzise@35).states_([
                        [x, Color.white, Color.gray(0.2)]
                ]).font_(Font("Optima", 11));
        }{
                bot = Button(~c3, ~bzise@35).states_([
                        [x ++ " OFF", Color.white, Color.gray(0.2)],
                        [x ++ " ON", Color.black, Color(0.2, 0.8)]
                ]).font_(Font("Optima", 11));
        };
        if ((i>1) and: ((i+1)%4== 0)) {~c3.decorator.nextLine; ~c3.decorator.shift(5,2)};
        bot;
};

~bot = ~bot1 ++ ~bot2;


~knob = 28.collect{|i| var knoby;
        knoby = Knob(~c4, ~knobsize@~knobsize);
        if ((i+1)%2 == 0) {~c4.decorator.shift(10, 0) };
        if ((i ==5) or: (i == 19)) {~c4.decorator.shift(25, 0) };
        if ((i+1)%14 == 0) {~c4.decorator.nextLine};
        knoby;
};

//ControlSpec knobs
//Bubbles
~specAmprb = ControlSpec(-inf, 12.0, \db, 0.0, 0, "dB");
~specFreqrb = ControlSpec(1.0, 55, \exponential, 0.0);
~specTfiltrb = ControlSpec(7.0, 99, \linear, 0.0, 55.0);
~specTramprb = ControlSpec(0.05, 0.45, \linear, 0.0, 0.2);
//Crunch
~specAmpcr = ControlSpec(-inf, 12.0, \db, 0.0, 0);
~specFreqcr = ControlSpec(0.01, 9, \exponential);
~specModcr = ControlSpec(59.5, 220, \exponential);
~specRoomcr = ControlSpec(0.05, 0.75, \linear);
//Wall
~specAmpw = ControlSpec(-inf, -1.5, \db, 0.0, -9);
~specFreqw = ControlSpec(46.0,3001, \exponential);
~specModw = ControlSpec(70, 351, \exponential);
~specTfiltw = ControlSpec(0.05,41.83, \exponential, 0.0);

//FM
~specAmpfm = ControlSpec(-inf, -15.0, \db, 0.0, -24);
~specPortfm = ControlSpec(30.0, 10000, \exponential, 0.0, 240);
~specModfm = ControlSpec(30.0, 10000, \exponential, 0.0, 240);
~specAmpmodfm = ControlSpec(0.0, 10000, \linear, 0.0, 5000);
//Gran
~specAmpg = ControlSpec(-inf, -12.0, \db, 0.0, -15);
~specDensg = ControlSpec(1.1, 23);
~specDurg = ControlSpec(0.001, 2.99);
~specPosg = ControlSpec(0.23, 0.89);
//CustX
~specAmpcx = ControlSpec(-inf, -6.0, \db, 0.0, -15); //\amp, v.value.linexp(0,1,0.0025,0.09)
~specFycx = ControlSpec(1.9, 41, \exponential, 0.0, 19); //\fy, v.value.linexp(0,1,0.25,31)
~specAmodcx = ControlSpec(0.5, 41, \exponential, 0.0, 1); //\am, v.value.linexp(0,1,0.25,31)
~specFxcx = ControlSpec(1.7, 41, \exponential, 0.0, 17); //\fx, v.value.linexp(0,1,0.25,31)
//Machine5
~specAmpmch = ControlSpec(-inf, -30, \db, 0.0, -69);
~specAmrmch = ControlSpec(0.1, 37, \linear, 0.0, 11);
~specFrrmch = ControlSpec(0.1, 37, \exponential, 0.0, 13);
~specDensmch = ControlSpec(0.05, 1, \linear, 0.0, 0.5);

//Para actualizar el GUI
~setFm = [
	{|v| {if(~bot[38].value == 1){
		~custfm.set(\amp, ~specAmpfm.map(v.value).dbamp);
		~paramFm[0] = v.value;}}.defer
	},
	{|v|{if(~bot[38].value == 1){
		~custfm.set(\portHz, ~specPortfm.map(v.value));
		~paramFm[1] = v.value;}}.defer
	},
	{|v|{if(~bot[38].value == 1){
		~custfm.set(\modHz, ~specModfm.map(v.value));
		~paramFm[2] = v.value;}}.defer
	},
	{|v| {if(~bot[38].value == 1){
		~custfm.set(\modAmp, ~specAmpmodfm.map(v.value));
		~paramFm[3] = v.value;}}.defer
	}
];

~setGran = [
	{|v| {if(~bot[39].value == 1){
		~gcust.set(\amp, ~specAmpg.map(v.value).dbamp);
		~paramG[0] = v.value;}}.defer
	},
	{|v| {if(~bot[39].value == 1){
		~gcust.set(\dens, ~specDensg.map(v.value));
		~paramG[1] = v.value;}}.defer
	},
	{|v| {if(~bot[39].value == 1){
		~gcust.set(\dur, ~specDurg.map(v.value));
		~paramG[2] = v.value;}}.defer
	},
	{|v| {if(~bot[39].value == 1){
		~gcust.set(\pos, ~specPosg.map(v.value));
		~paramG[3] = v.value;}}.defer
	}
];

~setX = [
	{|v| {if (~bot[40].value == 1){
		~instX.set(\amp, ~specAmpcx.map(v.value).dbamp);
		~paramX[0] = v.value;}}.defer
	},
	{|v| {if (~bot[40].value == 1){
		~instX.set(\fy, ~specFycx.map(v.value).dbamp);
		~paramX[1] = v.value;}}.defer

	},
	{|v| {if (~bot[40].value == 1){
		~instX.set(\am, ~specAmodcx.map(v.value).dbamp);
		~paramX[2] = v.value;}}.defer
	},
	{|v| {if (~bot[40].value == 1){
		~instX.set(\fx, ~specFxcx.map(v.value).dbamp);
		~paramX[3] = v.value;}}.defer
	}
];

MIDIdef.cc(\knobss, {|val, cnum|
	//[\cntl, cnum, val].postln;
	switch(cnum,
		71, {~setFm[0].value(val/127)},
		76, {~setFm[1].value(val/127)},
		19, {~setFm[2].value(val/127)},
		16, {~setFm[3].value(val/127)},

		77, {~setGran[0].value(val/127)},
		93, {~setGran[1].value(val/127)},
		17, {~setGran[2].value(val/127)},
		91, {~setGran[3].value(val/127)},

		73, {~setX[0].value(val/127)},
		75, {~setX[1].value(val/127)},
		79, {~setX[2].value(val/127)},
		72, {~setX[3].value(val/127)},
	);
});

~updategui = SkipJack(
	{
//		\running.postln;
		~knob[6].value = ~paramFm[0];
		~knob[7].value = ~paramFm[1];
		~knob[20].value = ~paramFm[2];
		~knob[21].value = ~paramFm[3];

		~knob[8].value = ~paramG[0];
		~knob[9].value = ~paramG[1];
		~knob[22].value = ~paramG[2];
		~knob[23].value = ~paramG[3];

		~knob[10].value = ~paramX[0];
		~knob[11].value = ~paramX[1];
		~knob[24].value = ~paramX[2];
		~knob[25].value = ~paramX[3];
	}, 0.075, name: "wooee"
).play;
//parar actualización del GUI
//~updategui.stop

~ampOut = -69.dbamp;
~ampr = 13;
~freqr = 13;
~dens = 0.5;

//abrir plot tree y meter
s.plotTree;
s.meter;

~play ={false}!40; //genera un array con 40 posiciones que se usan como banderillas o señales (cues) para prender o apagar los botones
//Botones y acciones
//izquierda primer columna
//burbujas
~bot[0].action_(
	{ |b|
		if (~play[0].not)
			{
				~burbAg = ~highBubbles.play; ~play[0] = true;
			"burbujas agudas prendidas".postln;
			}{
			~burbAg.stop; ~play[0] = false; "burbujas agudas apagadas".postln;
			}
		});

~bot[3].action_(
		{ |b|
		if (~play[1].not)
			{
				~burbMed = ~midBubbles.play; ~play[1] = true;
			"burbujas medias prendidas".postln;
			}{
				~burbMed.stop; ~play[1] = false; "burbujas medias apagadas".postln;
			}
		});

~bot[6].action_(
		{ |b|
		if (~play[2].not)
			{
				~burbBass = ~bassBubbles.play; ~play[2] = true;
				"burbujas graves prendidas".postln;
			}{
				~burbBass.stop; ~play[2] = false; "burbujas graves apagadas".postln;
			}
		});

~bot[9].action_(
		{ |b|
		if (~play[16].not)
			{
				~burbFullr = ~fullRgBubbles.play; ~play[16] = true;
				"burbujas fullrange prendidas".postln;
			}{
				~burbFullr.stop; ~play[16] = false; "burbujas fullrange apagadas".postln;
			}
		});

~bot[12].action_(
		{ |b|
		if (~play[17].not)
			{
				~burbRamp = ~rBubbles.play; ~play[17] = true;
				"burbujas rampa prendidas".postln;
			}{
				~burbRamp.stop; ~play[17] = false; "burbujas rampa apagadas".postln;
			}
		});

~bot[15].action_(
		{ |b|
		if (~play[27].not)
			{
			~custBubbles = Synth(\rampbubbles, [\amp, ~specAmprb.map(~knob[0].value).dbamp,
				\freq, ~specFreqrb.map(~knob[1].value),
				\timefilt, ~specTfiltrb.map(~knob[14].value),
				\timeramp, ~specTramprb.map(~knob[15].value)]); ~play[27] = true;
				"burbujas custom prendidas".postln;
			}{
			~custBubbles.set(\gate, 0); ~play[27] = false; "burbujas custom apagadas".postln;
			}
		});

//izquierda segunda culumna
//crunchy
~bot[1].action_(
		{ |b|
		if (~play[3].not)
			{
				~crunchHigh = ~highCrunch.play; ~play[3] = true;
			"crunch agudo prendido".postln;
			}{
			~crunchHigh.stop; ~play[3] = false; "crunch agudo apagado".postln;
			}
		});

~bot[4].action_(
		{ |b|
		if (~play[4].not)
			{
				~crunchMed = ~midCrunch.play; ~play[4] = true;
			"crunch medio prendido".postln;
			}{
			~crunchMed.stop; ~play[4] = false; "crunch medio apagado".postln;
			}
		});

~bot[7].action_(
		{ |b|
		if (~play[5].not)
			{
				~crunchBass = ~bassCrunch.play; ~play[5] = true;
			"crunch bajo prendido".postln;
			}{
			~crunchBass.stop; ~play[5] = false; "crunch bajo apagado".postln;
			}
		});

~bot[10].action_(
		{ |b|
		if (~play[18].not)
			{
				~crunchFullrange = ~fullrangeCrunch.play; ~play[18] = true;
			"crunch full range prendido".postln;
			}{
			~crunchFullrange.stop; ~play[18] = false; "crunch full range apagado".postln;
			}
		});

~bot[13].action_(
		{ |b|
		if (~play[20].not)
			{
				~crunchyRamp = ~rampCrunch.play; ~play[20] = true;
			"crunch ramp prendido".postln;
			}{
			~crunchyRamp.stop; ~play[20] = false; "crunch ramp apagado".postln;
			}
		});

~bot[16].action_(
		{ |b|
		if (~play[28].not)
			{
			~crunchyCust = Synth(\rampCrunch, [
				\amp, ~specAmpcr.map(~knob[2].value).dbamp,
				\freq, ~specFreqcr.map(~knob[3].value),
				\modl, ~specModcr.map(~knob[16].value),
				\room, ~specRoomcr.map(~knob[17].value)
			]); ~play[28] = true;
			"crunch custom prendido".postln;
			}{
			~crunchyCust.set(\gate, 0); ~play[28] = false; "crunch custom apagado".postln;
			}
		});

//izquierda tercer columna
//walls
~bot[2].action_(
		{ |b|
		if (~play[6].not)
			{
				~wallHigh = ~high.play; ~play[6] = true;
			"muro de sonido agudo prendido".postln;
			}{
			~wallHigh.stop; ~play[6] = false; "muro de sonido agudo apagado".postln;
			}
		});

~bot[5].action_(
		{ |b|
		if (~play[7].not)
			{
				~wallMid = ~mid.play; ~play[7] = true;
			"muro de sonido medio prendido".postln;
			}{
			~wallMid.stop; ~play[7] = false; "muro de sonido medio apagado".postln;
			}
		});

~bot[8].action_(
		{ |b|
		if (~play[8].not)
			{
				~wallBass = ~bass.play; ~play[8] = true;
			"muro de sonido bajo prendido".postln;
			}{
			~wallBass.stop; ~play[8] = false; "muro de sonido bajo apagado".postln;
			}
		});

~bot[11].action_(
		{ |b|
		if (~play[19].not)
			{
				~wallFrange = ~fullRange.play; ~play[19] = true;
			"muro de sonido full range prendido".postln;
			}{
			~wallFrange.stop; ~play[19] = false; "muro de sonido full range apagado".postln;
			}
		});

~bot[14].action_(
		{ |b|
		if (~play[21].not)
			{
				~wallRamp = ~rampWall.play; ~play[21] = true;
			"muro de sonido rampa prendido".postln;
			}{
			~wallRamp.stop; ~play[21] = false; "muro de sonido rampa apagado".postln;
			}
		});

~bot[17].action_(
		{ |b|
		if (~play[29].not)
			{
			~wallCust = Synth(\muroDeSonidoSt, [
				\amp, ~specAmpw.map(~knob[4].value).dbamp,
				\freq, ~specFreqw.map(~knob[5].value),
				\mod, ~specModw.map(~knob[18].value),
				\timefilt, ~specTfiltw.map(~knob[19].value)
			]); ~play[29] = true;
			"muro de sonido custom prendido".postln;
			}{
			~wallCust.set(\gate, 0); ~play[29] = false; "muro de sonido custom apagado".postln;
			}
		});

//////////////////sección derecha
//columna 1 (de izq a der)
//Sonido intermitente como platillos frotados
~bot[18].action_(
		{ |b|
		if (~play[9].not)
			{
				~c = ~clang.play; ~play[9] = true;
			"clang 2 prendido".postln;
			}{
			~c.stop; ~play[9] = false; "clang 2 apagado".postln;
			}
		});

//Caos tímbrico FM
~bot[22].action_({~caosT = Routine(
	{
		~reps = rrand(1,23); //elegir número de repeticiones
		~reps.postln; //mostrar número de repeticiones

		"inicio".postln; //indicar que se inició la secuencia
		//comienza un loop
		~reps.do{|n|n.postln; //indicar el número de repetición (empieza con 0)

		x = ~seq.play; //toca la secuencia

		~durs = exprand(0.1,11); //elegir un número entre 0.1 y 11

		~durs.postln; //indicar el número elegido

		~durs.wait; //esperar el número elegido en segundos antes de iniciar de nuevo
		};//el loop termina cuando suena la última repetición
		"fin".postln; //indicar que se terminó
	}
).play;});

//Secuencia bajo
~bot[26].action_(
	{ |b|
		if (~play[10].not)
		{  ~seqBass = ~bajo.play; ~play[10] = true; "secuencia bajo prendida".postln;
		}{
			~seqBass.stop; ~play[10] = false; "secuencia bajo apagada".postln;
		}
	}
);

//Secuencia campanas
~bot[30].action_(
	{ |b|
		if (~play[24].not)
		{  ~seqCamp = ~camp.play; ~play[24] = true; "secuencia campana prendida".postln;
		}{
			~seqCamp.stop; ~play[24] = false; "secuencia campana apagada".postln;
		}
	}
);

//Tetracordes
~bot[34].action_(
	{ |b|
		if (~play[25].not)
		{ ~tetra = ~padz.play; ~play[25] = true; "teracordes prendidos".postln;
		}{
			~tetra.stop; ~play[25] = false; "teracordes apagados".postln;
		}
	}
);

//FM knobs
~bot[38].action_(
	{ |b|
		if (~play[26].not)
		{ ~custfm = Synth(\fmlong2, [
			\amp, ~specAmpfm.map(~knob[6].value).dbamp,
			\portHz, ~specPortfm.map(~knob[7].value),
			\modHz, ~specModfm.map(~knob[20].value),
			\modAmp, ~specAmpmodfm.map(~knob[21].value)]
		); ~play[26] = true; "FM custom prendida".postln;
		}{
			~custfm.set(\gate, 0);~play[26] = false; "FM custom apagada".postln;
		}
	}
);

//derecha columna 2
//granuladores
//Granulador buffer caos
~bot[19].action_(
	{ |b|
		if (~play[11].not)
			{
			~gcaos = {
	|att 0.25, rel 1.1, gate 1, amp 1|
	var sig, pan, env, rl, at;
	~bofsrandl = ~bofs_mono[0..4].choose;
	~bofsrandr = ~bofs_mono[0..4].choose;
	rl = rrand(rel/2, rel*2);
	at = rrand(att, att * 3);
	env = EnvGen.ar(Env.asr(at, 1, rl, 4), gate, doneAction:2);
	pan = LFNoise1.kr(1).range(-1.0,1.0);
	sig = GrainBuf.ar(
		2,
		Dust.ar([MouseX.kr(0.2,41),MouseY.kr(0.2,41)]),
		LFNoise1.kr([0.3,0.3]).exprange(0.2,MouseX.kr(0.03,3.1,)),
		[~bofsrandl,~bofsrandr],
		rrand(0.66,1.33),
		rrand(0.111,0.991),
		2,
		pan) * env * amp * -9.dbamp;
	Out.ar(0, sig);
			}.play;
			~play[11] = true;
			"granulador buff caos prendido".postln;
			}{
			~gcaos.set(\gate, 0); ~play[11] = false; "granulador buff caos apagado".postln;
			}
		});

//Granulador buffer ritmo
~bot[23].action_(
	{ |b|
		if (~play[12].not)
			{
			~granr = {
	|att 0.25, rel 1.1, gate 1, amp 1|
	var sig, pan, env, bfl, bfr, at, rl;
	bfl = ~bofs_mono[0..4].choose;
	bfr = ~bofs_mono[0..4].choose;
	rl = rrand(rel/2, rel*2);
	at = rrand(att, att * 3);
	env = EnvGen.ar(Env.asr(at, 1, rl), gate, doneAction:2);
	pan = LFNoise1.kr(1).range(-1.0,1.0);
	sig = GrainBuf.ar(
		2,
		Impulse.ar([MouseX.kr(0.2,41),MouseY.kr(0.2,41)]),
		LFNoise1.kr([0.3,0.3]).exprange(0.2,MouseX.kr(0.03,3.1)),
		~bofs_mono[rrand(0,4),rrand(0,4)],
		rrand(0.66,1.33),
		rrand(0.111,0.991),
		2,
		pan) * env * amp * -9.dbamp;
	Out.ar(0, Pan2.ar(sig, pan));
			}.play;
			~play[12] = true;
			"granulador ritmo prendido".postln;
			}{
			~granr.set(\gate, 0); ~play[12] = false; "granulador ritmo apagado".postln;
			}
		}
);

//Iniciar grabación para granulador live
~bot[27].action_(
	{ |b|
		if (~play[21].not)
			{
			~grabar1 = Synth(\grabar, [\buff, ~buffs1[0], \in, 0]);
			~grabar2 = Synth(\grabar, [\buff, ~buffs1[1], \in, 1]); ~play[21] = true;
			"grabar prendido".postln;
			}{
			~grabar1.free; ~grabar2.free; ~play[21] = false; "grabar apagado".postln;
			}
		}
);

//Encender granulador live random
~bot[35].action_(
	{ |b|
		if (~play[15].not)
			{
			~grnd = ~granular_rnd.trace.play; ~play[15] = true;
			"granulador rand en vivo prendido".postln;
			}{
			~grnd.stop; ~play[15] = false; "granulador rand en vivo apagado".postln;
			}
		});

//Encender granulador live secuencia
~bot[31].action_(
	{ |b|
		if (~play[14].not)
			{
			~grseq = ~granular_seq.trace.play; ~play[14] = true;
			"granulador seq en vivo prendido".postln;
			}{
			~grseq.stop; ~play[14] = false; "granulador seq en vivo apagado".postln;
			}
		}
);

//Granulador Knobs
~bot[39].action_(
	{|b|
		if(~play[33].not)
		{
			~gcust = Synth(\grannycust, [
			\amp, ~specAmpg.map(~knob[8].value).dbamp,
			\dens, ~specDensg.map(~knob[9].value),
			\dur, ~specDurg.map(~knob[22].value),
			\pos, ~specPosg.map(~knob[23].value)]); ~play[33] = true;
			"granulador custom prendido".postln;
		}{
			~gcust.set(\gate, 0); ~play[33] = false; "granulador custom apagado".postln
		}
}
);

///////////derecha columna 3
/////varios más
~bot[20].action_(
	{ |b|
		if (~play[22].not)
			{
			~rutina.play; ~play[22] = true;
			"escuchar prendido".postln;
			}{
			~rutina.stop; ~play[22] = false; "escuchar apagado".postln;
			}
		}
);

~bot[24].action_(
	{ |b|
		if (~play[23].not)
			{
			~imitar = ~imitador.trace.play; ~play[23] = true;
			"imitar prendido".postln;
			}{
			~imitar.stop; ~play[23] = false; "imitar apagado".postln;
			}
		}
);

~bot[28].action_(
	{
			~rutina.reset; "volver a escuchar".postln;

});

//Dusty
~bot[32].action_(
	{ |b|
		if (~play[31].not)
		{
			~dust = Synth(\dusty); ~play[31] = true;
			"Polvoroso prendido".postln;
		}{
			~dust.set(\gate, 0); ~play[31] = false; "Polvoroso apagado".postln;
		}
	}
);

//Noise
~bot[36].action_(
	{ |b|
		if (~play[32].not)
		{
			~noisy = Synth(\ruido_filt); ~play[32] = true;
			"Ruido airoso prendido".postln;
		}{
			~noisy.set(\gate, 0); ~play[32] = false; "Ruido airoso apagado".postln;
		}
	}
);

//Instrumento X
~bot[40].action_(
	{ |b|
		if (~play[30].not)
		{
			~instX = Synth(\instrumentoX, [
			\amp,  ~specAmpcx.map(~knob[10].value).dbamp,
			\fy, ~specFycx.map(~knob[11].value),
			\am, ~specAmodcx.map(~knob[24].value),
			\fx, ~specFxcx.map(~knob[25].value)
			]); ~play[30] = true;"Custom X encendico".postln;
		}{
			~instX.set(\gate, 0); ~play[30] = false; "Custom X apagado".postln;
		}
});

//derecha columna final
//machines
//Auto Granny
~bot[21].action_(
	{ |b| if (~play[13].not)
		{
			~grannyauto ={
			var sig, env;
			sig = GrainBuf.ar(
				2,
		Dust.ar([LFNoise1.kr(rrand(0.1,3)).range(0.5,11),LFNoise1.kr(rrand(0.1,3)).range(0.5,11)]),// granos por segundo
				//un generador de ruido por canal
				LFNoise1.kr([0.3,0.3]).exprange(0.2,LFNoise1.kr(0.03,3.1)),//duración del grano
				~bofs_mono[rrand(0,6),rrand(0,6)],
				rrand(0.66,1.33), //rate
				rrand(0.111,0.991), //posición de inico
				2, 0, -1, 512, 0.6 // otros parámetros
			);
				sig = Limiter.ar(sig, 0.5);
			}.play; ~play[13] = true;"granulador auto prendido".postln;
			}{
			~grannyauto.free; ~play[13] = false; "granulador auto apagado".postln;
			}
		}
);

//Máquina 1
~bot[25].action_({|b|
	if (~play[34].not)
	{
		"machin uan prendida".postln; ~rut1.play(AppClock); ~play[34] = true;
}{
	~rut1.reset; ~play[34] = false; "machin uan reseteada".postln;
}
});

//Máquina 2
~bot[29].action_(
	{~jeli = Synth(\jelicopter); "machin tu".postln; });

//Máquina 3
~bot[33].action_({|b|
	if (~play[35].not)
	{
		"machin tri prendida".postln; ~rut2.play(AppClock); ~play[35] = true;
	}{
		~rut2.reset; ~play[35] = false; "machin tri reseteada".postln;
	}
});

//Máquina 4
~bot[37].action_(
	{~puntillismo.play; "machin for".postln; }
);

//Máquina 5
~bot[41].action_({|b|
	if (~play[36].not)
	{
		"machin fai prendida".postln;
		~maq5 = ~machfai.play;
		~play[36] = true;
	}{
		"machin fai apagada".postln; ~maq5.stop; ~play[36] = false;
	}
});

//acciones de los knobs
//k-bubbles
~knob[0].action_(
	{|v|
		if(~bot[15].value == 1){
			~custBubbles.set(\amp, ~specAmprb.map(v.value).dbamp);
		};
	}
);
~knob[0].value = 0.5;

~knob[1].action_(
	{|v|
		if(~bot[15].value == 1){
			~custBubbles.set(\freq, ~specFreqrb.map(v.value));
		};
	}
);
~knob[1].value = 0.5;

~knob[14].action_(
	{|v|
		if(~bot[15].value == 1){
			~custBubbles.set(\timefilt, ~specTfiltrb.map(v.value));
		};
	}
);
~knob[14].value = 0.5;

~knob[15].action_(
	{|v|
		if(~bot[15].value == 1){
			~custBubbles.set(\timeramp, ~specTramprb.map(v.value));
		};
	}
);
~knob[15].value = 0.5;

//////k-crunchy
~knob[2].action_(
	{|v|
		if(~bot[16].value == 1){
			~crunchyCust.set(\amp, ~specAmpcr.map(v.value).dbamp);
		};
	}
);
~knob[2].value = 0.5;

~knob[3].action_(
	{|v|
		if(~bot[16].value == 1){
			~crunchyCust.set(\freq, ~specFreqcr.map(v.value));
		};
	}
);
~knob[3].value = 0.5;

~knob[16].action_(
	{|v|
		if(~bot[16].value == 1){
			~crunchyCust.set(\modl, ~specModcr.map(v.value));
		};
	}
);
~knob[16].value = 0.5;

~knob[17].action_(
	{|v|
		if(~bot[16].value == 1){
			~crunchyCust.set(\room, ~specRoomcr.map(v.value));
		};
	}
);
~knob[17].value = 0.5;

//////k-wall
~knob[4].action_(
	{|v|
		if(~bot[17].value == 1){
			~wallCust.set(\amp, ~specAmpw.map(v.value).dbamp);
		};
	}
);
~knob[4].value = 0.5;

~knob[5].action_(
	{|v|
		if(~bot[17].value == 1){
			~wallCust.set(\freq, ~specFreqw.map(v.value));
		};
	}
);
~knob[5].value = 0.5;

~knob[18].action_(
	{|v|
		if(~bot[17].value == 1){
			~wallCust.set(\mod, ~specModw.map(v.value));
		};
	}
);
~knob[18].value = 0.5;

~knob[19].action_(
	{|v|
		if(~bot[17].value == 1){
			~wallCust.set(\timefilt, ~specTfiltw.map(v.value));
		};
	}
);
~knob[19].value = 0.5;

////////k-FM
~knob[6].action_(
	{|v|
		if(~bot[38].value == 1){
			~setFm[0].value(v.value);
		};
	}
);
~knob[6].value = 0.5;

~knob[7].action_(
	{|v|
		if(~bot[38].value == 1){
			~setFm[1].value(v.value);
		};
	}
);
~knob[7].value = 0.5;

~knob[20].action_(
	{|v|
		if(~bot[38].value == 1){
			~setFm[2].value(v.value);
		};
	}
);
~knob[20].value = 0.5;

~knob[21].action_(
	{|v|
		if(~bot[38].value == 1){
			~setFm[3].value(v.value);
		};
	}
);
~knob[21].value = 0.5;

///////k-gran
~knob[8].action_(
	{|v|
		if(~bot[39].value == 1){
			~setGran[0].value(v.value)
		};
	}
);
~knob[8].value = 0.5;

~knob[9].action_(
	{|v|
		if(~bot[39].value == 1){
			~setGran[1].value(v.value)
		};
	}
);
~knob[9].value = 0.5;

~knob[22].action_({|v|
		if(~bot[39].value == 1){
			~setGran[2].value(v.value)
		};
	});
~knob[22].value = 0.5;

~knob[23].action_({|v|
		if(~bot[39].value == 1){
			~setGran[3].value(v.value)
		};
	});
~knob[23].value = 0.5;

//////k-custX
~knob[10].action_(
	{|v|
		if(~bot[40].value == 1){
			~setX[0].value(v.value)
		};
	}
);
~knob[10].value = 0.5;

~knob[11].action_(
	{|v|
		if(~bot[40].value == 1){
			~setX[1].value(v.value)
		};
	}
);
~knob[11].value = 0.5;

~knob[24].action_(
	{|v|
		if(~bot[40].value == 1){
			~setX[2].value(v.value)
		};
	}
);
~knob[24].value = 0.5;

~knob[25].action_(
	{|v|
		if(~bot[40].value == 1){
			~setX[3].value(v.value)
		};
	}
);
~knob[25].value = 0.5;

~ampOut = 1; //encontrar valores fijos.

//////k-Mach5
~knob[12].action_(
	{|v|
		if(~bot[41].value == 1){
			~ampOut = ~specAmpmch.map(~knob[12].value); //out general
		};
	}
);
~knob[12].value = 0.5;

~knob[13].action_(
	{|v|
		if(~bot[41].value == 1){
			~ampr = ~specAmrmch.map(~knob[13].value); // velocidad de las amplitudes
		};
	}
);
~knob[13].value = 0.5;

~knob[26].action_(
	{|v|
		if(~bot[41].value == 1){
			~freqr = ~specFrrmch.map(~knob[26].value); // velocidad de las frecuencias
		};
	}
);
~knob[26].value = 0.5;

~knob[27].action_(
	{|v|
		if(~bot[41].value == 1){
			~dens = ~specDensmch.map(~knob[27].value); // densidad
		};
	}
);
~knob[27].value = 0.5;

////MIDI botones y knobs
MIDIdef.noteOn(\notas, {arg val, val2, val3; //[val, val2, val3].postln;
	switch(val2,

		36, {~caosT = Routine(
	{
		~reps = rrand(1,23);
		~reps.postln;

		"inicio".postln;

		~reps.do{|n|n.postln;

		x = ~seq.play;

		~durs = exprand(0.1,11);

		~durs.postln;

		~durs.wait;
		};
		"fin".postln;
	}
).play;
				\CaosT.postln;
			},

		37, { |b|
			if (~play[10].not)
			{
			{~bot[26].valueAction = 1}.defer;
			"secuencia bajo prendida midi".postln;
			}{
			{~bot[26].valueAction = 0}.defer;
			"secuencia bajo caos apagada midi".postln;
			}
			},

		38, {|b|
			if (~play[24].not)
			{
			{~bot[30].valueAction = 1}.defer;
			"secuencia campanas prendida midi".postln;
			}{
			{~bot[30].valueAction = 0}.defer;
			"secuencia campanas apagada midi".postln;
			}
			},

		39, { |b|
			if (~play[11].not)
			{
			{~bot[19].valueAction = 1}.defer;
			"granulador buff caos prendido midi".postln;
			}{
			{~bot[19].valueAction = 0}.defer;
			"granulador buff caos apagado midi".postln;
			}
		},

		40, { |b|
		if (~play[12].not)
			{
			{~bot[23].valueAction = 1}.defer;
			"granulador buff ritmo prendido midi".postln;
			}{
			{~bot[23].valueAction = 0}.defer;
			"granulador buff ritmo apagado midi".postln;
			}
		},

		41, {|b|
		if (~play[31].not)
			{
			{~bot[32].valueAction = 1}.defer;
			"Polvoroso prendido midi".postln;
			}{
			{~bot[32].valueAction = 0}.defer;
			"Polvoroso apagado midi".postln;
			}
		},

		42, {|b|
		if (~play[32].not)
			{
			{~bot[36].valueAction = 1}.defer;
			"Airoso prendido midi".postln;
			}{
			{~bot[36].valueAction = 0}.defer;
			"Airoso apagado midi".postln;
			}
		},

		43, {|b|
		if (~play[36].not)
		{
		{~bot[41].valueAction = 1}.defer;
		"Machin fai prendida midi".postln;
		}{
		{~bot[41].valueAction = 0}.defer;
		"Machin fai apagada midi".postln;
		}
		}
)};
);