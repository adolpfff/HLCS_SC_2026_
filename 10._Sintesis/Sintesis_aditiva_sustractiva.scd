
/*//////////
//Sintesis//
*///////////

/*
Consiste en la practica creativa de combinar e interconectar generadores de onda
tipicamente osciladores y generadores de ruido con el proposito de construir / componer timbres y texturas.

Podemos pensar la sintesis como la busqueda de una complejidad dentro del umbral de la información. Donde en un extremo se encuentra "dispositivos" con poca información, por lo general "muy" ordenados, y en el otro se encuentran con "demasiada" información totalmente aleatorio.

En este sentido nuestro umbral lo componen la señal Sinoide y el Ruido blanco respectivamente.

*/
"https://www.philipgalanter.com/downloads/ga2003_paper.pdf".openOS;

/*///////////////////
//Sintesis aditiva.//
*////////////////////

/*
Consiste en el acto de SUMAR dos o mas señales produciendo una nueva onda diferente a las originales.
Se suman los valores de sampleo de cada onda de la siguiente manera.
*/

//Suma de señales.
(
{
	var x, y, z;
	x = SinOsc.ar(2);
	y = SinOsc.ar(10) * 0.33;
	z = x + y; //SUMA
	[x,y,z]
}.plot(1)
.plotColor_([Color.red, Color.blue, Color.green])
.plotMode_(\plines)
.axisLabelX_([\SinOscX_2, \SinOscY_10, \SinOscZ])
.superpose_(true)
)
//s.

/*
La onda Sinoide funcióna como un buen bloque de construcción por la simplicidad de la onda ademas de que sabemos por el teorema de Fourier que todas las ondas periódicas se pueden expresar como la suma de ondas simples.
*/
"https://www.jezzamon.com/fourier/".openOS;

//Ejemplos de sintesis.

//Onda de diente de sierra.
//Suma de todos los armonicos (hasta el infinito) con una amplitud por armónico de 1/n.
"https://www.youtube.com/watch?v=E4u4B5y5420&t=1s".openOS;

(
var iter = 3; //Llamamos una variable iter que representa el numero de armónicos.
{
	var sig; //Dentro de la función creamos la variable sig que se encargará de almacenar la generación de las señales.
	sig = iter.collect({ //mediante .collect podemos almacenar en un arreglo el proceso.
		arg i; //i es el numero de iteraciónes, va de 0 a i.
		var freq = 100; //En este caso llamamos una frecuencia inicial de 100Hz.
		//La primera iter la frecuencia es igual a 1 * (0+1) y la amp es 1/(0+1).
		//La segunda iter freq = 1 * (1+1), que corresponde al 2ndo armónico. amp = 1/(1+1).
		//etc. hasta llegar a iter - 1.
		SinOsc.ar(freq * (i+1), mul: 1/(i+1));
	});
	//Al finalizar la iteración tomamos el arreglo sig con las señales producidas y lo concatenamos con sig.sum que es la suma del arreglo anterior.
	sig ++ sig.sum;

}.plot(100.reciprocal) //Graficamos solo un periodo.
.plotMode_(\plines)
.plotColor_(((iter).collect({Color.black})++[Color.red]))
.superpose_(true);
)

//Versiones UGen
//SC nos ofrece 2 versiónes de onda diente de sierra con dos propositos muy diferentes.

// Saw es lo que se considera un UGen con "Bandas limitadas" ie. remueve armónicos arriba de la frecuencia de Nyquist.
{Saw.ar(110)}.plot(110.reciprocal * 2); //Grafiquemos 2 periodos de la onda.

(
{Saw.ar(110!2) * 0.3}.scope; //Veamosla en acción.
FreqScope.new;//Como repercute en el espectro de frecuencias.
);

//Probemos modular la frecuencia.
(
{
	var sig, mod;
	mod = MouseX.kr(20,2e4,1).poll;
	Saw.ar(mod, 0.3);
}.scope;
)

//LFSaw es un UGen sin "Bandas limitadas" diseñado para operar como un oscilador de baja frecuencia. ie < 20.
{LFSaw.ar(110)}.plot(110.reciprocal*2); //Es diferente a la señal producida por Saw?

(
{LFSaw.ar(110!2) * 0.3}.scope; //En principio no hay mucha diferencia con la onda generada por Saw.
FreqScope.new;
)

(
{
	var sig, mod;
	mod = MouseX.kr(20,2e4,1).poll;
	LFSaw.ar(mod, mul: 0.3); //Al no limitar los armónicos que produce se genera un fenomeno de "folding" del espectro.
}.scope;
)


