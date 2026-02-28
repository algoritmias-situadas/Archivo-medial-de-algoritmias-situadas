//Secuencias burbujosas (columna 1)
~highBubbles = Pmono(\bubbles,
	\freq, Pwhite(0.4, 22*4), //densidad- número de puntos por segundo
	\dur, Pwhite(3.5,7), //duración de cada cambio de parámetros
	\amp, -3.dbamp,
	\att, Pwhite(5.1,11), //tiempo de entrada de la textura
	\rel, Pwhite(5.1,11), //tiempo de salida de la textura
	\lag, Pwhite(0.7, 2), //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4000), //límite agudo del filtro
	\cutofflow, Pwhite(800, 1600), //límite grave del filtro
	\timefilt, Pwhite(9, 93), //tiempo del filtro rápido (variación discontinua en la altura)
	//\timefilt, Pwhite(0.7, 7.0), //tiempo del filtro lento (variación continua en la altura)
	\rq, Pwhite(0.05, 0.11), //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.19, 0.31), //resonancia del filtro amplia (poca definición)
	\mix, Pwhite(0.05,0.65), //espacio (nivel del reverb)
	\room, Pwhite(0.05,0.65), //espacio (tamaño del espacio)
	\timepan, Pwhite(0.38, 0.53), //tiempo de paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1), //apertura derecha
);

~midBubbles = Pmono(\bubbles,
	\freq, Pwhite(0.3, 14*4), //densidad- número de puntos por segundo
	\dur, Pwhite(2.0, 9),  //duración de cada cambio de parámetros
	\amp, -3.dbamp,
	\att, Pwhite(0.1,3), //tiempo de entrada de la textura
	\rel, Pwhite(5.1,11), //tiempo de salida de la textura
	\lag, Pwhite(0.7, 2),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(1200, 2400), //límite agudo del filtro
	\cutofflow, Pwhite(400, 800),  //límite grave del filtro
	//\timefilt, Pwhite(8, 93),  //tiempo del filtro rápido (variación discontinua en la altura)
	\timefilt, Pwhite(0.4, 0.6), //tiempo del filtro lento (variación continua en la altura)
	\rq, Pwhite(0.05, 0.23), //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.33, 0.46),  //resonancia del filtro amplia (poca definición)
	\mix, Pwhite(0.05,0.65),  //espacio (nivel del reverb)
	\room, Pwhite(0.05,0.65), //espacio (tamaño del espacio)
	\timepan, Pwhite(0.24, 0.37), //tiempo de paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
);

~bassBubbles = Pmono(\bubbles,
	\freq, Pwhite(0.2, 8*4), //densidad- número de puntos por segundo
	\dur, Pwhite(4.9,11),  //duración de cada cambio de parámetros
	\amp, -3.dbamp,
	\att, Pwhite(0.1,3), //tiempo de entrada de la textura
	\rel, Pwhite(0.1,5),  //tiempo de salida de la textura
	\lag, Pwhite(0.7, 3),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(800, 1100), //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	\timefilt, Pwhite(7, 93), //tiempo del filtro rápido (variación discontinua en la altura)
	//\timefilt, Pwhite(0.1, 0.3), //tiempo del filtro lento (variación continua en la altura)
	\rq, Pwhite(0.05, 0.13), //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.41, 0.59),  //resonancia del filtro amplia (poca definición de altura)
	\mix, Pwhite(0.05,0.65),  //espacio (nivel del reverb)
	\room, Pwhite(0.05,0.65), //espacio (tamaño del espacio)
	\timepan, Pwhite(0.07, 0.23), //tiempo de paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
);

~fullRgBubbles = Pmono(\bubbles,
	\freq, Pwhite(0.11, 23*4), //densidad- número de puntos por segundo
	\dur, Pwhite(0.5, 3.1),  //duración de cada cambio de parámetros
	\amp, -3.dbamp,
	\att, Pwhite(0.1,3), //tiempo de entrada de la textura
	\rel, Pwhite(0.1,5), //tiempo de salida de la textura
	\lag, Pwhite(0.7, 3),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4000), //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	\timefilt, Pwhite(7, 93), //tiempo del filtro rápido (variación discontinua en la altura)
	//\timefilt, Pwhite(0.1, 0.3), //tiempo del filtro lento (variación continua en la altura)
	\rq, Pwhite(0.05, 0.13), //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.41, 0.59), //resonancia del filtro amplia (poca definición de altura)
	\mix, Pwhite(0.05,0.65),  //espacio (nivel del reverb)
	\room, Pwhite(0.05,0.65), //espacio (tamaño del espacio)
	\timepan, Pwhite(0.07, 0.23), //tiempo de paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
);

