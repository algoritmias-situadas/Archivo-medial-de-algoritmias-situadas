

///////////////////////////FUNCIÓN ARBOL////////////////////////////////////
//ARGUMENTOS:
//1. raiz -  nota raiz
//2. nNiveles - no. niveles
//3. nodo - arreglo que contiene el orden de los nodos:
//     'h' para nota heredada del arreglo del nivel anterior
//     'i' intervalo de la nota heredada.
//     'ri' para intervalo aleatorio de la nota heredada
//4. intervalos - arreglo de los intervalos a usar. cuando se usa 'i' en el
//   nodo sigue el orden del arreglo, cuando es 'ri' toma cualquiera de sus
//   valores aleatoriamente

/////////////////////////FUNCIÓN SECUENCIAS////////////////////////////////
//ARGUMENTOS
//1. arbol - la funcion arbol que retorna un arreglo de dos dimensiones
//2. probSilencio - arreglo con la probabilidad de un silencio por nodo en cada nivel
//3. durRaiz - duración total del árbol en segundos
//4. repSecuencia - repeticiones de las secuencias. usar inf para loop
//5. escala - escala
//6. octavaRaiz - octava del arreglo en el primer nivel
//7. decibeles - decibeles de cada nodo







//////////////////////// FUNCION GENERAR ARBOLES ////////////////////////////////////

~genArbol = {
	arg nNiveles = 2, nodo = ['h', 'i'], intervalos = [1,-1,2,-3];

	var  raiz = 0, arr, nHijos = nodo.size, selIntervalo;
	arr = Array.newClear(nNiveles+1);

	postln("~Árbol~");
	postln("Nodos: "++nodo);
	postln("Intervalos: "++intervalos);


	for (0, nNiveles, { //1er for para arr[i]
		arg i;

		arr[i] = Array.new(((nodo.size)**(i+1)));
		selIntervalo = 0; //es un contador para el tipo 'i'

		if (i==0,{ //el primer arreglo añade el valor directamente de la raiz

			arr[i].add(raiz);
			postln("Raíz:            [ "++raiz++" ]");
		},
		{
			for (0, arr[i-1].size -1, { //2do for para arr[i][j]
				arg j;


				for (0, nodo.size -1, {  //for con contador k para evaluar el orden de los nodos
					arg k;

					if (selIntervalo == intervalos.size, {selIntervalo=0}); //se resetea el contador para 'i'

					switch (nodo[k],
						'h', {arr[i].add(arr[i-1][j])},
						'i', {arr[i].add(arr[i-1][j] + intervalos[selIntervalo]); selIntervalo = selIntervalo + 1},
						'ri', {arr[i].add(arr[i-1][j] + intervalos.choose)}
					);
				});
			});
			postln("Arreglo nivel " ++ i ++ ": " ++ arr[i])
		});

	});

	~arbol = arr;

	postln("");

	arr;
};


postln("arboles.scd cargado");