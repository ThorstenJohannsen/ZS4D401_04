CLASS zcx_04_failed DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    DATA carrier_id TYPE /dmo/carrier_id READ-ONLY.

    CONSTANTS:
      BEGIN OF carrier_not_exist,
        msgid TYPE symsgid VALUE 'Z04_MESSAGES',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'carrier_id',
        attr2 TYPE scx_attrname VALUE 'attr2',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF carrier_not_exist.

    CONSTANTS:
      BEGIN OF carrier_no_read_auth,
        msgid TYPE symsgid VALUE 'Z04_MESSAGES',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE 'carrier_id',
        attr2 TYPE scx_attrname VALUE 'attr2',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF carrier_no_read_auth.

    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        previous LIKE previous OPTIONAL
        carrier_id like carrier_id.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_04_failed IMPLEMENTATION.


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

    if carrier_id is not INITIAL.
      me->carrier_id = carrier_id.
    endif.
  ENDMETHOD.
ENDCLASS.
