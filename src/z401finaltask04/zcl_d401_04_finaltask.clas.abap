CLASS zcl_d401_04_finaltask DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_finaltask IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lo_bus TYPE REF TO lcl_bus.
    DATA lo_truck TYPE REF TO lcl_truck.
    DATA lo_rental TYPE REF TO lcl_rental.

    lo_rental = NEW #( ).

    TRY.
        lo_bus = NEW #( i_make = '19870326'
                        i_color = 'grün-blau'
                        i_model = 'Doppelbus'
                        i_price = '33333.33'
                        i_seats = 88
                      ).
        lo_rental->add_vehicle( lo_bus ).

      CATCH zcx_d401_04_failed INTO DATA(lx_error).

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_bus = NEW #( i_make = '20230130'
                         i_color = 'rot'
                         i_model = 'Herry Potter Doppelbus'
                         i_price = '100000'
                         i_seats = 102
                      ).
        lo_rental->add_vehicle( lo_bus ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_bus = NEW #( i_make = '20250601'
                         i_color = 'blau'
                         i_model = 'Blue Montain Bus'
                         i_price = '555000'
                         i_seats = 88 ).
        lo_rental->add_vehicle( lo_bus ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_bus = NEW #( i_make = '19540926'
                         i_color = 'grün-blau-orange'
                         i_model = 'Boxer-Bus'
                         i_price = '13255.24'
                         i_seats = 77 ).
        lo_rental->add_vehicle( lo_bus ).
      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_bus = NEW #( i_make = '19900511'
                         i_color = 'blau-weiß'
                         i_model = 'Bavaria Bus'
                         i_price = '123450.25'
                         i_seats = 96 ).
        lo_rental->add_vehicle( lo_bus ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_bus = NEW #( i_make = '19100515'
                         i_color = 'braun-weiß-rot'
                         i_model = 'St.Pauli-Fanbus'
                         i_price = '44450.88'
                         i_seats = 88 ).
        lo_rental->add_vehicle( lo_bus ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.
********************************************************************************************
    TRY.
        lo_truck = NEW #( i_color = 'grau'
                           i_make = '20260227'
                           i_model = 'T-MB 4050TT'
                           i_price = '850000'
                           i_cargo = 2550 ).
        lo_rental->add_vehicle( lo_truck ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( cl_abap_char_utilities=>newline ).
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_truck = NEW #( i_color = 'rosa-rot'
                           i_make = '20121026'
                           i_model = 'T-TJ 4911TT'
                           i_price = '1850000'
                           i_cargo = 9999 ).
        lo_rental->add_vehicle( lo_truck ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( cl_abap_char_utilities=>newline ).
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_truck = NEW #( i_color = 'rot'
                            i_make = '19870326'
                            i_model = 'T-TT Super GT-TT'
                            i_price = '850000'
                            i_cargo = 2550 ).
        lo_rental->add_vehicle( lo_truck ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( cl_abap_char_utilities=>newline ).
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_truck = NEW #( i_color = 'rosa'
                            i_make = '20260112'
                            i_model = 'T-MB 4050TT'
                            i_price = '1233000'
                            i_cargo = 2500 ).
        lo_rental->add_vehicle( lo_truck ).
      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( cl_abap_char_utilities=>newline ).
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_truck = NEW #( i_color = 'Schwarz'
                           i_make = '20260227'
                           i_model = 'T-Kight Rider'
                           i_price = '999999'
                           i_cargo = 1500 ).
        lo_rental->add_vehicle( lo_truck ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( cl_abap_char_utilities=>newline ).
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_truck = NEW #( i_color = 'grün'
                           i_make = '20220720'
                           i_model = 'T-TT-Etronic-no-fuel'
                           i_price = '1850000'
                           i_cargo = 2500 ).
        lo_rental->add_vehicle( lo_truck ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( cl_abap_char_utilities=>newline ).
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    TRY.
        lo_truck = NEW #( i_color = 'flieder'
                           i_make = '20170720'
                           i_model = 'T-Kleintransporter'
                           i_price = '15000'
                           i_cargo = 1500 ).
        lo_rental->add_vehicle( lo_truck ).

      CATCH zcx_d401_04_failed INTO lx_error.

*        APPEND lo_truck TO lo_rental->mt_vehicles.
        out->write( cl_abap_char_utilities=>newline ).
        out->write( lx_error->get_text( ) ).
        out->write( lo_truck->display_attributes( ) ).

    ENDTRY.

    out->write( |Willkommen in: { lo_rental->get_name( ) }| ).
    out->write( '******+++++*****************+++++*************' ).
    out->write( '***************#######************************' ).


    LOOP AT lo_rental->get_vehicles( ) INTO DATA(lo_vehicle).

      " Hier wird r_result (string_table) abgeholt
      DATA(lt_details) = lo_vehicle->display_attributes( ).

      " Die gesamte Tabelle in die Konsole schreiben
      out->write( lt_details ).

    ENDLOOP.

    DATA(lo_best_truck) = lo_rental->get_max_cargo( ).

    IF lo_best_truck IS BOUND.

      out->write( |*******************************************| ).
      out->write( |DER TRUCK MIT DER HÖCHSTEN FRACHTKAPAZITÄT:| ).
      out->write( |*******************************************| ).

      " 3. Die gesamte string_table (Marke, Modell, Farbe, Preis, Cargo) abrufen
      DATA(lt_truck_data) = lo_best_truck->display_attributes( ).

      " 4. Alle Daten auf einmal in die Konsole schreiben
      out->write( lt_truck_data ).

    ELSE.
      out->write( 'Es wurden keine LKWs in der Mietstation gefunden.' ).
    ENDIF.


    DATA(lo_best_bus) = lo_rental->get_max_seats( ).

    IF lo_best_truck IS BOUND.

      out->write( |*******************************************| ).
      out->write( |DER BUS MIT DER HÖCHSTEN SITZPLATZANZAHL:| ).
      out->write( |*******************************************| ).

      " 3. Die gesamte string_table (Marke, Modell, Farbe, Preis, Cargo) abrufen
      DATA(lt_bus_data) = lo_best_bus->display_attributes( ).

      " 4. Alle Daten auf einmal in die Konsole schreiben
      out->write( lt_bus_data ).

    ELSE.
      out->write( 'Es wurden keine LKWs in der Mietstation gefunden.' ).
    ENDIF.
*    out->write( lo_bus->display_attributes( ) ).
*    out->write( lo_truck->display_attributes( ) ).


  ENDMETHOD.
ENDCLASS.
