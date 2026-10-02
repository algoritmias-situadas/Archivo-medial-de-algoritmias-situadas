~sl = Array.newClear(4);
~txt = Array.newClear(4);
~ventanas=Array.newClear(5);
~puertos=Array.newClear(5);

~ventanas[0]=Window(\RESISTE,Rect(496.0, 338.0, 498.0, 360.0));
~ventanas[1]=Window(\wintres, Rect(496.0, 425.0, 498.0, 273.0));
~ventanas[2]=Window(\winx4, Rect(496.0, 425.0, 498.0, 273.0));
~ventanas[3]=Window(\win, Rect(496.0, 425.0, 498.0, 273.0));
~ventanas[4]=Window(\winar, Rect(496.0, 425.0, 498.0, 273.0));

~puertos[0] = ~ventanas[0].addFlowLayout(10@10, 20@5);
~puertos[1] = ~ventanas[1].addFlowLayout(10@10, 20@5);
~puertos[2] = ~ventanas[2].addFlowLayout(100@100, 40@10);
~puertos[3] = ~ventanas[3].addFlowLayout(100@100, 40@10);
~puertos[4] = ~ventanas[4].addFlowLayout(100@100, 40@10);

~onn = Button(~ventanas[0], 100@70).states_([
	["no ti oigo", Color.white, Color.red ],
	["te oigo", Color.white, Color.green]
]);
~onf= Button (~ventanas[0], Rect(0, 0, 50, 50)).states_([
	["off", Color.black, Color.white],
	["on!", Color.black, Color.grey]]);
~sli =Slider(~ventanas[0], 200@30);
~tex =StaticText(~ventanas[0], 40@25);
~tex.string = "db";
~puertos[0].nextLine;

~oner = Button(~ventanas[0], 100@70).states_([
	["no escucho", Color.white, Color.red ],
	["t escucho", Color.white, Color.green]]);
~oni= Button (~ventanas[0], Rect(0, 0, 50, 50)).states_([
	["off", Color.black, Color.white],
	["on!", Color.black, Color.grey]]);

~sli1 =Slider(~ventanas[0], 200@30);
~tex1 =StaticText(~ventanas[0], 40@25);
~tex1.string = "db";
~puertos[0].nextLine;

~sensi=Slider(~ventanas[0], 30@100);
~tec2=StaticText(~ventanas[0], 75@25);
~tec2.string="multiplicador";
~tec3=StaticText(~ventanas[0], 75@25);

~cual=Button(~ventanas[0], 50@50).states_([
	["0", Color.black, Color.gray],
	["1", Color.black, Color.gray]]);
~next=Button(~ventanas[0], 50@50).states_([
	["--->", Color.white, Color.gray],
	[":o", Color.white, Color.red]]);

//////ACCIONESV1////////////////////////////////////////////////////////////////////////////////////////////////////////
~xd=ControlSpec(0.1, 1.9, 'lin', 0.0, 0);
/////////////////////////////////////////////////////////////////////////////////////////////////
~next.action={|c| if(c.value==1)
	{~cambiador=r{
		"adios".postln;
		1.wait;
		~ventanas[0].close;
		~ventanas[3].front;
		1.wait;
		"vas".postln;
}.play(AppClock);}{ "nada"}};
~cual.action={|a| if(a.value == 1, {~puerta.set(\fue, 1)},{~puerta.set(\fue, 0)})};
~sensi.action={|a| ~th=~xd.map(a.value);
	~tec3.string= ~th.round(0.01)};
~onf.action= {|a| if(a.value== 1, {
	~sin=Synth(\pulso);
	~ev=Synth(\chanel, [\trg, 1]);},{
	Routine{
		~ev.set(\trg, 0);
		30.wait;
		~ap.stop;
}.play;})};
~oni.action= {|a| if(a.value== 1, {
	~evl=Synth(\chanel1, [\trg, 1]);},{
	Routine{
		~evl.set(\trg, 0);
		30.wait;
		~rep.stop;
 }.play;})};
