CLASS ltcl_flights DEFINITION FINAL FOR TESTING
  DURATION LONG
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_find_cargo_flight FOR TESTING RAISING cx_static_check.

    CLASS-METHODS class_setup.

    CLASS-DATA the_carrier TYPE REF TO lcl_carrier.
    CLASS-DATA some_flight_data TYPE /lrn/cargoflight.

ENDCLASS.


CLASS ltcl_flights IMPLEMENTATION.

  METHOD test_find_cargo_flight.
*** S4D401 Seite 37
***Test 1 und Test 2 in die Statische Methode verschoben, deswegen haben wir die Variablen in Methods deklariert
*** und deshalb muss der Code umgeschrieben werden.
*    "Test 1
*    SELECT SINGLE FROM /lrn/cargoflight FIELDS carrier_id, connection_id,flight_date,
*                                        airport_from_id, airport_to_id
*                    INTO @DATA(some_flight_data).
*    IF sy-subrc <> 0.
*      cl_abap_unit_assert=>fail( 'Keine Daten in der Tabelle: /lrn/cargoflight' ).
*    ENDIF.
*
*    "Test 2
*    TRY.
*        DATA(the_carrier) = NEW lcl_carrier( i_carrier_id = some_flight_data-carrier_id  ).
*      CATCH cx_root.
*        cl_abap_unit_assert=>fail( 'Die Klasse: lcl_carrier konnet nicht instanziiert werden' ).
*    ENDTRY.


    "" Test 3 ist der Aufruf der Methode find_cargo_flight um zu sehen welche möglichen Fehler gibt es!
    the_carrier->find_cargo_flight(
      EXPORTING
        i_airport_from_id = some_flight_data-airport_from_id
        i_airport_to_id   = some_flight_data-airport_to_id
        i_from_date       = some_flight_data-flight_date
        i_cargo           = 1
      IMPORTING
        e_flight          = DATA(cargo_flight)
        e_days_later      = DATA(days_later) ).

    "" Fehlermöglichkeit 1 ist etwas am Objekt hier cargo_flight gefunden.
    "" Dann sind Daten vorhanden, dann ist das Objekt gebunden.
    cl_abap_unit_assert=>assert_bound(
           EXPORTING act = cargo_flight
               msg = 'Die Methode find_cargo_flight liefert kein Ergebnis zurück' ).

    "" Fehlermöglichkeit 2 ist den Rückgabewert von days_later zu prüfen.
    cl_abap_unit_assert=>assert_equals(
           EXPORTING
                act = days_later
                exp = 0
                msg = 'Die Methode find_cargo_flight liefert kein Ergebnis zurück' ).



  ENDMETHOD.

  METHOD class_setup.
************************************************************************
**** Statische Testmethoden erstellt, gehört zu Aufgabe 4 Seite 34
**** me=>methode gibt es in Statischen Methoden niemals, mann könnte aber ltcl_flights=>methode
     ""Test 1 hat die Tabelle einen Bestand
    SELECT SINGLE FROM /lrn/cargoflight
      FIELDS carrier_id, connection_id, flight_date, airport_from_id, airport_to_id
      "" hier müssen wir ohne DATA, denn die haben wir oben in der CLASS-METHODS deklariert
      "" und mit into Corresponding Fields of schreiben, weil die Tabelle mehr Felder hat
      "" als wir oben in FIELDS brauchen
      INTO corresponding fields of @some_flight_data.

    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( 'Keine Daten in der Tabelle: /lrn/cargoflight' ).
    ENDIF.

    "" Test 2 ist die Instanz vorhanden
    TRY.
        "" hier erstellen wir the_carrier ohne DATA, damit keine NEUE Variable erstellt wird!
        the_carrier = NEW lcl_carrier(  i_carrier_id = some_flight_data-carrier_id ).
      CATCH cx_root.
        "" diese fail Methode hat msg, detail, level und quit Seite 24 / 25
        cl_abap_unit_assert=>fail( 'Die Klasse lcl_carrier konnte nicht Instanziert werden' ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
