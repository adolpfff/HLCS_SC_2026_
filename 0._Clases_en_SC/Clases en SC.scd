//Tipos de datos en supercollider

//NUMEROS

////////////////////////////////////Clase.
SimpleNumber.

//Contiene a su vez las clases

Integer //ENTEROS.

100.class; //el metodo .class pregunta a un objeto por su clase.

Float //DECIMALES.

3.1416.class;

//Objeto que integra tanto numeros enteros y decimales y que soporta todo el ecosistema de operaciones matemáticas.

//Suma
4 + 3; //7

//ejemplo dentro de una función.
(
var x; //creamos una variable local "x"

x = { //abrimos una función dentro de x.
	arg x = 4, y = 3; //consideramos 2 argumentos |x,y| ( x argumento != al x variable).
	x + y; //realizamos la operación.
}; //la función siempre va a entregar como resultado la última linea!

x.(); //podemos omitir el metodo .value por .(). Se puede reemplazar los valores predeterminados colocando valores dentro del parentesis. x.(8,4).
//Al x ser una variable local, no va a funcionar fuera del parentesis!
)

//Resta
4 - 3; //1

(
var x;

x = {
	arg x = 4, y = 3;
	x - y;
};
x.();
)

//multiplicación
4 * 3; //12

(
var x;

x = {
	arg x = 4, y = 3;
	x * y;
};
x.();
)

//división
4 / 3; //1.33..

(
var x;

x = {
	arg x = 4, y = 3;
	x / y;
};
x.();
)

//modulo : residuo generado por la división.
4 % 3; //1
4.mod(3); //otra forma de expresarlo.

4 - (floor(4/3) * 3) //Operación desglosada.

(
var x;

x = {
	arg x = 4, y = 3;
	x.mod(y);
};
x.();
)

//div: división sin el residuo.

4.div(3) //1.

(2/3).floor //otra forma de expresarlo.

(
var x;

x = {
	arg x = 4, y = 3;
	x.div(y);
};
x.();
)

//** : Exponencial.
4**3 //4^3 = 4 * 4 * 4 = 64

(
var x;

x = {
	arg x = 4, y = 3;
	x**y;
};
x.();
)

//redondear
4.round(3) //redondea a un multiplo del valor indicado.
1.49.round //por defecto redondea a numeros enteros tomando como referencia 0.5.
1.5.round

4.7.floor //redondea hacia abajo
3.1.roundUp //redondea hacia arriba.
3.1.ceil; //redondea hacia arriba.

//.neg : numero negativo.
4.neg;
-4.neg;

//.abs : numero absoluto.
-3.abs;

//.sign : signo.

3.sign; // 1 = positivo.
-3.sign // -1 = negativo.

//trigonometria.
//.sin;
pi;

(pi/2).sin; //1

2pi.cos //1.

//.sqrt : raiz cuadrada.

16.sqrt; //4

//.pow : potencia.

4.pow(3) //4 * 4 * 4.

//.do : Realilza iteraciónes de una función x cantidad de veces (x.do).
10.do //Por defecto siempre regresa el numero de iteraciónes ie x.

10.do({27.postln}); //En este ejemplo estamos pidiendo a ".do" repetir 10 veces lo que se encuentra en la función, lo cual consiste en reportar en la post el numero 27. Despues de 10 operaciónes vuelve a dar como resultado en numero de iteraciones ie. 10.

x = 10.do({27.postln}); //si guaramos en una variable todo este metodo, solo almacenamos el numero 10.
x;

10.do({arg i; i.postln}); //.do en este caso contempla la posibilidad de un argumento "i" el cual corresponde al indice de la iteración.

(
10.do({
	arg i; //argumento que responde al indice.
	var x; //variable que utilizaremos para llevar un registro del proceso.
	x = 27 + i; //sumamos "i" a una constante 27.
	x.postln; //pedimos que el resultado de la variable se reporte en la post.
});
)

//.do es una de las herramientas de automatización mas importantes de SC, la veremos nuevamente con la clase Array.

//Herramientas de mapeo o convertir de un rango de valores a otro.

//.linlin "map de rango linear a rango linear"
(
var x = 0; //definimos variable "x" por fuera de ".do"
10.do({ //abrimos una funcion
	x.linlin(0,10,0,100).postln; //llamamos a la función de afuera y aplicamos el metodo linlin que transforma linealmente los valores recibidos de 0 a 10, a un rango de 10 a 100 .postln publica en la post los resultados.
	x = x + 1; //realizamos un incremento de la variable x el cual va a persistir a lo largo de las iteraciónes.
})
)

