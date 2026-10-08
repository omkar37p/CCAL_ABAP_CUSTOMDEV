CLASS lhc_ZSD_APPS02_1_RV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsd_apps02_1_rv RESULT result.

ENDCLASS.

CLASS lhc_ZSD_APPS02_1_RV IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
