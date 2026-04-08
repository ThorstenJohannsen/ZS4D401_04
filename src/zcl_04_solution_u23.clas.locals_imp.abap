*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


*Übung 21 Das Interface wird in den Klassen lcl_flight und lcl_carrier implementiert
*In beiden Klassen wird die gleiche Methode get_output unterschiedlich ausprogrammiert.

INTERFACE lif_output.

  TYPES t_output TYPE c LENGTH 40.
  TYPES tt_output TYPE STANDARD TABLE OF t_output
                  WITH NON-UNIQUE DEFAULT KEY.


  METHODS get_output RETURNING VALUE(r_result) TYPE tt_output.

ENDINTERFACE.

CLASS lcl_flight DEFINITION ABSTRACT.

  PUBLIC SECTION.
    INTERFACES lif_output.
    ALIASES get_output FOR lif_output~get_output.

    "" Übung 20 hier der Typ der Collection
    TYPES tab TYPE STANDARD TABLE OF REF TO lcl_flight WITH DEFAULT KEY.

    TYPES: BEGIN OF st_connection_details,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             departure_time  TYPE /dmo/flight_departure_time,
             arrival_time    TYPE /dmo/flight_departure_time,
             duration        TYPE i,
           END OF st_connection_details.

    DATA carrier_id    TYPE /dmo/carrier_id       READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id    READ-ONLY.
    DATA flight_date   TYPE /dmo/flight_date      READ-ONLY.

    METHODS: get_connection_details
      RETURNING
        VALUE(r_result) TYPE st_connection_details.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
        i_flight_date   TYPE /dmo/flight_date.



  PROTECTED SECTION.
    DATA planetype TYPE /dmo/plane_type_id.
    DATA connection_details TYPE st_connection_details.

    METHODS get_description RETURNING VALUE(r_result) TYPE string_table.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_flight IMPLEMENTATION.

  METHOD constructor.

    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.
    me->flight_date = i_flight_date.

  ENDMETHOD.

  METHOD get_connection_details.
    r_result = me->connection_details.
  ENDMETHOD.

  METHOD get_description.

    DATA txt TYPE string.

    txt = TEXT-005.
    txt = replace(  val = txt sub = '&carrid&' with = carrier_id ).
    txt = replace(  val = txt sub = '&connid&' with = connection_id ).
    txt = replace(  val = txt sub = '&date&' with = |{ flight_date DATE = USER }| ).
    txt = replace(  val = txt sub = '&from&' with = connection_details-airport_from_id ).
    txt = replace(  val = txt sub = '&to&' with = connection_details-airport_to_id ).

    APPEND txt TO r_result.

    APPEND |Planetype:      { planetype  } | TO r_result ##NO_TEXT.


  ENDMETHOD.

  METHOD lif_output~get_output.
    r_result = get_description(  ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_passenger_flight DEFINITION INHERITING FROM lcl_flight.

  PUBLIC SECTION.
    """ Übung 19. Die Variablen wurden in die "Mutter" geschoben, von der wir geerbt haben.
    """ deshalb sind diese hier gelöscht.


    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
        i_flight_date   TYPE /dmo/flight_date.

    TYPES
      tt_flights TYPE STANDARD TABLE OF REF TO lcl_passenger_flight WITH DEFAULT KEY.



    METHODS
      get_free_seats
        RETURNING
          VALUE(r_result) TYPE i.



    CLASS-METHODS class_constructor.

    CLASS-METHODS
      get_flights_by_carrier
        IMPORTING
          i_carrier_id    TYPE /dmo/carrier_id
        RETURNING
          VALUE(r_result) TYPE tt_flights.

  PROTECTED SECTION.
    METHODS
      get_description REDEFINITION.

  PRIVATE SECTION.



    DATA seats_max  TYPE /dmo/plane_seats_max.
    DATA seats_occ  TYPE /dmo/plane_seats_occupied.
    DATA seats_free TYPE i.

    DATA price TYPE /dmo/flight_price.
    CONSTANTS currency TYPE /dmo/currency_code VALUE 'EUR'.


    "" Übung 4 Seite 53 Select Single /lrn/passflight anweisung ändern im constructor
    TYPES: BEGIN OF st_flights_buffer,
             carrier_id     TYPE /dmo/carrier_id,
             connection_id  TYPE /dmo/connection_id,
             flight_date    TYPE /dmo/flight_date,
             price          TYPE /dmo/flight_price,
             currency_code  TYPE /dmo/currency_code,
             plane_type_id  TYPE /dmo/plane_type_id,
             seats_max      TYPE /dmo/plane_seats_max,
             seats_occupied TYPE /dmo/plane_seats_occupied,
             seats_free     TYPE i, "" neu mit Übung 11 Aufgabe 2 eingefügt
           END OF st_flights_buffer.
****"" Übung 16 Umstellung auf Sorted Table
*    CLASS-DATA flights_buffer TYPE SORTED TABLE OF st_flights_buffer
*                                    WITH NON-UNIQUE KEY carrier_id connection_id flight_date.

***"" Übung 17 Umstellung auf HASHED Table
    CLASS-DATA flights_buffer TYPE HASHED TABLE OF st_flights_buffer
                                    WITH UNIQUE KEY carrier_id connection_id flight_date
                                    WITH NON-UNIQUE SORTED KEY sk_carrier COMPONENTS carrier_id.

    "" Übung 5 Seite 71 Aufgabe 4
    TYPES: BEGIN OF st_connections_buffer,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             departure_time  TYPE /dmo/flight_departure_time,
             arrival_time    TYPE /dmo/flight_arrival_time,
             timzone_from    TYPE /lrn/airport-timzone, "" für Übung 10
             timzone_to      TYPE /lrn/airport-timzone, "" für Übung 10
             duration        TYPE i, "" für Übung 7 eingefügt.

           END OF st_connections_buffer.
***** """" Übung 16 Tabelle auf HASH umgestellt
    CLASS-DATA connection_buffer TYPE HASHED TABLE OF st_connections_buffer
                                        WITH UNIQUE KEY carrier_id connection_id.

ENDCLASS.


CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD class_constructor.
    """ Übung  Class Constructor erstellt! Die Fields Anweisung entspricht exact dem Type st_connections_buffer oben
    SELECT FROM /dmo/connection
        FIELDS carrier_id, connection_id, airport_from_id, airport_to_id, departure_time, arrival_time
        INTO TABLE @connection_buffer.

    """ Übung 7 Airports und Zeiten einfügen
    SELECT FROM /lrn/airport
        FIELDS airport_id, timzone INTO TABLE @DATA(airports).
    """ Übung 7 wichtig ist ein Datum für die Berechnung der Stunden
    DATA(today) = cl_abap_context_info=>get_system_date(  ).

    "Übung 10 ohne Alias
    SELECT  FROM /dmo/connection
     LEFT OUTER JOIN /lrn/airport AS a
        ON /dmo/connection~airport_from_id = a~airport_id
     LEFT OUTER JOIN /lrn/airport AS b
        ON /dmo/connection~airport_to_id = b~airport_id
        FIELDS carrier_id, connection_id, airport_from_id, airport_to_id, departure_time, arrival_time,
               a~timzone AS timzone_from, b~timzone AS timzone_to,

      "Übung 12
*      div( tstmp_seconds_between( tstmp1 = dats_tims_to_tstmp( date = @today, time = departure_time,
*                                    tzone = a~timzone ),
*                                  tstmp2 = dats_tims_to_tstmp( date = @today, time = arrival_time,
*                                     tzone = b~timzone ) )  ,  60 ) AS duration
         CASE
            WHEN div( tstmp_seconds_between( tstmp1 = dats_tims_to_tstmp( date = @today, time = departure_time,
                                    tzone = a~timzone ),
                                  tstmp2 = dats_tims_to_tstmp( date = @today, time = arrival_time,
                                     tzone = b~timzone ) )  ,  60 ) < 0
            THEN

                div( tstmp_seconds_between( tstmp1 = dats_tims_to_tstmp( date = @today, time = departure_time,
                                    tzone = a~timzone ),
                                  tstmp2 = dats_tims_to_tstmp( date = dats_add_days( @today, 1 ), time = arrival_time,
                                     tzone = b~timzone ) )  ,  60 )

            ELSE
                div( tstmp_seconds_between( tstmp1 = dats_tims_to_tstmp( date = @today, time = departure_time,
                                    tzone = a~timzone ),
                                  tstmp2 = dats_tims_to_tstmp( date = @today, time = arrival_time,
                                     tzone = b~timzone ) )  ,  60 )

            END AS duration

        INTO TABLE @connection_buffer.



    """" das muss weg wegen Übung 12, jetzt in der Select Anweisung für die DB
*        LOOP AT connection_buffer INTO DATA(connection).
*          """ Wenn Flüge über Mitternacht stattfinden, muss die Berechnung anders sein!!
*          """ hier werden die Stunden umgerechnet auf UTC Zeit z.B. hier Frankfurt 11:00 Uhr -> UTC 10 Uhr
*          CONVERT DATE today TIME connection-departure_time
*          time ZONE connection-timzone_from INTO UTCLONG DATA(departure_utclong).
*          """alte für bung 07 oder so
**          TIME ZONE airports[ airport_id = connection-airport_from_id ]-timzone
**          INTO UTCLONG DATA(departure_utclong).
*
*          """ hier werden die Stunden umgerechnet auf UTC Zeit z.B. hier New York 12:00 Uhr -> UTC 16 Uhr
*          CONVERT DATE today TIME connection-arrival_time
*          time ZONE connection-timzone_to INTO UTCLONG DATA(arrival_utclong).
*          """alte für bung 07 oder so
**          TIME ZONE airports[ airport_id = connection-airport_to_id ]-timzone
**          INTO UTCLONG DATA(arrival_utclong).
*
*          """ Zusatzaufgabe der Flüge wo der Ankunftstag ein Tag später ist.
*          IF departure_utclong > arrival_utclong.
*
*            arrival_utclong = utclong_add( val = arrival_utclong
*                                           days = 1 ).
*          ENDIF.
*
*          connection-duration = utclong_diff( high = arrival_utclong
*                                                  low  = departure_utclong ) / 60.
*          MODIFY connection_buffer FROM connection TRANSPORTING duration.
*
*        ENDLOOP.


  ENDMETHOD.

  METHOD get_flights_by_carrier.

*** """ wegen Übung 14 hier noch Anpassungen
*** """ Übung 17 Secondary key eingefügt
    IF NOT line_exists( flights_buffer[ KEY sk_carrier carrier_id = i_carrier_id ] ).

      SELECT FROM /lrn/passflight
      "" FIELDS * mit Übung 11 Aufgabe 2 geändert
      FIELDS carrier_id, connection_id, flight_date,
      """Übung 12
       currency_conversion(
                           amount = price,
                           source_currency = currency_code,
                           target_currency = @currency,
                           exchange_rate_date = flight_date,
                           on_error = @sql_currency_conversion=>c_on_error-set_to_null
                           )     AS   price,
         @currency AS currency_code, plane_type_id,
              seats_max, seats_occupied, seats_max -  seats_occupied AS seats_free
      WHERE carrier_id = @i_carrier_id
*    ORDER BY flight_date "" Übung 13 mit Übung 14 wieder auskommentieren
*    INTO CORRESPONDING FIELDS OF TABLE @flights_buffer. "" mit Übung 14 geändert auf APPENDING
      APPENDING CORRESPONDING FIELDS OF TABLE @flights_buffer.
*      SORT flights_buffer BY carrier_id connection_id flight_date. "" mit Übung 16 wieder rausgenommen
**      "" unten wieder rausgenommen, da die IF-Anweisung oben mit der Existensüberprüfung, wird die
***     "" DELETE Anweisung unten wieder gelöscht.
*      DELETE ADJACENT DUPLICATES FROM flights_buffer COMPARING carrier_id connection_id flight_date.

    ENDIF.

    """ WHERE eingefügt mit Übung 14, um doppelte Fluggesellschaften wieder zu löschen,
    """ damit wir keine Duplikate haben
*    LOOP AT flights_buffer INTO DATA(flight) WHERE carrier_id = i_carrier_id.
*      APPEND NEW lcl_passenger_flight( i_carrier_id    = flight-carrier_id
*                                       i_connection_id = flight-connection_id
*                                       i_flight_date   = flight-flight_date )
*              TO r_result.
*
*    ENDLOOP.

****""" Inline Variante field symbols
*Loop at flights_buffer assigning field-symbols( <fs> ).
*endloop.
****"" Übung 15 die Schleife unten (intern) mit Feldsymbolen
****"" Übung 17 den USING KEY eingefügt
    r_result = VALUE #( FOR <line> IN flights_buffer
                            USING KEY sk_carrier
                            WHERE ( carrier_id = i_carrier_id ) "" die Klause geht auf flight_buffer!!
                            ( NEW lcl_passenger_flight(
                                                i_carrier_id    = <line>-carrier_id
                                                i_connection_id = <line>-connection_id
                                                i_flight_date   = <line>-flight_date )
                            )
                       ).

**** "" Hier die Anweisung wegen Übung 14 // Aufpassen mit den Klammern
*    r_result = VALUE #( FOR line IN flights_buffer
*                            WHERE ( carrier_id = i_carrier_id ) "" die Klause geht auf flight_buffer!!
*                            ( NEW lcl_passenger_flight(
*                                                i_carrier_id    = line-carrier_id
*                                                i_connection_id = line-connection_id
*                                                i_flight_date   = line-flight_date )
*                            )
*                       ).

**** Hier die alte Select anweisung mit kleinen Änderungen, die wichtig sind
*      SELECT
*        FROM /lrn/passflight
*      FIELDS carrier_id, connection_id, flight_date
*       WHERE carrier_id    = @i_carrier_id
*        INTO TABLE @DATA(keys).  "" hier steht key, oben nehmen wir den flights_buffer
*
*        LOOP AT keys INTO DATA(key).
*          APPEND NEW lcl_passenger_flight( i_carrier_id    = key-carrier_id
*                                           i_connection_id = key-connection_id
*                                           i_flight_date   = key-flight_date )
*                  TO r_result.
*        ENDLOOP.

  ENDMETHOD.


  METHOD constructor.
    "" Übung 19 wegen Verrerbung muss dieser aufruf hier rein
    super->constructor(
              i_carrier_id    = I_carrier_id
              i_connection_id = i_connection_id
              i_flight_date   = i_flight_date
            ).

    """ Übung 4 Anfang
    TRY.
        "" Hier wird auf die erstellte Tabelle bei get_flights..
        DATA(flight_raw) = flights_buffer[ carrier_id    = i_carrier_id
                                           connection_id = i_connection_id
                                           flight_date   = i_flight_date ].
      CATCH cx_root.
        SELECT SINGLE
           FROM /lrn/passflight
         FIELDS carrier_id, connection_id, flight_date,  plane_type_id, seats_max, seats_occupied,

  currency_conversion(                                          "Übung 12
                       amount = price,
                       source_currency = currency_code,
                       target_currency = @currency,
                       exchange_rate_date = flight_date,
                       on_error = @sql_currency_conversion=>c_on_error-set_to_null
                       )     AS   price,
     @currency AS currency_code,
   seats_max - seats_occupied AS seats_free  "Übung 11
          WHERE carrier_id    = @i_carrier_id
            AND connection_id = @i_connection_id
            AND flight_date   = @i_flight_date
           INTO CORRESPONDING FIELDS OF @flight_raw.

    ENDTRY.

    IF flight_raw IS NOT INITIAL.
      """ Übung 4 Ende
      me->carrier_id    = i_carrier_id.
      me->connection_id = i_connection_id.
      me->flight_date   = i_flight_date.

      planetype = flight_raw-plane_type_id.
      seats_max = flight_raw-seats_max.
      seats_occ = flight_raw-seats_occupied.
      ""Übung 11 Aufgabe 2 deshalb Berechnung hier rausgenommen, macht nun DB in SELECT
*              seats_free = flight_raw-seats_max - flight_raw-seats_occupied.
      seats_free = flight_raw-seats_free.
      price = flight_raw-price.

* convert currencies
***""" für Aufgabe 12 rausgenommen
*              TRY.
*                  cl_exchange_rates=>convert_to_local_currency(
*                    EXPORTING
*                      date              = me->flight_date
*                      foreign_amount    = flight_raw-price
*                      foreign_currency  = flight_raw-currency_code
*                      local_currency    = me->currency
*                    IMPORTING
*                      local_amount      = me->price
*                  ).
*                CATCH cx_exchange_rates.
*                  price = flight_raw-price.
*              ENDTRY.

** Set connection details
*      SELECT SINGLE
*        FROM /dmo/connection
*      FIELDS airport_from_id, airport_to_id, departure_time, arrival_time
*       WHERE carrier_id    = @carrier_id
*         AND connection_id = @connection_id
*        INTO @connection_details .

      """ Übung 5 neu gemacht, der Buffer hat alle Daten,
      """ die Variablen werden durch die Methode eingelesen

      connection_details = CORRESPONDING #( connection_buffer[ carrier_id = i_carrier_id
                                              connection_id = i_connection_id ] ).
      """ Diese Berechnung ist falsch, deswegen haben wir es auskommentiert
      """ Übung 7