//Onda Cuadrada.
//Suma todos los armonicos inpares con una amplitud de 1/n inpar.
"https://computermusicresource.com/squarewave.tutorial.html".openOS;
(
var iter = 3;
{
	var sig;
	sig = iter.collect({
		arg i;
		var freq = 100;
		i = (i*2) + 1; //En el caso de la onda cuadrada hacemos un ajuste al indice para que solo utilice los armónicos inpares.
		//i.postln;
		SinOsc.ar(freq * i, mul: 1/i);
	});
	sig ++ sig.sum;

}.plot(100.reciprocal)
.plotMode_(\plines)
.plotColor_(((iter).collect({Color.black})++[Color.red]))
.superpose_(true);
)

//Versiones UGen

//Pulse es el UGen versión "Bandas Limitadas".
{Pulse.ar(110)}.plot(110.reciprocal * 2);

//LFPulse es la versión ilimitada
{LFPulse.ar(110)}.plot(110.reciprocal * 2);

//¿Se replicará el caso de la diente de sierra?

/*///////////////////////////////
//Otras formas de sumar con .do//
*////////////////////////////////

//Podemos utilizar metodos de iteración para sumar procesos en el servidor.
(
{
	//Toda variable que no tiene un valor por defecto se inicializa = a nil. nil no acepta operaciones matematicas.
	//ejemplo: (var x; x.postln) (nil + 2)
	var sig = 0; //sig se encargará de almacenar el proceso y tiene que ser igual a 0 al inicio para poder sumarse a sí mismo.
	var freq = Array.geom(5,100,2); //Creamos un arreglo sobre el cual vamos a iterar con el metodo .geom.

	freq.do({ //iteramos sobre los valores del arreglo.
		arg it, in; //El primer argumento es el elemento (item) y el segundo el indice (index).
		sig.postln;
		sig = sig + SinOsc.ar(it, mul: (in+1).reciprocal) * -3.dbamp;
	});

	sig = sig!2;
}.scope;
)

//Ejemplos con sonido y el metodo .collect

/*////////////////////////////////////
//Otras formas de sumar con .collect//
*/////////////////////////////////////

//similar a .do pero en lugar de entregar como resultado a si mismo, entrega un arreglo producto de la función.
~x = 10.collect({arg i; i.postln});
~x;

//Sobre arreglos igual contempla dos argumentos.
~x = [100,200,300,400,500].collect({arg it, in; [it,in].postln});
~x;

(
{
	var sig;  //ahora sig va a resultar en un arreglo.
	var freq = Array.rand(10,60,72).midicps; //Creamos un arreglo utilizando el metodo .rand

	sig = freq.collect({ //sig será igual al arreglo resultante por la iteración de .collect
		arg it, in; //Item, Index.
		SinOsc.ar(it, mul: (in+1).reciprocal * -12.dbamp);
	});

	sig.postln; //Vemos que hay dentro de sig

	sig = sig.sum; //el metodo .sum sobre un arreglo suma todos los valores contenidos. [1,1,1,1,1].sum;

	sig = sig!2;
}.scope
);

/*///////////////
//El objeto Mix//
*////////////////

//Recordemos que SC interpreta un arreglo como una expansión multicanal.
(
{
	var sig, freq;
	freq = Scale.dorian.ratios * 110; //Arreglo compuesto de la escala dorica a partir de la freq 110.
	sig = freq.collect({ //Iteramos sobre el arreglo.
		arg it,in;
		SinOsc.ar(it * (in+1), mul: freq.size.reciprocal);
	});
	sig; //Omitimos el metodo .sum
}.scope; //Podemos ver varias señales con diferentes frecuencias pero solo escuchamos 2.
)

//Ahora incorporamos el objeto Mix para sumar las señales.
(
{
	var sig, freq;
	freq = Scale.dorian.ratios * 110;

	sig = freq.collect({
		arg it,in;
		SinOsc.ar(
			it * (in+1)
			//* {rrand(0.99,1.01)}!2 //y la expansión multicanal?
			, mul: freq.size.reciprocal);
	});
	sig.postln;
	sig = Mix(sig); //Utilizamos mix para sumar todo a un canal.
	sig.postln;
}.scope;
)

//Mix tiene un metodo (.fill) que nos permite definir una función y realizar una suma del arreglo que la función genere.

