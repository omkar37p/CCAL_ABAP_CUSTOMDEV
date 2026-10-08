CLASS lsc_zmm_app01_rcv DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app01_rcv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-bdghdr IS NOT INITIAL.
      IF zbp_mm_app01_rcv=>gt_app01_tb1 IS NOT INITIAL.
        DATA(lt_bdghdr) = zbp_mm_app01_rcv=>gt_app01_tb1.
        MODIFY zmm_app01_tb1 FROM TABLE @lt_bdghdr.
      ENDIF.
    ENDIF.

**********************************************************************
    IF create-bdgitm IS NOT INITIAL.
      IF zbp_mm_app01_rcv=>gt_app01_tb2 IS NOT INITIAL.
        DATA(lt_bcodedata) = zbp_mm_app01_rcv=>gt_app01_tb2.
        MODIFY zmm_app01_tb2 FROM TABLE @lt_bcodedata.
      ENDIF.
    ENDIF.
**********************************************************************
*************** Delete Root & Child entity records *******************
    IF delete-bdghdr IS NOT INITIAL.
      LOOP AT delete-bdghdr INTO DATA(ls_hdr).
        DELETE FROM zmm_app01_tb1 WHERE plant = @ls_hdr-Plant
        AND prodgrp = @ls_hdr-Prodgrp.
      ENDLOOP.

    ENDIF.

    IF delete-bdgitm IS NOT INITIAL.
      LOOP AT delete-bdgitm INTO DATA(ls_itm).
        DELETE FROM zmm_app01_tb2 WHERE plant = @ls_itm-Plant
        AND prodgrp = @ls_itm-Prodgrp AND bdgcode = @ls_itm-Bdgcode AND exprdgrp = @ls_itm-Exprdgrp.
      ENDLOOP.
    ENDIF.
**********************************************************************
*    DELETE FROM zmm_app01_tb1 WHERE plant IS NOT INITIAL.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_bdgitm DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS bdgcode FOR DETERMINE ON SAVE
      IMPORTING keys FOR bdgitm~bdgcode.
*    METHODS bdgamt FOR VALIDATE ON SAVE
*      IMPORTING keys FOR bdgitm~bdgamt.


ENDCLASS.

CLASS lhc_bdgitm IMPLEMENTATION.

  METHOD bdgcode.
    DATA : lt_app01_tb2 TYPE TABLE OF zmm_app01_tb2,
           ls_tb2       TYPE zmm_app01_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app01_rcv IN LOCAL MODE
    ENTITY bdghdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].
**********************************************************************
    READ ENTITIES OF zmm_app01_rcv IN LOCAL MODE
    ENTITY bdgitm
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).
    DATA(ls_items)  = lt_item[ 1 ].
**********************************************************************
    ls_tb2-plant = ls_header-Plant.
    ls_tb2-prodgrp = ls_header-Prodgrp.
    ls_tb2-validon = ls_header-Validon.
    ls_tb2-validto = ls_header-Validto.
    ls_tb2-lncrtdby = ls_items-Lncrtdby.
    ls_tb2-bdgitxt = ls_items-Bdgitxt.
    ls_tb2-curky = ls_items-Curky.
    ls_tb2-exprdgrp = ls_items-Exprdgrp.
    ls_tb2-lncrtdat = ls_items-Lncrtdat.
    ls_tb2-balcibdg = ls_items-Allcibdg.
    ls_tb2-allcibdg = ls_items-Allcibdg.

**********************************************************************
    SELECT * FROM zmm_app01_tb2
    WHERE plant = @ls_header-Plant AND prodgrp = @ls_header-Prodgrp AND
          validon = @ls_header-Validon AND validto = @ls_header-Validto
        INTO TABLE @DATA(lt_bdgline).
    IF lt_bdgline IS INITIAL.
      ls_tb2-bdgcode = ls_header-Prodgrp && '_01'.
    ELSE.
      SORT lt_bdgline BY bdgcode DESCENDING.
      DATA(ls_bdgline)  = lt_bdgline[ 1 ].
      SPLIT ls_bdgline-bdgcode AT '_' INTO DATA(ls_t1) DATA(ls_num).
      ls_num += 1.
      IF ls_num < 9.
        ls_tb2-bdgcode = ls_t1 && '_0' && ls_num .
      ELSE.
        ls_tb2-bdgcode = ls_t1 && '_' && ls_num .
      ENDIF.
    ENDIF.
    APPEND ls_tb2  TO lt_app01_tb2.
    zbp_mm_app01_rcv=>gt_app01_tb2 = lt_app01_tb2.
  ENDMETHOD.



