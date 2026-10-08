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
    DATA : lt_bdgcode TYPE TABLE OF zmm_app08_tb1,
           ls_bdgcode TYPE zmm_app08_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app08_rv IN LOCAL MODE
    ENTITY bdgcode
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].

    ls_bdgcode-createdat = ls_header-Createdat.
    ls_bdgcode-createdby = ls_header-Createdby.
    ls_bdgcode-deptid = ls_header-Deptid.
    SELECT SINGLE plant, deptid,deptname FROM zi_department_vh1 WHERE plant = @ls_header-Plant AND deptid = @ls_header-Deptid
    INTO @DATA(ls_dept).
    ls_bdgcode-deptname = ls_dept-deptname.
    ls_bdgcode-plant = ls_header-Plant.
    ls_bdgcode-bdgyear = ls_header-Bdgyear.
    SELECT SINGLE Shpoint, Shpname  FROM zi_plant_vh1 WHERE Shpoint = @ls_header-Plant INTO @DATA(ls_plant).
    ls_bdgcode-plntname = ls_plant-Shpname.

**********************************************************************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
    TRY.
        DATA(lv_syuser) = cl_abap_context_info=>get_user_description( ).
      CATCH cx_abap_context_info_error.
        "handle exception
        DATA(lv_s) = 1.
    ENDTRY.
**********************************************************************
    SELECT SINGLE * FROM I_FiscalYearForCompanyCode WITH PRIVILEGED ACCESS
    WHERE FiscalYearStartDate <= @lv_sydate AND FiscalYearEndDate >= @lv_sydate
    INTO @DATA(ls_fsyear).

    DATA(lv_fdate) = ls_fsyear-FiscalYear && '04' && '01'.
    DATA(lv_year1) = ls_fsyear-FiscalYear + 1.
    DATA(lv_tdate) = lv_year1  && '03' && '31'.

    ls_bdgcode-validon = lv_fdate.
    ls_bdgcode-validto = lv_tdate.
    APPEND ls_bdgcode TO lt_bdgcode.
    zbp_mm_app08_rv=>gt_bdgcode = lt_bdgcode.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_BDGITM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CrtItem FOR DETERMINE ON SAVE
      IMPORTING keys FOR bdgitm~CrtItem.
    METHODS bdgval FOR VALIDATE ON SAVE
      IMPORTING keys FOR bdgitm~bdgval.

ENDCLASS.

CLASS lhc_BDGITM IMPLEMENTATION.

  METHOD CrtItem.
    DATA : lt_bdgitem TYPE TABLE OF zmm_app08_tb2,
           ls_bdgitem TYPE zmm_app08_tb2,
           lt_bdghdr  TYPE TABLE OF zmm_app08_tb1,
           ls_bdghdr  TYPE zmm_app08_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app08_rv IN LOCAL MODE
    ENTITY bdgcode
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr)
    ENTITY bdgitm
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).
    DATA(ls_item)  = lt_item[ 1 ].
    DATA(ls_hdr)  = lt_hdr[ 1 ].
    IF ls_item-Allcbdg > 0.
      ls_bdgitem-plant = ls_item-Plant.
      ls_bdgitem-deptid = ls_item-Deptid.
      ls_bdgitem-Bdgyear = ls_item-Bdgyear.
      ls_bdgitem-allcbdg = ls_item-Allcbdg.
      ls_bdgitem-curky = ls_item-Curky.
      ls_bdgitem-localcreatedat = ls_item-Localcreatedat.
      ls_bdgitem-localcreatedby = ls_item-Localcreatedby.
      ls_bdgitem-remarks = ls_item-Remarks.

      SELECT SINGLE MAX( itemno ) FROM zmm_app08_tb2
      WHERE plant = @ls_item-plant AND deptid = @ls_item-Deptid AND bdgyear = @ls_item-bdgyear
      INTO @DATA(ls_sno).
      IF sy-subrc = 0 AND NOT ls_sno IS INITIAL.
        ls_bdgitem-itemno = ls_sno + 1.
      ELSE.
        ls_bdgitem-itemno = 1.
      ENDIF.
      APPEND ls_bdgitem TO lt_bdgitem.
      zbp_mm_app08_rv=>gt_bdgitem = lt_bdgitem.
