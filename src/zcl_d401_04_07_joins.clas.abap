CLASS zcl_d401_04_07_joins DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_07_joins IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/carrier as carr INNER JOIN /dmo/connection
        ON carr~carrier_id = /dmo/connection~carrier_id
      FIELDS carr~carrier_id,
             carr~name,
             carr~currency_code,
             /dmo/connection~connection_id,
             """entweder so, wenn sie eindeutig ist
*             /dmo/connection~airport_from_id,
             """oder so, ABER nur wenn es Sie in den anderen tabellen nicht gibt!
             airport_from_id as Departure,
             /dmo/connection~airport_to_id as Destination
      INTO TABLE @DATA(lt_result).


    out->write( lt_result ).

  ENDMETHOD.
ENDCLASS.
