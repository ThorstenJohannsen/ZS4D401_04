CLASS zcl_d401_04_15class_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_15class_2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*    data(lo_super) = new lcl_super( ).


    DATA(lo_sub_01) = NEW lcl_sub1( ).
    out->write( lo_sub_01->mv_demo_01 ).
    out->write( lo_sub_01->mv_demo_02 ).
    out->write( lo_sub_01->mv_cargo ).


    DATA(lo_sub_02) = NEW lcl_sub2( ).
    out->write( lo_sub_02->mv_demo_01 ).
    out->write( lo_sub_02->mv_demo_02 ).
    out->write( lo_sub_02->mv_seats_max ).




  ENDMETHOD.
ENDCLASS.
