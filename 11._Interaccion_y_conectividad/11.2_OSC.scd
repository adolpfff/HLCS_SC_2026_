/*
COMUNICACIÓN OSC EN SC

Open Sound Control (OSC) es una especificación de comunicación entre aplicaciones y/o hadware. Fue publicado en 2002 y está diseñado para cumplir los mismos propósitos de MIDI con mayor flexibilidad y personalización. Está optimizado para protocolos modernos de transmisión de datos en redes.

En luagar de mensajes preconfigurados como noteOn, noteOff, control, etc. OSC utiliza una dirección OSC personalizable con una sintaxis similar a la de una URL. En seguida, se encuentran los datos comunicables separados por una coma.

Ej. ['/osciladores/sierra', 220, 220.2313343, 221.05]

*/

/*
OSC es de hecho, el lenguaje de comunicación entre sclang y scsynth.

Para imprimir los mensjaes OSC enviados y recibidos por el servidor usamos:
*/

s.dumpOSC(1);

//Para enviar directamente mensajes osc al servidor usamos el método sendMsg con la siguiente sintaxis.

s.sendMsg("/quit");
s.sendMsg("/dumpOSC",1);
s.sendMsg("/n_run",1009,1);
s.sendMsg("/n_free",1009);

//Una lista útil de comandos OSC del servidor puede consultarse en el archivo de ayuda:
HelpBrowser.openHelpFor("Server Command Reference");

/*
Para recibir mensajes OSC en SC provenientes de otro dispositivos, la opción más práctica es tener ambos dispositivos conectados a la misma red local.

Para hacerlo, el remitente necesita la dirección IP local asignada a nuestra computadora y el puerto receptor del destinatario.

Podemos consultar nuestra dirección IP local y el puerto en el cuál está escuchando SC los mensajes OSC externos con las líneas de código:
*/

NetAddr.localIP;
//o
NetAddr.localIPs('ipv4');
//y
NetAddr.langPort;
thisProcess.openUDPPort(8888);
/*
El proceso es muy parecido a mapear señales MIDI pero en lugar de 0 a 127 el rango de valores puede ser de diferentes tamaños.

Como parámetro a mapear usaremos la misma definición de síntesis del archivo sobre MIDI cambiando el mapeo a osc.

Para el ejemplo usaremos /data/motion/gyroscope/y enviada desde una aplicacación de celular.
*/

OSCdef.new(\test, {| msg, time, addr, recvPort | msg.postln},path: '/data/motion/accelerometer/y',recvPort: 57120);

//Creamos el bus de control
~notaOSC = Bus.control(s,1); //Creación del bus
~notaOSC.set(60); //Valor por defecto

//Evaluamos nuestra definición OSC.
OSCdef(
	\pimerOSC,
	{ |msg|
		"Frecuencia: ".post;
		~notaOSC.set(msg[1].linlin(-0.9,0.9, 40, 60).asInteger.postln;
	)},
	path: '/data/motion/accelerometer/y',
	recvPort: 57120

)


(
SynthDef(\phonk, {
	arg amp = 0.4, gate = 1;
	var env, sig, sig1, sig2, sig3, mod, rev, midiNote;

	env = Env.asr().kr(2,gate);

	midiNote = In.kr(~notaOSC);

	mod  = SinOsc.ar(6).range(0,0.3);

	sig1 = Saw.ar(midiNote.midicps, mod);

	sig2 = Saw.ar((midiNote + 7).midicps, mod);

	sig3 = Saw.ar((midiNote + 12).midicps, mod);

	sig = Splay.ar(sig3) * env * amp;

	rev = FreeVerb.ar(sig,0.5);

	Out.ar(0,rev);


}).play;
)



  _______    _______        __       ______    __          __        ________
 /" _   "|  /"      \      /""\     /" _  "\  |" \        /""\      /"       )
(: ( \___) |:        |    /    \   (: ( \___) ||  |      /    \    (:   \___/
 \/ \      |_____/   )   /' /\  \   \/ \      |:  |     /' /\  \    \___  \
 //  \ ___  //      /   //  __'  \  //  \ _   |.  |    //  __'  \    __/  \\
(:   _(  _||:  __   \  /   /  \\  \(:   _) \  /\  |\  /   /  \\  \  /" \   :)
 \_______) |__|  \___)(___/    \___)\_______)(__\_|_)(___/    \___)(_______/











