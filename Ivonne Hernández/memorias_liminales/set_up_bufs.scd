(
//________________________________________________________________________________________

// 2. Cargar Buffers. Línea 62-227. Sigue en 229.

Buffer.freeAll();

~path = thisProcess.nowExecutingPath.dirname;

~nom =[

	// 1. La ciudad que respira el tiempo - 1 audio - bofs[0]
	"01_001.wav", // [0]

	// 2. El Origen - 1 audio - bofs[1]
	"02_001.wav", // [1]

	// 3. Las Sendas olvidadas: Comunicación y transporte - 1 audio - bofs[2]
	"03_001.wav", // [2]

	// 4. Ecos en las paredes - 15 audios - bofs[3-17]
	"04_000.wav", // 185 [3]
	"04_001.wav", // 7
	"04_002.wav", // 8
	"04_003.wav", // 2
	"04_004.wav", // 9
	"04_005.wav", // 4
	"04_006.wav", // 4
	"04_007.wav", // 7
	"04_008.wav", // 3
	"04_009.wav", // 8
	"04_010.wav", // 3
	"04_011.wav", // 3
	"04_012.wav", // 5
	"04_013.wav", // 5
	"04_014.wav", // 21 [17]

	// 5. La sala de la últimas espera - 1 audio - bofs[18]
	"05_001.wav", // [18]

	// 6. El tiempo - 9 audios - bofs[19-27]
	"06_000.wav", // 185 [19]
	"06_001.wav", // 5
	"06_002.wav", // 2
	"06_003.wav", // 1
	"06_004.wav", // 3
	"06_005.wav", // 3
	"06_006.wav", // 7
	"06_007.wav", // 4
	"06_008.wav", // 5 [27]

	// 7. Los testigos de piedra - 7 audios - bofs[28-34]
	"07_000.wav", // 113 [28]
	"07_001.wav", // 1
	"07_002.wav", // 2
	"07_003.wav", // 3
	"07_004.wav", // 6
	"07_005.wav", // 6
	"07_006.wav", // 10 [34]

	// 8. Los inmuebles como tecnologías de memoria colectiva- 15 audios - bofs[35-49]
	"08_000_c.wav", // [35] ++ EN ESTE TIENES TRES OPCIONES. AGREGA LA LETRA DEL QUE MÁS TE GUSTE Y AGREGALA AL NOMBRE. ++
	"08_001.wav", // 3
	"08_002.wav", // 2
	"08_003.wav", // 2
	"08_004.wav", // 8
	"08_005.wav", // 3
	"08_006.wav", // 1
	"08_007_a.wav", // 4
	"08_007_b.wav", // 2
	"08_008.wav", // 1
	"08_009.wav", // 5
	"08_010.wav", // 2
	"08_011_a.wav", // 6
	"08_011_b.wav", // 1
	"08_011_c.wav", // 5 [49]

	// 9. El futuro: Sociedad en Ruinas - 10 audios - bofs[50-59]
	"09_000.wav", // 428 [50]
	"09_001.wav", // 2
	"09_002.wav", // 1
	"09_003.wav", // 3
	"09_004_a.wav", // 3
	"09_004_b.wav", // 1
	"09_005.wav", // 2
	"09_006.wav", // 7
	"09_007.wav", // 3
	"09_008.wav", // 9 [59]

	// 10. Violencia y Economía - 6 audios - bofs[60-59]
	"10_000.wav", // 429 [60]
	"10_001.wav", // 6
	"10_002.wav", // 2
	"10_003.wav", // 5
	"10_004.wav", // 2
	"10_005.wav", // 2 [65]

	// 11. Error y Esperanza - 1 audio - bofs[66]
	"11_001.wav", // [66]

	// 12. Fuego, Escombors y Fantasmas - 1 audio - bofs[67]
	"12_001.wav", // [67]

	// 13. Susurros del Olvido - 10 audios - bofs[68-77]
	"13_000.wav", // 427 [68]
	"13_001.wav", // 2
	"13_002.wav", // 5
	"13_003.wav", // 29
	"13_004.wav", // 6
	"13_005_a.wav", // 3
	"13_005_b.wav", // 2
	"13_005_c.wav", // 4
	"13_005_d.wav", // 3
	"13_005_e.wav", // 15 [77]

	// 14. Bellavista y Jauja - 8 audios - bofs[78-85]
	"14_000.wav", // 554 [78]
	"14_001.wav", // 2
	"14_002.wav", // 1
	"14_003.wav", // 3
	"14_004.wav", // 7
	"14_005.wav", // 10
	"14_006.wav", // 7
	"14_007.wav", // 17 [85]

	// 15. Narrativas del presente - 22 audios - bofs[86-107]
	"15_000.wav", // 550 [86]
	"15_001.wav", // 1
	"15_002.wav", // 1
	"15_003.wav", // 6
	"15_004.wav", // 1
	"15_005.wav", // 9
	"15_006.wav", // 11
	"15_007.wav", // 1
	"15_008.wav", // 9
	"15_009.wav", // 7
	"15_010.wav", // 2
	"15_011.wav", // 4
	"15_012.wav", // 3
	"15_013.wav", // 1
	"15_014.wav", // 8
	"15_015.wav", // 1
	"15_016.wav", // 2
	"15_017.wav", // 1
	"15_018.wav", // 1
	"15_019.wav", // 8
	"15_020.wav", // 1
	"15_021.wav", // 5 [107]

	// 16. Memorias Liminales - 1 audio - bofs[108]
	"16_001.wav", // [108]

];

//~path= "C:/Users/user/Documents/Titulación/Proyecto Titulación Audio/Despertar/Despertar";

~bofs = ~nom.collect{|nom|Buffer.read(s, ~path ++ "/audios/" ++ nom)};

~pleyer = ~bofs;
)