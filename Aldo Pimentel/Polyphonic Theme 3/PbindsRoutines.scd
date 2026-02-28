////////////////////////////// Variables Globales /////////////////////////////

~ampp = -12;

~ampb = -12;

~amppp = 0.1;

~alarma = [false, false, false];

////////////////////////////// Plambda /////////////////////////////

// Bajo //

~get = Pbind(
	\instrument, \colchon,
	\scale, Scale.majorPentatonic,
	\root, 9,
	\degree, Ptuple([Pget(\tonica) + Prand([1, 2, 3, 4], inf), Pget(\tonica) + Prand([6, 8], inf), Pget(\tonica) + Prand([10, 12, 14], inf) ], 16),
	\dur, Prand([0.5, 1, 1.5], inf),
	\octave, 3;
);

~ostblet = Pbind(
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Plet(\tonica, pattern: Pseq([[0, 7], \rest, [0, 7], \rest, [1, 8], \rest], 4)),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\octave, 2,
	\amp, -9;
);

~alet = Pbind(
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Plet(\tonica, pattern: Pseq([[0, 7], [-1, 6], [0, 7], [1, 8]], 2)),
	\dur, Pseq([3, 1], inf),
	\legato, Pseq([3, 1], inf),
	\octave, 2,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

~blet = Pbind(
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Plet(\tonica, pattern: Pseq([\rest, [7, 14], [6, 13], \rest , [5, 12], \rest, [4, 11], [3, 10], \rest, [0, 7], \rest, 7, 3, \rest, 6, \rest, 4, 3, \rest, -1], 2)),
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5], inf),
	\legato, Pseq([0, 0.25, 0.25, 0, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5], inf),
	\octave, 2,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

~clet = Pbind(
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Plet(\tonica, pattern: Pseq([[7, 14], [6, 13], \rest, [5, 12], \rest, [4, 11], [0, 7]], 4)),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\octave, 2,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

~dlet = Pbind(
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Plet(\tonica, pattern: Pseq([0, 2, 3, 4, \rest, 6, 6, 4, 2, 0, \rest, 1], 2)),
	\dur, Pseq([0.5, 0.5, 0.5, 1, 0.5, 1], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 1, 0.5, 0.1], inf),
	\octave, 3,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

~ostb = Plambda(Ppar([~ostblet, ~get]));

a = Plambda(Ppar([~alet, ~get]));

b = Plambda(Ppar([~blet, ~get]));

c = Plambda(Ppar([~clet, ~get]));

~de = Plambda(Ppar([~dlet, ~get]));

// Impro //

~improlet = Pbind(
	\instrument, \bass,
	\scale, Scale.minor,
	\root, 9,
	\degree, Plet(\tonica, pattern: Prand([Pseq([-1, 0, -3, -2, 3, 4], 1),  Pseq([2, 3, 5, -1], 1), Pseq([-1, -3, 2, 2s, 1, -2], 1), Pseq([0, 1, 2, 4, 3, -1], 1), Pseq([7, 6s, 5, 6, 3], 1), Pseq([4, 3, 6, -1, 0s, 0], 1), Pseq([7, 6s, 6, 5s, 5, 4], 1), Pseq([-1s, 0, 0s, 1, 2, 2s, Prand([0, 1, 2, 5, 6])], 1),], inf)),
	\dur, 0.5,
	\octave, 3,
	\amp, Pfunc({~ampb});
);

~improget = Pbind(
	\instrument, \colchon,
	\scale, Scale.minor,
	\root, 9,
	\degree, Ptuple([ Pget(\tonica) + Prand([1, 2, 3], inf), Pget(\tonica) + 4, Pget(\tonica) + Prand([6, 8], inf), Pget(\tonica) + Prand([10, 12], inf) ], inf),
	\dur, Prand([0.5, 1, 1.5, 2], inf),
	\amp, Pfunc({~amppp});
);

~impro = Plambda(Ppar([~improlet, ~improget]));

////////////////////////////// Pbinds /////////////////////////////

// Piano //

~ostp = Pbind(
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0,2,4,6,8,10,12], \rest, [0,2,4,6,8,10,12], \rest, [0,2,4,6,8,10,13], \rest], 4),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\octave, 3,
	\amp, Prand([Pseq([-18], inf), Pseq([-15], inf), Pseq([-12], inf)], 1);
);

