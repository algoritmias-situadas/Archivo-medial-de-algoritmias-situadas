z = ();
~posSpec = ControlSpec(0, 2.0, 'lin', 0.005, -inf, 'pos');
~rotSpec = ControlSpec(0, 2.0, 'lin', 0.005, -inf, 'rot');
~granoSpec = ControlSpec(0, 4.0, 'lin', 0.005, -inf, 'gsize');
//~fondo = Image.new("/Users/gerardomeza/Desktop/Entrelazados Project/Recurso 2.png");


z.view = Window("lozCiborsSonEter",Rect(6.0, 5.0, 1102.0, 535.0),true);
z.view2 = Window("Perfiles_Contornos",Rect(900.0, 5.0, 400.0, 400.0),false);
z.view3 = Window("controlador",Rect(260.0, 173.0, 480.0, 350.0),false);
z.comp = CompositeView(z.view,Rect(0,0,400, 400), true);
z.comp2 = CompositeView(z.comp,Rect(0, z.comp.bounds.height * 0.5, 400, 0.5));
z.comp3 = CompositeView(z.comp,Rect(200, 0, 0.5,  z.comp.bounds.height));
//z.comp5.decorator = FlowLayout(z.comp3.bounds,5);
z.comp4 = CompositeView(z.comp,Rect((z.comp.bounds.width * 0.5)- 5, (z.comp.bounds.height * 0.5)- 5, 10, 10));
//z.view.bounds;
/////////

z.comp5 = 5.collect{|i| i.postln; CompositeView(z.view, Rect(410, i *105, z.view.bounds.width-420, 100.0));};


/*z.comp5 =CompositeView(z.view,Rect(410,2, z.view.bounds.width-420, 100.0));
//z.comp5 =CompositeView(z.view,Rect(410,2, z.view.bounds.width-420, 200.0));
//z.comp5.decorator = FlowLayout(z.comp5.bounds);

z.comp8 = CompositeView(z.view,Rect(410,102,z.view.bounds.width-420,100.0));
z.comp9 = CompositeView(z.view,Rect(410,202,z.view.bounds.width-420,100.0));*/

/////
z.comp6 = CompositeView(z.view,Rect(0,400,400,2));
z.comp7 = CompositeView(z.view,Rect(400,0,2,402));

z.view.background_(Color.gray);
z.view3.background_(Color.black);

z.comp.background_(Color.gray(alpha:0.2));

z.comp2.background_(Color.rand);
z.comp3.background_(Color.rand);
z.comp4.background_(Color.rand);
z.comp5.do{|i| i.background_(Color.rand)};
z.comp6.background_(Color.rand);
z.comp7.background_(Color.rand);
//z.comp8.background_(Color.rand);
//z.comp9.background_(Color.rand);




z.text= StaticText(z.comp,Rect(z.comp.bounds.width - 150, (z.comp.bounds.height - 45) , 200, 20));
z.text2 = StaticText(z.comp,Rect(z.comp.bounds.width - 150, (z.comp.bounds.height - 30), 200,20));
z.text3 = StaticText(z.comp,Rect(2, z.comp.bounds.height -30, 200, 20));
z.text4 = StaticText(z.comp,Rect(2, z.comp.bounds.height -45, 200, 20));

/*z.text5 = StaticText(z.view2,Rect(2,105,100, 20));
z.text5.string = "AMP";*/

z.env = 4.collect{|i|
	i = EnvelopeView(z.view2, Rect(0, i * 100, 400, 80))
    .drawLines_(true)
    .selectionColor_(Color.red)
    .drawRects_(true)
    .resize_(5)
    .step_(0.05)
    .action_({arg b; [b.index, b.value]})
    .thumbSize_(20)
    .value_([[0.0, 0.1, 0.5, 0.7,1],[0.1,1.0,0.8,0.0]]);
};

z.boton = 4.collect{|i|
//	i.postln;
	i = Button(z.view,Rect(0+(i*100), 420, 100, 100))
	//.states_([["Contornos",Color.rand]])
	//.action_({z.view2.front});
};


z.view3.view.decorator = FlowLayout( z.view3.view.bounds, 10@10, 20@5 );
//z.knobs = 24.collect{ EZKnob(z.view3.view,40@40)};
z.knob3 = 8.collect{ EZKnob(z.view3.view,40@40,controlSpec:~granoSpec)};
z.knob2 = 8.collect{ EZKnob(z.view3.view,40@40,controlSpec:~rotSpec)};
z.knob = 8.collect{ EZKnob(z.view3.view,40@40,controlSpec:~posSpec)};


