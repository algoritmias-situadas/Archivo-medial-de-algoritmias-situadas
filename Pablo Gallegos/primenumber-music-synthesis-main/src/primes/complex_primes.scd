// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// Complex primes (4k - 1) + set for fast membership checks
//-----------------------------------------------------------------------------------------------------------------------
(
~lim = 10000;
~primoscomplejos = Array.new(10000);
~k = 1;
~n = 1;

while({ ~n <= ~lim }, {
	~n = 4 * ~k - 1;
	~raiz = ~n.sqrt.roundUp;
	~primo = true;

	for(2, ~raiz, { |i|
		if(~n % i == 0) { ~primo = false };
	});

	if(~primo == true) { ~primoscomplejos.add(~n) };
	~k = ~k + 1;
});

~primoscomplejos = ~primoscomplejos.select(_.notNil); // nil cleaning
~complexPrimeSet = ~primoscomplejos.as(Set);          // membership set (replaces .isPrime in complex mode)
)