~sli1.action = {|w| ~val1=~dbm.map(w.value);
	~tex1.string = ~val1.round(0.01)+"db";};
~sli.action = {|w| ~val=~dbm.map(w.value);
	~tex.string = ~val.round(0.01)+"db";};
~onn.action = {|b| if (b.value == 1){
	Routine{
		1.do{
			~onf.valueAction_(1);
		~gym=Routine{
				1.do{|v|
		~dur[v]=[];
		1.wait;
		\vas.postln;
		OSCdef(\stack).enable;
		8.wait;
		\queda.postln;
		OSCdef(\stack).disable;
		0.05.wait;
		~dur[v]= ~chest.differentiate[1..];
		0.1.wait;
		if(~dur[v].isEmpty){~dur[v]=1;}{
		~bata= Pbind(\instrument, \formantes,
	\dur, Pseq(~dur[v][1..],inf),
	\midinote, 60,

	\freq1, Pseq(~palabrastrabadas.formantesf("bajo")[0],inf),
	\freq2, Pseq(~palabrastrabadas.formantesf("bajo")[1],inf),
	\freq3, Pseq(~palabrastrabadas.formantesf("bajo")[2],inf),
	\freq4, Pseq(~palabrastrabadas.formantesf("bajo")[3],inf),
	\freq5, Pseq(~palabrastrabadas.formantesf("bajo")[4],inf),

	\amp1, Pseq(~palabrastrabadas.formantesa("bajo")[0],inf),
	\amp2, Pseq(~palabrastrabadas.formantesa("bajo")[1],inf),
	\amp3, Pseq(~palabrastrabadas.formantesa("bajo")[2],inf),
	\amp4, Pseq(~palabrastrabadas.formantesa("bajo")[3],inf),
	\amp5, Pseq(~palabrastrabadas.formantesa("bajo")[4],inf),

	\rq1, Pseq(~palabrastrabadas.formantesr("bajo")[0],inf),
	\rq2, Pseq(~palabrastrabadas.formantesr("bajo")[1],inf),
	\rq3, Pseq(~palabrastrabadas.formantesr("bajo")[2],inf),
	\rq4, Pseq(~palabrastrabadas.formantesr("bajo")[3],inf),
	\rq5, Pseq(~palabrastrabadas.formantesr("bajo")[4],inf),

							\amp, 1-Pfunc{~val}.dbamp);
		~ap=~bata.play;
						1.wait;}}}.play;
		15.wait;
		~onn.valueAction_(0);
			10.wait;}}.play(AppClock);}
	{}};
~oner.action = {|b| if (b.value == 1)
	{
		Routine{1.do{
			~oni.valueAction_(1);
		~ruitinaa=r{
		1.do{|n|
		~play=Synth(\recorder, [\in, 0, \bfn,  ~ano]);
		\vasbb.postln;
		5.wait;
		\yaestuvo.postln;
		~play.free;
		~depto[n]=~ano;
		0.1.wait;
		~plai=Pmono(\granulito,
						\freq,Pwrand([440, 440/2, 440*3/2]*2, [1, 1/2, 1/3].normalizeSum,inf), /*asdfasdf*/
						\pan,Pwhite(-1.0,1.0, inf),
						\out, 48,
						\bfn, ~ano,
						\in, 0,
						\rt, Pwhite(1.0, 2.0, inf),
						\ini, Pwhite(0.0, 5.0, inf),
						\dgr, Pkey(\freq)/880,
						\ampi, 1-Pfunc({~th}).dbamp,
						\amp, -6.dbamp
					);
		~rep=~plai.play;
		}}.play;
			7.wait;
			~oner.valueAction_(0);
		}}.play(AppClock);
	}
	{
	}
};

