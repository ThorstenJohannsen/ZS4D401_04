*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations



CLASS lcl_super DEFINITION ABSTRACT.

  PUBLIC SECTION.
    DATA mv_demo_01 TYPE i VALUE 100.
    DATA mv_demo_02 TYPE i VALUE 200.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS lcl_sub1 DEFINITION INHERITING FROM lcl_super.

  PUBLIC SECTION.
    DATA mv_cargo TYPE i VALUE 2000.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS lcl_sub2 DEFINITION INHERITING FROM lcl_super .

  PUBLIC SECTION.
    DATA mv_seats_max TYPE i VALUE 300.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS lcl_sub2_1 DEFINITION INHERITING FROM lcl_sub2.

  PUBLIC SECTION.
     DATA mv_seats_1_class TYPE i VALUE 10.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_sub2_1 IMPLEMENTATION.

ENDCLASS.