//alternativa con el mismo resultado.
(
10.do({
	arg i;
	i.linlin(0,10,0,100).postln
})
);

//.linexp "map de rango lineal a rango exponencial"
(
var x = 0; //definimos variable "x"
10.do({ //abrimos una funcion "do"
	x.linexp(0,10,20,2e4).postln; //linexp transforma exponencialmente los valores recibidos.
	x = x + 1; //realizamos un incremento de la variable.
}) //.postln publica en la postwindow los resultados.
)

//CONVERSIONES

//.degrad : convierte un numero de grados a radianes.
180.degrad; //pi

//.raddeg : convierte un numero de radianes a grados.

(pi/2).raddeg;

//tabla de degrad.
(thisProcess.nowExecutingPath.dirname +/+ "media/degrad.png").openOS;

//midicps : convierte valores de MIDI a ciclos por segundo (Hz).

60.midicps;

//.cpsmidi : convierte de ciclos por segundo a MIDI.

440.cpsmidi;

//tabla de notas midi
(thisProcess.nowExecutingPath.dirname +/+ "media/midinotes.jpg").openOS;

//.midiratio : Convierte un invervalo en semitonos a una proporción.
12.midiratio; //2.

//.ratiomidi : Convierte una proporción a invervalo en semitonos.
0.5.ratiomidi; //2.

//tabla de midiratio
(thisProcess.nowExecutingPath.dirname +/+ "media/midiratio.jpg").openOS;

//.ampdb : conviete de amplitud linear a decibeles.
0.5.ampdb;

//.dbamp : conviete de decibeles amplitud linear.
0.dbamp;

//tabla de amplitud a decibeles.
(thisProcess.nowExecutingPath.dirname +/+ "media/dbamp.png").openOS;

//.reciprocal : el reciproco de un numero ie: (1/x).
10.reciprocal;
0.1.reciprocal;


//Numeros RANDOM.

//.coin
coin(0.5) //X% de probabilidad de ser verdadero o falso.

//.rand : numero random de 0 a x.
100.rand; //numeros enteros.
10.0.rand;

//.rand2 : numeros random entre -x y x.
10.rand2;

//.rrand : numeros random en un rango.
1.rrand(50);
rrand(1,50); //también se puede expresar con el metodo antes.

//.exprand : distribución exponencial de numeros aleatorios.
exprand(1,1000);
exprand(0,100); //PRECAUCIÓN. El cero y exp no se llevan bien.


////////////////////////////////////Clase.
String

//Es una colección ordenada de caracteres.

~str = "Esto es un string";
~str.class;

~str.size; //Consideran un tamaño.
~str.at(0); //Cada elemento del string responde a una posición.

~str.do{|i,in| [i,in].postln};

~str.reverse; //se puede revertir.
~str.scramble; //se puede reordenar
~str.drop(4); //se puede modificaar.
~str.choose //se puede elegir un elemento al azar.

~str2 = "Este es otro";

~str + ~str2; //Se pueden "concatenar" mas de un string"
~str ++ ~str2;

"4".asInteger.class; //Podemos transformar elementos de un string a Enteros

4.asString.class; //De igual manera podemos convertir un entero a String.

////////////////////////////////////Clase.
Symbol

//Secuencia no ordenada de caracteres "sin tamaño" que se emplea para identificar y etiquetar (nombrar) procesos dentro de ciertos contextos.

'Esto es un symbol'.class;
\EstoEsUnSymbol.class;

~sym = \symbol;
~sym.size; //no tiene tamaño por mas grande que sea.

~sym + 5; //Los simbolos dan como resultado ellos mismos frente a operaciones.

~sym ++ ~sym //también se pueden "concatenar".

\4.asInteger + 4; //Se pueden convertir a enteros.

4.asSymbol.class; //También se puede convertir un entero a Symbol.

//.kr
//un simbolo seguido de la terminación ".kr" define un argumento de control dentro de una función. Incluye un parametro de valor predeterminado y uno de latencia.

~ktrl = {SinOsc.ar(\freq.kr(440, 1)) * 0.1}.play; //No definimos el argumento freq, pero lo creamos mediante \freq.kr.
~ktrl.set(\freq, 220);
~ktrl.release(1);

////////////////////////////////////Clase.
Array
//Conjunto ordenado de objetos no expandibles

