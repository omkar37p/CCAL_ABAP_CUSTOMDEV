CLASS zmm_email DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMM_EMAIL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  data: lv_sender type c LENGTH 512,
        lv_reciever type c LENGTH 512.


  ENDMETHOD.
ENDCLASS.
