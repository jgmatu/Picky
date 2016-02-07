program cuatroEnRaya;

consts:

	MaxColumnas = 10;
	MaxFilas = 9;
	MaxContadores = MaxColumnas;			/* Un contador por columna */
	NumRaya = 4;		/*  Es un 4 en raya  */
	MaxPal = 100;
	LenMar = 6; 		 /*    marmol    */
	LenCris = 7; 		 /*    cristal      */
	LenPino = 4;		 /*    pino         */
	LenAcero = 5; 		 /*    acero       */

types:

	TipoFicha = (marmol , cristal , pino , acero , cero);
	
	TipoCasilla = record {
		ficha : TipoFicha;
		mayus : bool;
	};
	
	TipoColumnas = array [0 .. MaxColumnas - 1] of TipoCasilla;
	TipoFilas = array [0 .. MaxFilas - 1] of TipoColumnas;
	
	TipoContadores = array [0 .. MaxContadores -1] of int;
	
	TipoTablero = record {
		contadores : TipoContadores;
		filas : TipoFilas;
	};
	
	TipoPtrMov = ^TipoMov;
	
	TipoMov = record {
		ficha : TipoFicha;
		columna : int;
		nextMov : TipoPtrMov;
	};
	
	TipoPal = array [0 .. MaxPal - 1] of char;
	

function devolvercolumnas () : TipoColumnas
	columnas : TipoColumnas;
	i : int;
{
	for (i = 0 , i < MaxColumnas ){
		columnas[i].ficha = cero;
		columnas[i].mayus = False;
	}
	return columnas;
}

procedure escribircasilla (casilla : TipoCasilla)

{
	switch (casilla.ficha){
	
	case marmol : 
	
		if (casilla.mayus){
			write ('M');
		}else{
			write('m');
		}

	case cristal :
	
		if (casilla.mayus){
			write ('C');
		}else{
			write('c');
		}

	case pino :
		
		if (casilla.mayus){
			write ('P');
		}else{
			write('p');
		}

	case acero :
	
		if (casilla.mayus){
			write ('A');
		}else{
			write('a');
		}

	
	default :
		
		write ('.');
	}
}
	
procedure escribircolumnas (columnas : TipoColumnas)
	i : int;
{
	for (i = 0 , i < MaxColumnas){
		escribircasilla (columnas[i]);
	}
	writeeol();
}

function devolverfilas () : TipoFilas
	filas : TipoFilas;
	i:int;
{
	for (i=0, i < MaxFilas){
		filas [i] = devolvercolumnas();
	}
	return filas;
}

procedure escribirfilas (filas : TipoFilas)
	i : int;
{
	for (i = MaxFilas - 1 , i >= 0){
		escribircolumnas(filas[i]);
	}
}


function devolvertablero () : TipoTablero
	tablero : TipoTablero;
	i: int;
{
	for (i=0, i < MaxContadores){
		tablero.contadores [i] = 0;
	}
	tablero.filas = devolverfilas();
	return tablero;
}

procedure escribirtablero (tablero : TipoTablero)
	i: int;
{
	for (i = 0, i < MaxContadores){
		write(tablero.contadores[i]);
	}
	writeeol();
	escribirfilas (tablero.filas);
}


procedure moverficha (ref tablero : TipoTablero , ficha : TipoFicha , columna : int)
	contador : int;
{

	if (columna >= MaxColumnas){
		fatal("Columna invalida");
	}
	
	contador = tablero.contadores[columna];
	if (contador< MaxFilas){
	
		/* Mover */
		tablero.filas[contador][columna].ficha = ficha;    
		tablero.contadores[columna] = contador + 1;
		
		escribirtablero(tablero);
		
	}else{
		write ("movimiento invalido por columna llena");
		writeeol();
	}
}


function isnext(tablero : TipoTablero , posFila : int , posCol : int , counter : int) : bool
	result : bool;
{
	result = posCol >= 0 and  posCol < MaxColumnas;  					/* Out of range on table*/
	
	result = result and posFila >= 0 and posFila < MaxFilas;				/* Out of range on table */

	result = result and counter != NumRaya;							/* not is NumRaya */

	return result;
}

