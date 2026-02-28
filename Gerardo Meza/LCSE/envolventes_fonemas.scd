~folder1 = PathName("/Users/mezaga93/Downloads/LCSE/CSV/");
~csvS = [];
~num = 1;  /// 0 amps, 1= fund, 2 = f1, 3 = f2, 4= f3, 5 = f4;
//~csvS.cs;
(
~folder1.entries.do({
	arg path;
	~csvS= ~csvS.add(CSVFileReader.read(path.fullPath));
});
);

//Quarks.gui;
~todasListas= ~csvS.collect({|i| i.flop});
~a = ~todasListas.flatten2(1);
~a.size;
~a.do({|i| i.postln; });
//~a = a.flop;
~a.size.do({|i| w = ~a[i].removeAllSuchThat({|i| i == ""})});
~a = ~a.asFloat;
~env = 6.collect{|i| Array.series(~a.size/6, i, 6)}.asInteger;
//6.do{|i| i.postln};
~env[2].cs;
~amplitudesF = ~env[0].collect({|i , index| ~a[i]});
~fundF= ~env[1].collect({|i , index| ~a[i]});
~f1= ~env[2].collect({|i , index| ~a[i]});
~f2= ~env[3].collect({|i , index| ~a[i]});
~f3= ~env[4].collect({|i , index| ~a[i]});
~f4= ~env[5].collect({|i , index| ~a[i]});

//~fundF[1].plot;

//ya aquí podríamos plotear todo lo de frecuencia
// ~b[1].plot;
//paranormalizar la env y que no haga clicks
~amps = ~amplitudesF.collect({|i| var num;
	num = i[3..].normalize(0, 1);
	num = num.put(0,0);
	num = num ++ num.minItem;
});

//~fundF.size;
//~amps[0].plot;
//~freq.plot;

//// hacerlos envolventes

~envolventesAmps = ~amps.size.collect{|i| i = Buffer.sendCollection(s,~amps[i], 1)};

//~envolventesAmps[0].plot;
//~f1[0].plot;
