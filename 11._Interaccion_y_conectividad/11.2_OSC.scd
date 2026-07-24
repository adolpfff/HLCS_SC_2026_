/*
COMUNICACIÓN OSC EN SC

Open Sound Control (OSC) es una especificación de comunicación entre aplicaciones y/o hadware. Fue publicado en 2002 y está diseñado para cumplir los mismos propósitos de MIDI con mayor flexibilidad y personalización. Está optimizado para protocolos modernos de transmisión de datos en redes.

En luagar de mensajes preconfigurados como noteOn, noteOff, control, etc. OSC utiliza una dirección OSC personalizable con una sintaxis similar a la de una URL. En seguida, se encuentran los datos comunicables separados por una coma.

Ej. ['/osciladores/sierra', 220, 220.2313343, 221.05]

*/

/*
OSC es de hecho, el lenguaje de comunicación entre sclang y scsynth.

Para imprimir los mensjaes OSC enviados y recibidos por el servidor usamos:
s.dumpOSC(1);

Para enviar directamente mensajes osc al servidor usamos el método sendMsg

s.sendMsg("/quit");
s.sendMsg("/dumpOSC",1);
s.sendMsg("/n_run",1009,1);
s.sendMsg("/n_free",1009);

Una lista útil de comandos OSC del servidor puede consultarse en el archivo de ayuda:

Server Command Reference
*/

/*
Para recibir mensajes de otr dispositivo, la opción más práctica es tener ambos dispositivos conectados a la misma red local.

Para hacerlo, el remitente necesita la dirección IP local asignada a nuestra computadora y el puerto receptor del destinatario.

Podemos consultar nuestra dirección IP local y el puerto en el cuál está escuchando SC los mensajes OSC externos con las línea de código:
*/

NetAddr.localIP;
NetAddr.localAddr.postln;

NetAddr.port

NetAddr.localIPs('ipv4');

s.options.port
OSCFunc.trace(true);

thisProcess.openUDPPort(8000);

OSCdef(\osc,{arg msg; msg.postln},'/freq',recvPort: 8000);


~miIP = NetAddr.localIP("192.168.1.1");







s.dumpOSC(0);
3x8

{SinOsc.ar(mul: 0.3)}.play;







*/

//Estructura de un mensaje MIDI:
(

var ventana, img;

img = Image.open(thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "midi_bytes.jpg");

ventana = Window("Estructura de un mensaje MIDI", img.bounds + [500,500,0,0]);

UserView(ventana,ventana.view.bounds).drawFunc_({img.drawInRect(img.bounds)});

ventana.front;
);

/*
El primer byte es llamado byte de estatus y comienza con un bit con valor de 1 para comunicar esto.

Los segundos dos bytes son llamados bytes de datos y comienzan con un bit en valor de 0 para comunicarlo.

Si un bit de cada byte ya está ocupado, nos quedan 7 bits disponibles para representar valores. Si cada bit tiene dos posibles valores tenemos en total 128 combinaciones posibles para cada byte.
*/

2*2*2*2*2*2*2;
//o
2.pow(7);

//El byte de status se divide en dos: los primeros tres bits disponibles después del 1 especifican la acción

2*2*2 //Número de acciones disponibles

//Las acciones disponibles más frcuentes y felixbles son:
(

var ventana, img;

img = Image.open(thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "acciones_MIDI.png");

ventana = Window("Mensajes MIDI disponibles", img.bounds + [200,200,0,0]);

UserView(ventana,ventana.view.bounds).drawFunc_({img.drawInRect(img.bounds)});

ventana.front;
);

//Los segundos cuatro bits representan el canal al cual mandar los datos

2.pow(4); //Número de canales disponibles para envío de información

//En MIDI tenemos diferentes tipos de mensajes, los más comunes son noteOn, noteOff y control change (cc). El protocolo MIDI expresa sus parámetros en 128 valores a través de 16 canales.


