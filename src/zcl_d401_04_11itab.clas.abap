CLASS zcl_d401_04_11itab DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_11itab IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

***Abb.117,118  Seite 245
*    TYPES tt_flights TYPE STANDARD TABLE OF /dmo/flight
*                 WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
*    DATA  flights TYPE tt_flights.
*
*    flights = VALUE #(  ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' flight_date = '20230201' plane_type_id = '747-400' price = '600' currency_code = 'EUR'  )
*                        ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' flight_date = '20230115' plane_type_id = '747-400' price = '600' currency_code = 'EUR'  )
*                        ( client = sy-mandt carrier_id = 'QF' connection_id = '0006' flight_date = '20230112' plane_type_id = 'A380'    price = '1600' currency_code = 'AUD' )
*                        ( client = sy-mandt carrier_id = 'AA' connection_id = '0017' flight_date = '20230110' plane_type_id = '747-400' price = '600' currency_code = 'USD'  )
*                        ( client = sy-mandt carrier_id = 'UA' connection_id = '0900' flight_date = '20230201' plane_type_id = '777-200' price = '600' currency_code = 'USD'  ) ).
*
*    out->write(  'Contents Before Sort' ).
*    out->write(  '____________________' ).
*    out->write(  flights  ).
*    out->write(  ` ` ).
*
** Sort with no additions - sort by primary table key carrier_id connection_id flight_date
*    SORT flights.
*
*    out->write(  'Effect of SORT with no additions - sort by primary table key' ).
*    out->write(  '____________________________________________________________' ).
*    out->write( flights ).
*    out->write(  ` ` ).
*
** Sort with field list - default sort direction is ascending
*    SORT flights BY currency_code plane_type_id.
*    out->write(  'Effect of SORT with field list  - ascending is default direction' ).
*    out->write(  '________________________________________________________________' ).
*    out->write( flights ).
*    out->write(  ` ` ).
*
** Sort with field list and sort directions.
*    SORT flights BY carrier_Id ASCENDING flight_Date DESCENDING.
*    out->write(  'Effect of SORT with field list and sort direction' ).
*    out->write(  '_________________________________________________' ).
*    out->write( flights ).
*    out->write(  ` ` ).
*    RETURN.


**Abb.123 Seite 248
*    TYPES tt_flights TYPE STANDARD TABLE OF /dmo/flight
*                         WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
*
*    DATA  flights TYPE tt_flights.
*
*    flights = VALUE #(  ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' flight_date = '20230201' plane_type_id = '747-400' price = '600' currency_code = 'EUR'  )
*                        ( client = sy-mandt carrier_id = 'QF' connection_id = '0006' flight_date = '20230112' plane_type_id = 'A380' price = '1600' currency_code = 'AUD'  )
*                        ( client = sy-mandt carrier_id = 'AA' connection_id = '0017' flight_date = '20230110' plane_type_id = '747-400' price = '600' currency_code = 'USD'  )
*                        ( client = sy-mandt carrier_id = 'LH' connection_id = '0400' flight_date = '20230206' plane_type_id = '747-400' price = '600' currency_code = 'EUR'  )
*                        ( client = sy-mandt carrier_id = 'UA' connection_id = '0900' flight_date = '20230201' plane_type_id = '777-200' price = '600' currency_code = 'USD'  )
*                        ( client = sy-mandt carrier_id = 'QF' connection_id = '0006' flight_date = '20230210' plane_type_id = 'A380' price = '1600' currency_code = 'AUD'  ) ).
*
*    out->write( 'Contents Before DELETE ADJACENT DUPLICATES' ).
*    out->write( '__________________________________________' ).
*    out->write( flights  ).
*    out->write( ` ` ).
*
*    DELETE ADJACENT DUPLICATES FROM flights.
*    out->write( 'Contents after DELETE ADJACENT DUPLICATES' ).
*    out->write( 'Nothing deleted - key values are not adjacent' ).
*    out->write( 'Sort the table before DELETE ADJACENT DUPLICATES' ).
*    out->write(  flights ).
*    out->write(  ` ` ).
*
*    SORT flights BY carrier_id connection_id flight_date.
*    out->write(  flights ).
*    out->write(  '------' ).
*    DELETE ADJACENT DUPLICATES FROM flights.
*    out->write(  'Contents after DELETE ADJACENT DUPLICATES' ).
*    out->write(  'Nothing deleted - ABAP compares all key values including flight_date, which is different for every entry' ).
*    out->write(  flights ).
*    out->write(  ` ` ).
*
*
*    SORT flights BY carrier_id DESCENDING connection_id DESCENDING flight_date DESCENDING.
*    out->write(  flights ).
*
*    DELETE ADJACENT DUPLICATES FROM flights
*                          COMPARING carrier_id connection_id.
*    out->write(  'Contents after DELETE ADJACENT DUPLICATES with COMPARING and field list' ).
*    out->write(  'Entries with identical values of carrier_id and connection_id have been deleted' ).
*    out->write(  flights ).
*    RETURN.