////GUI2////////////////////////////////////////////////////////////////////////////////
~encen = Button(~ventanas[1], 100@70).states_([
	["apagado", Color.white, Color.gray ],
	["encendido", Color.white, Color.red]
]);
~sl[3] =Slider(~ventanas[1], 150@30);
~txt[3]=StaticText(~ventanas[1], 150@25);
~puertos[1].nextLine;
~sl[0] =Slider(~ventanas[1], 300@30);
~txt[0]=StaticText(~ventanas[1], 150@25);
~sl[1] =Slider(~ventanas[1], 300@30);
~txt[1]=StaticText(~ventanas[1], 150@25);
~txt[2]=StaticText(~ventanas[1], 150@25);
~puertos[1].nextLine;

~txt.do{|x| x.font = Font("Georgia", 20) };
~txt[0].string = "Paneo";
~txt[1].string= "Ratio de Altura";
~txt[2].string= "TimeDis";
~txt[3].string = "¿cuál quieres?";

~puertos[1].nextLine;

~botin = Button(~ventanas[1], Rect(10, 170, 50, 50));
~botin.states = [["1/2"],["3/2"],["5/4"]];
~txtin = StaticText(~ventanas[1], Rect(70, 170, 100, 50));
~txtin.string = "fraccion(ando)";
~next1=Button(~ventanas[1], 50@50).states_([
	["--->", Color.white, Color.gray],
	[":o", Color.white, Color.red]]);
////////////SPECS////////////////////////////////////////
~fpanm = ControlSpec(0.1, 100, 'lin', 0.0, 0, "Hz");
~pRm = ControlSpec(0.0,4.0, 'lin', 0.0, 0);
~tDm = ControlSpec(0.0,1.0, 'lin', 0.0, 0, "s");
~cqam = ControlSpec(0.0, 1.0, 'lin',0.0);
////////////////////ACCIONV2////////////////////////
~encen.action = {|b| if (b.value == 1)
	{
		~re=~pem.play;
	}{
		~re.stop;
}
};
~next1.action={|c| if(c.value==1)
	{r{
		"adios".postln;
		1.wait;
		~ventanas[1].close;
		~ventanas[2].front;
		1.wait;
		"vas".postln;
}.play(AppClock);}{ "nada"}};
~sl[0].action = {|d| ~fpanv = ~fpanm.map(d.value);
	~txt[0].string = ~fpanv.round(0.1) + "Hz, pan";
};
~sl[1].action = {|d|  ~pRv = ~pRm.map(d.value);
	~txt[1].string = ~pRv.round(0.1)  + "pR";
};

~sl[3].action = {|d| ~cqav = d.value.postln; };

~fracT = 0;
~botin.action= {arg b;
	~fracT = switch(b.value,
		0, {1/2},
		1, {3/2},
		2, {5/4}
	);
};

/////////////GUI3/////////////////////////////////////////////////////////
~tercer=Button(~ventanas[2], 150@150).states_([
	["nonoido", Color.white, Color.gray ],
	["oidoencendido", Color.white, Color.red]]
);
~cuarto=Button(~ventanas[2], 80@80).states_([
	["--->", Color.white, Color.black],
	[":o", Color.black, Color.white]]);

~cuarto.action= { arg v; if(v.value==1){
	~ventanas[2].close;
	~ventanas[0].front;}{}};

~tercer.action= {|d| if(d.value==1, {
~ruot=r{
	1.do{
		\vas.postln;
		0.5.wait;
		~ax=Synth(\escucho, [\in,~in2, \bfn,~buff]);
		4.8.wait;
		\para.postln;
		0.2.wait;
		~ax.free;
		~plei=Synth(\reprodusco, [\out, 0, \bfn, ~buff, \vel, 1, \trg, 1, \ini, 0, \mxdt, 1, \dt, 0.5, \dct, 100, \pos, 1]);
	0.1.wait;
			~tercer.valueAction_(0);}}.play(AppClock);
},{~plei.set(\trg, 0);})};
// Variables globales
~omnibot=Array.newClear(5);
~omnibot[0] = Button(~ventanas[0], Rect(20, 20, 160, 40));
~omnibot[1] = Button(~ventanas[1], Rect(20, 20, 160, 40));
~omnibot[2] = Button(~ventanas[2], Rect(20, 20, 160, 40));
~omnibot[3] = Button(~ventanas[3], Rect(20, 20, 160, 40));
~omnibot[4]= Button(~ventanas[4], Rect(20, 20, 160, 40));