//Para mapear MIDI en SC primero tenemos que establecer conexión con el subsistema MIDI de nuestra computadora. Para esto usaremos la clase MIDIClient y el método .init , lo cual nos dará además una lista de los dispositivos MIDI conectados a nuestra computadora.
MIDIClient.init;

/*
Para conectar un dispositivo primero debemos decidir qué queremos hacer con él.

Si lo que queremos es recibir mensajes MIDI usamos la clase MIDIIn.

Si lo que queremos es mandar mensajes MIDI usamos la clase MIDIOut

Veamos ambas posibilidades:

1) Recibir mensajes MIDI
Para conectar todos los dispositivos usaremos el método .connectAll.
*/

MIDIIn.connectAll;
//Para conectar selectivamente un dispositivo, usaremos su índice dentro del arreglo de MIDIClient.sources
MIDIClient.sources;
MIDIClient.sources.at(3);
MIDIClient.sources[1]; //Sintaxis
MIDIIn.connect(device: MIDIClient.sources[4]);

//Una vez conectado algun dispositivo podemos comprobar y monitorear si estamos recibiendo mensajes MIDI:
MIDIFunc.trace(true); //Activa la impresión de los datos MIDI recibidos en la ventana de posteo.
MIDIFunc.trace(false);//Desactiva la impresión de los datos MIDI recibidos en la ventana de posteo.

//Para desconectar todos los dispositivos o alguno en específico utilizamos la misma sintaxis que usamos para conectarlos, unicamente sustituyendo los métodos .connectAll y .connect por .disconnectAll y .disconnect
MIDIIn.disconnectAll;
MIDIIn.disconnect(device: MIDIClient.sources[2].postln);

/*
Si queremos que SC realice acciones en respuesta a un mensaje MIDI entrante, utilizamos definiciones MIDI.

Las definiciones MIDI registran funciones a realizarse cuando se recibe un mensaje MIDI. Se crean con la clase MIDIdef.

MIDIdef responde a los mensajes MIDI más comunes por medio de los métodos .noteOn, .noteOff, y .cc . Para una recepción general de diferentes mensajes usamos el método .new

La lista completa de métodos se puede consultar en la ayuda de esta clase.
*/

/*Para el siguiente ejemplo usaremos el método .cc. Sus argumentos son:

1) key: Symbol identificador de la definción
2) func: Función que se ejecutará cuando se reciba el mensaje MIDI que nosotros especifiquemos.
3) ccNum: Número de mensaje de control
4) chan: Canal específico del cuál detecar mensajes.
5) srcID: Número correspondiente al identificador del dispositivo a utilizar. Por defecto es nil, lo cuál implica que se lea al mismo tiempo de todos los dispositivos conectados.
6) argTemplate: Argumento opcional consistente en un entero o una función que responde a la comparación con los datos de los mensajes MIDI entrantes, si esa comprobación es verdadera, se ejecuta la función derivada de nuestra definción MIDI.
*/

(
MIDIdef.cc( //Método .cc Responderá filtrando únicamente los mensajes cc.
	key: \primerMIDIdef,
	func: {{ //Función
		var sigs;
		sigs = 100.do({
			Saw.ar(rrand(180, 239))});
		Splay.ar(sigs);
}.play},
	ccNum: 48,
	chan: 0,
	argTemplate: {arg val; val == 100};

);
)


/*
Si lo que buscamos es mayor felxibilidad, podemos ocupar el método .new Sus argumentos son los siguientes:

1) key: Symbol identificador de la definción
2) func: Función que se ejecutará cuando se reciba el mensaje MIDI que nosotros especifiquemos.	Cuando se configura para recibir mensajes  noteOn, noteOff, control y polytouch, estos pasan sus argumentos val, num, chan o src a la función a ejecutarse si es que queremos utilizarlos.
3) msgNum: Entero indiando el número de un mensaje
4) chan: Entero indicando el canal del cuál leer. Puede ser un array. Si es nil lee todos los canales.
5) msgType: Un symbol indicando el tipo de mensajes MIDI a recibir. Las posibilidades son: \noteOn, \noteOff, \control, \touch, \polytouch, \bend, \program, \sysex, \mtcQF, \smpte, \songPosition, \songSelect, \tuneRequest, \midiClock, \sysrt, \tick, \start, \continue, \stop, \activeSense, y \reset.
6) srcID: identificador numérico del dispositivo a leer. Si es nil recibe mensajes de cualquier dispositivo.
*/

