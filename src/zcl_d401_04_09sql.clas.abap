CLASS zcl_d401_04_09sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_09sql IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
**Abb.106

*data lv_date type d.
*lv_date =  '20260323'.
*
*    SELECT FROM /dmo/travel
*          FIELDS customer_id,
*                 begin_date,
*                 end_date,
*                 is_valid( begin_date  )              AS valid,
*                 add_days( begin_date, 7 )            AS add_7_days,
*                 add_months(  begin_date, 3 )         AS add_3_months,
*                 days_between( begin_date, end_date ) AS duration,
*                 weekday( begin_date  )               AS weekday,
*                 weekday( @lv_date  )                 AS weekday1,
*                 extract_month( begin_date )          AS month,
*                 dayname( begin_date )                AS day_name,
*
*                 dats_add_days( @lv_date, 7 )         AS add_7_days_lv_date,
*                 dats_add_months(  @lv_date, 3 )    AS add_3_months_lv_date,
*                 dats_days_between( @lv_date, end_date ) AS duration_lv_date,
*                 dats_is_valid( @lv_date  )              AS valid_lv_date
*
*           WHERE "customer_id = '000001' AND
*                 days_between( begin_date, end_date ) = 0
*
*            INTO TABLE @DATA(result).
*
*    out->write(
*      EXPORTING
*        data   = result
*        name   = 'RESULT' && sy-dbcnt
*    ).

*    RETURN.

**Abb.108
*    SELECT FROM /dmo/travel
*         FIELDS lastchangedat,
*                CAST( lastchangedat AS DEC( 15,0 ) ) AS latstchangedat_short,
*
*                tstmp_to_dats( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
*                               tzone = CAST( 'UTC-5' AS CHAR( 6 ) )
*                               "client = ... ,
*                               "on_error = ...
*                             ) AS date_est,
*                tstmp_to_tims( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
*                               tzone = CAST( 'UTC-5' AS CHAR( 6 ) )
*                             ) AS time_est
*
*          WHERE customer_id = '000001'
*           INTO TABLE @DATA(result_date_time).
*
*    out->write(
*      EXPORTING
*        data   = result_date_time
*        name   = 'Timestamp Conversion'
*    ).
*
**********************************************************************
*    out->write(  `-------------------------------------------------------------------------` ).

*return.
*
*Abb.109
*    SELECT FROM /dmo/connection
*         FIELDS distance,
*                distance_unit,
*                unit_conversion( quantity = CAST( distance AS QUAN ),
*                                 source_unit = distance_unit,
*                                 target_unit = CAST( 'MI' AS UNIT ) )  AS distance_mi
*
*          WHERE airport_from_id = 'FRA'
*           INTO TABLE @DATA(result_unit).
*
*    out->write(
*      EXPORTING
*        data   = result_unit
*        name   = 'Unit Conversion'
*    ).

*return.

***********************************************************************
***Abb.110
    DATA(today) = cl_abap_context_info=>get_system_date(  ).

    SELECT FROM /dmo/travel
         FIELDS total_price,
                currency_code,

                currency_conversion( amount             = total_price,
                                     source_currency    = currency_code,
                                     target_currency    = 'EUR',
                                     exchange_rate_date = @today
                                   ) AS total_price_eur

          WHERE customer_id = '000001' AND currency_code <> 'EUR'
           INTO TABLE @DATA(result_currency).

    out->write(
      EXPORTING
        data   = result_currency
        name   = 'Currency Conversion'
    ).


  ENDMETHOD.
ENDCLASS.