*  METHOD bdgamt.
*    DATA : lv_totamt TYPE zmm_app01_tb2-allcibdg.
*
***********************************************************************
*    READ ENTITIES OF zmm_app01_rcv IN LOCAL MODE
*      ENTITY bdghdr
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_bdghdr).
*    DATA(ls_header) = lt_bdghdr[ 1 ].
*
*    READ ENTITIES OF zmm_app01_rcv IN LOCAL MODE
*      ENTITY bdgitm
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_bdgcode)
*      FAILED DATA(bdg_failed).
*
*    failed = CORRESPONDING #( DEEP bdg_failed ).
*
*    READ ENTITIES OF zmm_app01_rcv IN LOCAL MODE
*          ENTITY bdgitm BY \_bdghdr
*            FROM CORRESPONDING #( lt_bdgcode )
*          LINK DATA(bdghdr_links).
*
*    LOOP AT lt_bdgcode ASSIGNING FIELD-SYMBOL(<ls_bdgcode>).
*      "overwrite state area with empty message to avoid duplicate messages
*      APPEND VALUE #(  %tky               = <ls_bdgcode>-%tky
*                       %state_area        = 'VALIDATE_AMOUNT' ) TO reported-bdgitm.
***********************************************************************
*      SELECT SINGLE plant, Prodgrp, validon, validto, bdgcode, exprdgrp,
*       SUM( allcibdg ) AS totamt
*      FROM zmm_app01_tb2
*      WHERE plant = @<ls_bdgcode>-Plant AND prodgrp = @<ls_bdgcode>-Prodgrp AND
*        validon = @<ls_bdgcode>-Validon AND validto = @<ls_bdgcode>-Validto
*      GROUP BY plant, Prodgrp, validon, validto, bdgcode, exprdgrp
*      INTO @DATA(ls_bdgamt).
*
*      lv_totamt = ls_bdgamt-totamt + <ls_bdgcode>-Allcibdg.
*      IF lv_totamt GT ls_header-Allcbdg.
*        APPEND VALUE #( %tky = <ls_bdgcode>-%tky ) TO failed-bdgitm.
*
**        APPEND VALUE #( %cid      = <ls_bdgcode>-%cid
**                          %key      = <ls_bdgcode>-%key
**                          %is_draft = <ls_bdgcode>-%is_draft
**                          %msg      = new_message(
**                                        id       = 'ZMM_APPS'
**                                        number   = '001'
**                                        v1 = ls_header-Allcbdg
**                                        v2 = ls_header-Allcbdg - lv_totamt
**                                        severity = if_abap_behv_message=>severity-error )
**                        ) TO reported-bdgitm.
*
*        APPEND VALUE #( %tky                 = <ls_bdgcode>-%tky
*                            %state_area          = 'VALIDATE_AMOUNT'
*                            %msg                 = NEW zmm_apps_01(
*                                                                  textid      = zmm_apps_01=>check_amt
*                                                                  severity = if_abap_behv_message=>severity-error
*                                                                  bdgamt = ls_header-Allcbdg )
*                          %path                  = VALUE #( bdghdr-%tky = bdghdr_links[ source-%tky = <ls_bdgcode>-%tky ]-target-%tky )
*                          %element-Allcibdg    = if_abap_behv=>mk-on
*                           ) TO reported-bdgitm.
*
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_BDGHDR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR bdghdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR bdghdr RESULT result.
    METHODS bdgdates FOR DETERMINE ON SAVE
      IMPORTING keys FOR bdghdr~bdgdates.


ENDCLASS.

CLASS lhc_BDGHDR IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD bdgdates.
    DATA : lt_app01_tb1 TYPE TABLE OF zmm_app01_tb1,
           ls_tb1       TYPE zmm_app01_tb1.
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
**********************************************************************
    READ ENTITIES OF zmm_app01_rcv IN LOCAL MODE
      ENTITY bdghdr
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bdghdr).
    DATA(ls_header) = lt_bdghdr[ 1 ].
    ls_tb1-allcbdg = ls_header-Allcbdg.
    ls_tb1-plant = ls_header-Plant.
    ls_tb1-prodgrp = ls_header-Prodgrp.
    ls_tb1-bdghtxt = ls_header-Bdghtxt.
    ls_tb1-curky = ls_header-Curky.
    ls_tb1-validon = lv_fdate.
    ls_tb1-validto = lv_tdate.
    ls_tb1-createdat = ls_header-Createdat.
    ls_tb1-createdby = ls_header-Createdby.
    APPEND ls_tb1 TO lt_app01_tb1.
    zbp_mm_app01_rcv=>gt_app01_tb1 = lt_app01_tb1.
  ENDMETHOD.

ENDCLASS.