(
var chanls = rrand(1,16);

MIDIdef.new(
	key: \tiroAlBlanco,
	func: {"¡Diste en el blanco!".postln},
	msgNum: Array.fill(rrand(3,8), {rrand(0,127)}),
	chan: Array.series(chanls, 0, 1),
	msgType: [\noteOn, \noteOff, \control, \touch, \polytouch, \bend, \program, \sysex, \mtcQF, \smpte, \songPosition, \songSelect, \tuneRequest, \midiClock, \sysrt, \tick, \start, \continue, \stop, \activeSense,\reset].scramble[..rrand(5, 10)]
	);
)



3) ccNum: Número de mensaje de control
4) chan: Canal específico del cuál detecar mensajes.
5) srcID: Número correspondiente al identificador del dispositivo a utilizar. Por defecto es nil, lo cuál implica que se lea al mismo tiempo de todos los dispositivos conectados.
6) argTemplate: Argumento opcional consistente en un entero o una función que responde a la comparación con los datos de los mensajes MIDI entrantes, si esa comprobación es verdadera, se ejecuta la función derivada de nuestra definción MIDI.
MIDIdef.new(
	key: \ctrlNew,
	func: {{Saw.ar(Array.fill(2,{rrand(220,250)}),0.3) * Env.perc.kr(2)}.play},
	ccNum: 0,
	chan: 1 ,
	argTemplate: {arg val; val == 127}
);

MIDIdef.new( //Método .new
	key: \ctrlNew,
	func: {{Saw.ar(Array.fill(2,{rrand(220,250)}),0.3) * Env.perc.kr(2)}.play},
	ccNum: 0,
	chan: 1,
	argTemplate: {arg val; val == 127}
);

MIDIdef.cc( //Método .cc
	key: \ctrlCC,
	func: {{Saw.ar(Array.fill(2,{rrand(220,250)}),0.3) * Env.perc.kr(2)}.play},
	ccNum: 0,
	chan: 1,
	argTemplate: {arg val; val == 127}
);

//El siguiente sintetizador posee varios parámetros modulables, para el ejemplo escogeremos la frecuencia base (expresada en números MIDI) y la frecuencia moduladora(expresada en HZ):

(
SynthDef(\phonk, {
	arg midiNote = 60, amp = 0.4, modFreq = 5, gate = 1;
	var env, sig, sig1, sig2, sig3, offsets, mod, rev;

	env = Env.asr().kr(2,gate);

	offsets = [ -0.4, 0, 0.4];

	mod  = SinOsc.ar(modFreq).range(0,1);

	sig1 = offsets.collect{ |off|
		Saw.ar((midiNote - 5).midicps + off, mod )};

	sig2 = offsets.collect{ |off|
		Saw.ar((midiNote - 12).midicps + off, mod)};

	sig3 = Saw.ar(midiNote.midicps, mod);

	sig = (sig1 + sig2 + sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev!2);

}).add
)

~phonkP = Synth(\phonk); //Prender el sintetizador
~phonkP.set(\gate,0);//Apagar el sintetizador


/*Escogeremos un rango de valores para mapear a su equivalente a 0 a 127. En este caso utilizaremos los números MIDI del 36 al 95  (5 ocatvas) para la fecuencia base y 0 a 20 la frecuencia modulatoria

0 a 127 = 36 a 95 para fecuencia base
0 a 127 = 0 a 20 para la frecuencia modulatoria

Posteriormente crearemos un bus de control que conendrá los parámetros arrojados por nuestro mapeo MIDI.
Opcionalmente también se puede asignar un valor por default
*/

~note = Bus.control(s,1); //Creación del bus
~note.set(60); //Valor por defecto

~freqMod = Bus.control(s,1);
~freqMod.set(5);


