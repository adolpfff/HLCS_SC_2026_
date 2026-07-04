//SuperCollider
//27_02_2025
//Secuenciación
/*
Routine
TempoClock
Patterns
Eventos
*/

Routine;

//Activación del codigo es casi inmediata.
(
var sigA, sigB,sigC; //3 Synths.
sigA = {SinOsc.ar(60.midicps) * 0.2};
sigB = {SinOsc.ar(64.midicps) * 0.2};
sigC = {SinOsc.ar(67.midicps) * 0.2};

//La ejecución de cada linea es secuencial pero es tan rapido que parece simultanea.
f = {
	sigA.play;
	sigB.play;
	sigC.play;
};
);

f.(); //Escuchamos un acorde.

//Una Rutina es una clase que opera dentro del tiempo.
//Se le indica una clase y utilizando el metodo ".wait" o ".yield" se detiene.

(
var sigA, sigB,sigC;
sigA = {SinOsc.ar(60.midicps) * Line.kr(0.5,0,1)};
sigB = {SinOsc.ar(64.midicps) * Line.kr(0.5,0,1)};
sigC = {SinOsc.ar(67.midicps) * Line.kr(0.5,0,1)};

f = {
	sigA.play;
	1.wait; //Intercalamos entre cada linea un valor de espera.

	sigB.play;
	1.wait;

	sigC.play;
	1.wait;
};
);

r = Routine.new(f); //Colocamos la rutina en una variable.

r.play; //el metodo ".play" ahora reproduce las esperas entre cada linea.

r.reset; //".reset" resetea la rutina.

r.next; //".next" reproduce cada linea por separado.

//Una rutina no solo sirve para secuenciar sonido, tambien procesos.

(
f = {
	var num = 0;
	while(
		{num < 10},
		{
			num.yield; //".wait"
			num = num + rrand(1,3);
		}
	)
}
);

r = Routine(f);
r.next;
r.reset;

//////////////////Synth dentro de una rutina.

(
SynthDef(\routine, {
	arg freq, dur;
	var sig, env;

	env = XLine.ar(1,0.00001,dur, doneAction: 2); //Envolvente
	sig = SinOsc.ar(freq); //Señal
	sig = sig * env * 0.33; //Amplitud

	Out.ar(0,sig!2);//Salida de audio
}).add;

f = {
	Synth(\routine, [\freq, rrand(36,48).midicps, \dur, 1]); //Elige una fq entre 36 y 48 midi
	1.wait;
	Synth(\routine, [\freq, rrand(60,72).midicps, \dur, 0.5]);//Elige una fq entre 60 y 72 midi
	0.5.wait;
};

r = Routine(f); //almacenamos la funcion en la rutina

r.play; //reproducimos la rutina.

);

(
r.reset;
r.play;
)
//////////////////Iteración dentro de una rutina.

3.do{arg i; (i*3).postln};

(
SynthDef(\routine, {
	arg freq, dur;
	var sig, env;

	env = XLine.ar(1,0.00001,dur, doneAction: 2); //Envolvente
	sig = SinOsc.ar(freq); //Señal
	sig = sig * env * 0.33; //Amplitud

	Out.ar(0,sig!2);//Salida de audio
}).add;

f = {
	3.do{ //Iteramos una parte de la rutina.
		var w;
		w = rrand(0.1,0.4); //tiempo de espera aleatorio.
		Synth(\routine, [\freq, rrand(36,48).midicps, \dur, 1]); //Elige una fq entre 36 y 48 midi
		w.wait;
	};

	[60,63,67].do{ //Iteramos sobre un arreglo.
		arg it;
		Synth(\routine, [\freq, it.midicps, \dur, 0.5]);//Elige una fq entre 60 y 72 midi

	}; //Al no incluir ".wait" dentro de la iteración, realiza el proceso tan rapido como sea posible.

	0.5.wait;
};

r = Routine(f); //almacenamos la funcion en la rutina

r.play; //reproducimos la rutina.

);

(
r.reset;
r.play;
)

//////////////////Loop

(
SynthDef(\routine, {
	arg freq, dur;
	var sig, env;

	env = XLine.ar(1,0.00001,dur, doneAction: 2); //Envolvente
	sig = SinOsc.ar(freq); //Señal
	sig = sig * env * 0.33; //Amplitud

	Out.ar(0,sig!2);//Salida de audio
}).add;

r = Routine({
	loop({ //Loop recicla la rutina.
		3.do{
			w = rrand(0.1,0.4);
			Synth(\routine, [\freq, rrand(36,48).midicps, \dur, 1]); //Elige una fq entre 36 y 48 midi
			w.wait;
		};

		[60,63,67].do{
			arg it;
			Synth(\routine, [\freq, it.midicps, \dur, 0.5]);
		};
		0.5.wait;
	})
});
);

(
r.reset;
r.play;
);

r.resume;
r.stop;


//////////////////Ejemplo

(
SynthDef(\routine, {
	arg freq, dur;
	var sig, env;

	env = XLine.ar(1,0.00001,dur, doneAction: 2); //Envolvente
	sig = SinOsc.ar(freq); //Señal
	sig = sig * env * 0.33; //Amplitud

	Out.ar(0,sig!2);//Salida de audio
}).add;

r = Routine({
	loop({ //loop
		var num = 60, w = 0.25, x; //tres variables

		w = [1/16,1/8,1/4].choose; //elegimos una duración "w".

		while( //Mientras..
			{num < 73}, //num sea menor a 73.
			{ //repite la siguiente función.
				Synth(\routine, [\freq, num.midicps, \dur, w * 4]); //toca la nota "num".
				num = num + rrand(1,2); //suma un valor entre 1 y 2 a "num".
				w.wait; //espera un tiempo "w".
			};
		);

		num.postln; //se conserva el ultimo valor de num.
		if(0.25.coin, //tira una moneda (50/50 es true o false).
			{ //Si True:
				while( //Mientras ..
					{num > 60}, //num sea mayor a 60 ..
					{
						Synth(\routine, [\freq, num.midicps, \dur, w]); //toca la nota "num"
						num = num - rrand(1,2); //resta un valor entre 1 y 2 a "num"
						w.wait;  //espera un tiempo w.
					};
				);
			},
			{ //Si False:
				x = [63, 64].choose;
				rrand(1,2).do{ //Repite una o dos veces.
					[60,x,67].do{ //Toca 60, (63 o 64), y 67 muy rapido.
						arg it;
						Synth(\routine, [\freq, it.midicps, \dur, 1]);
					};
					0.5.wait;
				};
			}
		);
	})
});
);

(
r.reset;
r.play;
)
//////////////////Ejemplo

(
SynthDef(\routine, {
	arg freq, dur;
	var sig, env;

	env = XLine.ar(1,0.00001,dur, doneAction: 2); //Envolvente
	sig = SinOsc.ar(freq); //Señal
	sig = sig * env * 0.33; //Amplitud

	Out.ar(0,sig!2);//Salida de audio
}).add;

k = Routine({
	loop{
		(0,1..100).do{
		arg it;
			it.linexp(0,100,0.1,0.25).yield;//.wait
		}
	}
});

r = Routine({
	loop({ //loop
		var scale;
		scale = Scale.choose(7).degrees;

		scale.do{
			arg it, in;
			it = 60 + it;
			Synth(\routine, [\freq, it.midicps, \dur, 1]);
			k.next.wait;
		};
	});
}
);
)

(
r.reset;
r.play;
)