function esdiagonalInv (tablero : TipoTablero , ficha : TipoFicha , columna : int) : bool
	invertida : bool;
	posFila : int;
	posCol : int;
	countInv : int;
	seguidas : bool;
{
	countInv = 1;					/* La primera ficha se considera diagonal invertida */
	invertida = False;
	posCol = columna;
	posFila = tablero.contadores[columna] - 1;
	
	/* Diagonal invertida en sentido derecha desde la primera ficha en diagonal invertida hacia la derecha desde mi ficha */
	posCol = columna + 1;;
	posFila = posFila - 1;
	seguidas = True;
	while (isnext(tablero , posFila , posCol , countInv) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			countInv = countInv + 1;
		}else {
			seguidas = False;
		}
		posCol = posCol + 1;
		posFila = posFila - 1;
	}
	
	/* Diagonal invertida en sentido hacia la izquierda desde la primera ficha en diagonal invertida hacia la izquierda desde mi ficha*/
	posCol = columna - 1;
	posFila = tablero.contadores[columna] - 1;
	posFila = posFila + 1;
	seguidas = True;
	while(isnext(tablero , posFila , posCol , countInv) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			countInv = countInv + 1;
		}else {
			seguidas = False;
		}
		posCol = posCol - 1;
		posFila = posFila + 1;
	}
	if (countInv == NumRaya){
		invertida = True;
	}
	return invertida;
}



function esdiagonal (tablero : TipoTablero , ficha : TipoFicha , columna : int) : bool
	diagonal : bool;
	posFila : int;
	posCol  : int;
	countDig : int;
	seguidas : bool;
{
	countDig = 1;					/* La primera ficha cuenta como ficha diagonal */
	diagonal = False;
	posCol = columna;
	posFila = tablero.contadores[columna] - 1;
	
	/* Diagonal sentido a la derecha desde la primera ficha en diagonal hacia la derecha */
	posCol = columna + 1;
	posFila = posFila + 1;
	seguidas = True;
	while (isnext(tablero , posFila , posCol , countDig) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			countDig = countDig + 1;
		}else {
			seguidas = False;
		}
		posCol = posCol + 1;
		posFila = posFila + 1;
	}
	
	/* Diagonal sentido a la izquierda desde la primera ficha en diagonal hacia la izquierda */
	posCol = columna - 1;
	posFila = tablero.contadores[columna] - 1;
	posFila = posFila - 1;
	seguidas = True;
	while (isnext(tablero , posFila , posCol , countDig) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			countDig = countDig + 1;
		}else {
			seguidas = False;
		}
		posFila = posFila - 1;
		posCol = posCol - 1;
	}
	if (countDig == NumRaya){
		diagonal = True;
	}
	return diagonal;
}

function esvertical (tablero : TipoTablero , ficha : TipoFicha , columna : int) : bool
	vertical : bool;
	posCol : int;
	posFila : int;
	countVer : int;
	seguidas : bool;
{
	countVer = 1;					/* La primera ficha cuenta como una ficha en vertical */
	vertical = False;
	posCol = columna;
	
	/* Hacia arriba contar fichas en vertical desde la primera vertical después de la que quiero consultar su vertical*/
	seguidas = True;
	posFila = tablero.contadores[columna] - 1;
	posFila = posFila + 1;
	while (isnext(tablero , posFila , posCol , countVer) and seguidas){
		if(tablero.filas[posFila][posCol].ficha == ficha){
			countVer = countVer + 1;
		}else {
			seguidas = False;
		}
		posFila = posFila + 1;
	}
	
	/* Hacia arriba contar fichas en vertical desde la primera vertical después de la que quiero consultar su vertical*/
	seguidas = True;
	posFila = tablero.contadores[columna] - 1;
	posFila = posFila - 1;
	while (isnext(tablero , posFila , posCol , countVer) and seguidas){
		if(tablero.filas[posFila][posCol].ficha == ficha){
			countVer = countVer + 1;
		}else {
			seguidas = False;
		}
		posFila = posFila - 1;
	}
	if (countVer == NumRaya){
		vertical = True;
	}
	return vertical;
}