~rBubbles = Pmono(\rampbubbles,
	\freq, Pwhite(0.11, 23), //densidad- número de puntos por segundo
	\dur, Pwhite(2.1,11), //duración de cada cambio de parámetros
	\amp, -12.dbamp,
	\att, Pwhite(0.1,3), //tiempo de entrada de la textura
	\rel, Pwhite(0.1,5), //tiempo de salida de la textura
	\lag, Pwhite(0.7, 3),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4000), //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	\timefilt, Pwhite(7, 93), //tiempo del filtro rápido (variación discontinua en la altura)
	\timeramp, Pwhite(0.1, 0.3), //tiempo de la rampa
	\rq, Pwhite(0.05, 0.13), //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.41, 0.59), //resonancia del filtro amplia (poca definición de altura)
	\mix, Pwhite(0.05,0.65),  //espacio (nivel del reverb)
	\room, Pwhite(0.05,0.65), //espacio (tamaño del espacio)
	\timepan, Pwhite(0.07, 0.23), //tiempo de paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
);

//Secuencias Crunchy (columna 2)
~highCrunch = Pmono(\crunch,
	\freq, Pwhite(240, 500), //rango de la frecuencia
	\mod, Pwhite(1.23, 8.1), //velocidad de modulación de amplitud
	\grain, Pwhite(0.05, 0.23), //ancho de onda moduladora
	\dur, Pwhite(6.1,19), //duración de cada cambio de parámetros
	\amp, -9.dbamp,
	\att, Pwhite(5.1,7), //tiempo de entrada del sonido
	\rel, Pwhite(5.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(5.0, 7),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4000), //límite agudo del filtro
	\cutofflow, Pwhite(800, 1600),  //límite grave del filtro
	//\timefilt, Pwhite(80, 181).trace, //tiempo del filtro rápido (modulante)
	\timefilt, Pwhite(0.7, 7.0), //tiempo del filtro lento (rítmico)
	//\rq, Pwhite(0.05, 0.23), //resonancia del filtro cerrada (definición de la altura)
	\rq, Pwhite(0.19, 0.31), //resonancia del filtro amplia (poca definición de altura)
	\timepan, Pwhite(0.38, 0.53), //tiempo del paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1), //apertura derecha
	\mix, Pwhite(0.05,0.35), //espacio (nivel de reverb)
	\room, Pwhite(0.1,0.55), //espacio (tamaño)
);

