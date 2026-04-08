CLASS zcl_d401_04_08sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_08sql IMPLEMENTATION.



  METHOD if_oo_adt_classrun~main.

    DATA(lv_demo) =  lcl_demo=>summe( ).


*Kapitel 4 Lektion 2,3  Übung 11
*dats_add_days( date, days, on_error )
**Abb.88
    DATA lv_demo_1 TYPE c LENGTH 20.
    DATA ls_demo_1 TYPE /dmo/carrier.
    DATA lv_demo_2 TYPE /dmo/carrier_id.
    DATA lv_demo_3 TYPE string VALUE 'Ausgabe'.
*    SELECT SINGLE FROM /dmo/carrier FIELDS 'Demo-1' as a, 'Demo-2' as b  INTO @DATA(ls_result).
*    SELECT  FROM /dmo/carrier FIELDS  20 AS c,  'Demo-1' AS a, 'Demo-2' AS b, @lv_demo_3 AS demo_03,
*              @lv_demo as demo4, carrier_id, name

*       WHERE carrier_id like 'S%'  INTO TABLE @DATA(lt_result).
*       WHERE upper( carrier_id ) like 'S%'  INTO TABLE @DATA(lt_result).
*       WHERE  upper( name )  like 'AIR%'  INTO TABLE @DATA(lt_result).

*    out->write( lt_result ).



**Abb.91
*    SELECT SINGLE FROM /dmo/connection FIELDS airport_from_id,
*       `Demo-1` AS demo_1, `Demo2` AS demo_2,  '123' && '567' AS Zahlen_Kette,
*          CAST( '123456' AS CHAR( 6 )  ) AS Char6_Banane,
*          CAST( '123456' AS FLTP  ) AS Float_birne,
*          CAST( '11234635.55' AS DEC( 10, 2 )  ) AS dec_info,
*          CAST( '1123455' AS DEC( 10, 2 )  ) AS dec_info1,
*          CAST( '-123.551' AS DEC( 6, 3 )  ) AS dec_info2,
*          CAST( '123456' AS INT4  ) AS Int4_birne2
*
*           INTO @DATA(ls_demo).
*
*    out->write( ls_demo ).
*    DATA lp TYPE p LENGTH 5 DECIMALS 3.
*
*    lp = '-123.551'.
*    out->write( lp ).
**
*    RETURN.
*


**Abb.93

*    DATA lv_demo1 TYPE c LENGTH 10.
*
**    lv_demo1 = 'Demo'(001).
*    lv_demo1 = text-001.
*    SELECT FROM /dmo/customer
*           FIELDS customer_id, first_name as Vorname, last_name as Nachname,
*                  title,
*                  CASE title
*                  "" Textsymbole konnen hier nicht eingearbeitet werden, deshalb die Variable
*                    WHEN 'Mr.'  THEN @lv_demo1
*                    WHEN 'Mrs.' THEN 'Misses'
*                    ELSE             ' '
*                 END AS title_long
*
*           WHERE country_code = 'AT'
*            INTO TABLE @DATA(result_simple).
*
*    out->write(
*      EXPORTING
*        data   = result_simple
*        name   = 'Simple Case Distinction'
*    ).
*    RETURN.
**********************************************************************





***Abb.94
* out->write(  `-----------------------------------------------` ).
**
*    SELECT FROM /dmo/flight
*         FIELDS carrier_id,
*                connection_id,
*                flight_date,
*                seats_max,
*                seats_occupied,
*                CASE
*                  WHEN seats_occupied < seats_max THEN 'Seats Avaliable'
*                  WHEN seats_occupied = seats_max THEN 'Fully Booked'
*                  WHEN seats_occupied > seats_max THEN 'Overbooked!'
*                  ELSE                                 'This is impossible'
*                END AS booking_state
*          WHERE carrier_id    = 'LH'
*            AND connection_id = '0400'
*           INTO TABLE @DATA(result_complex).
*
*    out->write(
*      EXPORTING
*        data   = result_complex
*        name   = 'Complex Case Distinction'
*    ).
***
*
*return.

