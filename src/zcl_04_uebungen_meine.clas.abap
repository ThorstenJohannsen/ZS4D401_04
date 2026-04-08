CLASS zcl_04_uebungen_meine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_04_uebungen_meine IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF st_demo1,
             carrier_id   TYPE /dmo/carrier_id,
             distance     TYPE i,
             distance_avg TYPE p LENGTH 7 DECIMALS 2,
           END OF st_demo1.
    DATA connect TYPE TABLE OF /dmo/connection.

    DATA check_id   TYPE /dmo/carrier_id.

    SELECT * FROM /dmo/connection INTO TABLE @connect.

    SORT connect BY carrier_id.

    LOOP AT connect INTO DATA(ls_collect).
      IF ls_collect-carrier_id <> check_id.
        DATA(result_avg) = REDUCE st_demo1( INIT dist_avg TYPE st_demo1 count = 1
                                    FOR tj IN connect
                                    WHERE ( carrier_id = ls_collect-carrier_id )
                                    NEXT dist_avg-carrier_id = tj-carrier_id
                                         dist_avg-distance = dist_avg-distance + tj-distance
                                         dist_avg-distance_avg = dist_avg-distance / count
                                         count += 1
                                       ).

          check_id = ls_collect-carrier_id.
          out->write( result_avg ).
      ENDIF.
    ENDLOOP.

*    SORT connect BY carrier_id.
*    DELETE ADJACENT DUPLICATES FROM connect COMPARING carrier_id.
*    out->write( result_avg ).

    out->write( '-----------------------------------------------------------------------------------------------' ).

    SELECT FROM /dmo/connection FIELDS carrier_id, SUM( distance ) AS total,
                                division( SUM( distance ), COUNT( * ),2 ) AS distance_avg
                                GROUP BY carrier_id INTO TABLE @DATA(t_connect).
    out->write( t_connect ).
    out->write( '-----------------------------------------------------------------------------------------------' ).

    LOOP AT t_connect INTO DATA(result).

      out->write( result ).

    ENDLOOP.



