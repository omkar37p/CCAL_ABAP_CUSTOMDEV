CLASS lhc_ZMM_APP05_RV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_app05_rv RESULT result.

ENDCLASS.

CLASS lhc_ZMM_APP05_RV IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