**Abb.128 Seite 251 (Verknüpfung der Tabellen)
*    TYPES:
*      BEGIN OF st_connection,
**        carrier_id             TYPE /dmo/carrier_id,
*        carrier_id             TYPE c LENGTH 20,
*        connection_id          TYPE /dmo/connection_id,
*        departure_airport      TYPE /dmo/airport_from_id,
*        departure_airport_name TYPE /dmo/airport_name,
*      END OF st_connection.
*
*    TYPES tt_connections TYPE STANDARD TABLE OF st_connection WITH NON-UNIQUE KEY carrier_id connection_id.
*
*    DATA connections  TYPE TABLE OF /dmo/connection.
*    DATA airports     TYPE TABLE OF /dmo/airport.
*    DATA result_table TYPE tt_connections.
*
*
*    SELECT FROM /dmo/airport
*         FIELDS *
*           INTO TABLE @airports.
*
*    SELECT FROM /dmo/connection
*         FIELDS *
*           INTO TABLE @connections.
*
*    out->write( 'Connection Table' ).
*    out->write( '________________' ).
*    out->write( connections ).
*    out->write(  ` ` ).

*    out->write( 'Airports Table' ).
*    out->write( '________________' ).
*    out->write( airports ).
*    out->write(  ` ` ).
*
*    result_table = VALUE #( FOR line IN connections
*                              ( carrier_id = line-carrier_id
*                             connection_id = line-connection_id
*                         departure_airport = line-airport_from_id
*                    departure_airport_name = airports[ airport_id = line-airport_from_id ]-name )
*
*                         ).

*LET
*    DATA(demo) = cl_abap_random_int=>create( ).
*    data(demo_5) = demo->get_next( ). out->write( demo_5 ).
*    data(demo_6) = demo->get_next( ). out->write( demo_6 ).
*
*
*    result_table = VALUE #(  LET demo_1 = 'LH'  demo_3 = 'AA' demo_4 = 0 IN
*                               FOR line IN connections
*                                  LET demo_2 = conv string( cl_abap_random_int=>create( seed = 800 )->get_next( ) ) IN
*                                ( carrier_id =  demo_2
*                               connection_id = line-connection_id
*                           departure_airport = line-airport_from_id
*                      departure_airport_name = airports[ airport_id = line-airport_from_id ]-name )
*
*                           ).
**
**
*
*    out->write( result_table ).


*    out->write( 'Results' ).
*    out->write( '_______' ).
*    out->write( result_table ).
*    RETURN.

***Abb.131 Seite 252-253
    TYPES: BEGIN OF st_results,
             occupied TYPE /dmo/plane_seats_occupied,
             maximum  TYPE /dmo/plane_seats_max,
           END OF st_results.
* """ Versuche mal den Fahrzeugtyp mit einzubauen, dafür musst du WHERE einarbeiten!
    TYPES: BEGIN OF st_results_with_avg,
*             plane_type_id TYPE /dmo/plane_type_id,
             occupied      TYPE /dmo/plane_seats_occupied,
             maximum       TYPE /dmo/plane_seats_max,
             average       TYPE p LENGTH 16 DECIMALS 2,
           END OF st_results_with_avg.

    DATA flights TYPE TABLE OF /dmo/flight.
    SELECT FROM /dmo/flight FIELDS * INTO TABLE @flights.


    DATA sum TYPE i.

    sum = REDUCE #( INIT total = 0
                           FOR line IN flights
                          NEXT total += line-seats_occupied ).
    out->write(  'Result is a scalar data type' ).
    out->write(  '____________________________' ).
    out->write(  sum ).
    out->write(  ` ` ).
*    RETURN.

*
*
** Abb.132
    DATA(results) = REDUCE st_results( INIT totals TYPE st_results
                                        FOR line IN flights
                                       NEXT totals-occupied += line-seats_occupied
                                            totals-maximum  += line-seats_max
                                            ).
    out->write(  'Result is a structure' ).
    out->write(  '_____________________' ).

    out->write( results ).
    out->write( ` ` ).

**
**** Abb.133
    out->write(  'Result is a structure. The average is calculated using a local helper variable' ).
    out->write(  '______________________________________________________________________________' ).

    DATA(result_with_average) = REDUCE st_results_with_avg( INIT totals_avg TYPE st_results_with_avg
                                                                 count = 1

                                                             FOR line IN flights
                                                            NEXT ""totals_avg-plane_type_id = line-plane_type_id
                                                                 totals_avg-occupied += line-seats_occupied
                                                                 totals_avg-maximum  += line-seats_max
                                                                 totals_avg-average   = totals_avg-occupied / count
                                                                 count =  count + 1 ).
    out->write(  result_with_average ).
*
***
*



  ENDMETHOD.
ENDCLASS.
