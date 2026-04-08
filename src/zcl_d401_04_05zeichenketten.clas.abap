CLASS zcl_d401_04_05zeichenketten DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_05zeichenketten IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    "" Anzahl der Zeichen vor dem gefundenen ersten Suchmuster hier 'A'
*    DATA(result) = find( val  = `BAPabapABAP`   sub   = 'A' ).

    "" großes A wird hier nicht gefunden, deshalb ist das Ergebns -1
*    DATA(result) = find( val  = `ABAPabapABAP` sub = 'A' off = 4 len = 4 ).
*     DATA(result) = find( val  = `ABAPabapABAP` sub = 'A' off = 4 ).

    "" Treffer hier wäre das Ergebnis dann 4, weil das a direkt gefunden wird
*    DATA(result) = find( val  = `ABAPabapABAP` sub = 'a' off = 4 len = 4 ).

    "" Änderung der Suchrichtung
*    DATA(result) = find( val  = `ABAPabapABAP` sub = 'A' occ = -4 ).



*out->write( result ).




**Abb.66
*    DATA text   TYPE string VALUE `  let's talk about abap  `.
*    DATA result TYPE i.
*
*    out->write(  |input string: { text } | ).
*
*    out->write( `------------------------` ).
*
*    result = find( val = text sub = 'a' case = abap_true ).
*    out->write(  |find 'a' (standard):                 { result } | ).
*
*    result = find( val = text sub = 'a' case = abap_false ).
*    out->write(  |find 'a' (case = abap_false):        { result } | ).
*    "" occ = suchtreffer bei minus von rechts, bei plus von links
*    "" finden soll er dann bei -1 das erste Suchmuster im text von rechts
*    """ die Anzahl der zeichen wird dann wieder von links ab gezählt
*    result = find( val = text sub = 'a' case = abap_false occ =  -1 ).
*    out->write(  |find 'a' (occ = -1):                 { result } | ).
*    """ `  let's talk about abap  `
*    result = find( val = text sub = 'a' case = abap_false occ =  -2 ).
*    out->write(  |find 'a' (occ = -2):                 { result } | ).
*
*    result = find( val = text sub = 'a' case = abap_false occ =   2 ).
*    out->write(  |find 'a' (occ =  2):                 { result } | ).
*""" `  let's talk about abap  `
*    """ off = Beginn der Suche ab Zeichen 10
*    result = find( val = text sub = 'a' case = abap_false occ = 2 off = 10 ).
*    out->write(  |find 'a' (occ = 2 off = 10):         { result } | ).
*
*     result = find( val = text sub = 'a' case = abap_false occ = -1 off = 10 ).
*    out->write(  |find 'a' (occ = -1 off = 10):         { result } | ).
*
*    result = find( val = text sub = 'a' case = abap_false occ = 2 off = 10 len = 4 ).
*    out->write(  |Find 'a' (occ = 2 off = 10 len = 4): { result } | ).

*return.





**Abb.67
*    DATA text TYPE string      VALUE `  SAP BTP, ABAP environment  `.
*
*    out->write( |Input String              = { text }|  ).
*
*
*** Description Function (returns integer value)
************************************************************************
*
*    DATA result_int TYPE i.
*
*    result_int = numofchar(  text ) .
*
*    out->write( |NUMOFCHAR                 = { result_int }  | ).
*
*
*    result_int = strlen(  text ) .
*
*    out->write( |STRLEN                 = { result_int }  | ).
*
*
*
*
*    result_int = find(  val = text sub = 'env' ).
*
*    out->write( |FIND  'env'               = { result_int }  | ).
*
** Processing Function (returns string value)
***********************************************************************
*
*    DATA result_string TYPE string.
*
*    result_string = replace(  val = text sub = 'env' with = 'Env' ).
*
*    out->write( |REPLACE 'env' with 'Env'  = { result_string }  | ).
*
*** Predicate Function ( serves as a logical expression )
************************************************************************
*
*    IF contains(  val = text  sub = 'env' ).
*
*      out->write( |CONTAINS 'env'            is true | ).
*
*    ELSE.
*
*      out->write( |CONTAINS 'env'            is false | ).
*
*    ENDIF.
*
*    " use function XSDBOOL(  ) to convert predicate function
*    " to values 'X' (for true) and ' ' (for false)
*
*    DATA result_char1 TYPE abap_bool.   "TYPE c LENGTH 1.
*    result_char1 = xsdbool(  contains(  val = text sub = 'env' ) ).
*
*    out->write( |XSDBOOL( CONTAINS 'env' ) = { result_char1 }| ).
*
*
*    IF xsdbool(  contains(  val = text sub = 'env' ) ) = abap_true.
*      out->write( 'True' ).
*
*    ENDIF.

