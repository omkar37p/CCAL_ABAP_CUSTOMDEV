CLASS lhc_BDGCODE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR bdgcode RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR bdgcode RESULT result.

    METHODS CrtData FOR DETERMINE ON SAVE
      IMPORTING keys FOR bdgcode~CrtData.

ENDCLASS.

CLASS lhc_BDGCODE IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CrtData.
    DATA : lt_bdgcode TYPE TABLE OF zmm_app06_tb1,
           ls_bdgcode TYPE zmm_app06_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app06_rv IN LOCAL MODE
    ENTITY bdgcode
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].

    ls_bdgcode-allcbdg = ls_header-Allcbdg.
    ls_bdgcode-bdghtxt = ls_header-Bdghtxt.
    ls_bdgcode-bdgtype = ls_header-Bdgtype.
    ls_bdgcode-createdat = ls_header-Createdat.
    ls_bdgcode-createdby = ls_header-Createdby.
    ls_bdgcode-curky = ls_header-Curky.
    ls_bdgcode-deptid = ls_header-Deptid.
    ls_bdgcode-deptname = ls_header-Deptname.
    ls_bdgcode-exmptmrk = ls_header-ExmptMrk.
    ls_bdgcode-plant = ls_header-Plant.
    ls_bdgcode-plntname = ls_header-Plntname.
    ls_bdgcode-wbselmt = ls_header-Wbselmt.
*    SELECT SINGLE MAX( bdgcode ) FROM zmm_app06_tb1 INTO @DATA(lv_bdgcode).
*    IF sy-subrc NE 0 AND lv_bdgcode IS INITIAL.
*      ls_bdgcode-bdgcode = 'BDG1000000000'.
*    ELSE.
*      ls_bdgcode-bdgcode = lv_bdgcode + 1.
*    ENDIF.
    SELECT * FROM zmm_app06_tb1 WHERE bdgcode IS NOT INITIAL INTO TABLE @DATA(lt_bdgline).
    IF lt_bdgline IS INITIAL.
      ls_bdgcode-bdgcode = '1000000000'.
    ELSE.
      SORT lt_bdgline BY bdgcode DESCENDING.
      DATA(ls_bdgline)  = lt_bdgline[ 1 ].
      ls_bdgcode-bdgcode = ls_bdgline-bdgcode + 1.
*      SPLIT ls_bdgline-bdgcode AT 'BDG' INTO DATA(ls_t1) DATA(ls_num).
*      ls_num += 1.
*      IF ls_num < 9.
*        ls_bdgcode-bdgcode = ls_t1 && '_0' && ls_num .
*      ELSE.
*        ls_bdgcode-bdgcode = ls_t1 && '_' && ls_num .
*      ENDIF.
    ENDIF.

**********************************************************************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
        DATA(lv_fdate) = lv_sydate+0(4) && '04' && '01'.
        DATA(lv_year) = lv_sydate+0(4).
        DATA(lv_year1) = lv_year + 1.
        DATA(lv_tdate) = lv_year1  && '04' && '01'.
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
    TRY.
        DATA(lv_syuser) = cl_abap_context_info=>get_user_description( ).
      CATCH cx_abap_context_info_error.
        "handle exception
        DATA(lv_s) = 1.
    ENDTRY.
    ls_bdgcode-validon = lv_fdate.
    ls_bdgcode-validto = lv_tdate.
    APPEND ls_bdgcode TO lt_bdgcode.
    zbp_mm_app06_rv=>gt_bdgcode = lt_bdgcode.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_APP06_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_APP06_RV IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-bdgcode IS NOT INITIAL.
      IF zbp_mm_app06_rv=>gt_bdgcode IS NOT INITIAL.
        DATA(lt_bdgcode) = zbp_mm_app06_rv=>gt_bdgcode.
        MODIFY zmm_app06_tb1 FROM TABLE @lt_bdgcode.
      ENDIF.
    ENDIF.
**********************************************************************
    IF delete-bdgcode IS NOT INITIAL.
      LOOP AT delete-bdgcode INTO DATA(ls_bdg).
*        DELETE FROM zmm_app06_tb1 WHERE plant = @ls_bdg-Plant AND deptid = @ls_bdg-Deptid AND bdgcode = @ls_bdg-Bdgcode.
        SELECT SINGLE * FROM zmm_app06_tb1 WHERE plant = @ls_bdg-Plant AND deptid = @ls_bdg-Deptid AND bdgcode = @ls_bdg-Bdgcode
        INTO @DATA(ls_delrecd).
        ls_delrecd-delemrk = 'X'.
        MODIFY zmm_app06_tb1 FROM  @ls_delrecd.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
