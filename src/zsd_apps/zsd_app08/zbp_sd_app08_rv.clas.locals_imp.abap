CLASS lhc_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR hdr RESULT result.
    METHODS getdata1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hdr~getdata1.

ENDCLASS.

CLASS lhc_hdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getdata1.
**********************************************************************
**********************************************************************
    READ ENTITIES OF zsd_app08_rv IN LOCAL MODE
          ENTITY hdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    IF ls_header IS NOT INITIAL.
      SELECT SINGLE * FROM i_billingdocument WHERE billingdocument = @ls_header-vbeln INTO @DATA(ls_billdoc).
      IF ls_billdoc IS NOT INITIAL.

      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsd_app08_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsd_app08_rv IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