*      connection_details-duration = connection_details-arrival_time
*                                  - connection_details-departure_time.

    ENDIF.
  ENDMETHOD.


  METHOD get_free_seats.
    r_result = me->seats_free.
  ENDMETHOD.

  METHOD get_description.

    r_result = super->get_description( ).

    APPEND |Maximum Seats:  { seats_max  } | TO r_result ##NO_TEXT.
    APPEND |Occupied Seats: { seats_occ } | TO r_result ##NO_TEXT.
    APPEND |Free Seats:     { seats_free } | TO r_result ##NO_TEXT.
    APPEND |Ticket Price:   { price CURRENCY = currency } { currency } | TO r_result ##NO_TEXT.
    APPEND |Duration    :   { connection_details-duration } minutes  | TO r_result ##NO_TEXT.

  ENDMETHOD.

ENDCLASS.


***********************************************************************************
****nächste Klasse lcl_cargo_flight !!!! *******************************************

CLASS lcl_cargo_flight DEFINITION INHERITING FROM lcl_flight.

  PUBLIC SECTION.
    """ Übung 19. Die Variablen wurden in die "Mutter" geschoben, von der wir geerbt haben.
    """ deshalb sind diese hier gelöscht.


    TYPES
       tt_flights TYPE STANDARD TABLE OF REF TO lcl_cargo_flight WITH DEFAULT KEY.


    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
        i_flight_date   TYPE /dmo/flight_date.

