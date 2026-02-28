
// ===== EJECUCIÓN =====
~voces_final.play;

// RUTINA
(
Pdef.all.do({ |pdef| pdef.quant = 4;});
~voces_final = Routine({
	//Inicializo valores globales
	~ampiasi = 1.8; ~ampritmo = 2.2; ~ampvoz = 0.4; ~ampreso = 0.5; ~tempo = 1.8;

	"1 - intro".postln;
	Pdef(\iasi).play;
	8.wait;
	~ampiasi = 2.3;
	8.wait;
	Pdef(\reso_fragmentado).play;
	12.wait;

	"2 - Gestos intro".postln;
	Pdef(\gestos_I).play;
	12.wait;
	~ampvoz = 0.75;
	12.wait;

	"3 - entra ritmo".postln;
	~ampiasi = 1.8;
	~ampreso = 0.3;
	Pdef(\ritmo_base).play;
	6.wait;
	Pdef(\gestos_I).stop;
	3.wait;

	"4 - desarrollo rítmico".postln;
	~tempo = 1.4; ~ampritmo = 3.2; ~ampiasi = 2;
	Pdef(\ritmo_base).stop;
	Pdef(\ritmo_base_v1).play;
	Pdef(\ritmo_medio_v1).play;
	8.wait;
	Pdef(\ritmo_denso).play;
	4.wait;
	Pdef(\ritmo_base).play;
	Pdef(\ritmo_medio_v2).play;
	2.wait;
	Pdef(\ritmo_base_v1).stop;
	Pdef(\ritmo_medio_v1).stop;
	6.wait;

	8.do { |i|
		~tempo = i.linexp(0, 7, 1.4, 0.8);
		~ampritmo = i.linexp(0, 7, 3.2, 3.6);
		1.wait;
	};
	2.wait;

	Pdef(\reso_fragmentado).stop;
	4.wait;

	"5 - piano subito hacia desarrollo".postln;
	~ampritmo = 0.15; ~ampiasi = 0.05;
	2.wait;
	~ampritmo = 1.0; ~ampiasi = 0.4;
	2.wait;
	~ampritmo = 2.2; ~ampiasi = 1.2;
	1.wait;

	"6 - Gestos desarrollo".postln;
	~ampritmo = 3.2; ~ampiasi = 1.6; ~ampvoz = 0.3; ~ampreso = 0.5;
	Pdef(\gestos_II).play;
	Pdef(\reso_grave).play;
	1.wait;
	~ampritmo = 3.4; ~ampiasi = 2; ~ampvoz = 0.6; ~ampreso = 0.6;
	Pdef(\ritmo_denso_v1).play;
	Pdef(\ritmo_medio_v1).play;
	6.wait;
	Pdef(\ritmo_denso).stop;
	Pdef(\ritmo_base).stop;
	Pdef(\ritmo_medio_v2).stop;
	5.wait;
	~ampiasi = 1.2; ~ampvoz = 1; ~ampritmo = 2; ~ampreso = 0.8;
	Pdef(\ritmo_base_v2).play;
	Pdef(\reso_base).play;
	6.wait;

	"7 - desarrollo resos".postln;
	~ampreso = 0.9;
	Pdef(\reso_grave).stop;
	6.wait; // era 8
	Pdef(\ritmo_denso_v1).stop;
	3.wait;
	~ampvoz = 1.2; ~ampreso = 1;
	Pdef(\reso_base).stop;
	Pdef(\reso_medio).play;
	4.wait;
	Pdef(\reso_fragmentado).play;
	4.wait;
	Pdef(\reso_agudo).play;
	Pdef(\ritmo_medio_v1).stop;
	Pdef(\ritmo_base_v2).stop;
	6.wait;
	Pdef(\reso_medio).stop;
	~ampreso = 0.75;
	3.wait;
	Pdef(\reso_fragmentado).stop;
	Pdef(\reso_grave).play;
	Pdef(\gestos_III).play;
	~ampvoz = 1.4;
	4.wait;
	Pdef(\reso_denso).play;
	Pdef(\gestos_II).stop;
	4.wait;
	~ampreso = 0.85;
	4.wait;
	Pdef(\iasi).stop;
	4.wait;

	"8 - climax".postln;
	~ampreso = 0.8; ~ampvoz = 1.6;
	Pdef(\reso_agudo).stop;
	Pdef(\reso_grave).stop;
	Pdef(\ritmo_base_v1).play;
	Pdef(\ritmo_medio).play;
	Pdef(\ritmo_denso_v2).play;
	Pdef(\reso_fragmentado).play;
	~ampritmo = 1.6; ~tempo = 0.7;
	6.wait;
	~ampreso = 0.9;
	Pdef(\reso_denso).play;
	4.wait;
	Pdef(\reso_total).play;
	4.wait;
	Pdef(\reso_denso).stop;
	Pdef(\ritmo_base).play;
	Pdef(\ritmo_base_v1).stop;
	Pdef(\reso_base).play;
	8.wait;
	Pdef(\reso_fragmentado).stop;
	Pdef(\ritmo_medio).stop;

	6.do { |i|
		~ampreso = i.linexp(0, 5, 0.9, 0.7);
		~ampritmo = i.linexp(0, 5, 1.6, 1.9);
		~ampvoz = i.linexp(0, 5, 1.6, 1.0);
		~tempo = i.linexp(0, 5, 0.7, 0.7);
		1.wait;
	};
	8.wait;

	"9 - Calma hacia final".postln;
	Pdef(\ritmo_denso).stop;
	Pdef(\ritmo_denso_v1).stop;
	Pdef(\ritmo_denso_v2).stop;

	12.do { |i|
		~ampritmo = i.linexp(0, 11, 1.6, 0.7);
		~tempo = i.linexp(0, 11, 0.7, 1.3);
		1.wait;
	};
	3.wait;
	Pdef(\ritmo_base_v1).play;
	6.wait;

	"10 - FINAL".postln;
	6.do { |i|
		~ampritmo = i.linexp(0, 5, 0.7, 0.9);
		~tempo = i.linexp(0, 5, 1.3, 1.5);
		~ampvoz = i.linexp(0, 5, 1.0, 0.3);
		1.wait;
	};
	4.wait;
	Pdef(\ritmo_base_v1).stop;
	~ampreso = 0.9;
	3.wait;

	6.do { |i|
		~ampreso = i.linexp(0, 5, 0.9, 0.0);
		~ampritmo = i.linexp(0, 5, 0.9, 0.0);
		~ampvoz = i.linexp(0, 5, 0.3, 0.05);
		1.wait;
	};
	4.wait; // AJUSTADO: era 8
	Pdef(\ritmo_base).stop;
	Pdef(\reso_total).stop;
	Pdef(\gestos_III).stop;
	3.wait;

	"FIN".postln;
});
)
