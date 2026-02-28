Chronometer {
	
	var <>w, <>x, <>y, <>clockField ;
	var <>r, <>startTime, <>title, <>fontSize;

	*new { arg fontSize = 40, x = 30, y = 120, title ="Tempus fugit", sizeX = 220, sizeY = 80;Ê
		^super.new.initChronometer(fontSize, x, y, title, sizeX, sizeY)Ê
	}

	initChronometer { arg fontSize, aX, aY, aTitle, sizeX,sizeY ;
		fontSize = fontSize; 
		x = aX ;
		y = aY ;		Ê
		title = aTitle ;
		startTime = thisThread.seconds ;
		this.createGUI(fontSize, x, y, aTitle, sizeX, sizeY) ;
	}Ê
	
	createGUI { arg fontSize = 40, x = 10, y = 120, title =Ê "Tempus fugit", sizeX, sizeY;
		w = GUI.window.new(title, Rect(x, y, sizeX, sizeY), false);
		clockField = GUI.staticText.new(w, Rect(5,5, sizeX, sizeY))			.align_(\center)
			.stringColor_(Color(1.0, 1.0, 0.0))
			.background_(Color(0,0,0))
			.font_(GUI.font.new("Optima", fontSize));Ê
		r = Task.new({
			  loop {Ê
				clockField.string_((thisThread.seconds-startTime).round(1).asTimeStringCage);
				1.wait 
			   } 
			}).play(AppClock);	
		w.front ;
		w.onClose_({ r.stop });

	}


}
