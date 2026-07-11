//Rutinas 2.

//Una rutina también puede ser una serie de aprocesos que se activen de acuerdo a un comando.
(
~exemplo = Routine({ //abrimos una rutina.
	var x = 0; //declaramos la variable x = 0.

	loop({ //abrimos un loop dentro de la rutina.
		("Soy una rutina en mi ciclo" + x ).yield; //usamos yield igual que .wait

		x = x+1; //aumentamos el valor de x por 1.
	});
});
)

~exemplo.next; //utilizo el metodo .next para llamar al siguiente valor.

~exemplo.reset; //también podemos resetear el proceaso.
~exemplo.stop; //.stop detiene el proceso y lo asesina :(

//Patrones.
Pattern

//Una librería compleja dedicada a la secuenciación en contextos musicales.
//Un objeto de la clase Pattern es como una partitura, en el sentido de que es una serie de instrucciones que por si mismas no pueden ejecutar nada.

/*///////////////////////////////////////////////
//Patterns define behavior; streams execute it.//
*////////////////////////////////////////////////

//Al evaluar el objeto Pseq, solo nos regresa el mismo (similar a las funciones).
x = Pseq([1,2,3,4,5,9], 1);

//cuando evaluamos el metodo .asStream, le indicamos al patron opere como una secuencia, o rutina.
y = x.asStream;

//ahora y, obedece al metodo .next
y.next;

//una vez que se termina la secuencia el metodo .reset reanuda la operación.
y.reset;

//Comparemos un Pseq con una versión descrita como Routine

a = [1,2,3,4,5,9]; //guardamos en "a" un arreglo

~pat = Pseq(a,1);
~str = ~pat.asStream;

~rout = Routine({
	a.do({arg it; it.yield}); //.yield y .wait hacen lo mismo, entregar el valor sobre el que están funcionando.
});

(
~str.next.postln;
~rout.next.postln;
)

(
~str.reset;
~rout.reset;
)

//hagamos un ejemplo aplicado.

~freq = (Scale.major.semitones + 60).midicps; //Escala mayor de C en Hz como un arreglo.

~pattern = Pseq(~freq,inf); //lo introducimos a un Pseq con un valor de repetición inf.
~stream = ~pattern.asStream; //lo embebemos en un stream

~sig = {SinOsc.ar(\freq.kr) * XLine.ar(1,0.000001,0.25,doneAction: 2)}; //sintetizador con envolvente.

(
~routine = Routine({ //abrimos una rutina.
	var freq, sig; //creamos 2 variables freq y sig.
	inf.do{ //abrimos un ".do" sobre infinito (similar a loop).
		freq = ~stream.next; //a la variable local le asignamos el siguiente valor del stream.
		freq.postln; //aquí se reporta en la post.
		sig = ~sig.play(args:[\freq, freq]); //sobre la variable sig guardamos la reproducción del sinte ~sig y le asignamos como argumento de inicio el valor en freq.
		rrand(0.1,0.2).wait; //Como con loop, es importante indicar un tiempo de .wait. En este caso es aleatorio entre 0.1 y 0.2.
	};
});
)
~routine.play; //reproducimos la rutina.

~routine.stop; //detiene la rutina.

(
~routine.reset; //resetea la rutina.
~routine.play; //vuelve a reproducir la rutina desde donde se quedo.
)

//podemos resetear también el stream del patron.
~stream.reset;

~routine.stop;


/*/////////////////////////////////////////////////////////////////
//Lista de patrones más comunes para generar secuencias numéricas//
*//////////////////////////////////////////////////////////////////

/*
Pseq
Da como resultado los valores de un arreglo, respetando el orden del mismo. Puede repetirse y desfazarse por medio de sus argumentos.
*/

~pat_1 = Pseq([1,2,3,4,5,9],2,2);
~sec_1 = ~pat_1.asStream;
~sec_1.next;
~sec_1.reset;

/*
Pwhite
Valores aleatorios de distribución uniforme entre un número mínimo y un número máximo especificados.
*/

~pat_2 = Pwhite(0.23,10,10);
~sec_2 = ~pat_2.asStream;
~sec_2.next.round(0.01);
~sec_2.reset;

/*
Pexprand
Valores aleatorios con distribución exponencial entre un número mínimo y un número máximo especificados.
*/