*    RETURN.




*Abb.68
*    DATA result TYPE i.
*
*    DATA text    TYPE string VALUE `  abap oder ABAP ist cool  `.
*    DATA text    TYPE string VALUE ` coolABAP `.
*    DATA substring TYPE string VALUE `AB`. "" das ist mein Suchmuster
*    DATA offset    TYPE i      VALUE 1. "" Ab Anzahl der Zeichen im Text


*** Call different description functions
******************************************************************************
*
*    out->write( |Input string: '{ text }'| ).
*    out->write( `----------------------------------` ).
*
*    result = strlen( text ).
*    out->write( |Strlen:              { result }| ). "" 10
*
*    result = numofchar(  text ).
*    out->write( |Numofchar:           { result }| ). "" 8+ Leerzeichen davor und mittendrin, die hinteren letzten Leerzeichen werden nicht mitgezählt
*
*    result = count(             val = text sub = substring off = offset ). "" 1
*    out->write( |Count { substring }:            { result }| ).
*
*    result = find(             val = text sub = substring off = offset ). "" 5
*    out->write( |Find { substring }:             { result }| ).
*
*    result = count_any_of(     val = text sub = substring off = offset ).""1
*    out->write( |Count_any_of { substring }:     { result }| ).
*    "" `  ABAP  `
*    result = find_any_of(      val = text sub = substring off = offset )."" 1
*    out->write( |Find_any_of { substring }:      { result }| ).
*
*    result = count_any_not_of( val = text sub = substring off = offset ).""6
*    out->write( |Count_any_not_of { substring }: { result }| ).
*
*    result = find_any_not_of(  val = text sub = substring off = offset )."" 8
*    out->write( |Find_any_not_of { substring }:  { result }| ).

*    RETURN.