*    METHODS get_connection_details
*      RETURNING
*        VALUE(r_result) TYPE st_connection_details.

    METHODS
      get_free_capacity
        RETURNING
          VALUE(r_result) TYPE /lrn/plane_actual_load.



    CLASS-METHODS
      get_flights_by_carrier
        IMPORTING
          i_carrier_id    TYPE /dmo/carrier_id
        RETURNING
          VALUE(r_result) TYPE tt_flights.

  PROTECTED SECTION.

    METHODS get_description REDEFINITION.

  PRIVATE SECTION.

    TYPES: BEGIN OF st_flights_buffer,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             flight_date     TYPE /dmo/flight_date,
             plane_type_id   TYPE /dmo/plane_type_id,
             maximum_load    TYPE /lrn/plane_maximum_load,
             actual_load     TYPE /lrn/plane_actual_load,
             load_unit       TYPE /lrn/plane_weight_unit,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             departure_time  TYPE /dmo/flight_departure_time,
             arrival_time    TYPE /dmo/flight_arrival_time,
           END OF st_flights_buffer.

    TYPES tt_flights_buffer TYPE HASHED TABLE OF st_flights_buffer
                            WITH UNIQUE KEY carrier_id connection_id flight_date.

    DATA maximum_load TYPE /lrn/plane_maximum_load.
    DATA actual_load TYPE /lrn/plane_actual_load.
    DATA load_unit    TYPE /lrn/plane_weight_unit.

    CLASS-DATA flights_buffer TYPE tt_flights_buffer.

