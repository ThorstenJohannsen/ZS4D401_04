CLASS zcl_d401_04_06self_joins DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_06self_joins IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*Abb.80
    SELECT FROM /dmo/connection AS a
                FIELDS a~airport_from_id, a~carrier_id AS carrier_1, a~connection_id AS conn_1,
                       a~airport_to_id AS via_airport_id
                  WHERE a~airport_from_id = 'FRA' OR
                        ( a~airport_from_id = 'EWR' AND a~airport_to_id <> 'FRA' ) OR
                        ( a~airport_from_id = 'JFK' AND a~airport_to_id <> 'FRA' ) OR
                        ( a~airport_from_id = 'NRT' AND a~airport_to_id <> 'FRA' ) OR
                        ( a~airport_from_id = 'SFO' AND a~airport_to_id <> 'FRA' ) OR
                        ( a~airport_from_id = 'MIA' AND a~airport_to_id <> 'FRA' ) OR
                        ( a~airport_from_id = 'SIN' AND a~airport_to_id <> 'FRA' ) OR
                        ( a~airport_from_id = 'VCE' AND a~airport_to_id <> 'FRA' )
*                    a~connection_id = '0017'
                  ORDER BY a~airport_from_id, a~airport_to_id
                  INTO TABLE @DATA(lt_result).

    out->write( data = lt_result name = CONV string( sy-dbcnt ) ).

    SELECT FROM /dmo/connection AS a
         INNER JOIN /dmo/connection AS b
            ON a~airport_to_id = b~airport_from_id AND
              a~airport_from_id <> b~airport_to_id
            FIELDS a~airport_from_id, a~carrier_id AS carrier_1, a~connection_id AS conn_1,
                   a~airport_to_id AS via_airport_id,
                   b~carrier_id AS carrier_2, b~connection_id AS conn_2,
                   b~airport_to_id AS dest_airport_id_2
              WHERE a~airport_from_id = 'FRA'
              ORDER BY a~airport_from_id, a~airport_to_id,
                       b~airport_from_id, b~airport_to_id
              INTO TABLE @DATA(lt_result1).

    out->write( cl_abap_char_utilities=>newline ).
    out->write( data = lt_result1 name = CONV string( sy-dbcnt ) ).

    SELECT FROM /dmo/connection AS a
     INNER JOIN /dmo/connection AS b
        ON a~airport_to_id = b~airport_from_id AND
          a~airport_from_id <> b~airport_to_id
     INNER JOIN /dmo/connection AS c
        ON b~airport_to_id = c~airport_from_id AND
           b~airport_from_id <> c~airport_to_id or
           a~airport_from_id <> c~airport_to_id and
           a~airport_to_id = c~airport_to_id
        FIELDS a~airport_from_id, a~carrier_id AS carrier_1, a~connection_id AS conn_1,
               a~airport_to_id AS via_airport_id,
               b~carrier_id AS carrier_2, b~connection_id AS conn_2,
               b~airport_to_id AS dest_airport_id_2,
               c~carrier_id     AS carrier_3,
               c~connection_id  AS conn_3,
               c~airport_to_id  AS dest_airport_id_3

          WHERE a~airport_from_id = 'FRA'
          ORDER BY a~airport_from_id, a~airport_to_id,
                   b~airport_from_id, b~airport_to_id,
                   c~airport_from_id, c~airport_to_id
          INTO TABLE @DATA(lt_result2).

    out->write( cl_abap_char_utilities=>newline ).
    out->write( data = lt_result2 name = CONV string( sy-dbcnt ) ).

  ENDMETHOD.
ENDCLASS.