d = Pbind(
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0,2,4,6,8,10,12], [-1,1,3,6,8,10,13], \rest, [0,2,4,6,8,10,12], [1,3,5,7,8,10,12], \rest], 1),
	\dur, Pseq([3, 1, 4], inf),
	\legato, Pseq([3, 0, 0], inf),
	\octave, 3,
	\amp, Prand([Pseq([-18], inf), Pseq([-15], inf), Pseq([-12], inf)], 1);
);

e = Pbind(
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0,2,4,6,8,10,12], [-1,1,3,6,8,10,13], [0,2,4,6,8,10,12], [1,3,5,7,8,10,12]], 2),
	\dur, Pseq([3, 1], inf),
	\legato, Pseq([3, 0], inf),
	\octave, 3,
	\amp, Prand([Pseq([-18], inf), Pseq([-15], inf), Pseq([-12], inf)], 1);
);

f = Pbind(
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0,0+7,0+15], [2,2+7,2+15], [3,3+7,3+15], [4,4+7,4+15], \rest, [6,6+7,6+15], [6,6+7,6+15], [4,4+7,4+15], [2,2+7,2+15], [0,0+7,0+15], \rest, [1,1+7,1+15]], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 1, 0.5, 1], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 1, 0.5, 0.1], inf),
	\octave, 3,
	\amp, Prand([Pseq([-18], inf), Pseq([-15], inf), Pseq([-12], inf)], 1);
);

g = Pbind(
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 7, 3, 6, 4, \rest, 3, -1, \rest, \rest, 3, 4, 6, 8, \rest, 3, 6, \rest], 1),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5, 4], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\octave, 4,
	\amp, Prand([Pseq([-18], inf), Pseq([-15], inf), Pseq([-12], inf)], 1);
);

h = Pbind(
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[2,2-6], [1,1-6], \rest, [0,0-6], \rest, [-1,-1-6], [-5,-5-6], [2,2-6], [-2,-2-6], \rest, [1,1-6], \rest, [-2,-2-6], [-6,-6-6]], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\octave, 4,
	\amp, Prand([Pseq([-18], inf), Pseq([-15], inf), Pseq([-12], inf)], 1);
);

// Sax //

~osts = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([0, \rest, 0, \rest, 1, \rest], 4),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\vibA, Pseq([Pwhite(0.01, 0.02)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Pseg( Pseq([0.01, 0.05], inf), Pseq([0.05, 0.01], inf), \linear),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

i = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([6, 7, 6, \rest, 6, 7, 8, \rest], 1),
	\dur, Pseq([0.05, 2.95, 1, 4], inf),
	\legato, Pseq([0, 3, 0, 0], inf),
	\vibA, Pseq([Pwhite(0.01, 0.015)], inf),
	\filT, Prand([Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear), 0.01], inf),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

j = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([0, 2, 3, 4, \rest, 6, 6, 4, 2, 0, \rest, 1], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 1, 0.5, 1], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 1, 0.5, 0.1], inf),
	\vibA, Prand([Pwhite(0.01, 0.03), Pwhite(0.01, 0.02), Pwhite(0.01, 0.015)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Prand([Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear), 0.01], inf),
	\atk, Pwhite(0.2, 0.4),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

k = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([7, 4, 5, 3, \rest, 1, \rest, 7, 4, 5, 3, \rest, 6, \rest], 1),
	\dur, Pseq([0.5, 0.5, 0.5, 1, 0.5, 1, 4], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 1, 0.5, 0.1, 0], inf),
	\vibA, Prand([Pwhite(0.01, 0.03)], inf),
	\filT, Prand([Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear), 0.01], inf),
	\atk, Pwhite(0.2, 0.4),
	\bw, Pseq([Pwhite(2, 4)], inf),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

l = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 7, 3, 6, 4, \rest, 3, -1], 4),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\vibA, Prand([Pwhite(0.01, 0.03), 0.01], inf),
	\vibF, Prand([Pwhite(5.0, 7.0), 5], inf),
	\filT, Prand([Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear), 0.01], inf),
	\atk, Prand([Pwhite(0.2, 0.4), 0.2], inf),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

m = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 7, 3, 6, 4, \rest, 3, -1, \rest, 7, 6, 5, 4, \rest, 3, 0], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\vibA, Prand([Pwhite(0.01, 0.03), 0.01], inf),
	\vibF, Prand([Pwhite(5.0, 7.0), 5], inf),
	\filT, Prand([Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear), 0.01], inf),
	\atk, Prand([Pwhite(0.2, 0.4), 0.2], inf),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

n = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 0, 1, 2, \rest, 2, 3, 1, 2, \rest, 0, 1, 2, \rest, 2, 4, 2, 3], 2),
	\dur, Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 1], inf),
	\legato, Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 1], inf),
	\vibA, Pseq([Pwhite(0.01, 0.02)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Pseg( Pseq([0.01, 0.05], inf), Pseq([0.05, 0.01], inf), \linear),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

o = Pbind(
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([6, 7, 6, 6, 7, 8], 2),
	\dur, Pseq([0.05, 2.95, 1], inf),
	\legato, Pseq([0, 3, 0], inf),
	\vibA, Prand([Pwhite(0.01, 0.015), 0.01], inf),
	\vibF, Prand([Pwhite(5.0, 7.0), 5], inf),
	\filT, Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear),
	\atk, Prand([Pwhite(0.2, 0.4), 0.2], inf),
	\octave, 5,
	\amp, Prand([Pseq([-15], inf), Pseq([-12], inf), Pseq([-9], inf)], 1);
);

p = Pbind( //pausa
	\degree, Pseq([\rest], 4),
	\dur, Pseq([4], inf);
);

////////////////////////////// Pfsm /////////////////////////////

~cadenab = Pfsm([ // Bajo //
	#[0],
	//state 0
	Pbind( // intbb //
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, Pseq([\rest, [7, 14], [3, 10], [6, 13], [4, 11], \rest, [3, 10], [-1, 6], \rest, 3, 4, 6, 8, \rest, 3, 6], 2)], 1),
	\dur, Pseq([16, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], 4)], 1),
	\legato, Pseq([1, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], 4)], 1),
	\octave, 2,
	\amp, -9;
	),
	#[1, 2, 3],
	//state 1
	Pbind( //p
	\degree, Pseq([\rest], 4),
	\dur, Pseq([4], inf);
	),
	#[2, 3, 4, 5],
	//state 2
	Pbind( // b //
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, [7, 14], [6, 13], \rest , [5, 12], \rest, [4, 11], [3, 10], \rest, [0, 7], \rest, 7, 3, \rest, 6, \rest, 4, 3, \rest, -1], 2),
	\dur, Pseq([0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5], inf),
	\legato, Pseq([0, 0.25, 0.25, 0, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5], inf),
	\octave, 2,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[2, 3, 3, 4, 4],
	//state 3
	Pbind( // c //
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[7, 14], [6, 13], \rest, [5, 12], \rest, [4, 11], [0, 7]], 4),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\octave, 2,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[3, 4, 4],
	//state 4
	Pbind( // intbb //
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, [7, 14], [3, 10], [6, 13], [4, 11], \rest, [3, 10], [-1, 6], \rest, 3, 4, 6, 8, \rest, 3, 6], 4),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\octave, 2,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[1, 2, 3, 5, 5, 6],
	//state 5
	Pbind( // ostb //
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0, 7], \rest, [0, 7], \rest, [1, 8], \rest], 4),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\octave, 2,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[1, 2, 2, 6, 7, 7],
	//state 6
	Pbind( // a //
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0, 7], [-1, 6], [0, 7], [1, 8]], 2),
	\dur, Pseq([3, 1], inf),
	\legato, Pseq([3, 1], inf),
	\octave, 2,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[4, 5, 6, 7, 7],
	//state 7
	Pbind( // ostb //
	\instrument, \bass,
	\root, 9,
	\scale, Scale.major,
	\alarma, Pfunc{ ~alarma[0]= true;},
	\degree, Pseq([[0, 7], \rest, [0, 7], \rest, [1, 8], \rest], inf),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\octave, 2,
	\amp, Pfunc({~ampp});
	),
	#[7],
	nil, nil
]);

