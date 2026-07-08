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

