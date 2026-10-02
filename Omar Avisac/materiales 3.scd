(
/////////grooves////////////
~groove1 = [[0, 4b], [0, 4b], 4b, 0, [2, 4b], [0, 4b], 4b, [0, 4b], [0, 4b], 4b, 6b, 0, [2, 6b], [0, 4b], 4b, [1, 6b]];

~groove2 = [[0, 4b], 4b, 4b, [0, 6b], [2, 4b], [0, 6b], 4b, [0, 4b], [0, 4b], 4b, 6b, 4b, [2, 4b], [0, 4b], 4b, [0, 4b]];

~groove3 = [[0, 4b], 4b, [2, 4b], [0, 6b], [2, 4b], [0, 6b], [0, 4b], 4b, [0, 4b], 4b, 6b, 4b, [2, 4b], [0, 4b], 4b, [0, 4b]];

~groove4 = [[0, 6b], 4b, 6b, 4b , [2, 6b], [0, 6b], 4b, [0, 4b], [0, 4b], 4b, 6b, 4b, [2, 4b], [0, 4b], 4b, [0, 4b]];
////////duraciones//////////

~durs1 = [0.25, 0.25, 0.5, 0.125, 0.75, 0.25, 0.5, 0.25, 0.25, 0.125, 0.75, 0.5, 0.25, 0.125, 0.25, 0.5];

~durs2 = [0.5, 0.25, 0.25, 0.125, Rest(0.125), 0.125, 0.125, 0.5, 0.5, Rest(0.25), 0.25, 0.5, 0.25, 0.25, 0.5, 0.25];

~durs3 = [0.5, Rest(0.25), 0.125, 0.125, Rest(0.125), 0.125, 0.25, 0.5, 0.25, Rest(0.5), 0.25, 0.25, 0.5, 0.25];

~durs4 = [0.75, 0.25, Rest(0.5), 0.125, 0.125, Rest(0.35), 0.65, 0.5, Rest(0.125), 0.125, 0.25, Rest(0.75), 0.35, 1, 0.75, 0.35];
~durs5 = [0.75, 0.25, 0.333, 0.125, 0.5, Rest(0.35), 0.65, Rest(0.125), 0.35];

~durs6 = [ 0.25 , 0.35, 0.45, 0.5, 0.65, 0.75, 0.80, 0.90, 1];

~durs7 = [ 0.25 , 0.5, 1, 1.25, 1.50, 1.75, 2,  Rest(0.25), Rest(0.5), Rest(1), Rest(1.25), Rest(1.50), Rest(1.75), Rest(2)];


//ENTRENAR SHANNONFINGERS CON ARRAYS DE ARRAYS
~groovis = [~groove1, ~groove2, ~groove3, ~groove4].flatten;
~dursys = [~durs1, ~durs2, ~durs3, ~durs4, ~durs5, ~durs6, ~durs7].flatten;
~markys = ~groovis.collect{|x| ShannonFinger.new.data =x.asArray};
~markyd = ~dursys.collect{|x| ShannonFinger.new.data =x.asArray};
~strG = ~markys.collect{|x| x.asStream(order: 8, repeats: inf)};
~strD = ~markyd.collect{|x| x.asStream(order: 8, repeats: inf)};

// en tus pibainds poner ~strim[0], ~strim[1], etc




~i = [0,2,4];
~ii = [1,3,5];
~iii = [2,4,6];
~iv = [3,5,0];
~v = [4,6,1];
~vi = [5,0,2];
~vim = [5,0b,2];
~vii = [6,1,3];


//~todas = [[0,2,4], [1,3,5], [2,4,6], [3,5,0], [3,5b,0],[4,6,1], [5,0,2], [5,0b,2], [6,1,3]];
~todas = [~i, ~ii, ~iii, ~iv, ~v, ~vi, ~vim, ~vii];


~ia = [0];
~iia = [1];
~iiia = [2];
~iva = [3];
~va = [4];
~via = [5];
~vima = [5];
~viia = [6];

~todas1 = [~ia, ~iia, ~iiia, ~iva, ~va, ~via, ~vima, ~viia];

~ib = [2];
~iib = [3];
~iiib = [4];
~ivb = [5];
~vb = [6];
~vib = [0];
~vimb = [0b];
~viib = [1];

~todas2 = [~ib, ~iib, ~iiib, ~ivb, ~vb,~vib, ~vimb, ~viib];

~ic = [4];
~iic = [5];
~iiic = [6];
~ivc = [0];
~vc = [1];
~vic = [2];
~vimc = [2];
~viic = [3];


~todas3 = [~ic, ~iic, ~iiic, ~ivc, ~vc, ~vic, ~vimc, ~viic];

///primer loop prog, voicing

~voicing1 = [[3,4,5], [5,4,3], [4,5,6]];
~voicing1a = [3, 5, 4];
~voicing1b = [4, 4, 5];
~voicing1c = [5, 3, 6];
~prog1 =  [~ii, ~v, ~i];
~prog1a = [~iia, ~va, ~ia].flatten;
~prog1b = [~iib, ~vb, ~ib].flatten;
~prog1c = [~iic, ~vc, ~ib].flatten;


~loopi1 = [~prog1, ~prog1a, ~prog1b, ~prog1c].flatten;
~looparmoni1 = ~loopi1.collect{|x| ShannonFinger.new.data =x.asArray};
~strA = ~looparmoni1.collect{|x| x.asStream(order: 8, repeats: inf)};



///segundo loop prog, voicing

~voicing2 = [[3,4,5], [5,4,3], [4,5,6], [3,4,5]];
~voicing2a = [3, 5, 4, 3];
~voicing2b = [4, 4, 5, 4];
~voicing2c = [5, 3, 6, 5];
~prog2 =  [~iv, ~i, ~v, ~iv];
~prog2a = [~iva, ~ia, ~va, ~iva].flatten;
~prog2b = [~ivb, ~ib, ~vb, ~ivb].flatten;
~prog2c = [~ivc, ~ic, ~vc, ~ivc].flatten;

~loopi2 = [~prog2, ~prog2a, ~prog2b, ~prog2c].flatten;
~looparmoni2 = ~loopi2.collect{|x| ShannonFinger.new.data =x.asArray};
~strB = ~looparmoni2.collect{|x| x.asStream(4, 16)};


///tercer loop prog, voicing
~voicing3 = [[3,4,5], [5,4,3], [4,5,6], [5,4,3]];
~voicing3a = [3, 5, 4, 5];
~voicing3b = [4, 4, 5, 4];
~voicing3c = [5, 3, 6, 3];
~prog3 =  [~i, ~i, ~v, ~iv];
~prog3a = [~ia, ~ia, ~va, ~iva].flatten;
~prog3b = [~ib, ~ib, ~vb, ~ivb].flatten;
~prog3c = [~ic, ~ic, ~vc, ~ivc].flatten;


~loopi2 = [~prog2, ~prog2a, ~prog2b, ~prog2c].flatten;
~looparmoni2 = ~loopi2.collect{|x| ShannonFinger.new.data =x.asArray};
~strC = ~looparmoni2.collect{|x| x.asStream(order: 5, repeats: inf)};


///cuarto loop prog, voicing
~voicing4 = [[3,4,5], [5,4,3], [4,5,6], [3,4,5]];
~voicing4a = [3, 5, 4, 3];
~voicing4b = [4, 4, 5, 3];
~voicing4c = [5, 3, 6, 5];
~prog4 =  [~i, ~iv, ~ii, ~v];
~prog4a = [~ia, ~iva, ~iia, ~va].flatten;
~prog4b = [~ib, ~ivb, ~iib, ~vb].flatten;
~prog4c = [~ic, ~ivc, ~iic, ~vc].flatten;



~loopi4 = [~prog4, ~prog4a, ~prog4b, ~prog4c].flatten;
~looparmoni4 = ~loopi4.collect{|x| ShannonFinger.new.data =x.asArray};
~strE = ~looparmoni4.collect{|x| x.asStream(order: 8, repeats: inf)};
)


