CLASS zcl_d401_04_18class_5 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_04_18class_5 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


    DATA lo_super TYPE REF TO lcl_super.
    lo_super = NEW lcl_sub1(  ).

    data(lo_demo) = cast lcl_sub1( lo_super ).



*    out->write( lo_demo->a  ).
*    out->write( lo_demo->b  ).
*    out->write( lo_demo->c  ).
    out->write( lo_demo->d  ).




**************************************************
*    DATA lo_super TYPE REF TO lcl_super.
**    lo_super = NEW lcl_sub1(  ).
*    out->write( lo_super->a  ).
*    out->write( lo_super->b  ).
*    out->write( lo_super->c  ).





********************************************************
*    DATA lo_super TYPE REF TO lcl_super.
*    lo_super = NEW lcl_sub1(  ).
*    out->write( lo_super->a  ).
*    out->write( lo_super->b  ).
*    out->write( lo_super->c  ).



********************************************************
*    DATA(lo_super) = NEW lcl_sub1(  ).
*    out->write( lo_super->a ).
*    out->write( lo_super->b ).
*    out->write( lo_super->c ).
*    out->write( lo_super->d ).
********************************************************




  ENDMETHOD.

ENDCLASS.