**Abb.69
* DATA text TYPE string      VALUE ` SAP_BTP,   ABAP_En_vironment  `.
*
*    out->write( |Input string:          '{ text }'| ).
*    out->write( `------------------------------------------------------------------` ).
*
*** Change Case of characters
************************************************************************
*    out->write( |TO_UPPER             = '{   to_upper(  text ) }' | ).
*    out->write( |TO_LOWER             = '{   to_lower(  text ) }' | ).
*    out->write( |TO_MIXED             = '{   to_mixed(  text ) }' | ).
*    out->write( |FROM_MIXED           = '{ from_mixed(  text ) }' | ).
*
*
*** Change order of characters
************************************************************************
*    out->write( |REVERSE              = '{  reverse( text ) }' | ).
*    out->write( |SHIFT_LEFT  (places 3) = '{  shift_left(  val = text places   = 3  ) }' | ).
*    out->write( |SHIFT_RIGHT (places 3) = '{  shift_right( val = text places   = 3  ) }' | ).
*    out->write( |SHIFT_LEFT  (circ 3)   = '{  shift_left(  val = text circular = 3  ) }' | ).
*    out->write( |SHIFT_RIGHT (circ 3)   = '{  shift_right( val = text circular = 3  ) }' | ).
*
*
*** Extract a Substring
************************************************************************
*    out->write( |SUBSTRING (off 4, len 10)  = '{  substring(        val = text off = 4 len = 10 ) }' | ).
*    "" Substring from, Fundstelle und alles dahinter wird genommen
*    out->write( |SUBSTRING_FROM             = '{  substring_from(   val = text sub = 'ABAP'     ) }' | ).
*    """ after ohne fundstelle ausgegeben
*    out->write( |SUBSTRING_AFTER            = '{  substring_after(  val = text sub = 'ABAP'     ) }' | ).
*    "" Fundstelle inkl. alles vorne
*    out->write( |SUBSTRING_TO               = '{  substring_to(     val = text sub = 'ABAP'     ) }' | ).
*    "" Alles was vor der Fundstelle steht, ohne Fundstelle
*    out->write( |SUBSTRING_BEFORE           = '{  substring_before( val = text sub = 'ABAP'     ) }' | ).
*
*
*** Condense, REPEAT and Segment
************************************************************************
*    "" Reduzierung der LEERZEICHEN auf "normal, vorne hinten weg,
*    "" Zwischen den zeichen auf 1 Leerzeichen reduziert, so wie man es schreiben würde
*    out->write( |CONDENSE             = '{   condense( val = text )         }' | ).
*    out->write( |REPEAT               = '{   repeat(   val = text occ = 2 ) }' | ).
*
*    out->write( |SEGMENT1 mit Index 1 = '{   segment(  val = text sep = ',' index = 1 ) }' |  ).
*    out->write( |SEGMENT2 mit Index 2 = '{   segment(  val = text sep = ',' index = 2 ) }' |  ).
*
*    out->write( |TO_MIXED             = '{   to_mixed( val = '##ABAP_is_cool' sep = '_' ) }' | ).

*    RETURN.

**Abb.71
**Eine Übergabe von substring an start oder end bedeutet, dass die Übereinstimmungen direkt hintereinander am Anfang bzw.
**am Ende des Suchbereichs vorkommen müssen, während sie bei sub irgendwo im Suchbereich vorkommen können.
*
*    DATA text TYPE string      VALUE ` SAP BTP,   ABAP Environment  `.
*
*    out->write( |Input string:          '{ text }'| ).
*    out->write( `------------------------------------------------------------------` ).
*
** Check if a string contains a certain substring
***********************************************************************
*    """ xsdbool ist für X gefunden oder NULL nicht gefunden
*    out->write( |CONTAINS 'ABAP':                           { xsdbool( contains( val = text sub   = 'ABAP' ) ) } | ).
*    out->write( |CONTAINS 'ABAP', off = 20:                 { xsdbool( contains( val = text sub   = 'ABAP' off = 20 ) ) } | ).
*    out->write( |CONTAINS 'ABAP', start ='ABAP', off = 12:  { xsdbool( contains( val = text start = 'ABAP' off = 12 ) ) } | ).
*
** Check if a string contains any characters from a list of characters
***********************************************************************
*    out->write( |CONTAINS_ANY_OF 'ABC':                     { xsdbool( contains_any_of( val = text sub   = 'ABC' ) ) } | ).
*    out->write( |CONTAINS_ANY_OF 'XYZ':                     { xsdbool( contains_any_of( val = text sub   = 'XYZ' ) ) } | ).
*
** Check if a string contains any characters outside of a list of characters
******************************************************************************
*    out->write( |CONTAINS_ANY_NOT_OF 'ABC':                 { xsdbool( contains_any_not_of( val = text sub   = 'ABC' ) ) } | ).
*    out->write( |CONTAINS_ANY_NOT_OF 'XYZ':                 { xsdbool( contains_any_not_of( val = text sub   = 'XYZ' ) ) } | ).

*    RETURN.

*Abb.75
    DATA text TYPE string      VALUE `1989-11-09`.
*    DATA text TYPE string      VALUE `For example, 1989-11-09 is a date in ISO-Format`.
*   DATA text TYPE string      VALUE `For example, 12.30.2189 is not in ISO-Format`.
*   DATA text TYPE string      VALUE `50.30.2189`.

*    DATA regex TYPE string VALUE '[0-9]{4}{2}(-[0-9]{2})'.
    DATA regex TYPE string VALUE '[0-9]{4}-[0-9]{2}-[0-9]{2}'."" Regular expression ist ISO Format
*    DATA regex TYPE string VALUE '[0-9]{4}(-[0-9]{2})'.
*
*
*    DATA text TYPE string VALUE 'demo1.demo2@gmx.net'.
*
*    """ Codierung von Punkt, damit ich den Punkt nicht als Platzhalter für beliebig benutze
*    """ wird ein  \ davor gestellt => für 12.30.2189
*   DATA regex TYPE string VALUE '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'.

    out->write( |Text to be processed    = `{ text  }` | ).
    out->write( |Regular Expression      = `{ regex }` | ).
    out->write(  `--------------------------------------------------` ).

    IF NOT contains(   val = text pcre = regex   ).
      out->write( `Did not find any matching substring` ).
    ELSE.

      DATA(number) = count(  val = text pcre = regex ).

      out->write( |Number of findings      = { number } | ).

      DATA(offset) = find(  val = text pcre = regex occ = 1 ).

      out->write( |Offset of 1st finding   = { offset } | ).

      DATA(date_text) = match(  val = text pcre = regex occ = 1 ).

      out->write( |1st finding (extracted) = `{ date_text }` | ).

      IF matches(  val = text pcre = regex  ).
        out->write( `This is a complete match` ).
      ELSE.
        out->write( `Not a complete match` ).
      ENDIF.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
