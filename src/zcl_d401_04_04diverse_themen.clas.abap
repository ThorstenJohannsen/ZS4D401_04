CLASS zcl_d401_04_04diverse_themen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_04diverse_themen IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

select single from /lrn/carrier fields substring( 'ABCDE', 1, 1 ) as demo_1, left( 'ABCDE', 1 ) as demo_2
                    into @data(ls_result).

    out->write( ls_result ).

data lv_tp1 type string.
lv_tp1 = substring( val = 'ABCD' len = 1 ).
out->write( lv_tp1 ).

*SELECT FROM /dmo/connection FIELDS carrier_id, connection_id, COUNT( * ) AS counter,
*
**                                    MAX( distance   ) as distance, avg( distance as dec( 6,2 ) ) AS avg1
*         GROUP BY carrier_id, connection_id INTO TABLE @DATA(lt_result).


    SELECT FROM /dmo/flight FIELDS carrier_id,  COUNT( * ) AS counter,
                                    count( distinct ( connection_id ) ) as connections,
                                    sum( price ) as sum_Price, avg(  price as dec( 6,2 ) ) as avg_Price
         GROUP BY carrier_id  INTO TABLE @DATA(lt_result).
    out->write(  lt_result ).



*    "Abb. 50
*    DATA lv_demo_01 TYPE d.
*    DATA lv_demo_02 TYPE d.
*    DATA lv_result TYPE i.
*
*    lv_demo_01 = cl_abap_context_info=>get_system_date( ).
*    lv_demo_02 = cl_abap_context_info=>get_system_date( ) + 5.
*    lv_result = lv_demo_02 - lv_demo_01.
*    out->write( lv_result  ).
*
*    lv_demo_01 = cl_abap_context_info=>get_system_date( ).
*    lv_demo_02 = cl_abap_context_info=>get_system_date( ) + 300.
*
*    "" 202701% für ANSI SQL % ist Platzhalter bei WHERE Datum like '202701%'
*    DATA(lv_demo3) = lv_demo_02+0(6) && '%'.
*
*
*    out->write( lv_demo3  ).
*
*    DATA lv_demo4 TYPE string VALUE 'ABCDEFG123456789'. "" 123456789ABCDEF
*    """ Hier kommt raus FG12345, nach der 5 Stelle werden (7) Zeichen werden ausgegeben
*    lv_demo4 = lv_demo4+5(7).
*
*    out->write( lv_demo4  ).
*
*    DATA(lv_demo5) = utclong_current(  ).
*    out->write( |                                                           | ).
*    out->write( 'UTCLONG_CURRENT => hierunter' ).
*    out->write( lv_demo5  ).
**    lv_demo_01 = lv_demo_01 + 1. "" Das geht nicht wegen UTClong
*    "" Lösung
*    lv_demo5 = utclong_add(
*                            val = lv_demo5
*                            days = 7
*                            hours = 1 ).
*    out->write( |                                                          | ).
*    out->write( 'UTCLONG_ADD => hierunter' ).
*    out->write( lv_demo5  ).
*
*    DATA(lv_demo6) = utclong_current(  ).
*
*    Try.
*    CONVERT UTCLONG lv_demo5 TIME ZONE cl_abap_context_info=>get_user_time_zone(  )
*    into date data(lv_date) time Data(lv_time).
*        catch cx_root.
*    endtry.
*
*    out->write( |                                                           | ).
*    out->write( 'mit CL_ABAP... lv_date und lv_time' ).
*    out->write( lv_date  ).
*    out->write( lv_time  ).
*
*
*data lv_text1 type string.
*data lv_text2 type string.
*
*
*lv_text1 = 'Demo_1_DE'(001).
*lv_text2 = 'Demo_2_DE'(002).
*
*out->write( |                                                           | ).
*    out->write( 'Text Symbole' ).
*    out->write( lv_text1 ).
*    out->write( lv_text2 ).


*    DATA lv_connection TYPE n LENGTH 4 VALUE 'A400'.
**    DATA lv_connection TYPE string VALUE 'A400'.
*
*    SELECT SINGLE FROM /dmo/connection FIELDS * WHERE carrier_id = 'LH' AND connection_id = @lv_connection
*       INTO @DATA(ls_result).
*    IF sy-subrc = 0.
*      out->write( ls_result ).
*    ELSE.
*      out->write( 'no result' ).
*    ENDIF.





*    DATA lv_demo_01 TYPE d.
*
*    lv_demo_01 = '20260318'.
*
*
*    out->write( lv_demo_01  ).
*
*    lv_demo_01 = 3652060.
*
*    out->write( lv_demo_01  ).





*    lv_demo_01 = sy-datum .
*
*    lv_demo_01 = lv_demo_01 + 7.
*    out->write( lv_demo_01  ).




*    DATA lv_demo_01 TYPE string.
*    DATA lv_demo_02 TYPE i.
*    DATA lv_demo_03 TYPE p LENGTH 3 DECIMALS 2.   "-999.99 bis 999.99  3*2-1 = 5
*
*
*    lv_demo_03 = '123.45-'.
*    lv_demo_03 = `123.45-`.
*
*
*    lv_demo_01 = 'A12345'.
**    lv_demo_02 = lv_demo_01.
*
*
*    out->write( lv_demo_02  ).
*    out->write( lv_demo_03  ).





  ENDMETHOD.
ENDCLASS.