function eshorizontal (tablero : TipoTablero , ficha : TipoFicha , columna : int) : bool
	horizontal : bool;
	posCol : int;
	posFila : int;
	countHor : int;
	seguidas : bool;
{
	countHor = 1;					/* La primera ficha cuenta como una ficha en horizontal */
	horizontal = False;
	posFila = tablero.contadores[columna] - 1;
	seguidas = True;
	
	/* Hacia la derecha contar fichas en horizontal desde la primera ficha horizontal a la derecha de la fica que quiero consultar su horizontal */
	posCol = columna + 1;
	while (isnext(tablero , posFila , posCol , countHor) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			countHor = countHor + 1;
		}else{
			seguidas = False;
		}
		posCol = posCol + 1;
	}
	
	/* Hacia la izquierda contar fichas en horizontal desde la primera ficha horizontal a la izquierda de la fica que quiero consultar su horizontal */
	seguidas = True;
	posCol = columna - 1;
	while (isnext(tablero , posFila , posCol , countHor) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			countHor = countHor + 1;
		}else {
			seguidas = False;
		}
		posCol = posCol - 1;
	}
	if (countHor == NumRaya){
		horizontal = True;
	}
	return horizontal;
}


function esganador (tablero : TipoTablero , ficha : TipoFicha , columna : int) : bool
{
	return esdiagonal(tablero , ficha , columna) or esdiagonalInv(tablero , ficha , columna) or eshorizontal(tablero , ficha , columna) or esvertical(tablero , ficha , columna);
}


function esSep(c : char) : bool
{
	return c == ' ' or c == Tab;
}

function devPalInit () : TipoPal
	i : int;
	pal : TipoPal;
{
	for (i = 0 , i < MaxPal){
		pal[i] = '?';
	}
	return  pal;
} 

procedure escpal (pal : TipoPal , numCar : int)
	i : int;
{
	i = 0;
	write("[");
	for (i = 0 , i < numCar){
		write(pal[i]);
	}
	write("]");
	writeeol();
}

function esDigit (c : char) : bool
{
	return c >= '0' and c <= '9';
}

function areDigits (pal : TipoPal , numCar : int) : bool
	pos : int;
	digit : bool;
{
	pos = 0;
	digit = True;
	
	while (pos < numCar and digit){
		if (esDigit(pal[pos])){
			pos = pos + 1;
		}else {
			digit = False;
		}
	}
	return digit;
}

function devColumna (pal : TipoPal , numCar : int) : int
	i : int;
	columna : int;
	number : int;
	base : int;
	pot : int;
{
	base  = 10;
	columna = 0;
	pot = numCar - 1;
	
	for (i = 0 , i < numCar){
		number = int(pal[i]) - int('0');
		columna = columna + number*base**pot;
		pot = pot - 1;
	}
	return columna;
}

function devMar () : TipoPal
	pal : TipoPal;
	pos : int;
{
	pal = devPalInit();
	
	pos = 0;
	pal[pos] = 'm';
	pos = 1;
	pal[pos] = 'a';
	pos = 2;
	pal[pos] = 'r';
	pos = 3;
	pal[pos] = 'm';
	pos = 4;
	pal[pos] = 'o';
	pos = 5;
	pal[pos] = 'l';
	return pal;
}

function esMar(pal : TipoPal , numCar : int) : bool
	marPal : TipoPal;
	esmar : bool;
	pos : int;
{
	pos = 0;
	esmar = True;
	marPal = devMar();
	
	if (numCar != LenMar){
		esmar = False;
	}
	while (esmar and pal[pos] != '?'){
		if (marPal[pos] == pal[pos]){
			pos = pos + 1;
		}else{
			esmar = False;
		}
	} 
	return esmar;
}

function devCris () : TipoPal
	crisPal : TipoPal;
	pos : int;
{
	crisPal = devPalInit();
	
	pos = 0;
	crisPal[pos] = 'c';
	pos = 1;
	crisPal[pos] = 'r';
	pos = 2;
	crisPal[pos] = 'i';
	pos = 3;
	crisPal[pos] = 's';
	pos = 4;
	crisPal[pos] = 't';
	pos = 5;
	crisPal[pos] = 'a';
	pos = 6;
	crisPal[pos] = 'l';
	return crisPal;
}

function esCris(pal : TipoPal , numCar : int) : bool
	crisPal : TipoPal;
	escris : bool;
	pos : int;
{
	crisPal = devCris();
	escris = True;
	pos = 0;
	
	if (numCar != LenCris){
		escris = False;
	}
	while (escris and pal[pos] != '?'){
		if (crisPal[pos] == pal[pos]){
			pos = pos + 1;
		}else {
			escris = False;
		}
	}
	return escris;
}