ENDCLASS.

CLASS lcl_cargo_flight IMPLEMENTATION.

  METHOD get_flights_by_carrier.

    SELECT
      FROM /lrn/cargoflight
    FIELDS carrier_id, connection_id, flight_date,
           plane_type_id, maximum_load, actual_load, load_unit,
           airport_from_id, airport_to_id, departure_time, arrival_time
     WHERE carrier_id    = @i_carrier_id
     ORDER BY flight_date "" Aufgabe 13
      INTO CORRESPONDING FIELDS OF TABLE @flights_buffer.

    LOOP AT flights_buffer INTO DATA(flight).
      APPEND NEW lcl_cargo_flight( i_carrier_id    = flight-carrier_id
                                   i_connection_id = flight-connection_id
                                   i_flight_date   = flight-flight_date )
              TO r_result.

    ENDLOOP.
  ENDMETHOD.

  METHOD constructor.
    "" Übung 19 wegen Verrerbung muss dieser aufruf hier rein
    super->constructor(
              i_carrier_id    = i_carrier_id
              i_connection_id = i_connection_id
              i_flight_date   = i_flight_date
                      ).
    " Read buffer
    TRY.
        DATA(flight_raw) = flights_buffer[ carrier_id    = i_carrier_id
                                           connection_id = i_connection_id
                                           flight_date   = i_flight_date ].

      CATCH cx_sy_itab_line_not_found.
        " Read from database if data not found in buffer
        SELECT SINGLE
          FROM /lrn/cargoflight
        FIELDS plane_type_id, maximum_load, actual_load, load_unit,
               airport_from_id, airport_to_id, departure_time, arrival_time
         WHERE carrier_id    = @i_carrier_id
           AND connection_id = @i_connection_id
           AND flight_date   = @i_flight_date
          INTO CORRESPONDING FIELDS OF @flight_raw.
    ENDTRY.

    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.
    flight_date   = i_flight_date.

    planetype = flight_raw-plane_type_id.
    maximum_load = flight_raw-maximum_load.
    actual_load = flight_raw-actual_load.
    load_unit = flight_raw-load_unit.

    connection_details = CORRESPONDING #( flight_raw ).

    connection_details-duration = me->connection_details-arrival_time
                                    - me->connection_details-departure_time.

  ENDMETHOD.


