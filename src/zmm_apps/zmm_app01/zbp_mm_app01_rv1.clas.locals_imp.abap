CLASS lsc_zmm_app01_rv1 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app01_rv1 IMPLEMENTATION.

  METHOD save_modified.
    IF create-zmm_app01_rv1 IS NOT INITIAL.
      IF zbp_mm_app01_rv1=>gt_app01_tb3 IS NOT INITIAL.
        DATA(lt_app01_tb3) = zbp_mm_app01_rv1=>gt_app01_tb3.
        MODIFY zmm_app01_tb3 FROM TABLE @lt_app01_tb3.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZMM_APP01_RV1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zmm_app01_rv1 RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_app01_rv1 RESULT result.
    METHODS data1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR zmm_app01_rv1~data1.

ENDCLASS.

CLASS lhc_ZMM_APP01_RV1 IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD data1.
    DATA: lt_tb3 TYPE TABLE OF zmm_app01_tb3,
          ls_tb3 TYPE zmm_app01_tb3..
**********************************************************************
    READ ENTITIES OF zmm_app01_rv1 IN LOCAL MODE
    ENTITY zmm_app01_rv1
    ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    SELECT SINGLE * FROM I_ProductGroup_2 AS h
    INNER JOIN I_ProductGroupText_2  AS t          ON t~ProductGroup = h~ProductGroup
    WHERE h~ProductGroup = @ls_header-Prodgrp
    INTO @DATA(ls_matgrp).
    SELECT SINGLE * FROM zi_departmentvh1 WHERE ExternalProductGroup = @ls_header-Exprdgrp
    INTO @DATA(ls_exmatgrp).
**********************************************************************
    ls_tb3-prodgrp = ls_header-Prodgrp.
    ls_tb3-exprdgrp = ls_header-Exprdgrp.
    ls_tb3-exgrpname = ls_exmatgrp-Groupname.
    ls_tb3-prodgrpname = ls_matgrp-t-ProductGroupName.
    APPEND ls_tb3 TO lt_tb3.
    zbp_mm_app01_rv1=>gt_app01_tb3 = lt_tb3.
**********************************************************************

  ENDMETHOD.

ENDCLASS.