~midCrunch = Pmono(\crunch,
	\freq, Pwhite(100, 240), //rango de la frecuencia
	\mod, Pwhite(97, 199), //velocidad de modulación de amplitud
	\grain, Pwhite(0.3, 0.5), //ancho de onda moduladora
	\dur, Pwhite(7.1,17), //duración de cada cambio de parámetros
	\amp, -0.dbamp,
	\att, Pwhite(5.1,7), //tiempo de entrada del sonido
	\rel, Pwhite(5.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(5.0, 7),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(1200, 2400), //límite agudo del filtro
	\cutofflow, Pwhite(400, 800), //límite grave del filtro
	\timefilt, Pwhite(0.5, 81), //tiempo del filtro rápido (modulante)
	//\timefilt, Pwhite(0.5, 6),  //tiempo del filtro lento (rítmico)
	//\rq, Pwhite(0.05, 0.23), /resonancia del filtro cerrada (definición de la altura)
	\rq, Pwhite(0.33, 0.46), //resonancia del filtro amplia (poca definición de altura)
	\timepan, Pwhite(0.24, 0.37), //tiempo del paneo
	\left, Pwhite(-1.0,0),  //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
	\mix, Pwhite(0.05,0.35), //espacio (nivel de reverb)
	\room, Pwhite(0.1,0.55), //espacio (tamaño)
);

~bassCrunch = Pmono(\crunch,
	\freq, Pwhite(40, 100),  //rango de la frecuencia
	\mod, Pwhite(71, 116),  //velocidad de modulación de amplitud
	\grain, Pwhite(0.1, 0.3), //ancho de onda moduladora
	\dur, Pwhite(8.1,23.1), //duración de cada cambio de parámetros
	\amp, 1.dbamp,
	\att, Pwhite(5.1,7), //tiempo de entrada del sonido
	\rel, Pwhite(5.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(5.0, 7), //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(800, 1100), //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	//\timefilt, Pwhite(10.17, 75), //tiempo del filtro rápido (modulante)
	\timefilt, Pwhite(0.1, 7.3), //tiempo del filtro lento (rítmico)
	\rq, Pwhite(0.05, 0.23),  //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.41, 0.59), //resonancia del filtro amplia (poca definición de altura)
	\timepan, Pwhite(0.07, 0.23),  //tiempo del paneo
	\left, Pwhite(-1.0,0),  //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
	\mix, Pwhite(0.05,0.35),//espacio (nivel de reverb)
	\room, Pwhite(0.1,0.55), //espacio (tamaño)
);

~fullrangeCrunch = Pmono(\crunch,
	\freq, Pwhite(40, 700),  //rango de la frecuencia
	\mod, Pwhite(1.71, 216),  //velocidad de modulación de amplitud
	\grain, Pwhite(0.1, 0.3),  //ancho de onda moduladora
	\dur, Pwhite(1.6, 23.1),  //duración de cada cambio de parámetros
	\amp, -3.dbamp,
	\att, Pwhite(5.1,7), //tiempo de entrada del sonido
	\rel, Pwhite(5.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(5.0, 7), //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4100), //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	//\timefilt, Pwhite(0.17, 7.5), //tiempo del filtro lento (rítmico)
	\timefilt, Pwhite(10.1, 70.3),  //tiempo del filtro rápido (modulante)
	\rq, Pwhite(0.05, 0.23), //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.41, 0.59), //resonancia del filtro amplia (poca definición de altura)
	\timepan, Pwhite(0.07, 0.23), //tiempo del paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
	\mix, Pwhite(0.05,0.35), //espacio (nivel de reverb)
	\room, Pwhite(0.1,0.55), //espacio (tamaño)
);

~rampCrunch = Pmono(\rampCrunch,
	\freq, Pwhite(0.01, 9), //velocidad de la rampa
	\highf, Pwhite(2500,3500), //límite agudo de la frecuencia
	\lowf, Pwhite(52,72), //límite grave de la frecuencia
	\dur, Pwhite(6.1,13.1), //duración de cada cambio de parámetros
	\mod, Pwhite(60, 216), //rango alto de la onda moduladora
	\modl, Pwhite(0.5,55), //rango bajo de la onda moduladora
	\grain, Pwhite(0.1, 0.3), //ancho de la onda moduladora
	\amp, -9.dbamp,
	\att, Pwhite(5.1,7),  //tiempo de entrada del sonido
	\rel, Pwhite(5.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(5.0, 7),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4100), //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	//\timefilt, Pwhite(0.17, 7.5), //tiempo del filtro lento (rítmico)
	\timefilt, Pwhite(10.1, 70.3),  //tiempo del filtro rápido (modulante)
	\rq, Pwhite(0.05, 0.23), //resonancia del filtro cerrada (definición de la altura)
	//\rq, Pwhite(0.41, 0.59), //resonancia del filtro amplia (poca definición de altura)
	\timepan, Pwhite(0.07, 0.23), //tiempo del paneo
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1), //apertura derecha
	\mod, Pwhite(60, 216), //rango alto de la onda moduladora
	\modl, Pwhite(0.5,55), //rango bajo de la onda moduladora
	\grain, Pwhite(0.1, 0.3), //ancho de la onda moduladora
	\mix, Pwhite(0.05,0.35), //espacio (nivel de reverb)
	\room, Pwhite(0.1,0.55),  //espacio (tamaño)
);

//Muro de sonido (columna 3)
~high = Pmono(\muroDeSonidoSt,
	\freq, Pwhite(1002.0, 3001), //rango de la frecuencia
	\width, Pwhite(0.07, 0.31), //ancho del pulso
	\mod, Pwhite(0.93, 670), //rango de la frecuencia moduladora
	\grain, Pwhite(0.11, 0.83), //ancho de la onda moduladora
	\dur, Pwhite(7.1,23), //duración de cada cambio de parámetros
	\amp, -12.dbamp,
	\att, Pwhite(2.1,6), //tiempo de entrada del sonido
	\rel, Pwhite(2.1,6),  //tiempo de salida del sonido
	\lag, Pwhite(2.0, 6),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4000), //límite agudo del filtro
	\cutofflow, Pwhite(800, 1600), //límite grave del filtro
	\timefilt, Pwhite(0.07,17),  //tiempo del filtro lento (rítmico)
	//\timefilt, Pwhite(10.07, 70.1),  //tiempo del filtro rápido (modulante)
	\rq, Pwhite(0.19, 0.31), //resonancia del filtro -cerrada (definición de la altura)-abierta (poca definición de altura)
	\timepan, Pwhite(0.7, 5), //tiempo del paneo rápido
	//\timepan, Pwhite(0.08, 0.2), //tiempo de paneo lento
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
	\mix, Pwhite(0.05,0.85), //espacio (nivel de reverb)
	\room, Pwhite(0.1,5), //espacio (tamaño)
);

~mid = Pmono(\muroDeSonidoSt,
	\freq, Pwhite(94.0, 1001), //rango de la frecuencia
	\width, Pwhite(0.23, 0.49), //ancho del pulso
	\mod, Pwhite(0.67, 619), //rango de la frecuencia moduladora
	\grain, Pwhite(0.23, 0.89),  //ancho de la onda moduladora
	\dur, Pwhite(8.1,19), //duración de cada cambio de parámetros
	\amp, -12.dbamp,
	\att, Pwhite(3.1,7), //tiempo de entrada del sonido
	\rel, Pwhite(3.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(3.0, 7), //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(1200, 2400), //límite agudo del filtro
	\cutofflow, Pwhite(400, 800),  //límite grave del filtro
	//\timefilt, Pwhite(0.05,17),   //tiempo del filtro lento (rítmico)
	\timefilt, Pwhite(10.04, 70.11), //tiempo del filtro rápido (modulante)
	\rq, Pwhite(0.33, 0.46),  //resonancia del filtro -cerrada (definición de la altura)-abierta (poca definición de altura)
	\timepan, Pwhite(0.04, 5),  //tiempo del paneo rápido
	//\timepan, Pwhite(0.08, 0.2), //tiempo de paneo lento
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1),  //apertura derecha
	\mix, Pwhite(0.05,0.85), //espacio (nivel de reverb)
	\room, Pwhite(0.1,5), //espacio (tamaño)
);

~bass = Pmono(\muroDeSonidoSt,
	\freq, Pwhite(46.0, 93), //rango de la frecuencia
	\width, Pwhite(0.39, 0.67),  //ancho del pulso
	\mod, Pwhite(0.31, 586), //rango de la frecuencia moduladora
	\grain, Pwhite(0.31, 0.83), //ancho de la onda moduladora
	\dur, Pwhite(9.1,31), //duración de cada cambio de parámetros
	\amp, -6.dbamp,
	\att, Pwhite(5.1,7), //tiempo de entrada del sonido
	\rel, Pwhite(5.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(5.0, 7),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(800, 1100),  //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	\timefilt, Pwhite(0.05,17),  //tiempo del filtro lento (rítmico)
	//\timefilt, Pwhite(10.04, 70.11), //tiempo del filtro rápido (modulante)
	\rq, Pwhite(0.41, 0.59), //resonancia del filtro -cerrada (definición de la altura)-abierta (poca definición de altura)
	\timepan, Pwhite(0.07, 5), //tiempo del paneo rápido
	//\timepan, Pwhite(0.07, 0.23), //tiempo de paneo lento
	\left, Pwhite(-1.0,0), //apertura izquierda
	\right, Pwhite(0.0,1), //apertura derecha
	\mix, Pwhite(0.05,0.85), //espacio (nivel de reverb)
	\room, Pwhite(0.1,5), //espacio (tamaño)
);

~fullRange = Pmono(\muroDeSonidoSt,
	\freq, Pwhite(46.0, 3001), //rango de la frecuencia
	\width, Pwhite(0.07, 0.31),  //ancho del pulso
	\mod, Pwhite(0.23, 670), //rango de la frecuencia moduladora
	\grain, Pwhite(0.11, 0.83), //ancho de la onda moduladora
	\dur, Pwhite(7.1,29),  //duración de cada cambio de parámetros
	\amp, -12.dbamp,
	\att, Pwhite(3.1,7), //tiempo de entrada del sonido
	\rel, Pwhite(3.1,7), //tiempo de salida del sonido
	\lag, Pwhite(3.0, 7), //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4000), //límite agudo del filtro
	\cutofflow, Pwhite(800, 1600), //límite grave del filtro
	//\timefilt, Pwhite(10.04, 70.11), //tiempo del filtro rápido (modulante)
	\timefilt, Pwhite(0.07, 10.1),  //tiempo del filtro lento (rítmico)
	\rq, Pwhite(0.19, 0.31),  //resonancia del filtro -cerrada (definición de la altura)-abierta (poca definición de altura)
	//\timepan, Pwhite(0.07, 5), //tiempo del paneo rápido
	\timepan, Pwhite(0.08, 0.2), //tiempo del paneo lento
	\left, Pwhite(-1.0,0),//apertura izquierda
	\right, Pwhite(0.0,1), //apertura derecha
	\mix, Pwhite(0.05,0.85), //espacio (nivel de reverb)
	\room, Pwhite(0.1,5), //espacio (tamaño)
);

~rampWall = Pmono(\muroDeSonidoRamp,
	\freq, Pwhite(0.01, 101),  //velocidad de la rampa
	\width, Pwhite(0.39, 0.67), //ancho del pulso
	\highf, Pwhite(1300,1800), //límite agudo de la frecuencia
	\lowf, Pwhite(52,72), //límite grave de la frecuencia
	\dur, Pwhite(8.1,17), //duración de cada cambio de parámetros
	\mod, Pwhite(70, 151),//rango alto de la onda moduladora
	\modl, Pwhite(0.5,33),  //rango bajo de la onda moduladora
	\grain, Pwhite(0.1, 0.3), //ancho de la onda moduladora
	\amp, -18.dbamp,
	\att, Pwhite(5.1,7),  //tiempo de entrada del sonido
	\rel, Pwhite(5.1,7),  //tiempo de salida del sonido
	\lag, Pwhite(1.0, 5),  //tiempo de paso de un grupo de parámetros a otro (suaviza transición)
	\cutoffhigh, Pwhite(2000, 4100),  //límite agudo del filtro
	\cutofflow, Pwhite(200, 400), //límite grave del filtro
	\timefilt, Pwhite(10.04, 70.11), //tiempo del filtro rápido (modulante)
	//\timefilt, Pwhite(0.07, 10.1),  //tiempo del filtro lento (rítmico)
	\rq, Pwhite(0.05, 0.23), //resonancia del filtro cerrada (altura más definida)
	//\rq, Pwhite(0.41, 0.59), //resonancia del filtro abierta (poca definición de altura)
	\timepan, Pwhite(0.07, 0.23), //tiempo del paneo lento
	\left, Pwhite(-1.0,0),//apertura izquierda
	\right, Pwhite(0.0,1), //apertura derecha
	\mix, Pwhite(0.05,0.85), //espacio (nivel de reverb)
	\room, Pwhite(0.1,5), //espacio (tamaño)
);

//Cuadro derecho, primera columna desde la izquierda
//Secuencia intermitente (platillo frotado)
~clang = Pbind(\instrument, \clang2,
	\dur, Pwhite(1.3,7),
	\scale, (0..11), //total cromático
	\octave, Pwhite(2,6),
	\degree, Pwhite(0,11), //aleatorio del total cromático
	\type, Pwrand([\note,\rest],[0.66,0.34],inf).trace, //densidad por probabilidad ponderada
	\releaseTime, Pwhite(1.0,2.9),
	\pan, Pwhite(-1.0,1),
	\amp, -12.dbamp
);

//Secuencia caótica FM
~seq = Pbind(\instrument, Pwrand([\fm, \fmlong], [rrand(1,10), rrand(1,10)].normalizeSum, inf),
	//\dur, Prand([Pseq([0.25],4),0.5,1,Pseq([1/5],5),Pseq([1/7],7),2,1.5,7], exprand(1,11)),
	\dur, Prand([0.5, 1, 1.5, 2, ~dos, ~dos1, ~tres, ~tres1, ~tres2, ~tres3, ~cuatro, ~cuatro1, ~cuatro2, ~cuatro3, ~cuatro4, ~cinco, ~cinco1, ~cinco2, ~cinco3, ~cinco4, ~cinco5, ~siete, ~nueve, ~once], exprand(1,11)), //se escoge entre 1 y 11 veces alguno de los patrones indicados
	\portHz, Pexprand(30, 10000), //se elige uan frecuencia portadora
	\modHz, Pexprand(30, 10000), //frecuencia moduladora
	\modAmp, Pwhite(0,10000), //amplitud de la modulación
	\atk, Pwhite(0.01,rrand(0.07,0.17)), //ataque de la envolvente de cada sonido
	\rel, Pexprand(0.1,2.3), //release de la envolvente de cada sonido
	\pan, Pwhite(-1.0,1.0), //paneo
	\amp, Pwhite(-26.0, -23).dbamp
);

//Secuencia de bajo
~bajo = Pbind(\instrument,\bajo,
	\octave, 3, // registro grave
	\dur, Pwhite(0.6,3.3),
	//\dur, Pwhite(3.1,5.3), //duraciones largas
	\amp, Pwhite(-15.0, -13).dbamp,
	\type, Pwrand([\rest, \note], [0.01, 0.99], inf).trace, //para agregar silencios, reajustar proporciones
	\scale, (0..11),
	\degree, Pxrand([Pxrand(~i.scramble,4), Pxrand(~ii.scramble,4), Pxrand(~iii.scramble,4), Pxrand(~iv.scramble,4), Pxrand(~v.scramble,4), Pxrand(~vi.scramble,4)],inf), //secuencia notas
	\att, Pwhite(0.2,0.5),
	\rel, Pwhite(0.3, 0.6),
);

/*
~bajo = Pbind(\instrument, \bajo,
	\dur, Prand([0.5, 0.25, Pseq([0.375], 2)], inf),
	\octave, 3,
	\scale, (0..11),
	\degree, Pwrand([0,-1,-3,3], [8,5,13,3].normalizeSum, inf),
	\root, -4,
	\amp, 0.231,
	\rq, Pwhite(0.31,0.71)
);
*/

//Secuencia de campanas
~camp = Pbind(
	\instrument, \clang,
	\amp, Pwhite(-0.1, 6.0).dbamp,
	\dur, Prand([0.5, 1, 1.5, 2, ~dos, ~dos1, ~tres, ~tres1, ~tres2, ~tres3, ~cuatro, ~cuatro1, ~cuatro2, ~cuatro3, ~cuatro4, ~cinco, ~cinco1, ~cinco2, ~cinco3, ~cinco4, ~cinco5, ~siete, ~nueve, ~once], inf), //secuencia de ritmo caótico
	\octave, Pwhite(3,5), //registro medio grave
	\scale, (0..11),
	\degree, Pxrand([Pxrand(~i.scramble, 6), Pxrand(~ii.scramble, 6), Pxrand(~iii.scramble,6), Pxrand(~iv.scramble,6), Pxrand(~v.scramble,6), Pxrand(~vi.scramble,4)],inf),
	\pan, Pwhite(-1.0,1)
);

//Secuencia de pads
~padz = Pbind(\instrument, \pad,
	\amp, -24.dbamp,
	\dur, Pwhite(1.1,9),
	//\dur, Prand([0.5,1,1.5,2,2.5,3,3.5,4], inf), //duraciones "cuadradas"
	\octave, [4,5,5,6],
	\scale, (0..11),
	\degree, Pxrand([~i.scramble, ~ii.scramble, ~iii.scramble, ~iv.scramble, ~v.scramble, ~vi.scramble], inf).trace,
	\strum, Pwhite(0.0, 0.6),
	\att, Pwhite(0.01,0.75)
);

//Columna 2
//Granulador live secuencia
~granular_seq = Pmono(\granular,
	\dur, Pwhite(1.5, 3),
	\buff, Prand(~buffs1, inf),
	\rit, Pwhite(7,23),
	\rate, Pwhite(-1.45, 1.11),
	\pos, Pseries(0.01, 101), //posición del grano secuencial
	\durg, Pwhite(0.21, 2.1),
	\amp, 0.dbamp,
	\pan, Pwhite(-1, 1.0, inf),
);

//Granulador live random
~granular_rnd = Pmono(\granular,
	\dur, Pwhite(2.1, 5, inf),
	\buff, Prand(~buffs1, inf),
	\rit, Pwhite(7,23),
	\rate, Pwhite(-1.45, 1.11),
	\pos, Pwhite(0.0, 1), // posición del grano aleatoria
	\durg, Pwhite(0.21, 2.1),
	\amp, 0.dbamp,
	\pan, Pwhite(-1.0, 1.0, inf),
);

//Imitador de ritmo
~imitador = Pbind(\instrument, Prand([\fm, \pad], inf),
	\portHz, Pexprand(30, 10000),
	\modHz, Pexprand(30, 10000),
	\modAmp, Pwhite(0,10000),
	\atk,Pwhite(0.01,0.07),
	\rel,Pexprand(0.1,2.3),
	\pan, Pwhite(-1.0,1.0),
	\amp, 0.2,
	\dur, Pn(Plazy{ Pseq(~durs * exprand(0.25, 2), 1)}, inf).trace);

//Máquina 1
~rut1 = Routine({
	~bot[0].valueAction = 1; //prender burbujas high
	~bot[3].valueAction = 1; //prender burbujas mid
	~bot[6].valueAction = 1; //prender burbujas bass
	rrand(11.0,17).wait;
	~bot[0].valueAction = 0; //apagar burbujas high
	rrand(3.0,7).wait;
	~bot[3].valueAction = 0; //apagar burbujas mid
	~bot[18].valueAction = 1; //prender inv clang
	~bot[22].valueAction = 1; //activar tfm caos
	rrand(13.0,17).wait;
	~bot[13].valueAction = 1; //prender ramp cruch
	rrand(19.0,23).wait;

	~bot[6].valueAction = 0; //apagar burbujas bass
	~bot[22].valueAction = 1; //activar tfm caos
	rrand(7.9,17).wait;
	~bot[18].valueAction = 0; //apagar inv clang
	~bot[13].valueAction = 0; //apagar ramp crunch
	rrand(3.0,5).wait;
	"machin uan finalizada".postln;
	rrand(1.0,2).wait;
	"apaga el botón para reiniciar la rutina".postln;
});

//Máquina 3
~rut2 = Routine({
	~bot[2].valueAction = 1; //prender wall high
	~bot[5].valueAction = 1; //prender wall mid
	~bot[8].valueAction = 1; //prender wall bass
	rrand(23.0,29).wait;
	~bot[18].valueAction = 1; //prender inv clang
	~bot[5].valueAction = 0; //apagar mid wall
	rrand(7.1,17).wait;
	~bot[2].valueAction = 0; //apagar wall high
	~bot[1].valueAction = 1; // prender high crunch
	rrand(7.1,13).wait;
	~bot[4].valueAction = 1; // prender mid crunch
	~bot[10].valueAction = 1;// prender full range crunch
	rrand(13.0,19).wait;
	~bot[18].valueAction = 0; //apagar inv clang
	rrand(19.0,23).wait;
	~bot[8].valueAction = 0; //apagar wall bass
	~bot[1].valueAction = 0; //apagar high crunch
	~bot[4].valueAction = 0; //apagar mid crunch
	~bot[34].valueAction = 1;//prender tetracordes
	rrand(19.0,23).wait;
	~bot[10].valueAction = 0; //apagar full range crunch
	rrand(19.0,23).wait;
	~bot[34].valueAction = 0; //apagar tetracordes
	"machin tri finalizada".postln;
	rrand(1.0,2).wait;
	"apaga el botón para reiniciar la rutina".postln;
});

//Máquina 4
~punt = Pbind(\instrument, \buffmono,
	\buf, Prand(~bofs_mono[[11,10,9,8,7]],1),
	\start, Pwhite(0, Pfunc{|e| e.buf.numFrames / e.buf.sampleRate }),
	\dur, Pfunc{|e| e.buf.numFrames / e.buf.sampleRate },
	\amp, -6.dbamp,
	\loop, 1,
	\rate, Pwhite(-2.3,2.3),
	\pan, Pwhite(-1.0,1.0),
);

~puntillismo = Ppar(~punt!rrand(11,31),1);

//Máquina 5
~cross = Pbind(\instrument, Prand([\cross4, \cross5], inf),
	\dur, Pwhite(Pfunc{0.25 * ~dens}, Pfunc{3 * ~dens}),
	\ampout, Pfunc{~ampOut},
	\amr, Pfunc{~ampr},
	\speed, Pwhite(0.1,10),
	\frr, Pfunc{~freqr},
	\at, Pwhite(0.05, 0.5),
	\rel, Pwhite(0.1,1),
	\type, Pwrand([\note, \rest], Ptuple([Pfunc{~dens}, 1- Pfunc{~dens}]), inf),
);

~machfai = Ppar([~cross, ~cross],1);