**********************************************************************
      MOVE-CORRESPONDING ls_hdr TO ls_bdghdr.
      SELECT SINGLE plant, deptid,bdgyear, SUM( Allcbdg ) AS allcbdg FROM zmm_app08_tb2
            WHERE plant = @ls_item-plant AND deptid = @ls_item-Deptid AND bdgyear = @ls_item-bdgyear
            GROUP BY plant, deptid,bdgyear
            INTO @DATA(ls_totbdg).
      IF sy-subrc = 0 AND NOT ls_totbdg IS INITIAL.
        ls_bdghdr-allcbdg = ls_totbdg-allcbdg + ls_item-Allcbdg.
      ELSE.
        ls_bdghdr-allcbdg = ls_item-Allcbdg.
      ENDIF.
      APPEND ls_bdghdr TO lt_bdghdr.
      zbp_mm_app08_rv=>gt_bdghdr = lt_bdghdr.
    ENDIF.
  ENDMETHOD.

  METHOD bdgval.
**********************************************************************
    READ ENTITIES OF zmm_app08_rv IN LOCAL MODE
    ENTITY bdgitm
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).
    DATA(ls_item)  = lt_item[ 1 ].
    IF ls_item-Allcbdg <= 0.
      APPEND VALUE #( %tky = ls_item-%tky ) TO failed-bdgitm.
      APPEND VALUE #( %tky = ls_item-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Allotted amount can not be Zero or less' )
                     ) TO reported-bdgitm.

    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_APP08_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_APP08_RV IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-bdgcode IS NOT INITIAL.
*      DELETE FROM zmm_app08_dt1 WHERE plant IS NOT INITIAL.
*      DELETE FROM zmm_app08_tb1 WHERE plant IS NOT INITIAL.
      IF zbp_mm_app08_rv=>gt_bdgcode IS NOT INITIAL.
        DATA(lt_bdgcode) = zbp_mm_app08_rv=>gt_bdgcode.
        MODIFY zmm_app08_tb1 FROM TABLE @lt_bdgcode.
      ENDIF.
    ENDIF.
    IF create-bdgitm IS NOT INITIAL.
      IF zbp_mm_app08_rv=>gt_bdgitem IS NOT INITIAL.
        DATA(lt_bdgitem) = zbp_mm_app08_rv=>gt_bdgitem.
        MODIFY zmm_app08_tb2 FROM TABLE @lt_bdgitem.
      ENDIF.
    ENDIF.
**********************************************************************
    IF zbp_mm_app08_rv=>gt_bdghdr IS NOT INITIAL.
      DATA(lt_bdghdr) = zbp_mm_app08_rv=>gt_bdghdr.
      MODIFY zmm_app08_tb1 FROM TABLE @lt_bdghdr.
    ENDIF.

**********************************************************************
    IF delete-bdgcode IS NOT INITIAL.
      LOOP AT delete-bdgcode INTO DATA(ls_bdg).
*        DELETE FROM zmm_app08_tb2 WHERE plant = @ls_bdg-Plant AND deptid = @ls_bdg-Deptid AND bdgyear = @ls_bdg-Bdgyear.
*        DELETE FROM zmm_app08_tb1 WHERE plant = @ls_bdg-Plant AND deptid = @ls_bdg-Deptid AND bdgyear = @ls_bdg-Bdgyear.
        SELECT SINGLE * FROM zmm_app08_tb1 WHERE plant = @ls_bdg-Plant AND deptid = @ls_bdg-Deptid AND bdgyear = @ls_bdg-bdgyear
        INTO @DATA(ls_delrecd).
        ls_delrecd-delemrk = 'X'.
        MODIFY zmm_app08_tb1 FROM  @ls_delrecd.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