function devPino () : TipoPal
	pinoPal : TipoPal;
	pos : int;
{
	pinoPal = devPalInit();
	
	pos = 0;
	pinoPal[pos] = 'p';
	pos = 1;
	pinoPal[pos] = 'i';
	pos = 2;
	pinoPal[pos] = 'n';
	pos = 3;
	pinoPal[pos] = 'o';
	return pinoPal;
}

function esPino(pal : TipoPal , numCar : int) : bool
	pinoPal : TipoPal;
	espino : bool;
	pos : int;
{
	espino = True;
	pinoPal = devPino();
	pos = 0;
	
	if (numCar != LenPino){
		espino = False;
	}
	while (espino and pal[pos] != '?'){
		if (pinoPal[pos] == pal[pos]){
			pos = pos + 1;
		}else {
			espino = False;
		}
	}
	return espino;
}

function devAcero () : TipoPal
	aceroPal : TipoPal;
	pos : int;
{
	aceroPal = devPalInit();
	
	pos = 0;
	aceroPal[pos] = 'a';
	pos = 1;
	aceroPal[pos] = 'c';
	pos = 2;
	aceroPal[pos] = 'e';
	pos = 3;
	aceroPal[pos] = 'r';
	pos = 4;
	aceroPal[pos] = 'o';
	
	return aceroPal;
}

function esAcero(pal : TipoPal , numCar : int) : bool
	esacero : bool;
	pos : int;
	aceroPal : TipoPal;
{
	aceroPal = devAcero();
	pos = 0;
	esacero = True;
	
	if (numCar != LenAcero){
		esacero = False;
	}
	while (esacero and pal[pos] != '?') {
		if (aceroPal[pos] == pal[pos]){
			pos = pos + 1;
		}else {
			esacero = False;
		}
	}
	return esacero;
}


function devFicha (pal : TipoPal , numCar : int) : TipoFicha
	ficha : TipoFicha;
{	
	ficha = cero;
	if (esMar(pal , numCar)){
		ficha = marmol;
	}
	if (esCris(pal , numCar)){
		ficha = cristal;
	}	
	if (esAcero(pal , numCar)){
		ficha = acero;
	}
	if (esPino(pal , numCar)){
		ficha = pino;
	}
	return ficha;
}

function esFicha (pal : TipoPal , numCar : int) : bool
{
	return esMar(pal , numCar) or esCris(pal , numCar) or esPino(pal , numCar) or esAcero(pal , numCar);
}

procedure addMov (ref firstMov : TipoPtrMov , ficha : TipoFicha , columna : int)
	lastMov : TipoPtrMov;
	auxMov : TipoPtrMov;
{
	lastMov = firstMov;
	auxMov = firstMov;

	/* Go to last move to add the new mov at the end of movs... */
	while (auxMov != nil){	
		if (auxMov^.nextMov == nil){
			lastMov = auxMov;
		}
		auxMov = auxMov^.nextMov; 		/* Next Mov */
	}
	
	/* Add new move at the end of moves... */
	if (lastMov != nil){
		new(auxMov);
		auxMov^.ficha = ficha;
		auxMov^.columna = columna;
		auxMov^.nextMov = nil;
		lastMov^.nextMov = auxMov;
	}
	
	/* Case first Move */
	if (firstMov == nil){
		new(firstMov);
		firstMov^.ficha = ficha;
		firstMov^.columna = columna;
		firstMov^.nextMov = nil;
	}
}
 
 
procedure takeMov (ref firstMov : TipoPtrMov , ref ficha : TipoFicha , ref columna : int ,  pal : TipoPal , numCar : int , ref fichaR : bool)
{

	if (esFicha(pal , numCar)){
		ficha = devFicha(pal , numCar);
		fichaR = True;
	}
				
	if (areDigits(pal , numCar) and fichaR){
		columna = devColumna(pal , numCar);
	}
				
	if (ficha != cero and columna != -1){
		addMov(firstMov , ficha , columna);
		ficha = cero;
		columna = -1;
		fichaR = False;
	}	
}
 
 procedure nextpal (ref pal : TipoPal , ref numCar : int , ref inpal : bool)
 {
	inpal = not inpal;
	pal = devPalInit();
	numCar = 0;
			
 }
 
