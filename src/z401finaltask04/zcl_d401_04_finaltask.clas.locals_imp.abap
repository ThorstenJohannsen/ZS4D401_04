*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_vehicle DEFINITION ABSTRACT.

  PUBLIC SECTION.
    TYPES ty_model TYPE c LENGTH 30.
    TYPES ty_price TYPE p LENGTH 16 DECIMALS 2.
    TYPES ty_color TYPE c LENGTH 20.

    METHODS constructor
      IMPORTING
        i_make  TYPE d
        i_model TYPE ty_model
        i_price TYPE ty_price
        i_color TYPE ty_color.

    METHODS display_attributes RETURNING VALUE(r_result) TYPE string_table.
    METHODS get_model RETURNING VALUE(rv_model) TYPE ty_model.
    METHODS get_make  RETURNING VALUE(rv_make)  TYPE d.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_make TYPE d.
    DATA mv_model TYPE c LENGTH 30.
    DATA mv_price TYPE p LENGTH 16 DECIMALS 2.
    DATA mv_color TYPE c LENGTH 20.

ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.

  METHOD constructor.

    me->mv_make = i_make.
    me->mv_model = i_model.
    me->mv_price = i_price.
    me->mv_color = i_color.

  ENDMETHOD.

  METHOD display_attributes.

*    APPEND |------------------------------------------------| TO r_result.

    APPEND |Modell:        { mv_model }| TO r_result.
    APPEND |Erstzulassung: { mv_make DATE = USER }| TO r_result.
    APPEND |Farbe:         { mv_color }| TO r_result.
    APPEND |Preis:         { mv_price CURRENCY = 'EUR' NUMBER = USER } €| TO r_result.

  ENDMETHOD.

  METHOD get_make.
    rv_make  = me->mv_make.
  ENDMETHOD.

  METHOD get_model.
    rv_model = me->mv_model.
  ENDMETHOD.

ENDCLASS.




CLASS lcl_truck DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        i_make  TYPE d
        i_model TYPE lcl_vehicle=>ty_model
        i_price TYPE lcl_vehicle=>ty_price
        i_color TYPE lcl_vehicle=>ty_color
        i_cargo TYPE i.

    METHODS display_attributes REDEFINITION.



    METHODS get_cargo RETURNING VALUE(rv_cargo) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_cargo TYPE i.

ENDCLASS.

CLASS lcl_truck IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_make = i_make i_model = i_model i_price = i_price i_color = i_color ).

    me->mv_cargo = i_cargo.

  ENDMETHOD.

  METHOD display_attributes.
    r_result = super->display_attributes( ).
    APPEND |Fracht in kg:  { me->mv_cargo }| TO r_result.

    " 3. Logik-Prüfung für den Zusatztext (Zusatz an r_result)
    IF me->mv_cargo < 2000.
      APPEND |>>> HINWEIS: Kapazität unter 2000kg!| TO r_result.
      APPEND |      Sondergenehmigung erforderlich.| TO r_result.
    ENDIF.
    "" Leerzeile
    APPEND cl_abap_char_utilities=>newline TO r_result.

  ENDMETHOD.

  METHOD get_cargo.
    rv_cargo = me->mv_cargo.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_bus DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.

    METHODS display_attributes REDEFINITION.
    METHODS get_seats RETURNING VALUE(rv_seats) TYPE i.
    METHODS constructor
      IMPORTING
        i_make  TYPE d
        i_model TYPE lcl_vehicle=>ty_model
        i_price TYPE lcl_vehicle=>ty_price
        i_color TYPE lcl_vehicle=>ty_color
        i_seats TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_seats TYPE i.

ENDCLASS.

