CLASS zcl_d401_04_14class_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_14class_1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lo_passanger_plane TYPE REF TO lcl_passenger_plane.

    lo_passanger_plane = NEW lcl_passenger_plane(
      type       =   'A123-200'
      demo_01    =   'demo-1'
      mv_demo_02 =   'demo-2'
    ).

    lo_passanger_plane->display_attributes( out ).




  ENDMETHOD.
ENDCLASS.