**Abb.96
*    SELECT FROM /dmo/flight
*            FIELDS seats_max,
*                   seats_occupied,
*                   seats_max - seats_occupied  AS seats_avaliable,
*
*                  CAST(
*                   ( CAST( seats_occupied AS FLTP ) / CAST(  seats_max AS FLTP )
*                    * CAST( 100 AS FLTP ) )
*                    AS DEC( 10,2 ) ) AS percentage_dec,
*
*
*                   ( CAST( seats_occupied AS FLTP ) * CAST( 100 AS FLTP ) )
*                    / CAST(  seats_max AS FLTP ) AS percentage_fltp
*
*              WHERE carrier_id = 'LH'
*               INTO TABLE @DATA(result).
*    out->write( data   = result name   = 'RESULT' ).
*
*    DATA lv_dec TYPE p DECIMALS 2.
*    LOOP AT result ASSIGNING FIELD-SYMBOL(<fs>).
*      lv_dec = <fs>-percentage_fltp.
*      out->write( lv_dec ).
*    ENDLOOP.
*
*
*
*
*     "" Hier wird der Punkt in ein Komma gesetzt!!!
**    DATA lv_dec TYPE p DECIMALS 2.
*    LOOP AT result ASSIGNING FIELD-SYMBOL(<fs1>).
*      lv_dec = <fs1>-percentage_fltp.
*      out->write( | { <fs1>-seats_max } { <fs1>-seats_occupied } { <fs1>-seats_avaliable }  { lv_dec NUMBER = ENVIRONMENT  }  |    ).
*    ENDLOOP.
**
*
*
*    RETURN.

**Abb.98
*    SELECT FROM /dmo/flight
*             FIELDS seats_max,
*                    seats_occupied,
*
*                    (   CAST( seats_occupied AS FLTP )
*                      * CAST( 100 AS FLTP )
*                    ) / CAST(  seats_max AS FLTP )                  AS percentage_fltp,
*
*                    div( seats_occupied * 100 , seats_max )         AS percentage_int,
*
*                    division(  seats_occupied * 100, seats_max, 2 ) AS percentage_dec
*
*              WHERE carrier_id    = 'LH'
*               INTO TABLE @DATA(result).
*
*    out->write(
*      EXPORTING
*        data   = result
*        name   = 'RESULT'
*    ).

*    RETURN.


**Abb.101
*SELECT FROM /dmo/customer
*         FIELDS customer_id, upper(  city ) as demo1,
*                street && ',' && ' '  && postal_code && ' ' && city   AS address_expr, ""hier geht upper nicht!!
*
*                concat( street,
*                        concat_with_space(  ',',
*                                             concat_with_space( postal_code,
*                                                                upper(  city ),
*                                                            1 ),
*                                       1 )
*                       ) AS address_func
*
*          WHERE upper( country_code ) = 'ES'
*           INTO TABLE @DATA(result_concat).
*
*    out->write(
*      EXPORTING
*        data   = result_concat
*        name   = 'Concatenation'
*    ).
**
***********************************************************************
*out->write(  `-------------------------------------------------------------------------` ).

**Abb.102
*    SELECT FROM /dmo/carrier
*         FIELDS carrier_id,
*                name,
*                upper( name )   AS name_upper,
*                lower( name )   AS name_lower,
*                initcap( name ) AS name_initcap
*
*          WHERE carrier_id like 'S%'
*           INTO TABLE @DATA(result_transform).
*
*    out->write(
*      EXPORTING
*        data   = result_transform
*        name   = 'Uppercase/Lowercase'
*    ).

***********************************************************************

*out->write(  `-------------------------------------------------------------------------` ).

**Abb.103

    SELECT FROM /dmo/flight
         FIELDS flight_date,
                CAST( flight_date AS CHAR( 8 ) )  AS flight_date_raw,

                left(      flight_date, 4    ) AS year,
                right(     flight_date, 2    ) AS day,
                "" das bedeutet inkl. ab 5ten Stelle, die zwei Ziffern/Zeichen danch
                substring( flight_date, 5, 2 ) AS month

          WHERE carrier_id = 'LH'
            AND connection_id = '0400'
           INTO TABLE @DATA(result_substring).

    out->write(
      EXPORTING
        data   = result_substring
        name   = 'Substring extraction'
    ).



  ENDMETHOD.
ENDCLASS.
