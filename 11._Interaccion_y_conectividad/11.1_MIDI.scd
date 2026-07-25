/*
COMUNICACIÓN MIDI EN SC

MIDI (Musical Instrument Digital Interface o Interfaz Digital de Instrumentos Musicales, en español) es un protocolo que permite la comunicación entre instrumentos musicales electrónicos, computadoras y otros dispositivos relacionados.

Fue publicado en 1983 y desde entonces tuvo muy rápida aceptación en el mundo musical y de audio digital. Actualmente MIDI es ya un estándar de comunicación para recibir y mandar datos sencillos en general. Se encuentra disponible en prácticamente cualquier DAW o lenguaje de programación de audio moderno.

Un mensaje midi se compone de información en código binario. Cada digito binario es llamado bit. 8 bits conforman un byte. Un mensaje MIDI se compone de 1, 2 o 3 bytes.
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

2.pow(7);

//El byte de status se divide en dos: los primeros tres bits disponibles después del 1 especifican la acción

2.pow(3);

//Las acciones disponibles más frecuentes son:
(

var ventana, img;

img = Image.open(thisProcess.nowExecutingPath.dirname +/+ "media" +/+ "acciones_MIDI.png");

ventana = Window("Mensajes MIDI disponibles", img.bounds + [200,200,0,0]);

UserView(ventana,ventana.view.bounds).drawFunc_({img.drawInRect(img.bounds)});

ventana.front;
);

//Los segundos cuatro bits representan el canal al cual mandar los datos
2.pow(4); //Número de canales disponibles para envío de información

//Los siguientes dos bytes tienen 7 bits disponibles y se usan para diferentes cosas dependiendo el tipo de mensaje.
2.pow(7);

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
MIDIClient.sources.at(2);
MIDIClient.sources[1]; //Sintaxis alternativa de .at
MIDIIn.connect(device: MIDIClient.sources[1]);

//Una vez conectado algun dispositivo podemos comprobar y monitorear si estamos recibiendo mensajes MIDI:
MIDIFunc.trace(true); //Activa la impresión de los datos MIDI recibidos en la ventana de posteo.
MIDIFunc.trace(false);//Desactiva la impresión de los datos MIDI recibidos en la ventana de posteo.

//Para desconectar todos los dispositivos o alguno en específico utilizamos la misma sintaxis que usamos para conectarlos, unicamente sustituyendo los métodos .connectAll y .connect por .disconnectAll y .disconnect
MIDIIn.disconnectAll;
MIDIIn.disconnect(device: MIDIClient.sources[2].postln);

/*
Si queremos que SC realice acciones en respuesta a un mensaje MIDI entrante, utilizamos definiciones MIDI.

Las definiciones MIDI registran funciones a realizarse cuando se recibe un mensaje MIDI. Se crean con la clase MIDIdef.

MIDIdef responde a los mensajes MIDI más comunes por medio de los métodos .noteOn, .noteOff, y .cc . La lista completa de métodos se puede consultar en la ayuda de esta clase.
*/

/*Para el siguiente ejemplo usaremos el método .cc. Sus argumentos son:

1) key: Symbol identificador de la definción
2) func: Función que se ejecutará cuando se reciba el mensaje MIDI que nosotros especifiquemos.
3) ccNum: Número de mensaje de control
4) chan: Canal específico del cuál detecar mensajes.
5) srcID: Número correspondiente al identificador del dispositivo a utilizar. Por defecto es nil, lo cuál implica que se lea al mismo tiempo de todos los dispositivos conectados.
6) argTemplate: Argumento opcional consistente en un entero o una función que responde a la comparación con los datos de los mensajes MIDI entrantes, si esa comprobación es verdadera, se ejecuta la función derivada de nuestra definción MIDI.
*/

 //Estos argumentos son muy similares a los de los demás tipos de mensajes MIDI como .noteOn y .noteOff
(
MIDIdef.cc( //Método .cc Responderá filtrando únicamente los mensajes cc.
	key: \primerMIDIdef, //Identificador de la función
	func: {
		{ //Función
		var sigs, sig;
		sigs = 12.collect({
			Saw.ar(rrand(180, 239), rrand(0.5,1)) *
			EnvGen.kr(Env.perc,doneAction: 2);
		});
		sig = Splay.ar(sigs * 0.8);

		FreeVerb.ar(sig, 0.7, 0.67, 1);
	}.play;
},
	ccNum: 0, //Números cc
	chan: 1, //canal
	argTemplate: {arg val; val == 127};
);
)