*  METHOD get_connection_details.
*    r_result = me->connection_details.
*  ENDMETHOD.


  METHOD get_free_capacity.
    r_result = maximum_load - actual_load.
  ENDMETHOD.

  METHOD get_description.

*    APPEND |Flight { carrier_id } { connection_id } on { flight_date DATE = USER } | && ##NO_TEXT
*           |from { connection_details-airport_from_id } to { connection_details-airport_to_id } | ##NO_TEXT
*           TO r_result.
*    APPEND |Planetype:     { planetype } |                         TO r_result ##NO_TEXT.

    r_result = super->get_description( ).

    APPEND |Maximum Load:  { maximum_load         } { load_unit }| TO r_result ##NO_TEXT.
    APPEND |Free Capacity: { get_free_capacity( ) } { load_unit }| TO r_result ##NO_TEXT.

  ENDMETHOD.

ENDCLASS.


***********************************************************************************
****nächste Klasse lcl_carrier !!!! *******************************************

CLASS lcl_carrier DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES lif_output.
    ALIASES: get_output FOR lif_output~get_output,
             t_output FOR lif_output~t_output,
             tt_output FOR lif_output~tt_output.
    """ Übung 23
    class-METHODS get_instance
      IMPORTING
                i_carrier_id    TYPE /dmo/carrier_id
      RETURNING VALUE(r_result) TYPE REF TO lcl_carrier

      RAISING   cx_abap_invalid_value
                cx_abap_auth_check_exception.

    DATA carrier_id TYPE /dmo/carrier_id READ-ONLY.

    METHODS constructor
      IMPORTING
                i_carrier_id TYPE /dmo/carrier_id
      RAISING   cx_abap_invalid_value
                cx_abap_auth_check_exception.


    METHODS find_passenger_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id
        i_from_date       TYPE /dmo/flight_date
        i_seats           TYPE i
      EXPORTING
        e_flight          TYPE REF TO lcl_flight "" Übung 20 hier Upcast auf lcl-flight -> Passenger_flights
        e_days_later      TYPE i.


    METHODS find_cargo_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id
        i_from_date       TYPE /dmo/flight_date
        i_cargo           TYPE /lrn/plane_actual_load
      EXPORTING
        e_flight          TYPE REF TO lcl_flight "" Übung 20 hier Upcast auf lcl-flight -> Cargo_flights
        e_days_later      TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA name          TYPE /dmo/carrier_name .
    DATA currency_code TYPE /dmo/currency_code ##NEEDED.

*    DATA passenger_flights TYPE lcl_passenger_flight=>tt_flights.
*    DATA passenger_flights TYPE lcl_passenger_flight=>tt_flights.
*
*    DATA cargo_flights TYPE lcl_cargo_flight=>tt_flights.

    DATA flights TYPE lcl_flight=>tab.  " Übung 20 Collection für alle Flüge
    DATA pf_count TYPE i.  " Übung 20 Anzahl der Passagier-Flüge
    DATA cf_count TYPE i.  " Übung 20 Anzahl der Fracht-Flüge

    METHODS get_average_free_seats
      RETURNING VALUE(r_result) TYPE i.

    "" Übung 23 Instanzattribut instances erstellen, damit wir die Instanz speichern
    "" können und nur einmal erstellen!
    class-data instances type table of ref TO lcl_carrier with defAULT KEY.

ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.

    me->carrier_id = i_carrier_id.

    ""Übung 11 Aufgabe 3 rauskommentiert
*  name = carrier_id && ` ` && name.
**"" Übung 20 neu
    DATA(passenger_flights) = lcl_passenger_flight=>get_flights_by_carrier(
                                    i_carrier_id    = i_carrier_id ).
    pf_count = lines(  passenger_flights ).

    DATA(cargo_flights) = lcl_cargo_flight=>get_flights_by_carrier(
                                i_carrier_id    = i_carrier_id ).
    cf_count = lines(  cargo_flights ).


    LOOP AT passenger_flights INTO DATA(passflight). ""Übung 20Flüge in die Collection übertragen
      APPEND passflight TO flights.  "" Übung 20 Up Cast zur Mutter lcl_flight!
    ENDLOOP.

    LOOP AT cargo_flights INTO DATA(cargoflight). ""Übung 20Flüge in die Collection übertragen
      APPEND cargoflight TO flights.  "" Übung 20 Up Cast zur Mutter lcl_flight!
    ENDLOOP.

**alter Code vor Übung 20
*    me->passenger_flights =
*        lcl_passenger_flight=>get_flights_by_carrier(
*              i_carrier_id    = i_carrier_id ).

*    me->cargo_flights =
*        lcl_cargo_flight=>get_flights_by_carrier(
*              i_carrier_id    = i_carrier_id ).

  ENDMETHOD.

  METHOD lif_output~get_output.

    APPEND |{ 'Carrier'(001) } { me->name } | TO r_result.
    APPEND |{ 'Passenger Flights:'(002) }  { pf_count } | TO r_result. "" Übung 20 pf_count eingefügt statt lines..
    APPEND |{ 'Average free seats:'(003) } { get_average_free_seats(  ) } | TO r_result.
    APPEND |{ 'Cargo Flights:'(004) }      { cf_count } | TO r_result. "" Übung 20 cf_count eingefügt statt lines..

  ENDMETHOD.

  METHOD find_cargo_flight.

    e_days_later = 99999999 ##NUMBER_OK.

    LOOP AT me->flights INTO DATA(flight)
        WHERE table_line->flight_date >= i_from_date AND table_line IS INSTANCE OF lcl_cargo_flight.

      DATA(connection_details) = flight->get_connection_details(  ).

      IF connection_details-airport_from_id = i_airport_from_id
       AND connection_details-airport_to_id = i_airport_to_id
       AND CAST lcl_cargo_flight( flight )->get_free_capacity(  ) >= i_cargo.""" Übung 20 Down Cast

        DATA(days_later) =  flight->flight_date - i_from_date.

        IF days_later < e_days_later. "earlier than previous one?
          e_flight = flight.
          e_days_later = days_later.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD find_passenger_flight.

    e_days_later = 99999999.

    LOOP AT me->flights INTO DATA(flight)
         WHERE table_line->flight_date >= i_from_date AND table_line IS INSTANCE OF lcl_passenger_flight.

      DATA(connection_details) = flight->get_connection_details(  ).

      IF connection_details-airport_from_id = i_airport_from_id
       AND connection_details-airport_to_id = i_airport_to_id
       AND CAST lcl_passenger_flight( flight )->get_free_seats( ) >= i_seats.""" Übung 20 Down Cast
        DATA(days_later) = flight->flight_date - i_from_date.

        IF days_later < e_days_later. "earlier than previous one?
          e_flight = flight.
          e_days_later = days_later.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_average_free_seats.


    """ Übung 20 WHERE Bedingung wegen der Collection, die alle Flüge enthält!!
    """
    r_result = REDUCE #( INIT i = 0
                         FOR <line> IN flights WHERE ( table_line IS INSTANCE OF lcl_passenger_flight )
                         NEXT i = i + CAST lcl_passenger_flight( <line> )->get_free_seats(  ) """ Übung 20 hier Down Cast
                        ) / pf_count. "" Übung 20 Attribut eingefügt => lines( flights ) würde nicht funktionieren
    "" weil hier auch die Cargo Flüge mit dabei wären.

    """ REDUCE wird ab Seite 253 erklärt auch hier einfach Feldsymbole eingefügt
*    r_result = REDUCE #( INIT i = 0
*                         FOR <line> IN passenger_flights
*                         NEXT i = i + <line>->get_free_seats(  )
*                        ) / lines( passenger_flights ). "" lines Ausdruck ist nichts anderes als die anzahl der Flüge


**** """ Übung 13 mit Übung 14 wieder rausgenommen
*    SELECT FROM /lrn/passflight
*      FIELDS SUM( seats_max - seats_occupied ) AS sum, ""seats_free
*        COUNT( * ) AS count
*      WHERE carrier_id = @carrier_id
*      INTO @DATA(aggregates).
*
*    r_result = aggregates-sum / aggregates-count.