~pat_3 = Pexprand(0.23,10,inf);
~sec_3 = ~pat_3.asStream;
~sec_3.next.round(0.01);
~sec_3.reset;

/*
Pbrown
Valores aleatorios entre un número mínimo y un número máximo especificados, sin embargo, los nuevos números solo se desvían del anterior por un intervalo máximo especificado.
*/

~pat_4 = Pbrown(1,1000,100,inf);
~sec_4 = ~pat_4.asStream;
~sec_4.next.round(0.01);
~sec_4.reset;

/*
Prand
Secuencia los valores de un array de manera aleatoria
*/

~pat_5 = Prand([\gato,3,5,\perro, \pato,999],inf);
~sec_5 = ~pat_5.asStream;
~sec_5.next;
~sec_5.reset;

/*
Pxrand
Secuencia los valores de un array de manera aleatoria, pero nunca repite el mismo ítem uno después del otro.
*/

~pat_6 = Pxrand([\gato,3,5],inf);
~sec_6 = ~pat_6.asStream;
~sec_6.next;
~sec_6.reset;

/*
Pwrand
Secuencia los valores de un arreglo de manera aleatoria, poniendo más probabilidades a ciertos elementos por medio de un arreglo adicional cuyos valores deben sumar 1;
*/

~pat_7 = Pwrand([\gato,3,5,\perro, \pato,999],[70,100,50,100,60,30].normalizeSum,inf);
~sec_7 = ~pat_7.asStream;
~sec_7.next;
~sec_7.reset;

/*
Pseries
Secuencia una serie aritmética. Se especifica un número inicial y el factor de incremento.
*/

~pat_8 = Pseries(0,3,inf);
~sec_8 = ~pat_8.asStream;
~sec_8.next;
~sec_8.reset;

/*
Pgeom
Secuencia una serie geométrica. Se especifica un número inicial y el factor de multiplicación.
*/

~pat_9 = Pgeom(8,2,inf);
~sec_9 = ~pat_9.asStream;
~sec_9.next;
~sec_9.reset;

/*
Pshuf
Secuencia una serie geométrica. Se especifica un número inicial y el factor de multiplicación.
*/
~pat_10 = Pshuf([1,2,3,4,5],inf);
~sec_10 = ~pat_10.asStream;
~sec_10.next;
~sec_10.reset;

/*//////////////////////////
//Operaciónes con PATRONES//
*///////////////////////////

//Podemos realizar operaciones entre patrones.

~pat_11 = Pseq([10,20,30,40,50,60,70,80,90],inf) * Prand([-1,1],inf);
~seq_11 = ~pat_11.asStream;
~seq_11.nextN(10);
~seq_11.reset;

//Cuando la operación involucra una secuencia la operación se realiza un elemento a la vez ignorando posicisiones. Cuando la cantidad de valores por secuencia no coincide, estos se desplazan.

~pat_12 = Pseq([10,20,30],inf) + Pseq([1,2,3,4],inf);
~seq_12 = ~pat_12.asStream;
~seq_12.nextN(10);
~seq_12.reset;

//Patrones anidados.
//Una funcionalidad muy poderosa de los patrones es que es posible anidarlos, ie. poner patrones dentro de patrones.

(
~pat_13 = Pseq(
	[
		Pseq([1,2,3],1),
		Prand([-10,10],1),
		Pshuf([\perro, \gato, \vaca],1),
		Pwhite(-1.0,1.0,1)
	],
	inf
);
)

~seq_13 = ~pat_13.asStream;
~seq_13.next;
~seq_13.reset;

/*//////////
//El Pbind//
*///////////

//Eventos
Event

//Es una colección de pares de "claves" y valores. ie cada valor es llamado por una clave. Similar a un diccionario.

~evento = (freq: 220, dur: 0.5); //Creamos un evento con dos "claves". \freq asociada al valor 220 y \dur asociada al valor 0.5.

~evento[\freq]; //Podemos recuperar el valor de una clave llamando al evento e indicando su clave entre [].
~evento.freq; //Funciona igual si llamamos con la clave como metodo.

~evento[\freq] = 880; //podemos modificar el valor de cada clave asignandole uno nuevo.
~evento[\freq];

~evento.put(\amp, 0.5);//Es posible añadir claves y valores sobre la marcha.
~evento;

//Los eventos son una clase de colección muy particular ya que cuentan con muchos comportamientos y propiedades predefinidos lo cual los vuelve  una clase muy robusta.
~evento.play;

