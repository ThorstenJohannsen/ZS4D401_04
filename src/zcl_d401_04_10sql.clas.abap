CLASS zcl_d401_04_10sql DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_10sql IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.
*      SELECT FROM /dmo/connection
*            FIELDS carrier_id,
*                   connection_id,
*                   airport_from_id,
*                   distance
**             WHERE carrier_id = 'LH'
*              INTO TABLE @DATA(result_raw).
*
*
*    out->write(
*      EXPORTING
*        data   = result_raw
*        name   = 'Raw Data'
*    ).


*********************************************************************
**    out->write( `----------------------------------------------------` ).
*    SELECT FROM /dmo/connection
*         FIELDS carrier_id,  MAX( distance ) AS max_dist,
**         FIELDS  MAX( distance ) AS max_dist,
*                MIN( distance ) AS min_dist,
*                SUM( distance ) AS sum_dist,
**                AVG( distance AS FLTP ) AS avg_dist,
*                CAST(  AVG( distance AS FLTP ) AS DEC  ) AS avg_dist,
*                COUNT( * ) AS count,
*                COUNT( DISTINCT airport_from_id ) AS count_dist_airpfrom
**    WHERE carrier_id = 'LH'
*    GROUP BY  carrier_id
*           INTO TABLE @DATA(result_aggregate).
*
*    out->write(
*      EXPORTING
*        data   = result_aggregate
*        name   = 'Aggregated Result'
*    ).
**
*    RETURN.


* out->write( `----------------------------------------------------` ).
    SELECT FROM /dmo/connection
         FIELDS carrier_id,
                MAX( distance ) AS max_dist,
                MIN( distance ) AS min_dist,
                SUM( distance ) AS sum_dist,
                AVG( distance AS FLTP ) AS avg_dist_fltp,
                CAST(  AVG( distance AS FLTP ) AS DEC  ) AS avg_dist,
                COUNT( * ) AS count,
                COUNT( DISTINCT airport_from_id ) AS count_dist_airpfrom
*    WHERE carrier_id = 'AAA'
    GROUP BY  carrier_id
           INTO TABLE @DATA(result_aggregate).
    out->write( sy-subrc ).

    out->write(
      EXPORTING
        data   = result_aggregate
        name   = 'Aggregated Result'
    ).

    RETURN.




  ENDMETHOD.
ENDCLASS.