***""" Variante 2
*    SELECT FROM /lrn/passflight
*      FIELDS AVG( seats_max - seats_occupied ) ""seats_free
*      WHERE carrier_id = @carrier_id
*      INTO @DATA(aggregates_1).

*     r_result = aggregates_1.


*    DATA total TYPE i.
*
*    LOOP AT passenger_flights INTO DATA(flight).
*
*      total = total + flight->get_free_seats( ).
*
*    ENDLOOP.

*    r_result = total / lines( passenger_flights ).

  ENDMETHOD.

  METHOD get_instance.

    SELECT SINGLE
      FROM /dmo/carrier  ""/lrn/I_Carrier

      FIELDS concat_with_space(  Carrier_ID , name, 1 ) as name, currency_code "" Alter Code war ohne 'as name'!
      WHERE Carrier_ID = @i_carrier_id
      INTO @DATA(details).
*     INTO ( @me->name, @me->currency_code ). "" Alter Code


    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    "" Übung 18 jetzt mit Authority check
    AUTHORITY-CHECK OBJECT '/LRN/CARR'
            ID '/LRN/CARR' FIELD i_carrier_id
            ID 'ACTVT' FIELD '03'.


    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_auth_check_exception.
    ENDIF.

    "" Übung 23 Überprüfung von Instanzen
    TRY.
     r_result = instances[ table_line->carrier_id = i_carrier_id ].

     catch cx_sy_itab_line_not_found.
       r_result = new #( i_carrier_id = i_carrier_id ).

       r_result->name = details-name.
       r_result->currency_code = details-currency_code.

       append r_result to instances.

    endtry.



  ENDMETHOD.

ENDCLASS.
