
////////////////////////////// GUI /////////////////////////////////////////


~nBoxRaiz = NumberBox()
.clipLo_(-9)
.clipHi_(9)
.value_(0)
.action_({arg r; ~nBoxRaizValue = r.value;})
.value_(0);

~nBoxNNiveles = NumberBox()
.clipLo_(1)
.clipHi_(9)
.action_({arg n; ~nBoxNNivelesValue = n.value;})
.value_(1);


~botonesNodos = Array.newClear(5);
~botonesNodosValue = Array.newClear(5);

for (0,4, {
	arg i;
	~botonesNodos[i] = Button(~genArbolGUI)
	.states_([['n/a'],['h'],['i'],['ri']])
	.maxWidth_(50)
	.action_({
		arg n;
		switch (n.value,
			0, {~botonesNodosValue[i] = 'n/a';},
			1, {~botonesNodosValue[i] = 'h';},
			2, {~botonesNodosValue[i] = 'i';},
			3, {~botonesNodosValue[i] = 'ri';}
		);
	})
	.value_(0);
});

~nBoxIntervalos = Array.newClear(8);
~nBoxIntervalosValue = Array.newClear(8);

for (0,7, {
	arg i;
	~nBoxIntervalos[i] = NumberBox(~genArbolGUI)
	.clipLo_(-20)
	.clipHi_(20)
	.maxWidth_(25)
	.action_({arg int; ~nBoxIntervalosValue[i] = int.value;})
	.value_(0);
});

~nBoxRaizValue = 0;      //se inicializan con estos valores que
~nBoxNNivelesValue = 1;  //son los mismos a los .value de los number box

for (0,4,{arg i; ~botonesNodosValue[i] = 'n/a'});
for (0,7, {arg i; ~nBoxIntervalosValue[i] = 0});

~funcNodosGUI = {
	var nodosGUI = Array.new(5);
	for (0, 4, {arg i; if (~botonesNodosValue[i] != 'n/a', {nodosGUI.add(~botonesNodosValue[i])})});
	nodosGUI
};

~funcIntervalosGUI = {
	var intervalosGUI = Array.new(5);
	for (0,7, {arg i; if (~nBoxIntervalosValue[i] != 0, {intervalosGUI.add(~nBoxIntervalosValue[i])})});
	intervalosGUI
};

(
~genArbolGUI = Window.new("Árboles", Rect.new(750,50,198,163)).layout_(
    VLayout(
		[StaticText().string_("Generador de árboles").stringColor_("#317873"), align:\top],
		HLayout(
			[StaticText().string_("Nota raíz:").stringColor_("#317873"), align:\right],
			[~nBoxRaiz.maxWidth_(50), align:\left],
			[StaticText().string_("Número de niveles:").stringColor_("#317873"), align:\right],
			[~nBoxNNiveles.maxWidth_(50), align:\left]
		),
		HLayout(
			StaticText().string_("Nodos:").stringColor_("#317873"),
			~botonesNodos[0],
			~botonesNodos[1],
			~botonesNodos[2],
			~botonesNodos[3],
			~botonesNodos[4]
		),
		HLayout(
			StaticText().string_("Intervalos:").stringColor_("#317873"),
			~nBoxIntervalos[0],
			~nBoxIntervalos[1],
			~nBoxIntervalos[2],
			~nBoxIntervalos[3],
			~nBoxIntervalos[4],
			~nBoxIntervalos[5],
			~nBoxIntervalos[6],
			~nBoxIntervalos[7]
		),
		[Button.new
			.states_([["Crear árbol", Color.fromHexString("#ffffff"), Color.fromHexString("#49796b")]])
			.action_({~arbol = ~genArbol.(~nBoxRaizValue, ~nBoxNNivelesValue, ~funcNodosGUI.(), ~funcIntervalosGUI.())}),
		align:\bottom]
    )
).background_(Color.fromHexString("#a3c1ad"));

);

