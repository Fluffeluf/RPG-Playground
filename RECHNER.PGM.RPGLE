**free
ctl-opt dftactgrp(*no) actgrp(*caller) option(*nodebugio:*srcstmt);

dcl-f rechner workstn;

dcl-s fm_Laenge zoned(4) inz ;
dcl-s text_laenge zoned(4) inz ;
dcl-s laenge_ergebnis zoned(4) inz ;
dcl-s anfangsposition_text zoned(4) inz ;

//dcl-pi rechner ;
//end-pi;

// Ab hier darf Cecilia anfangen, was zu tun

// Wir bleiben so lange in der Schleife, bis der Benutzer F3 gedrückt hat
dow not *inkc ;

  // Wir bereiten den Fehlertext auf, wenn es denn einen gibt
  if fm <> '' ;
    fm_laenge = %len(fm) ; // Ermittelt einfach nur die Länge
    text_laenge = %len(%trim(fm)) ;
    laenge_ergebnis = fm_laenge - text_laenge ;
    anfangsposition_text = laenge_ergebnis / 2 ;
    %subst(fm:anfangsposition_text) = fm;
    %subst(fm:1:anfangsposition_text - 1) = '';
  endif;

  // Wir zeigen den Bildschirm an und warten auf Eingaben des Benutzers
  exfmt record1;

  clear ergebnis ;
  clear fm ;
  clear endtext ;

  // Prüfbereich für die Eingaben des Benutzers
  if rz = ':' and zahl2 = 0 ;
    fm = 'Aufgabe nicht möglich' ;
  endif;

  if rz <> '+' and rz <> '-' and rz <> '*' and rz <> ':' ;
    fm = 'Falsches Rechenzeichen' ;
  endif;

  if rz = '*' and (zahl1 * zahl2 ) > 999999999 or
  rz = '+' and (zahl1 + zahl2 ) > 999999999;
    fm = 'Zu Großes Ergebnis' ;
  endif;



  if rz = '*' and (zahl1 * zahl2) < -999999999 or
  rz = '-' and (zahl1 - zahl2) < -999999999 ;
    fm = 'Zu Kleines Ergebnis'  ;
  endif;

  if fm <> '';
    iter;
  endif;



  // Die Prüfungen waren alle ok, also berechnen wir das Ergebnis
  select;
    when rz = '+' ;
      ergebnis = zahl1 + zahl2 ;
    when rz = '-' ;
      ergebnis = zahl1 - zahl2 ;
    when rz = '*' ;
      ergebnis = zahl1 * zahl2 ;
    when rz = ':' ;
      ergebnis = zahl1 / zahl2 ;
  endsl;


  if ergebnis <> 0 ;
    endtext = 'Unter der Linie rechne ich';
    iter;
  endif;


enddo;

// Hier ist Ende für Cecilia
// und fertig
exsr srExit;

//**************************************************************
// Programmende
//**************************************************************
begsr srExit;
  // und Programm schliessen
  *inlr = *on;
  return;
endsr; 