///////////////GUI4/////////////////////
~butan=Button(~ventanas[3], 50@50).states_([["off", Color.black],["onn", Color.red]]);
~sigueme=Button(~ventanas[3], 50@50).states_([["--->",Color.white, Color.gray],[":O", Color.white, Color.red]]);
/////ACCIONES V4////
~butan.action= {|d|if(d.value==1){
	~apex=Synth(\detecta);
	~apix=Synth(\pitchero);
	OSCdef(\pitchero).enable;
	OSCdef(\deTec).enable;
	"rapido!".postln;
}{
	OSCdef(\pitchero).disable;
	OSCdef(\deTec).disable;
	~apex=Synth(\detecta);
	~apix=Synth(\pitchero);
}};
~sigueme.action={|x| if(x.value==1)
	{~cambiador=r{
		"adios".postln;
		1.wait;
		~ventanas[3].close;
		~ventanas[4].front;
		1.wait;
		"vas".postln;
}.play(AppClock);}{ "nada"}};
////////////////GUI5////////////
~bit=Button(~ventanas[4], 100@50).states_([
	["sordo", Color.black, Color.white],
	["oigo", Color.black, Color.grey]]);
~bet=Button(~ventanas[4], 100@50).states_([
	["metrin", Color.black, Color.white],
	["sinmetrin", Color.black, Color.grey]]);
/////////ACCIONES V5//////
~bit.action={arg i;
	if(i.value==1,
		{OSCdef(\conciencia).enable;
		~arranq.play(AppClock);
	},{});
};
~bet.action={arg i;
	if(i.value==1,
		{~metrin.play;"simón".postln;~bit.valueAction_(1);},{});
};
// Función global para actualizar los botones
~updateButtons = {
    if (~pressed) {
        ~omnibot[0].states_([["Apagar", Color.white, Color.green]]);
        ~omnibot[1].states_([["Apagar", Color.white, Color.green]]);
		~omnibot[2].states_([["Apagar", Color.white, Color.green]]);
		~omnibot[3].states_([["Apagar", Color.white, Color.green]]);
		~omnibot[4].states_([["Apagar", Color.white, Color.green]]);
    } {
		~omnibot[0].states_([["Prender", Color.black, Color.gray]]);
        ~omnibot[1].states_([["Prender", Color.black, Color.gray]]);
		~omnibot[2].states_([["Prender", Color.black, Color.gray]]);
		~omnibot[3].states_([["Prender", Color.black, Color.gray]]);
		~omnibot[4].states_([["Prender", Color.black, Color.gray]]);
    };
};

// OMNIBOTON
~cnt=0.1;
MIDIdef.cc(\control, {
    |val|
    ~cnt = val.linlin(0, 127, 0.01, 4);
},ccNum: 0);

~playStop = {
    if (~pressed) {
		~vox=Synth(\natura, [\trg, 1,\mul, ~cnt]);
    } {
		~vox.set(\trg, 0);
        };
    };

~omnibot[0].action_({
    ~pressed = ~pressed.not;
    ~playStop.();
    ~updateButtons.();
});

~omnibot[1].action_({
    ~pressed = ~pressed.not;
    ~playStop.();
    ~updateButtons.();
});
~omnibot[2].action_({
    ~pressed = ~pressed.not;
    ~playStop.();
    ~updateButtons.();
});
~omnibot[3].action_({
    ~pressed = ~pressed.not;
    ~playStop.();
    ~updateButtons.();
});
~omnibot[4].action_({
    ~pressed = ~pressed.not;
    ~playStop.();
    ~updateButtons.();
});