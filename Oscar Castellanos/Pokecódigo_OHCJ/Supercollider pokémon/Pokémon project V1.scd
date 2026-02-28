
//Primero es necesario cargar los códigos que contienen todos los instrumentos, pokémones y secuencias.

"SynthDefsP V1.scd".loadRelative;
"Synths Pdef V1.scd".loadRelative;

//Pokellider

//Primero es necesario cargar la secuencia
(
~rolita = Pfsm([
	#[0],
	~intro = Ptpar([0, ~melodia.finDur(80), 8, ~acordes.finDur(48), 16, ~bajo.finDur(64)], 1),
	#[1],
	~nivelmelodia = Ptpar([0, Pdef(\nivel)], 1),
	#[2],
	~defensita = Ptpar([0, Pdef(\defensa2).finDur(80), 16, Pdef(\defensa3).finDur(64), 8, Pdef(\defensa4).finDur(50)], 1),
	#[3],
	~nivelmelodia = Ptpar([0, Pdef(\nivel)], 1),
	#[4],
	~ataquito = Ptpar([0, Pdef(\ataque).finDur(72), 16, Pdef(\ataque2).finDur(64), 8, Pdef(\ataque3).finDur(40)], 1),
	#[5],
	~nivelmelodia = Ptpar([0, Pdef(\nivel)], 1),
	#[6],
	~velocito = Ptpar([0, Pdef(\speed).finDur(80), 8, Pdef(\speed2).finDur(64), 16, Pdef(\speed3).finDur(48)], 1),
	#[7],
	~final = Ptpar([0, ~melodiafinal.finDur(94), 8, ~acordesfinal.finDur(72), 16, ~bajofinal.finDur(72)], 1),
	#[8],
	~finalfinal = Ptpar([0, ~acordesfinal.finDur(4)],1),
	#[9],
	nil, nil
]);
)

//Con los siguientes comandos se le puede poner play y stop a la pieza.

~rolitaplayer = ~rolita.play;
~rolitaplayer.stop;


//Los Pdefs de cada pokemon estan hechos y pensados para sonar durante la parte de nivel, entre cada melodía hay un Pdef que se llama \nivel, durante su reproducción se planea que suenen al azar 2 de los Pdefs de pokemones para simular un pequeño combate melódico/simbólico entre pokemones y darle profundiad y vida al sintetizador de nivel.

Pdef(\Jolteon).play
Pdef(\Jolteon).stop

Pdef(\Aron).play
Pdef(\Aron).stop

Pdef(\Charizard).play
Pdef(\Charizard).stop

Pdef(\Kadabra).play
Pdef(\Kadabra).stop

Pdef(\Bulbasaur).play
Pdef(\Bulbasaur).stop

Pdef(\Warturtle).play
Pdef(\Warturtle).stop

Pdef(\Gyarados).play
Pdef(\Gyarados).stop

Pdef(\Combusken).play
Pdef(\Combusken).stop

//Lo siguiente es para poder probar los Pdefs y melodías que utilizo

Pdef(\defensa).play
Pdef(\defensa).stop

Pdef(\defensa2).play
Pdef(\defensa2).stop

Pdef(\defensa3).play
Pdef(\defensa3).stop

Pdef(\defensa4).play
Pdef(\defensa4).stop

Pdef(\nivel).play
Pdef(\nivel).play

Pdef(\ataque).play
Pdef(\ataque).stop

Pdef(\ataque2).play
Pdef(\ataque2).stop

Pdef(\ataque3).play
Pdef(\ataque3).stop

Pdef(\speed).play
Pdef(\speed).stop

Pdef(\speed2).play
Pdef(\speed2).stop

Pdef(\speed3).play
Pdef(\speed3).stop



~introplayer = ~intro.play
~introplayer.stop

~introchopplay = ~introchop.play
~introchopplay.stop

~defensitaplayer = ~defensita.play
~defensitaplayer.stop

~velocitoplayer = ~velocito.play
~velocitoplayer.stop

~ataquitoplayer = ~ataquito.play
~ataquitoplayer.stop

~finalplayer = ~final.play
~finalplayer.stop

~sampi.finDur(5).play
~finalfinal.play




