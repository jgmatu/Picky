program cat;

procedure leerfichero (fichero : file) 
	byte : char;
{
	do{
		fpeek(fichero , byte);
		
		switch (byte) {
		case Eol :
		
			freadeol (fichero);
			writeeol ();
			
		case Eof :
	
			;
	
		default : 
			
			fread (fichero, byte) ;
		
			if(byte != Tab and byte == ' '){
				write(byte);
			}
		
		}
	}while(not feof(fichero));
}


procedure main ()
	fichdatos: file;
{
	open (fichdatos, "datos.txt", "r");
	writeln ("Hello World!");
	leerfichero (fichdatos);
	close(fichdatos);
	
}