//El siguiente sintetizador posee varios parámetros modulables, para el ejemplo escogeremos la amplitud, la frecuencia base (expresada en números MIDI) y la frecuencia moduladora(expresada en Hz):

(
SynthDef(\phonk, {
	arg midiNote = 40, amp = 0.4, modFreq = 5, gate = 1;
	var env, sig, sig1, sig2, sig3, desp, mod, rev;

	env = Env.asr().kr(2,gate);

	mod  = SinOsc.ar(modFreq).range(0,0.3);

	sig1 = Saw.ar(midiNote.midicps, mod);

	sig2 = Saw.ar((midiNote + 7).midicps, mod);

	sig3 = Saw.ar((midiNote + 12).midicps, mod);

	sig = Splay.ar(sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev);

}).add
)

~phonkP = Synth(\phonk); //Prender el sintetizador
~phonkP.set(\gate,0);//Apagar el sintetizador

/*
Para mapear parámetros e información


Primeramente crearemos un bus de control que contendrá los parámetros arrojados por nuestro mapeo MIDI.

Opcionalmente también podemos asignar un valor por defecto.
*/

~nota = Bus.control(s,1); //Creación del bus
~nota.set(60); //Valor por defecto

~freqMod = Bus.control(s,1);
~freqMod.set(5);

~amp = Bus.control(s,1);
~amp.set(0.5);

//Procedemos a modificar el sintetizador para aceptar buses de control con la classe In.kr

(
SynthDef(\phonk, {
	arg gate = 1;
	var amp, env, sig, sig1, sig2, sig3, offsets, mod, rev, midiNote, modFreq;

	midiNote = In.kr(~nota);
	modFreq = In.kr(~freqMod);
	amp = In.kr(~amp);

	env = Env.asr().kr(2,gate);

	mod  = SinOsc.ar(modFreq).range(0,0.3);

	sig1 = Saw.ar(midiNote.midicps, mod);

	sig2 = Saw.ar((midiNote + 7).midicps, mod);

	sig3 = Saw.ar((midiNote + 12).midicps, mod);

	sig = Splay.ar(sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev);

}).add
)

~phonkP = Synth(\phonk); //Prender el sintetizador
~phonkP.set(\gate,0);//Apagar el sintetizador

//Para finalizar, agregaremos un objeto MIDIdef para mapear nuestros valores y reflejarlos en el bus de control. Para esto utilizaremos el primer argumento por defecto de MIDIDef:

MIDIdef.noteOn(\printArgs, { |val, num, ch, id| [val,num,ch,id].postln}, chan: nil);

MIDIdef.noteOn(\note, { |val, num |
	"Nota MIDI: ".post;
	~nota.value_(num).postln;

	"Amplitud: ".post;
	~amp.value_(val.linlin(0,127,0,1).postln;
	)
});

MIDIdef.cc(\freqMod, { |val| ("Frecuencia de modulación: ").post; ~freqMod.value_(val.linlin(0,127,0,30).asInteger.postln)},ccNum: 0, chan: 0);

//////////////////////////////MAPEO DE NOTAS MIDI /////////////////////
//Para mapear las notas de un controlador a notas MIDI, usaremos un sintetizador adaptado y la clase MIDIdef.noteOn y MIDIdef.noteOff

//Veamos a detalle el metodo .noteOn
(
MIDIdef.noteOn(
	key: \ejemplo,
	func: {
		arg val,num,chan,src; //Las funciones de MIDIdef consideran 4 argumentos por defecto: Valor MIDI, Numero MIDI, Canal MIDI y Fuente o Source. (Un identificador del equipo que manda el mensaje).
		[val,num,chan,src].postln;
		("Mandaste una nota con valor" + val + "y corresponde al numero MIDI" + num).postln;
});
)

//noteOff
(
MIDIdef.noteOff(
	key: \ejemploff,
	func: {
		arg val, num, chan, src;
		[val,num, chan, src].postln; //En este caso, el mensaje se manda ya que se liberó la nota en el controlador.
		("Liberaste una nota en la posición" + num).postln;
	}
)
)


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