//Procedemos a moificar el sintetizador para aceptar buses de control con la classe In.kr

(
SynthDef(\phonk, {
	arg amp = 0.4, gate = 1;
	var env, sig, sig1, sig2, sig3, offsets, mod, rev, midiNote, modFreq;

	midiNote = In.kr(~note);
	modFreq = In.kr(~freqMod);

	env = Env.asr().kr(2,gate);

	offsets = [ -0.4, 0, 0.4];

	mod  = SinOsc.ar(modFreq).range(0,1);

	sig1 = offsets.collect{ |off|
		Saw.ar((midiNote - 5).midicps + off, mod )};

	sig2 = offsets.collect{ |off|
		Saw.ar((midiNote - 12).midicps + off, mod)};

	sig3 = Saw.ar(midiNote.midicps, mod);

	sig = (sig1 + sig2 + sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev!2);

}).add
)

~phonkP = Synth(\phonk); //Prender el sintetizador
~phonkP.set(\gate,0);//Apagar el sintetizador

//Para finalizar, agregaremos un objeto MIDIdef para mapear nuestros valores y reflejarlos en el bus de control.

/*El método  .cc responde a mensajes de control MIDI, (más adelante veremos cómo repsonder a mensajes noteOn y note Off)

Los argumentos de MIDIdef.cc son
1.Nombre
2.Función que responderá a los valores entrantes
3.Número de Control Change que leerá
4.Canal que se leera
5.srcID: Entreada MIDI que se leera
6.Función opcional que indica si los valores cumplen cierta condición para que la función principal se ejecute.

Los príncipales y más útiles son 1,2,3 y 4. Los demás pueden omitirse en este ejercicio.
*/

MIDIdef.cc(\note, { },ccNum: 93, chan: 0);

MIDIdef.cc(\note, { |val| ("Nota MIDI ").post; ~note.value_(val.linlin(0,127,36,95).asInteger.postln)},ccNum: 93, chan: 0);

MIDIdef.cc(\freqMod, { |val| ("Frecuencia de modulación ").post; ~freqMod.value_(val.linlin(0,127,0,20).asInteger.postln)},ccNum: 18, chan: 0);

.set
Spec
ControlSpec


//////////////////////////////MAPEO DE NOTAS MIDI /////////////////////
//Para mapear las notas de un controlador a notas MIDI, usaremos un sintetizador adaptado y la clase MIDIdef.noteOn y MIDIdef.noteOff

(
SynthDef(\phonk, {
	arg amp = 0.4, gate = 1, midiNote = 60;
	var env, sig, sig1, sig2, sig3, offsets, mod, rev, modFreq;

	modFreq = In.kr(~freqMod);

	env = Env.asr().kr(2,gate);

	offsets = [ -0.4, 0, 0.4];

	mod  = SinOsc.ar(modFreq).range(0,1);

	sig1 = offsets.collect{ |off|
		Saw.ar((midiNote - 5).midicps + off, mod )};

	sig2 = offsets.collect{ |off|
		Saw.ar((midiNote - 12).midicps + off, mod)};

	sig3 = Saw.ar(midiNote.midicps, mod);

	sig = (sig1 + sig2 + sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev!2);

}).add
)

~phonkP = Array.newClear(128);

MIDIdef.noteOn(\notesOn, {|val, num| ~phonkP[num] = Synth(\phonk,[\midiNote, num, \amp, val.linlin(0,127,0.1,0.8)])});

MIDIdef.noteOff(\notesOff, {|val, num| ~phonkP[num].set(\gate,0); ~phonkP[num] = nil});





A Function or similar object which will respond to the incoming message. When evaluated for noteOn, noteOff, control, and polytouch messages it will be passed the arguments val, num, chan, and src, corresponding to the message value (e.g. velocity, control value, etc.), message number (e.g. note number), MIDI channel, and MIDI source uid. For touch, program change and bend messages it will be passed only val, chan, and src. For information on the args passed for the other sorts of msgType see the convenience methods below.