~cadenap = Pfsm([ // Piano //
	#[0],
	//state 0
	Pbind( // intp //
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, Pseq([\rest, [2,2-6], [-2,-2-6], [1,1-6], [-1,-1-6], \rest, [-2,-2-6], [-6,-6-6], \rest, [-2,-2-6], [-1,-1-6], [1,1-6], [3,3-6], \rest, [-2,-2-6], [1,1-6]], 3)], 1),
	\dur, Pseq([8, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], 6)], 1),
	\legato, Pseq([8, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], 6)], 1),
	\octave, 4,
	\amp, -12;
	),
	#[1, 2],
	//state 1
    Pbind( // h //
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[2,2-6], [1,1-6], \rest, [0,0-6], \rest, [-1,-1-6], [-5,-5-6], [2,2-6], [-2,-2-6], \rest, [1,1-6], \rest, [-2,-2-6], [-6,-6-6]], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\octave, 4,
	\amp, Prand([Pseq([Pfunc({~ampp - 9})], inf), Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf)], 1);
	),
	#[1, 2],
	//state 2
	Pbind( // f //
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0,0+7,0+15], [2,2+7,2+15], [3,3+7,3+15], [4,4+7,4+15], \rest, [6,6+7,6+15], [6,6+7,6+15], [4,4+7,4+15], [2,2+7,2+15], [0,0+7,0+15], \rest, [1,1+7,1+15]], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 1, 0.5, 1], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 1, 0.5, 0.1], inf),
	\octave, 3,
	\amp, Prand([Pseq([Pfunc({~ampp - 9})], inf), Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf)], 1);
	),
	#[1, 2, 4, 4],
	//state 3
    Pbind( // p //
	\degree, Pseq([\rest], 4),
	\dur, Pseq([4], inf);
	),
	#[2, 4, 5, 6],
	//state 4
	Pbind( // intp bien //
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, [2,2-6], [-2,-2-6], [1,1-6], [-1,-1-6], \rest, [-2,-2-6], [-6,-6-6], \rest, [-2,-2-6], [-1,-1-6], [1,1-6], [3,3-6], \rest, [-2,-2-6], [1,1-6]], 4),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\octave, 4,
	\amp, Prand([Pseq([Pfunc({~ampp - 9})], inf), Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf)], 1);
	),
	#[3, 5, 6, 6, 7],
	//state 5
	Pbind( // ostp //
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0,2,4,6,8,10,12], \rest, [0,2,4,6,8,10,12], \rest, [0,2,4,6,8,10,13], \rest], 4),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\octave, 3,
	\amp, Prand([Pseq([Pfunc({~ampp - 9})], inf), Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf)], 1);
	),
	#[4, 6, 7, 7],
	//state 6
	Pbind( // e //
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([[0,2,4,6,8,10,12], [-1,1,3,6,8,10,13], [0,2,4,6,8,10,12], [1,3,5,7,8,10,12]], 2),
	\dur, Pseq([3, 1], inf),
	\legato, Pseq([3, 0], inf),
	\octave, 3,
	\amp, Prand([Pseq([Pfunc({~ampp - 9})], inf), Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf)], 1);
	),
	#[1, 5, 6, 7, 7],
	//state 7
	Pbind( // ostp //
	\instrument, \piano,
	\root, 9,
	\scale, Scale.major,
	\alarma, Pfunc{ ~alarma[1]= true;},
	\degree, Pseq([[0,2,4,6,8,10,12], \rest, [0,2,4,6,8,10,12], \rest, [0,2,4,6,8,10,13], \rest], inf),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\octave, 3,
	\amp, Pfunc({~ampp - 6} );
	),
	#[7],
	nil, nil
]);

