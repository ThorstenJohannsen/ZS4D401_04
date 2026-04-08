*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_plane DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS class_constructor.
    METHODS constructor
      IMPORTING
        type TYPE string
        demo_01 TYPE string.
    METHODS display_attributes IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_type TYPE string.
    DATA mv_demo_01 TYPE string.
ENDCLASS.

CLASS lcl_plane IMPLEMENTATION.

  METHOD class_constructor.

  ENDMETHOD.

  METHOD constructor.

    me->mv_type = type.
    me->mv_demo_01 = demo_01.

  ENDMETHOD.

  METHOD display_attributes.
    out->write( 'Display_attributes Class: lcl_plane' ).
  ENDMETHOD.
ENDCLASS.


CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_plane.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.
    METHODS display_attributes REDEFINITION.
    METHODS constructor
      IMPORTING
        type TYPE string
        demo_01 TYPE string
        mv_demo_02 TYPE string.



   private SECTION.
    DATA mv_demo_02 TYPE string.

ENDCLASS.

CLASS lcl_passenger_plane IMPLEMENTATION.

  METHOD constructor.

    super->constructor( type = type demo_01 = demo_01 ).

    me->mv_demo_02 = mv_demo_02.

  ENDMETHOD.


  METHOD display_attributes.
    super->display_attributes( out ).
    out->write( 'Display_attributes Class: lcl_passenger_plane' ).
  ENDMETHOD.

  METHOD class_constructor.

  ENDMETHOD.

ENDCLASS.
