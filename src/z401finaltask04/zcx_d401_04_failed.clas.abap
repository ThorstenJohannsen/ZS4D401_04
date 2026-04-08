CLASS zcx_d401_04_failed DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    DATA i_model TYPE c LENGTH 30 READ-ONLY.
    DATA i_make TYPE d.

    CONSTANTS:
      BEGIN OF cargo_to_low,
        msgid TYPE symsgid VALUE 'Z04_FT_MESSAGES',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'i_model',
        attr2 TYPE scx_attrname VALUE 'i_make',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF cargo_to_low.

    CONSTANTS:
      BEGIN OF vehicle_exist,
        msgid TYPE symsgid VALUE 'Z04_FT_MESSAGES',
        msgno TYPE symsgno VALUE '015',
        attr1 TYPE scx_attrname VALUE 'i_model',
        attr2 TYPE scx_attrname VALUE 'i_make',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF vehicle_exist.

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        i_make     LIKE i_make
        i_model     LIKE i_model.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_d401_04_failed IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    previous = previous
    ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    IF i_make IS NOT INITIAL.
      me->i_make = i_make.
    ENDIF.

    if i_model IS NOT INITIAL.
        me->i_model = i_model.
    endif.


  ENDMETHOD.
ENDCLASS.

