
~niebla=File.new(~path ++ "/NIEBLA.txt", "r").readAllString;
//carga el txt de Niebla y lo pone un arrary
~palabrotas= ~niebla.split($ );
//separa las palabras con el caracter espacio y los pone un array
~ventana1 = Window("ventana1", Window.screenBounds);
~ventana1.view.background=Color.black;
~ventana1.front;
~ventana1.fullScreen;
//declara la ventana con fondo negro y la pone fullscreen
~txt1 = StaticText(~ventana1, Rect(0, 0, Window.screenBounds.width, Window.screenBounds.height));
~txt1.stringColor=Color.white;
~txt1.align = \topLeft;
~txt1.font = Font("Times New Roman", 50);

~txt2 = StaticText(~ventana1, Rect(0, 0, Window.screenBounds.width, Window.screenBounds.height));
~txt2.stringColor=Color.white;
~txt2.align =\topRight;
~txt2.font = Font("Times New Roman", 50);

~txt3 = StaticText(~ventana1, Rect(0, 0, Window.screenBounds.width, Window.screenBounds.height));
~txt3.stringColor=Color.white;
~txt3.align = \bottom;
~txt3.font = Font("Times New Roman", 50);

~txt4 = StaticText(~ventana1, Rect(0,0, Window.screenBounds.width, Window.screenBounds.height));
~txt4.stringColor=Color.white;
~txt4.align =\left;
~txt4.font = Font("Times New Roman", 50);

~txt5 = StaticText(~ventana1, Rect(0,0, Window.screenBounds.width, Window.screenBounds.height));
~txt5.stringColor=Color.white;
~txt5.align =\bottomLeft;
~txt5.font = Font("Times New Roman", 50);

~txt6 = StaticText(~ventana1, Rect(0,0, Window.screenBounds.width, Window.screenBounds.height));
~txt6.stringColor=Color.white;
~txt6.align =\bottomRight;
~txt6.font = Font("Times New Roman", 50);

~txt7 = StaticText(~ventana1, Rect(0,0, Window.screenBounds.width, Window.screenBounds.height));
~txt7.stringColor=Color.white;
~txt7.align =\right;
~txt7.font = Font("Times New Roman", 50);

~txt8 = StaticText(~ventana1, Rect(0,0, Window.screenBounds.width, Window.screenBounds.height));
~txt8.stringColor=Color.white;
~txt8.align =\top;
~txt8.font = Font("Times New Roman", 50);

~txt9 = StaticText(~ventana1, Rect(0,0, Window.screenBounds.width, Window.screenBounds.height));
~txt9.stringColor=Color.white;
~txt9.align =\center;
~txt9.font = Font("Times New Roman", 50);
//declaraciónde los 9 rectangulos de texto para la ventana.

r{
	~palabrotas.scramble.do{|i|
		~txt1.string = i;
		~txt1.font = Font("Times New Roman", rrand(60, 200));
		~txt1.stringColor=Color.white;
		1.wait;

	}
}.play(AppClock);
r{
	~palabrotas.scramble.do{|i|
		~txt2.string = i;
		~txt2.font = Font("Times New Roman", rrand(70,200));
		~txt2.stringColor=Color.rand;
		1.5.wait;
	}
}.play(AppClock);
r{
	 ~palabrotas.scramble.do{|i|
		~txt3.string = i;
		~txt3.font = Font("Times New Roman", rrand(30, 100));
		~txt3.stringColor=Color.rand;
		1.9.wait;
	}
}.play(AppClock);
r{
	 ~palabrotas.scramble.do{|i|
		~txt4.string = i;
		~txt4.font = Font("Times New Roman", rrand(30, 100));
		~txt4.stringColor=Color.rand;
		rrand(1, 3).wait;
	}
}.play(AppClock);
r{
	 ~palabrotas.scramble.scramble.do{|i|
		~txt5.string = i;
		~txt5.font = Font("Times New Roman", rrand(30, 100));
		~txt5.stringColor=Color.blue;
		rrand(1, 3).wait;
	}
}.play(AppClock);
r{
	 ~palabrotas.scramble.do{|i|
		~txt6.string = i;
		~txt6.font = Font("Times New Roman", rrand(30, 100));
		~txt6.stringColor=Color.rand;
		rrand(1, 8).wait;
	}
}.play(AppClock);
r{
	 ~palabrotas.scramble.do{|i|
		~txt7.string = i;
		~txt7.font = Font("Helvetica", rrand(30, 100));
		~txt7.stringColor=Color.rand;
		rrand(1, 5).wait;
	}
}.play(AppClock);
r{
	 ~palabrotas.scramble.do{|i|
		~txt8.string = i;
		~txt8.font = Font("Times New Roman", rrand(30, 100));
		~txt8.stringColor=Color.rand;
		rrand(1, 3).wait;
	}
}.play(AppClock);
r{
	 ~palabrotas.do{|i|
		~txt9.string = i;
		~txt9.font = Font("Times New Roman", rrand(30, 100));
		~txt9.stringColor=Color.rand;
		rrand(1, 3).wait;
	}
}.play(AppClock);
r{
	1.do{
	~ventana1 = Window("ventana1", Window.screenBounds);
	1.wait;
	~palabrotas.do{arg i;
	~txt1.string = i;
	~txt1.font = Font("Times New Roman", rrand(60, 200));
	~txt1.stringColor=Color.white;
		1.wait;
}}}.play(AppClock);
//ruitna para que cambien el texto confrome a los waits y cambiando el orden de Niebla con un scramble, varia también el tamaño y en algunos el color

		