z.slider = 8.collect{ EZSlider(z.view3.view, 40@160, layout:\vert)};
z.boton2 = 8.collect{Button(z.view3, 40@15)};
z.boton3 = 8.collect{Button(z.view3, 40@15)};


/////botones del menú principal
z.boton[0].states_(~procesos.size.collect{|x|
	[x.asString, Color.white, Color.green(alpha:0.5)]})
.action_({|b| ~procesos[b.value].value});

z.boton[1].states_([["Contornos",Color.rand],["Contornos",Color.rand,Color.red]]).action_({|v|
	v.value.postln;
	if(v.value == 1) {z.view2.front;};
	if(v.value == 0) {z.view2.visible = 0};

});


z.boton[2].states_([["Controlador",Color.rand],["Controlador",Color.rand, Color.red]]).action_({|v|
	if(v.value == 1) {z.view3.front};
	if(v.value == 0) {z.view3.visible = 0};
});
z.boton[3].states_([["Timer",Color.rand]]).action_({z.view2.front});


/////botones del controlador
z.boton2.size.do{|i|z.boton2[i]
	.states_([[(i+1).asString,Color.rand],
		["|>|",Color.rand,Color.red]]).action_({|v|
		//v.postln;
		if(v.value==1){~pattern[i].play;};
			if(v.value==0){~pattern[i].stop;
			~pattern[i].reset;
		}
})};

////falta asignar
z.boton3.size.do{|i|z.boton3[i]
	.states_([[(i+1).asString,Color.rand],["|>|",Color.rand,Color.red]]).action_({|v|
		if(v.value==1){~pattern2[i].play;};
			if(v.value==0){~pattern2[i].stop;}
})};


z.text.font = Font("Arial", 12);
z.text2.font = Font("Arial", 12);
z.text3.font = Font("Arial", 12);
z.text4.font = Font("Arial", 12);

z.text.string = "HDensity: " ++ ~pos.size;
//o.string = "FreqRange: " ++ ~freq.minItem++  " - "++ ~freq.maxItem ++ " hz";
//l.string = "HDensity: " ++ ~lista.size;
z.text3.string = "Delta: " ++ ~lista.size;
z.text2.string = "CDensity: " ++ ~cuadrantesPost;


~dibujo =
{z.view.drawFunc = {
	//~q.do{|item, i|
	//i.postln;
	Pen.translate(200,200);
	Pen.color = Color.magenta(1.0);
	Pen.fillColor = Color.hsv(1.0.rand, 0.5, 0.5 , 0.5);
	Pen.strokeOval(Rect.aboutPoint(0@0, 150, 150));

	Pen.moveTo(0@0);
	};

	/*~a.do({|i, index|
	i.postln;
		Pen.fillColor = Color.hsv(~gdur[index], 1, 1, 1);
		Pen.fillOval(Rect.aboutPoint(i,~tamano[index], ~tamano[index]));
	Pen.fillStroke;*/

}.value;

z.view.refresh;



~update = SkipJack(
	{
//		\running.postln;
		z.knob.size.do{|i|z.knob[i].valueAction = ~position[i];};
		z.knob2.size.do{|i| z.knob2[i].valueAction = ~rotacion[i];};
		z.knob3.size.do{|i| z.knob3[i].valueAction = ~gSize[i];};
		z.slider.size.do{|i| z.slider[i].valueAction = ~ampInter[i];};
		~maskAmp = z.env[0].value;
		~maskDur = z.env[1].value;
		~maskAmp2 = z.env[2].value;
		~maskDur2 = z.env[3].value;

	}, 0.000015, name: "wui"
).play;

//~update.stop;

z.view.onClose = {
	z.view2.close;
	z.view3.close;
	s.freeAll;
	~controladormidi.free;
	~controladormidi2.free;
	~update.stop;
	\saleBye.postln;
	Buffer.freeAll;
};


z.view2.onClose = {{z.boton[1].valueAction =  z.boton[1].value.switch(0,1,1,0)}.defer;};
z.view3.onClose = {{z.boton[2].valueAction =  z.boton[2].value.switch(0,1,1,0)}.defer;};


z.view.refresh;
z.view.front;