(
{
	var sig;
	var freq = Array.rand(10,0,12); //creamos un arreglo de frecuencias en MIDI.0-12.

	sig = Mix.fill(freq.size, {
		arg i; //al igual que Array.fill, mix tiene un argumento i que representa el indice.
		var f = freq[i] + ((i + 3) * 12); //tomamos el valor i del arreglo.
		SinOsc.ar(f.midicps) * 10.reciprocal * -6.dbamp;
	});
	sig.postln;
	sig!2;
}.scope;
);

//Expansión Multicanal.

(
{
	var sig;
	var freq = Array.rand(10,0,12);
	Mix.fill(10,{
		arg i;
		var f = freq[i] + ((i + 3) * 12);
		SinOsc.ar(
			{f.midicps * Rand(0.9,1.1)}!2 //Utilizamos una función para expresar que el contenido dentro se va a ejecutar 2 veces.
		) * 10.reciprocal * -6.dbamp;
	});
}.scope;
)

//Algunos UGens para sintesis aditiva.

//Blip : Generador de impulsos con bandas limitadas.
//Blip.ar(frecuencia, numero de armónicos, mul, add);
(
{
	var sig, mod;
	mod = SinOsc.kr(0.1, {Rand(0,pi)}!2).range(1,200);
	sig = Blip.ar(freq: 220, numharm: mod);
}.scope;
)

//Klang : Banco de osciladores Sin con frecuencias fijas. No es flexible!
//Klang.ar( Arreglo (Ref) de arreglos que especifica: [[frecuencias], [amplitudes], [fases]], factor escalar para freq, offset de frecuencias).
//Para indicar el arreglo sin generar expansión multicanal se utiliza una clase especial llamada Ref.

//Ref
Ref
//Previene expansión multicanal.

(
{
	var sig, ref;
	ref = Ref.new([
		[1,2,3,4,5] * 100,
		[1,2,3,4,5].normalizeSum,
		{Rand(0,2pi)}!5
	]);
	sig = Klang.ar(specificationsArrayRef: ref, freqscale: rrand(1.0,4.0));
	sig!2 * -6.dbamp;
}.scope
)

//DynKlang : similar a Klang con la diferencia de que se pueden modificar sus valores posterior a la inicialización.

//Podemos abreviar la creación de un Ref mediante una coma invertida. (`)
`[].class;

(
{
	var ref;
	var iter = 5;
	ref = `[
		Array.rand(iter, 100, 200),
		Array.rand(iter, -12.dbamp,-3.dbamp) * iter.reciprocal,
		Array.interpolation(iter,0,2pi);
	];

	DynKlang.ar(ref, SinOsc.kr({rrand(0.4,0.5)}!2, {rrand(0,pi)}!2).range(0.5,16));
}.scope;
)

/*//////////////////////
//Sintesis sustractiva//
*///////////////////////

/*
Del otro lado del espectro de la complejidad tenemos otra aproximación a la sintesis, la cual en lugar de comenzar con una señal simple, se aproxima desde el maximo estado de la complejidad,
el ruido.

En lugar de sumar señales simples ahora buscaremos substraer elementos de una señal compleja. Similar a lo que haría un escultor.

Para realizar está acción existen los filtros.
*/

//Existen muchos tipos de filtros con diversas topologias y aplicaciones, pero para fines practicos nos enfocaremos en una selección: [LPF, HPF, BPF, BRF, RLPF, RHPF, MoogFF]

//Todos los filtros tienen (casi siempre) los mismos argumentos.

/*
in: Señal a ser procesada.
freq: Frecuencia de corte. Lugar en el espectro de frecuencias donde el filtro empieza a hacer efecto.
rq: Factor de calidad. Indice que refiere a la proporción entre la frecuencia central y el ancho de banda. No aplica en todos los casos.
*/

//Para ejemplificar el efecto de los filtros usaremos un generador de ruido blanco
//El ruido blanco es el resultado de todas las frecuencias audibles con igualdad de intensidad.
{WhiteNoise.ar(1)}.plot(0.001);

{WhiteNoise.ar(0.1)}.scope;

//LPF : Low Pass Filter ó Fitro Pasa Graves.
//Reduce la amplitud de todas las frecuencias por encima de la frecuencia de corte.

//LPF.ar(Señal a ser afectada, frecuencia de corte) no tiene factor de cualidad.
(
{
	LPF.ar(
		in: WhiteNoise.ar(0.6),
		freq: MouseX.kr(20,12e3).clip(20,12e3)
	)
}.scope;
FreqScope.new;
)


RLPF.ar
Resonz

WhiteNoise

PinkNoise

Filtros



