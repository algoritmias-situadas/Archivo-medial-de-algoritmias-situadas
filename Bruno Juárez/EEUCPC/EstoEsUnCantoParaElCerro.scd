//VARIABLES GLOBALES ANTES DE INCIAR//
(
~path = thisProcess.nowExecutingPath.dirname;
~pressed = false;
~bocinas= 2;
~chest = [];
~dur =Array.newClear(4);
~ano=Buffer.alloc(s, s.sampleRate*5, 1);
~buff=Buffer.alloc(s, s.sampleRate*5);
~oido=Buffer.alloc(s, 4*s.sampleRate,1);
~depto=Array.newClear(10);
~bandido=false;
~bandera=false;
~flag = false;
~umbral = -26.dbamp;
~umbralT = 1;
~tiempo = 0;
~actual=440;
~palabrastrabadas= "resiste, resiste, resiste, resiste, cerro, resiste, somos como los cerros resistentes, porque solo no muevo un edificio, pero unidos lo tiramos a la verga. ¿Me puedes escuchar?¿Me puedes oir? No nos puedes ignorar. Te enfada tiktok y no volteas a ver la puta calle, donar al mundo es lo mismo que ver por si mismo, te quejas de que te venden humo y te fumas un puro. No nos puedes dejar de escuchar porque somos resistencia. ¿Crees que puedes callarme? Estas voces están amplificadas por la palabra, por que decimos la palabra autentica, te digo mentiras!";
~palabrastrabadas.vocales;
~palabrastrabadas.formantes;
~min = 130.812;
~max = 660;

~in1=1;
)
//AMIGXSRELATIVXS//
"SYNTHDEFS.scd".loadRelative;

"OSCesss.scd".loadRelative;
"GUIZzz.scd".loadRelative;
//PRIMEROS PASOS///
~puerta=Synth(\mix, [\out,0, \fue,0]);
~metrin=r{
	inf.do{arg i;
		Synth(\metro, [\buf, nil,\amp, 0.8, \rat, 1.25, \gato, 1]);
		0.5.wait;
		7.do{
		Synth(\metro, [\buf, nil,\amp, 0.5, \rat, 1]);
			rrand(0.5, 2).wait;
		}
}};
~arranq=r{
	2.wait;
	Synth(\rapeo, [\bnf, ~oido]);
	4.wait;
	~bandera=true;
	~bit.valueAction_(0);
};

~ventanas[1].front;
