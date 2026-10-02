////////////////////////////////////OSCCES//////////////////////////////////////////
OSCdef(\stack, {arg msg, time;
	var id;
	id=msg[2];
	if(id==0){
		~chest = ~chest.add(time);}
}, \tr, s.addr);

OSCdef(\pit, {arg msg;
	var id;
	id=msg[2];
	if(id== 1){~actual=msg[3]}{};
},\tr, s.addr);
OSCdef(\deTec, {arg msg;
	var ampli,port;
	port=msg[2];
	if(port == 2){
	ampli = msg[3];
	 if (~flag) {
	 	if ( ampli > ~umbral) {
	 		(Process.elapsedTime - ~tiempo).postln;
	 		if ( (Process.elapsedTime - ~tiempo) > ~umbralT) {
	 			\victoria.postln;
					~altura = ~actual;
					while{~altura> ~max} { ~altura = ~altura / 2};
					while{~altura< ~min} { ~altura = ~altura * 2};
				x=Synth(\rovoxis, [\freq, ~altura, \temp, rrand(30,40)]);
	 			~flag = false;
	 			~tiempo = 0;
			};
	 	}{~flag = false; ~tiempo = 0};
	 };
	 if ((ampli > ~umbral) and: ~flag.not) {
	 	~flag = true;
	 	~tiempo = Process.elapsedTime;
	};}
}, \tr, s.addr);

OSCdef(\conciencia, {arg msg;
	var id;
	id=msg[2];
	if((id==3)){~bandido=true;}{};
	if(~bandido&&~bandera){
		"YIYPI".postln;
		Synth(\hiphop, [\bfn, ~oido]);}{"nelpas".postln};
},\tr, s.addr);
OSCdef(\conciencia).disable;
OSCdef(\deTec).disable;