().play; //Incluso el evento menos descrito tiene un comportamiento.

//Pbind
Pbind
// Objeto que combina varios streams en un solo "evento".

(
~pbind = Pbind( //Creamos un objeto Pbind.
	\freq, Pseq([60,64,66,68,71].midicps,1), // asignamos a la clave \freq el Pattern Pseq.
	\dur, Pseq([0.5,0.25,0.5,0.5,0.25,0.25,1],1) //ahora asignamos a la clave \dur otro pattern Pseq con un tamaño diferente.
);

~pbindStream = ~pbind.asStream; //Convertimos en stream
)

~pbindStream.next(Event.new); //llamamos el siguiente valor con .next(Event.new).
~pbindStream.reset;

//Que está sucediendo cada vez que evaluamos .next?

~eventStreamPlayer = ~pbind.play; //Al reproducir un Pbind con el metodo .play se crea un objeto especial llamado EventStreamPlayer que se encarga de gestionar varias cosas de la reproducción del Pbind.

//OJO, hasta este punto no hemos creado ningun Synth!

(
~ejemplo0 = Pbind(
	\dur, Pseq([0.75,0.5,0.5,0.25,0.75,0.5,0.5,0.25,0.25,0.25,0.25,1],1)
	\freq, Pseq([60,64,66,69,67,64,60,57,54,54,54,55].midicps,1),
);
~ejemplo0.play;
)

//y los silencios?

//Rest : Recibe como argumento un numero que representa la cantidad de tiempo. Indica que el evento en cuestión es un descanzo o silencio.
(
~ejemplo1 = Pbind(
	\dur, Pseq([0.25,0.25,0.25,2,Rest(rrand(1,3))],2), //Usamos la clase Rest
	\freq, Pseq([67,67,67,63,63,65,65,65,62,62].midicps,1),
).trace; //el metodo .trace nos ayuda a monitorear los valores del evento.
~ejemplo1.play;
)

//Symbol.

(
~ejemplo2 = Pbind(
	\dur, Pseq([0.25],inf), //repeticiones infinitas
	\midinote, Pseq([55,55,55,55,60,\rest,\r,\],inf), //Ahora las alturas las define la clave \midinote.
).trace; //ahora los silencios estan siendo determiados al colocar simbolos en alguna clave que no sea dur:
~ejemplo2.play;
)

//Para mas información de las claves disponibles para un evento por default visita el archivo de ayuda:

Event

/*/////////////////////////
//COMBO: SynthDef + Pbind//
*//////////////////////////

//Es posible correr un SynthDef a travez de un Pbind.
().play; //Existe una clave llamada 'instrument' el cual determina el "instrumento" que va a utilizar el Pbind para generar sonido y a su vez claves.
//Consideremos el siguiente SynthDef.
(
SynthDef.new(\pbind,{
	arg freq, amp, atk, rel; //Fijate en todos los argumentos definidos. Mas adelante serán nuestras claves.
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction: 2);
	sig = SinOsc.ar(freq, mul: amp);
	// sig = Saw.ar({freq, amp);
	sig = sig * env;
	Out.ar(0,sig!2);
}).add;
)
//Creamos un Pbind.
(
~pat = Pbind(
	\instrument, \pbind,
	\freq, Pseq([60,60,67,67,69,69,67].midicps,1),
	// \midinote, Pseq([60,60,67,67,69,69,67],1),
	\amp, Pseq([0.75,0.2],4),
	\atk, 0.125,
	\rel, 0.125,
	\dur, 0.5,
);
~seq = ~pat.play;
)

(
~pat = Pbind(
	\instrument, \pbind,
	\midinote, Pshuf((60,62..72),inf),
	\amp, Prand((0.125,0.5..1),inf),
	\atk, 0.1,
	\rel, 0.15,
	\dur, 0.25,
);
)
~seq = ~pat.play;
~seq.stop;
~seq.play;
~seq.reset;

~seq.unmute;

~seq.pause;
~seq.resume;

(
~seq.stream = Pbind(
	\instrument, \pbind,
	\midinote, Prand([60,61,67,69,70],inf)+0.5.ratiomidi,
	\amp, Prand((0.125,0.5..0.75),inf),
	\atk, Prand([0.01,0.5],inf),
	\rel, 0.15,
	\dur, Pseq([0.125],inf),
).asStream;
)
