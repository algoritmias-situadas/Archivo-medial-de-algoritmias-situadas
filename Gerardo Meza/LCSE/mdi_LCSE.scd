MIDIClient.init;
MIDIIn.connectAll;

///mapeo del controlador y escalamiento de valores
~controladormidi = MIDIdef.cc(\faders, {|val, cnum|
	//[\cntl, cnum, val].postln;
	switch(cnum,
		49, {~position[0] = val.linlin(0,127,0.0,2.0)},
		50, {~position[1] = val.linlin(0,127,0.0,2.0)},
		51, {~position[2] = val.linlin(0,127,0.0,2.0)},
		52, {~position[3] = val.linlin(0,127,0.0,2.0)},
		53, {~position[4] = val.linlin(0,127,0.0,2.0)},
		54, {~position[5] = val.linlin(0,127,0.0,2.0)},

		29, {~rotacion[0]  = val.linlin(0,127,0.0,2.0)},
		30, {~rotacion[1]  = val.linlin(0,127,0.0,2.0)},
		31, {~rotacion[2]  = val.linlin(0,127,0.0,2.0)},
		32, {~rotacion[3]  = val.linlin(0,127,0.0,2.0)},
		33, {~rotacion[4]  = val.linlin(0,127,0.0,2.0)},
		34, {~rotacion [5] = val.linlin(0,127,0.0,2.0)},

		13, {~gSize[0]  = val.linlin(0,127,0.0,4.0)},
		14, {~gSize[1] = val.linlin(0,127,0.0,4.0)},
		15, {~gSize[2]  = val.linlin(0,127,0.0,4.0)},
		16, {~gSize[3]  = val.linlin(0,127,0.0,4.0)},
		17, {~gSize[4]  = val.linlin(0,127,0.0,4.0)},
		18, {~gSize[5]   = val.linlin(0,127,0.0,4.0)},

		77, {~ampInter[0] = val.linlin(0,127,0.0,1.0)},
		78, {~ampInter[1] = val.linlin(0,127,0.0,1.0)},
		79, {~ampInter[2] = val.linlin(0,127,0.0,1.0)},
		80, {~ampInter[3] = val.linlin(0,127,0.0,1.0)},
		81, {~ampInter[4] = val.linlin(0,127,0.0,1.0)},
		82, {~ampInter[5] = val.linlin(0,127,0.0,1.0)},
		83, {~ampInter[6] = val.linlin(0,127,0.0,1.0)},
		84, {~ampInter[7] = val.linlin(0,127,0.0,1.0)},

		104,{ if (val == 127) {~mod = ~mod + 1}};
		105,{ if (val == 127) {~mod = ~mod - 1}};


		//81,{~panVel = val.linlin(0,127,10,100)}
	);
}).permanent = true;




~controladormidi2 = MIDIdef.noteOn(\botones, {|val, cnum|
	//[\cntl, cnum, val].postln;
	///solo está mapeada la primera fila
	switch(cnum,
		41, { if (val == 127) { {z.boton2[0].valueAction = z.boton2[0].value.switch(0,1,1,0)}.defer}},
		42, { if (val == 127) { {z.boton2[1].valueAction = z.boton2[1].value.switch(0,1,1,0)}.defer}},
		43, { if (val == 127) { {z.boton2[2].valueAction = z.boton2[2].value.switch(0,1,1,0)}.defer}},
		44, { if (val == 127) { {z.boton2[3].valueAction = z.boton2[3].value.switch(0,1,1,0)}.defer}},
		57, { if (val == 127) { {z.boton2[4].valueAction = z.boton2[4].value.switch(0,1,1,0)}.defer}},
		58, { if (val == 127) { {z.boton2[5].valueAction = z.boton2[5].value.switch(0,1,1,0)}.defer}},
		59, { if (val == 127) { {z.boton2[6].valueAction = z.boton2[6].value.switch(0,1,1,0)}.defer}},
		60, { if (val == 127) { {z.boton2[7].valueAction = z.boton2[7].value.switch(0,1,1,0)}.defer}},

		73, { if (val == 127) { {z.boton3[0].valueAction = z.boton3[0].value.switch(0,1,1,0)}.defer}},
		74, { if (val == 127) { {z.boton3[1].valueAction = z.boton3[1].value.switch(0,1,1,0)}.defer}},
		75, { if (val == 127) { {z.boton3[2].valueAction = z.boton3[2].value.switch(0,1,1,0)}.defer}},
		76, { if (val == 127) { {z.boton3[3].valueAction = z.boton3[3].value.switch(0,1,1,0)}.defer}},
		89, { if (val == 127) { {z.boton3[4].valueAction = z.boton3[4].value.switch(0,1,1,0)}.defer}},
		90, { if (val == 127) { {z.boton3[5].valueAction = z.boton3[5].value.switch(0,1,1,0)}.defer}},
		91, { if (val == 127) { {z.boton3[6].valueAction = z.boton3[6].value.switch(0,1,1,0)}.defer}},
		92, { if (val == 127) { {z.boton3[7].valueAction = z.boton3[7].value.switch(0,1,1,0)}.defer}},



		105, { if (val == 127){{z.boton[0].valueAction = z.boton[0].value + 1}.defer}}


		//81,{~panVel = val.linlin(0,127,10,100)}
	);
}).permanent = true;