//Para este ejemplo declararemos un array de 128 posiciones que se encuentre vacio dentro de ~phonkP.
~phonkP = Array.newClear(128);

//Esto nos va a permitir definir un lugar ordenado donde almacenar los Nodos de cada nota para posteriormente invocarlos.

(
MIDIdef.noteOn( //Definimos una función MIDI que se active con mensajes de noteOn. (1001)
	key: \notesOn, //identifiador de la funcion.
	func: {
		|val, num| //La función considera 4 argumentos por defecto: [Valor, Numero MIDI, Canal MIDI, Fuente];
		~phonkP[num] = Synth( //Guardamos la ejecución del Synth(\phonk) en la posición del arreglo con la que coincide el numero MIDI.
			\phonk,
			[
				\midiNote, num, //Utilizamos la información del num para determinar la nota en formato MIDI.
				\amp, val.linlin(0,127,0.1,0.8) //Val en este caso nos indica la amplitud del Synth.
			]
		)
	}
);
)

//Para poder comunicar que queremos liberar el sonido del nodo que creamos previamente utiliazmos mensajes MIDI de noteOff (1000).
//Este mensaje se activa al liberar la nota del controlador.

(
MIDIdef.noteOff( //Definimos una función MIDI que se activa ahora con note off;
	key: \notesOff,
	func: {
		|val, num| //Nuevamente utilizamos los argumentos que ofrece por defecto la función en MIDIdef [val, num, chan, src].
		~phonkP[num].set(\gate,0);  //Ubicamos el Synth que queremos desactivar en el arreglo a travez del numero MIDI. y de aplicamos el metodo .set(\gate, 0) para indicarle a la envolvente que se desactive.
		~phonkP[num] = nil //Como último paso, restauramos el valor de nil que existía originalmente en el arreglo.
	}
);
)

//MIDI Out
//Asi como es posible ingresar mensajes MIDI a SC desde un controlador, un sintetizador u otras plataformas de trabajo con audio. Tambien es posible crear mensajes MIDI desde SC para comunicarse con otros dispositivos.

//Para ello empleamos la clase MIDIOut
MIDIOut.new;

//Consiste en un puerto o "destino" el cual nosotros definimos para establecer comunicación.
//Si queremos conocer los destinos disponibles podemos utilizar el siguiente comando:

MIDIClient.destinations;

//Al igual que el metodo anterior podemos definir una conección al indicar el indice al que corresponde en el arreglo de destinos.
~midiOut = MIDIOut.new(0);

//Una opción mas confiable es definir la conexión por nombre del dispositivo.
~midiOut = MIDIOut.newByName("Driver IAC", "Bus 1");

//Hay varios metodos con los cuales podemos mandar información MIDI.
/*Los mas importantes son:
.noteOn(chan, note, vel). //Mensajes de noteOn
.noteOff(chan, note, vel); //Mensajes de noteOff
.control(chan, ctlNum, vel) //Mensajes de control.

.allNotesOff //Mensaje que apaga todas las notas que pudieran estar atoradas. Es muy util!
*/
~midiOut.noteOn(0,84,64);
~midiOut.noteOff(0,84,64);

~midiOut.control(0,1,10);

~midiOut.allNotesOff(0);


//Podemos emplear una rutina para mandar información MIDI.
(
~r = Routine({
	var midi;
	[60,62,64,66,68,72].do({
		arg it, in;

		~midiOut.noteOn(0,it,127);
		1.wait;

		~midiOut.noteOff(0,it,127);
	});
	~midiOut.allNotesOff(0);
});
~r.play;
);

//Una alternativa es utilizar el tipo de evento MIDI en el entorno de los patrones.
HelpBrowser.openHelpFor("Event types");
HelpBrowser.openHelpFor("Pattern Guide 08: Event Types and Parameters");
HelpBrowser.openHelpFor("Pattern Guide Cookbook 04: Sending MIDI");

(
Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, ~midiOut,
	\chan, 0,
	\dur, 1,
	\midinote, Pseq([60,62,64,66,68,70,72],inf)
).play;
)

n = NetAddr("localhost", 12345);
n = s.addr;
~net = NetAddr.new("172.17.73.80",8000);
(
{
	inf.do{
		~net.sendMsg(\freq,200).postln;
	1.wait;
	}

}.fork;
)
OSCdef.new(\)
NetAddr.localAddr_(123456)