~array = [1, 2.3, "array", \array, nil, [7,6,5]]; //collección compuesta de varias clases.
~array.at(0); //el metodo .at solicita del array un valor en la posición indicada. el 0 es la primera posición.

~array.size; //nos reporta su tamaño

(
~array.size.do({ //encadenamos el metodo .size y el .do para abrir una función ".do" donde las iteraciónes coincidan con el tamaño del arreglo.
	arg i;
	~array.at(i).class.postln; //utilizamos el metodo .at para localizar una posición y pedimos que reporte la clase del objeto en esa posición.
})
)

//podemos usar el metodo ".do" directamente en el arreglo. En este caso se consideran 2 argumentos que corresponden al contenido del arreglo y al indice dentro del arreglo respectivamente.
(
~array.do({
	arg it, in;
	[it,in].postln;
})
)

//ejemplo anterior utilizando ahora .do
(
~array.do({
	arg it, in;
	it.class.postln;
})
)

//Crear arreglos.

//Cualquier información contenida dentro de [ ] es un arreglo.
~array = [];
~array.class;

//Podemos utilizar varios metodos sobre la clase Array para crear arreglos.
/*
.fill : crea una colección de un tamaño indicado usando las instrucciónes de una función.
.fill(size, func)
*/
Array.fill( 10, {arg i; i}); //contempla un argumento que corresponde a un indice de iteración.

Array.fill( 10, {arg i; 100*i});

/*
.geom : crea un arreglo mediante una serie geometrica.
.geom(size, inicio de la serie, crecimiento);
*/
Array.geom(10, 1, 2);

Array.geom(10, 110, 2); //10 armonicos a partir de 110Hz.

/*
.series : crea un arreglo mediante una serie aritmética.
.series(size, inicio de la serie, crecimiento);
*/
Array.series(6,60,2); //Escala de tonos enteros a partir de la notaMIDI 60.

//Podemos crear una especie de serie poniendo dentro de un parentesis el rango y dos puntos ".." entre ellos.
(0..100);

//adicionalmente podemos indicar un intervalo entre un punto y otro;
(0,2..100);

/*
.interpolation : valores interpolados entre el punto de inicio y el de arribo.
.interpolation(size, inicio de la serie, fin de la serie);
*/
Array.interpolation(10, -40, 0) //diez niveles en dB del -40 al 0.


/*
.rand : arreglo compuesto de valores aleatorios en un rango
.rand(size, valor minimo, valor maximo).
*/
Array.rand(10, 0,10);

//tambien hay .rand2, .linrand, .exprand

/*
.fib : Secuencia utilizando la serie de fibonacci
.fib(size, valor de aumento inicial, valor inicial)
*/
Array.fib(10, 0, 1); //secuencia de fibonacci

//Operaciones con arreglos.
~array = Array.series(10,0,10);

//.at : ubicamos un valor en el arreglo por su posición.
// se pude abreviar con [ ]
~array.at(5);
~array[5];

//.put : reemplaza un elemento del arreglo por otro de acuerdo a un indice.
~array.put(5, \error);
~array; //Modifica el arreglo!
~array.put(5, 50); //restauramos el arreglo.

//.insert : inserta un elemento nuevo al arreglo en un indice especificado.
~array.insert(5, \error2)
~array; //también modifica el arreglo.

//.swap: intercambia valores en los indices indicados.
~array.swap(0,5);
~array; //modifica el arreglo.

//.replace : reemplaza elementos de un arreglo
//.replace(find, replace).
~array.replace(90, 900);
~array.replace(\error2, 0.1);

~array.replace([10,20,30,40], 100); //se pueden reemplazar varios elementos añadiendo un arreglo como argumento.
~array.replace(10, [100,200,300,400]); //se pueden reemplazar un elemento por varios.

//Concatenación.
[0,1,2] ++ [3,4,5];


//.collect
(
~array.collect({
	arg it,in;
	[it,in].postln;
});
)

//.normalize
[1,2,3,4,5].normalize
[1,2,3,4,5].normalize(-70,0);

//.normalizeSum

~normSum = [1,2,4].normalizeSum;

//.sum
~normSum.sum;

//.plot
(
Array.fill(100,{
	arg i;
	i;
}).plot
)

//.reverse
~array.reverse;

//.scamble
~array.scramble;

//.mirror
~array.mirror;

//.stutter
~array.stutter(2);

//.rotate
~array.rotate(1);

//.flat
[[1,2,3], [10,20,30], [100,200,300]].flat