~cadenas = Pfsm([ // Saxo //
	#[0],
	//state 0
	Pbind( // ints //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 7, 3, 6, 4, \rest, 3, -1, \rest, 3, 4, 6, 8, \rest, 3, 6], 4),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\vibA, Prand([Pwhite(0.01, 0.02), Pwhite(0.01, 0.015)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Pseg(Pseq([0.01, Pwhite(0.01, 0.5)], inf), Pseq([Pwhite(0.01, 0.5), 0.01], inf), \linear),
	\atk, Pwhite(0.2, 0.4),
	\octave, 5,
	\amp, -9;
	),
	#[1, 1, 2],
	//state 1
	Pbind( // m //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 7, 3, 6, 4, \rest, 3, -1, \rest, 7, 6, 5, 4, \rest, 3, 0], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\vibA, Prand([Pwhite(0.01, 0.03), 0.01], inf),
	\vibF, Prand([Pwhite(5.0, 7.0), 5], inf),
	\filT, Prand([Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear), 0.01], inf),
	\tk, Prand([Pwhite(0.2, 0.4), 0.2], inf),
	\octave, 5,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
    ),
    #[2, 2, 3, 3, 4, 5],
	//state 2
    Pbind( // j //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([0, 2, 3, 4, \rest, 6, 6, 4, 2, 0, \rest, 1], 2),
	\dur, Pseq([0.5, 0.5, 0.5, 1, 0.5, 1], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 1, 0.5, 0.1], inf),
	\vibA, Prand([Pwhite(0.01, 0.03), Pwhite(0.01, 0.02), Pwhite(0.01, 0.015)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Prand([Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear), 0.01], inf),
	\atk, Pwhite(0.2, 0.4),
	\octave, 5,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
    ),
	#[1, 1, 2, 3, 3, 3, 4],
	//state 3
	Pbind( // n //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 0, 1, 2, \rest, 2, 3, 1, 2, \rest, 0, 1, 2, \rest, 2, 4, 2, 3], 2),
	\dur, Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 1], inf),
	\legato, Pseq([0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 1], inf),
	\vibA, Pseq([Pwhite(0.01, 0.02)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Pseg( Pseq([0.01, 0.05], inf), Pseq([0.05, 0.01], inf), \linear),
	\octave, 5,
    \amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[2, 2, 3, 5, 5, 6],
	//state 4
	Pbind( // p //
	\degree, Pseq([\rest], 4),
	\dur, Pseq([4], inf);
    ),
	#[2, 5],
	//state 5
	Pbind( // ints //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([\rest, 7, 3, 6, 4, \rest, 3, -1, \rest, 3, 4, 6, 8, \rest, 3, 6], 4),
	\dur, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\legato, Pseq([0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 1, 0.5], inf),
	\vibA, Prand([Pwhite(0.01, 0.02), Pwhite(0.01, 0.015)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Pseg(Pseq([0.01, Pwhite(0.01, 0.5)], inf), Pseq([Pwhite(0.01, 0.5), 0.01], inf), \linear),
	\atk, Pwhite(0.2, 0.4),
	\octave, 5,
    \amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[1, 2, 3, 6, 6, 7, 7],
	//state 6
	Pbind( // osts //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([0, \rest, 0, \rest, 1, \rest], 4),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\vibA, Pseq([Pwhite(0.01, 0.02)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Pseg( Pseq([0.01, 0.05], inf), Pseq([0.05, 0.01], inf), \linear),
	\octave, 5,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
    ),
	#[2, 4, 7, 8, 8],
	//state 7
	Pbind( // o //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([6, 7, 6, 6, 7, 8], 2),
	\dur, Pseq([0.05, 2.95, 1], inf),
	\legato, Pseq([0, 3, 0], inf),
	\vibA, Prand([Pwhite(0.01, 0.015), 0.01], inf),
	\vibF, Prand([Pwhite(5.0, 7.0), 5], inf),
	\filT, Pseg( Pseq([0.01, 0.4], inf), Pseq([0.4, 0.01], inf), \linear),
	\atk, Prand([Pwhite(0.2, 0.4), 0.2], inf),
	\octave, 5,
	\amp, Prand([Pseq([Pfunc({~ampp - 6})], inf), Pseq([Pfunc({~ampp - 3})], inf), Pseq([Pfunc({~ampp})], inf)], 1);
	),
	#[1, 5, 6, 8, 8],
	//state 8
	Pbind( // osts //
	\instrument, \sax,
	\root, 9,
	\scale, Scale.major,
	\degree, Pseq([0, \rest, 0, \rest, 1, \rest], inf),
	\alarma, Pfunc{ ~alarma[2]= true;},
	\dur, Pseq([1, 0.5, 0.5, 0.5, 1, 0.5], inf),
	\legato, Pseq([1.5, 0, 1, 0, 1.5, 0], inf),
	\vibA, Pseq([Pwhite(0.01, 0.02)], inf),
	\vibF, Pseq([Pwhite(5.0, 7.0)], inf),
	\filT, Pseg( Pseq([0.01, 0.05], inf), Pseq([0.05, 0.01], inf), \linear),
	\octave, 5,
	\amp, Pfunc({~ampp});
    ),
	#[8],
	nil, nil
]);

////////////////////////////// Rutinas /////////////////////////////

~final = Routine({
	var vin, zzz, impro;
	16.wait;
	vin = Synth(\vinil);
	4.wait(t);
	"último buffer".postln;
	zzz = Synth(\zzz);
	18.wait(t);
	100.do({ |i|
		zzz.set(\pR, i * (30 / 100.0) + 1.03);
		zzz.set(\tD, i * (20 / 100.0));
		~ampp = ~ampp - 0.5;
		~ritmo.set(\amp, 1 * (1 - (i / 100.0)));
		0.25.wait;
	});
	8.wait(t);
	"baja".postln;
	impro = ~impro;
	impro.play;
	100.do({ |i|
		zzz.set(\amp, 0.5 * (1 - (i / 100.0)));
		~amppp = ~amppp + 0.00095;
		0.2.wait;
	});
	~cadenab.stop;
	~cadenap.stop;
	~cadenas.stop;
	zzz.free;
	2.wait;
	30.do({ |i|
		vin.set(\amp, 0.5 * (1 - (i / 60.0)));
		0.1.wait;
	});
	"out".postln;
	26.do({
		~amppp = ~amppp - 0.00365;
		0.5.wait;
	});
	5.wait;
	impro.stop;
	vin.free;
	5.wait;
	"fin".postln;
	CmdPeriod.run;
});

~checadoruno = r { loop{
		if (~alarma[0] and: ~alarma[1]) {
		~alarma[0] = false;
		~alarma[1] = false;
		\si.postln;
		~final.play;
		~checadordos.stop;
		~checadortres.stop;
		~checadoruno.stop;
	}{\no.postln};
		0.5.wait;
}};

~checadordos = r { loop{
		if (~alarma[1] and: ~alarma[2]) {
		~alarma[1] = false;
		~alarma[2] = false;
		\si.postln;
		~final.play;
		~checadoruno.stop;
		~checadortres.stop;
		~checadordos.stop;
	}{\no.postln};
		0.5.wait;
}};

~checadortres = r { loop{
		if (~alarma[0] and: ~alarma[2]) {
		~alarma[0] = false;
		~alarma[2] = false;
		\si.postln;
		~final.play;
		~checadoruno.stop;
		~checadordos.stop;
		~checadortres.stop;
	}{\no.postln};
		0.5.wait;
}};