*    DATA: BEGIN OF st_demo1,
*            col1 TYPE i,
*            col2 TYPE i,
*            col3 TYPE i,
*            col4 TYPE i.
*    DATA: END OF st_demo1.
*
*    DATA lt_demo1 LIKE TABLE OF st_demo1.
*
*    DATA: BEGIN OF st_demo2,
*            col1_s1 TYPE i,
*            col2_s1 TYPE i,
*            col3_s1 TYPE i,
*            col4_s1 TYPE i.
*    DATA: END OF st_demo2.
*
*    DATA lt_demo2 LIKE TABLE OF st_demo2.
*
*    st_demo2-col1_s1 = 100.
*    st_demo2-col2_s1 = 200.
*    st_demo2-col3_s1 = 300.
*    st_demo2-col4_s1 = 400.
*    APPEND st_demo2 TO lt_demo2.
*
*    st_demo2-col1_s1 = 500.
*    st_demo2-col2_s1 = 600.
*    st_demo2-col3_s1 = 700.
*    st_demo2-col4_s1 = 800.
*    APPEND st_demo2 TO lt_demo2.
*
*    out->write( '                                 ' ).
*    out->write( lt_demo2 ).
*
**** target-table = value #( for workarea in source-table ( Felder in Source-table = Felder
**** target table oder meine Anweisung, auch Variable, Berechnungen )
*    lt_demo1 = value #( for tj in lt_demo2
*                        ( col1 = tj-col1_s1 + 1
*                          col2 = tj-col2_s1 / 2
*                          col3 = tj-col3_s1 * 3
*                          col4 = tj-col4_s1 - 4
*                          )
*                       ).
*
*    data sums type i.
*
*    sums = reduce #( init total = 0
*                    for banane in lt_demo1
*                      next total +=  banane-col1
*                   ).
*
*    out->write( lt_demo1 ).
*    out->write( sums ).
*    out->write( '                                 ' ).
*
*    field-symbols <fs> type i.
*
*    Assign lt_demo2[ 2 ]-col2_s1 to <fs>.
*
**** hier mit Feldsymbol
*    lt_demo1 = value #( for <tj> in lt_demo2
*                        ( col1 = <tj>-col1_s1 + 1
*                          col2 = <fs> / 2
*                          col3 = <tj>-col3_s1 * 3
*                          col4 = <tj>-col4_s1 - 4
*                          )
*                       ).
*
*    out->write( lt_demo1 ).
*
*    out->write( '                                 ' ).
*
*    loop at lt_demo2 into data(ls_demo2).
*         st_demo1-col1 = ls_demo2-col1_s1 + 2.
*         st_demo1-col2 = <fs> / 2.
*         st_demo1-col3 = ls_demo2-col3_s1 * 3.
*         st_demo1-col4 = ls_demo2-col4_s1 - 4.
*      APPEND st_demo1 TO lt_demo1.
*
*    endloop.
*
*    out->write( lt_demo1 ).
*
*    out->write( '                                 ' ).
*
*lt_demo1 = value #( for tj in lt_demo2
*                        where ( col2_s1 = 600 )
*                        ( col1 = tj-col1_s1 + 44
*                          col2 = tj-col2_s1 / 2
*                          col3 = tj-col3_s1 * 2
*                          col4 = tj-col4_s1 - 44
*                          )
*                       ).
*
*    out->write( lt_demo1 ).
*
*    out->write( '                                 ' ).
*******************************************************************************
*    DATA tp_p TYPE p LENGTH 4 DECIMALS 3.
*    DATA result1 TYPE string.
*    data result_tz type c lENGTH 6.
*    DATA tp_n TYPE n LENGTH 5.
*
*    result_tz = cl_abap_context_info=>get_user_time_zone( ).
*    out->write( result_tz ).
*
*
*    IF tp_p = ''.
*      out->write( |Leider sind noch keine Daten vorhanden, deshalb steht hier der Initialwert drin => | && tp_p ).
*    ENDIF.
*
*    tp_p = '123.235'.
*    tp_p = tp_p - 1 / 8.
*
*    out->write( |Jetzt haben wir den Wert auf { tp_p }  gesetzt! | ).
*
*
*    IF result1 = ''.
*      out->write( |Leider sind noch keine Daten vorhanden, deshalb steht hier der Initialwert drin => | && result1 ).
*    ENDIF.
*
*    tp_p = 1 / 8.
*
*    result1 = '12AB34CD'.
*    result1 = result1 && CONV string( tp_p ).
*
*    out->write( |result && conv string(tp_p) wird zu: { result1 }  gesetzt! | ).
*
*     result1 = '12AB34CDHD4KvsHD8K'.
*    tp_n = result1.
*    out->write( | tp_p = result { tp_n }  result ist aber { result1 }! | ).
*
*
*    DATA text2 TYPE string.
*    text2 = '1234A67a9b1B3456789'.
*    result1 = find( val = text2 sub = 'a' case = abap_false occ =  2 ).
*    out->write(  |find 'a' (occ = -1):                 { result1 } | ).
*
*
*
*******Abb.68
*    DATA result TYPE i.
*
*    DATA text    TYPE string VALUE `  1234A64a9b1B3454A35A49  `.
*    DATA substring TYPE string VALUE `4A`. "" das ist mein Suchmuster
*    DATA offset    TYPE i      VALUE 2. "" Ab Anzahl der Zeichen im Text
*
*
**** Call different description functions
*******************************************************************************
*
*    out->write( |Input string: '{ text }'| ).
*    out->write( `----------------------------------` ).
*
*    result = strlen( text ).
*    out->write( |Strlen:              { result }| ).
*
*    result = numofchar(  text ).
*    out->write( |Numofchar:           { result }| ).
*
*    result = count(             val = text sub = substring off = offset ).
*    out->write( |Count { substring }:            { result }| ).
*
*    result = find(             val = text sub = substring off = offset ).
*    out->write( |Find { substring }:             { result }| ).
*
*    result = count_any_of(     val = text sub = substring off = offset ).
*    out->write( |Count_any_of { substring }:     { result }| ).
*    "" `  ABAP  `
*    result = find_any_of(      val = text sub = substring off = offset ).
*    out->write( |Find_any_of { substring }:      { result }| ).
*
*    result = count_any_not_of( val = text sub = substring off = offset ).
*    out->write( |Count_any_not_of { substring }: { result }| ).
*
*    result = find_any_not_of(  val = text sub = substring off = offset ).
*    out->write( |Find_any_not_of { substring }:  { result }| ).



  ENDMETHOD.
ENDCLASS.