procedure readmovs (ref firstMov : TipoPtrMov)
	dataFile : file;
	c : char;
	fin : bool;
	inpal : bool;
	pal : TipoPal;
	numCar : int;
	ficha : TipoFicha;
	columna : int;
	fichaR : bool;
{
	fichaR = False;
	ficha = cero;
	columna = -1;
	numCar = 0;				/* Primera palabra */
	pal = devPalInit();			/* Primera palabra */
	inpal = False;
	fin = False;
	open(dataFile , "movimientos.txt" , "r");
	
	do{ 
		fpeek(dataFile , c);
		switch (c){
		/* Mismas sentencias que sep  blanco y tabulador eol y eof es separador especial en picky */
		case Eol :
		
			/* Es Separador Eol y es inpal... final de palabra */
			if (inpal){
				
				takeMov (firstMov , ficha , columna , pal , numCar , fichaR);
				nextpal(pal , numCar , inpal);
			
			}
			freadeol(dataFile);
		
		case Eof :
		
			/* Es Separador Eof y es inpal... final de palabra */
			if (inpal){
			
				takeMov (firstMov , ficha , columna , pal , numCar , fichaR);
				nextpal(pal , numCar , inpal);
			
			}
			fin = True;
		
		default :
		
			if (not esSep(c) and not inpal){      /* Principio de palabra */
		
				inpal = not inpal;
				pal[numCar] = c;
				numCar = numCar + 1;
			
			}else if (esSep(c) and inpal){		/* Final de palabra */
			
				takeMov (firstMov , ficha , columna , pal , numCar , fichaR);
				nextpal(pal , numCar , inpal);
			
			}else if (not esSep(c) and inpal){	/* Dentro de palabra */
			
				pal[numCar] = c;
				numCar = numCar + 1;
			
			}
			fread(dataFile , c);
		}
	}while (not fin);
	close(dataFile);
}


procedure dropmovs (ref firstMov : TipoPtrMov)
{
	if (firstMov != nil){
		dropmovs(firstMov^.nextMov);
		dispose(firstMov);
	}
}

procedure escribirficha(ficha : TipoFicha)
{
	switch(ficha){
	case acero :
		write('a');
	case marmol :
		write('m');
	case cristal :
		write('c');
	case pino :
		write('p');
	default:
		write('.');
	}
}

procedure wrtmovs (firstMov : TipoPtrMov)
	auxMov : TipoPtrMov;
{
	auxMov = firstMov;
	
	while (auxMov != nil){
		escribirficha(auxMov^.ficha);
		writeln(auxMov^.columna);
		auxMov = auxMov^.nextMov;
	}
}

function isFullTab (tablero : TipoTablero) : bool
	pos : int;
	full : bool;
{
	pos = 0;
	full = True;

	while (pos < MaxContadores and full){
		if (tablero.contadores[pos] == MaxFilas){
			pos = pos + 1;
		}else{
			full = False;
		}
	}
	return full;
}

procedure mayusHor(ref tablero : TipoTablero , ficha : TipoFicha , columna : int)
	posCol : int;
	posFila : int;
	seguidas : bool;
{
	seguidas = True;
	posCol = columna;
	posFila = tablero.contadores[columna] - 1;
	tablero.filas[posFila][posCol].mayus = True;		/* Primera ficha de la linea ganadora a mayusculas */
	
	/* La primera despues de la movida hacia la derecha poner en mayusculas las ganadoras */
	posCol = columna + 1;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posCol = posCol + 1;
	}
	
	/* La primera despues de la movida hacia la izquierda poner en mayusculas las ganadoras */
	seguidas = True;
	posCol = columna - 1;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posCol = posCol - 1;
	}
}