CLASS lcl_bus IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_make = i_make i_model = i_model i_price = i_price i_color = i_color ).

    me->mv_seats = i_seats.

  ENDMETHOD.


  METHOD display_attributes.

    r_result = super->display_attributes( ).
    APPEND |Sitzplätze:    { mv_seats }| TO r_result.
    APPEND cl_abap_char_utilities=>newline TO r_result.

  ENDMETHOD.

  METHOD get_seats.
    rv_seats = me->mv_seats.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_rental DEFINITION.

  PUBLIC SECTION.

    METHODS get_name RETURNING VALUE(iv_rname) TYPE string.
    TYPES tt_vehicles TYPE STANDARD TABLE OF REF TO lcl_vehicle WITH EMPTY KEY.

    METHODS get_vehicles RETURNING VALUE(rt_vehicles) TYPE tt_vehicles.

    " Neue Methode zur Ermittlung des Max-Trucks
    METHODS get_max_cargo RETURNING VALUE(ro_truck) TYPE REF TO lcl_truck.

    " Neue Methode zur Ermittlung des Max-Buss
    METHODS get_max_seats RETURNING VALUE(ro_bus) TYPE REF TO lcl_bus.


    METHODS add_vehicle
      IMPORTING io_vehicle TYPE REF TO lcl_vehicle
      RAISING   zcx_d401_04_failed.

  PROTECTED SECTION.
  PRIVATE SECTION.
    " Die Collection laut Diagramm: Aggregation zu lcl_vehicle
    DATA mt_vehicles TYPE STANDARD TABLE OF REF TO lcl_vehicle WITH EMPTY KEY.
    DATA mv_rname TYPE string. " Hier speichern wir den Namen der Reisegesellschaft

ENDCLASS.

CLASS lcl_rental IMPLEMENTATION.

  METHOD get_max_cargo.
    LOOP AT mt_vehicles INTO DATA(lo_vehicle).
      " Prüfen, ob das aktuelle Fahrzeug ein LKW ist
      IF lo_vehicle IS INSTANCE OF lcl_truck.
        DATA(lo_current_truck) = CAST lcl_truck( lo_vehicle ).

        " Vergleich: Ist dieser LKW stärker als der bisher gefundene?
        IF ro_truck IS INITIAL OR lo_current_truck->get_cargo( ) > ro_truck->get_cargo( ).
          ro_truck = lo_current_truck.
        ENDIF.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD add_vehicle.

*    IF line_exists( mt_vehicles[ table_line = io_vehicle ] ).
*       " Optional: Fehlermeldung oder Exception, falls Dubletten verboten sind
*        """ 4. Exception auslösen und Daten an den Konstruktor übergeben
*        RAISE EXCEPTION TYPE zcx_d401_04_failed
*          EXPORTING
*            textid = zcx_d401_04_failed=>vehicle_exist
*            i_model  = io_vehicle->get_model( )
*            i_make  = io_vehicle->get_make( ).
*    else.
    """ 1. Prüfen: Ist das übergebene Fahrzeug ein LKW?
    IF io_vehicle IS INSTANCE OF lcl_truck.

      """ 2. Downcast: Zugriff auf LKW-spezifische Daten (mv_cargo)
      DATA(lo_truck) = CAST lcl_truck( io_vehicle ).

      """ 3. Logik-Prüfung: Unter 2000kg (2t) wird abgelehnt
      IF lo_truck->get_cargo( ) < 2000.
        "" trotzdem anhängen, mit Zusatztext!
        APPEND io_vehicle TO mt_vehicles.
        """ 4. Exception auslösen und Daten an den Konstruktor übergeben
        RAISE EXCEPTION TYPE zcx_d401_04_failed
          EXPORTING
            textid  = zcx_d401_04_failed=>cargo_to_low
            i_model = lo_truck->get_model( )
            i_make  = lo_truck->get_make( ).

      ENDIF.
    ENDIF.

    """ 5. Wenn keine Exception ausgelöst wurde: Ab in die Liste!
    APPEND io_vehicle TO mt_vehicles.
*    ENDIF.
  ENDMETHOD.

  METHOD get_name.
    iv_rname = 'TJs Gebraucht-Vehicle-Unternehmen'.
    me->mv_rname = iv_rname.
  ENDMETHOD.

  METHOD get_vehicles.
    rt_vehicles = mt_vehicles.
  ENDMETHOD.

  METHOD get_max_seats.
    LOOP AT mt_vehicles INTO DATA(lo_vehicle).
      " Prüfen, ob das aktuelle Fahrzeug ein Bus ist
      IF lo_vehicle IS INSTANCE OF lcl_bus.
        DATA(lo_current_bus) = CAST lcl_bus( lo_vehicle ).

        " Vergleich: Hat dieser Bus mehr Sitzplätze als der bisher gefundene?
        IF ro_bus IS INITIAL OR lo_current_bus->get_seats( ) > ro_bus->get_seats( ).
          ro_bus = lo_current_bus.
        ENDIF.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