procedure mayusVer(ref tablero : TipoTablero , ficha : TipoFicha , columna : int)
	posCol : int;
	posFila : int;
	seguidas : bool;
{
	posCol = columna;
	posFila = tablero.contadores[columna] - 1;
	tablero.filas[posFila][posCol].mayus = True;		/* Primera ficha de la linea ganadora a mayusculas */
	
	
	/* La primera despues de la movida hacia arriba poner en mayusculas las ganadoras */
	posFila = posFila + 1;
	seguidas = True;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posFila = posFila + 1;
	}
	
	/* La primera despues de la movida hacia abajo poner en mayusculas las ganadoras */
	seguidas = True;
	posFila = tablero.contadores[columna] - 1;
	posFila = posFila - 1;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posFila = posFila - 1;
	}
}


procedure mayusDiag(ref tablero : TipoTablero , ficha : TipoFicha , columna : int)
	posCol : int;
	posFila : int;
	seguidas : bool;
{
	posCol = columna;
	posFila = tablero.contadores[columna] - 1;
	tablero.filas[posFila][posCol].mayus = True;		/* Primera ficha de la linea ganadora a mayusculas */
	
	
	/* La primera despues de la movida hacia arriba y al a derecha poner en mayusculas las ganadoras */
	posFila = posFila + 1;
	posCol = posCol + 1;
	seguidas = True;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posFila = posFila + 1;
		posCol = posCol + 1;
	}
	
	/* La primera despues de la movida hacia abajo poner en mayusculas las ganadoras */
	seguidas = True;
	posFila = tablero.contadores[columna] - 1;
	posFila = posFila - 1;
	posCol = columna - 1;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posFila = posFila - 1;
		posCol = posCol - 1;
	}
}


procedure mayusDiagInv(ref tablero : TipoTablero , ficha : TipoFicha , columna : int)
	posCol : int;
	posFila : int;
	seguidas : bool;
{
	posCol = columna;
	posFila = tablero.contadores[columna] - 1;
	tablero.filas[posFila][posCol].mayus = True;		/* Primera ficha de la linea ganadora a mayusculas */
		
	/* La primera despues de la movida hacia arriba y al a derecha poner en mayusculas las ganadoras */
	posCol = columna + 1;;
	posFila = posFila - 1;
	seguidas = True;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posFila = posFila - 1;
		posCol = posCol + 1;
	}
	
	/* La primera despues de la movida hacia abajo poner en mayusculas las ganadoras */
	seguidas = True;
	posFila = tablero.contadores[columna] - 1;
	posFila = posFila + 1;
	posCol = columna - 1;
	while (isnext(tablero , posFila , posCol , 0) and seguidas){
		if (tablero.filas[posFila][posCol].ficha == ficha){
			tablero.filas[posFila][posCol].mayus = True;
		}else{
			seguidas = False;
		}
		posFila = posFila + 1;
		posCol = posCol - 1;
	}
}



procedure esclineaGanadora(ref tablero : TipoTablero , ficha : TipoFicha , columna : int)
{
	
	if (eshorizontal(tablero , ficha , columna)){
		mayusHor(tablero , ficha , columna);
	}
	
	if (esvertical(tablero , ficha , columna)){
		mayusVer(tablero , ficha , columna);
	}
	
	if (esdiagonal(tablero , ficha , columna)){
		mayusDiag(tablero , ficha , columna);
	}
	
	if (esdiagonalInv(tablero , ficha , columna)){
		mayusDiagInv (tablero , ficha , columna);
	}
}

procedure main()
	tablero : TipoTablero;
	firstMov : TipoPtrMov;
	auxMov : TipoPtrMov;
	ganador : bool;
	fichaGanadora : TipoFicha;
{
	fichaGanadora = cero;
	ganador = False;
	tablero = devolvertablero();	
	firstMov = nil;
	
	readmovs(firstMov);
	auxMov = firstMov;

	while (auxMov != nil and not isFullTab(tablero) and not ganador){

		moverficha(tablero , auxMov^.ficha , auxMov^.columna);
		
		if (esganador(tablero , auxMov^.ficha , auxMov^.columna)){
		
			ganador = True;
			fichaGanadora = auxMov^.ficha;
			esclineaGanadora(tablero , auxMov^.ficha , auxMov^.columna);	
		
		}
		
		auxMov = auxMov^.nextMov;
	}
	dropmovs(firstMov);
	
	escribirtablero(tablero);
	if (isFullTab(tablero)){
		writeln("Tablas");
	}
	
	if (ganador){
		write("Gana jugador con ficha : ");
		escribirficha(fichaGanadora);
		writeeol();
	}
}