CLASS lhc_bdgcode DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR bdgcode RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR bdgcode RESULT result.

    METHODS crtdata FOR DETERMINE ON SAVE
      IMPORTING keys FOR bdgcode~crtdata.
    METHODS mandt FOR VALIDATE ON SAVE
      IMPORTING keys FOR bdgcode~mandt.
*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE bdgcode.

ENDCLASS.

CLASS lhc_bdgcode IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
    READ ENTITIES OF zmm_app09_rv IN LOCAL MODE
        ENTITY bdgcode
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_status)
        ENTITY bdgcode BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).

    result = VALUE #( FOR ls_data IN lt_status
      ( %tky =  ls_data-%tky
        %features-%action-edit = COND #( WHEN ls_data-delemrk EQ 'X'
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled
         )  ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD crtdata.
    DATA : lt_bdgcode  TYPE TABLE OF zmm_app09_tb1,
           ls_bdgcode  TYPE zmm_app09_tb1,
           ls_bdgcode2 TYPE zmm_app09_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app09_rv IN LOCAL MODE
    ENTITY bdgcode
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).
    DATA(ls_header)  = lt_header[ 1 ].

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
*    SELECT SINGLE h~plant,h~deptid,h~bdgyear, SUM( h~allcbdg ) AS baseamt
*    FROM zmm_app08_tb2 AS h INNER JOIN zmm_app08_tb1 AS i
*    ON i~plant = h~Plant AND i~deptid = h~Deptid AND i~bdgyear = h~bdgyear
*    WHERE i~validon <= @lv_date AND i~validto >= @lv_date
*    GROUP BY h~plant,h~deptid,h~bdgyear
*    INTO @DATA(ls_depbdg).
*    IF sy-subrc = 0 AND NOT ls_depbdg IS INITIAL.
*      ls_bdgcode-basebdg = ls_depbdg-baseamt.
*      ls_bdgcode-curky = 'INR'.
*    ENDIF.
    ls_bdgcode-uuid =  ls_header-uuid.
    ls_bdgcode-bdghtxt = ls_header-bdghtxt.
    ls_bdgcode-bdgtype = ls_header-bdgtype.
    ls_bdgcode-createdat = ls_header-createdat.
    ls_bdgcode-createdby = ls_header-createdby.
    ls_bdgcode-deptid = ls_header-deptid.
    ls_bdgcode-deptname = ls_header-deptname.
    ls_bdgcode-exmptmrk = ls_header-exmptmrk.
    ls_bdgcode-plant = ls_header-plant.
    ls_bdgcode-plntname = ls_header-plntname.
    ls_bdgcode-wbselmt = ls_header-wbselmt.
    ls_bdgcode-bdgcode =  ls_header-bdgcode.
    ls_bdgcode-curky = 'INR'.
**********************************************************************
    SELECT SINGLE * FROM i_fiscalyearforcompanycode WITH PRIVILEGED ACCESS
    WHERE companycode = '1000' AND fiscalyearstartdate LE @lv_sydate AND fiscalyearenddate GE @lv_sydate
    INTO @DATA(ls_fsyear).
    DATA(lv_fsyear) = ls_fsyear-fiscalyear+2(2).
    DATA(lv_fdate) = ls_fsyear-fiscalyear && '04' && '01'.
    ls_bdgcode-validon = lv_fdate.
    DATA(lv_year1) = ls_fsyear-fiscalyear + 1.
    DATA(lv_tdate) = lv_year1  && '03' && '31'.
    ls_bdgcode-validto = lv_tdate.

    SELECT * FROM zmm_app09_tb1 WHERE uuid IS NOT INITIAL INTO TABLE @DATA(lt_bdgline).
    IF lt_bdgline IS INITIAL.
      ls_bdgcode-bdgcode = lv_fsyear && '00000000'.
    ELSE.
      SORT lt_bdgline BY bdgcode DESCENDING.
      DATA(ls_bdgline)  = lt_bdgline[ 1 ].
      IF ls_bdgline-bdgcode+0(2) = lv_fsyear.
        ls_bdgcode-bdgcode = ls_bdgline-bdgcode + 1.
      ELSE.
        ls_bdgcode-bdgcode = lv_fsyear && '00000000'.
      ENDIF.
    ENDIF.
**********************************************************************
    APPEND ls_bdgcode TO lt_bdgcode.
    zbp_mm_app09_rv=>gt_bdgcode = lt_bdgcode.

  ENDMETHOD.


  METHOD mandt.
**********************************************************************
    READ ENTITIES OF zmm_app09_rv IN LOCAL MODE
        ENTITY bdgcode
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_bdgcode)
        ENTITY bdgcode BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).
    DATA(ls_bdgcode) = lt_bdgcode[ 1 ].

    IF ls_bdgcode-bdgtype IS INITIAL.
      APPEND VALUE #( %tky = ls_bdgcode-%tky ) TO failed-bdgcode.
      APPEND VALUE #( %tky = ls_bdgcode-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Budget Type is Mandatory'  )
                     ) TO reported-bdgcode.
    ENDIF.

  ENDMETHOD.

*  METHOD earlynumbering_create.
*    DATA : lv_bdgcode TYPE zmm_app09_tb1-bdgcode.
*    DATA(entities_wo_id) = entities.
*    DELETE entities_wo_id WHERE Bdgcode IS NOT INITIAL.
*    TRY.
*        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
*      CATCH cx_abap_context_info_error.
*        DATA(ls_v) = 1.
*    ENDTRY.
***********************************************************************
*    SELECT SINGLE * FROM I_FiscalYearForCompanyCode WHERE FiscalYearStartDate < @lv_sydate AND FiscalYearEndDate > @lv_sydate
*    INTO @DATA(ls_fsyear).
*    DATA(lv_fsyear) = ls_fsyear-FiscalYear+2(2).
*    SELECT * FROM zmm_app09_tb1 INTO TABLE @DATA(lt_bdgline).
*    IF lt_bdgline IS INITIAL.
*      lv_bdgcode = lv_fsyear && '00000000'.
*    ELSE.
*      SORT lt_bdgline BY bdgcode DESCENDING.
*      DATA(ls_bdgline)  = lt_bdgline[ 1 ].
*      IF ls_bdgline-bdgcode+0(2) = lv_fsyear.
*        lv_bdgcode = ls_bdgline-bdgcode + 1.
*      ELSE.
*        lv_bdgcode = lv_fsyear && '00000000'.
*      ENDIF.
*    ENDIF.
***********************************************************************
*    LOOP AT entities_wo_id INTO DATA(ls_entity).
*      TRY.
*          "Generate UUID. Here, number range FM can be called
*          ls_entity-Bdgcode = lv_bdgcode.
*
*          "Add entity to mapped entity, note the draft key
*          APPEND VALUE #( %cid      = ls_entity-%cid
*                          %key      = ls_entity-%key
*                          %is_draft = ls_entity-%is_draft
*                        ) TO mapped-bdgcode.
*        CATCH cx_uuid_error INTO DATA(lx_uuid_error).
**          "In case of error, append to reported and failed
**          APPEND VALUE #( %cid      = ls_entity-%cid
**                          %key      = ls_entity-%key
**                          %is_draft = ls_entity-%is_draft
**                          %msg      = new_message(
**                                        id       = 'ZJP_MSG'
**                                        number   = '001'
**                                        severity = if_abap_behv_message=>severity-error )
**                        ) TO reported-carrier.
*
*          APPEND VALUE #( %cid      = ls_entity-%cid
*                          %key      = ls_entity-%key
*                          %is_draft = ls_entity-%is_draft
*                        ) TO failed-bdgcode.
*
*      ENDTRY.
*    ENDLOOP.
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_bdgitm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS crtitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR bdgitm~crtitem.
    METHODS upditem FOR DETERMINE ON SAVE
      IMPORTING keys FOR bdgitm~upditem.
    METHODS totval FOR VALIDATE ON SAVE
      IMPORTING keys FOR bdgitm~totval.
    METHODS totval2 FOR VALIDATE ON SAVE
      IMPORTING keys FOR bdgitm~totval2.

ENDCLASS.

CLASS lhc_bdgitm IMPLEMENTATION.

  METHOD crtitem.
    DATA : lt_bdgitem TYPE TABLE OF zmm_app09_tb2,
           ls_bdgitem TYPE zmm_app09_tb2,
           lt_bdghdr  TYPE TABLE OF zmm_app09_tb1,
           ls_bdghdr  TYPE zmm_app09_tb1,
           lv_currval TYPE zmm_app09_tb2-allcbdg,
           lv_totbdg  TYPE zmm_app09_tb2-allcbdg.
**********************************************************************
    READ ENTITIES OF zmm_app09_rv IN LOCAL MODE
    ENTITY bdgcode
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr)
    ENTITY bdgitm
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).
    DATA(ls_item)  = lt_item[ 1 ].
    DATA(ls_hdr)  = lt_hdr[ 1 ].

**********************************************************************
    IF ls_item-allcbdg < 0.
      "******************* Total PO allocation Value *************************"
      SELECT SINGLE bdgcode, SUM( inramt ) AS totnetamt FROM zi_purord_data01
        WHERE bdgcode = @ls_hdr-bdgcode
        GROUP BY bdgcode
        INTO @DATA(ls_pototal).
      "**************** Existing released budget Line Value *************"
      SELECT SINGLE plant, deptid, bdgcode, SUM( allcbdg ) AS totbdg FROM zmm_app09_tb2
        WHERE plant = @ls_item-plant AND deptid = @ls_item-deptid AND uuid = @ls_item-uuid
        AND bdgcode = @ls_hdr-bdgcode  AND actstss = 'X'
        GROUP BY plant, deptid,bdgcode
        INTO @DATA(ls_bdctot).
      DATA(lv_bdgbal) = ls_bdctot-totbdg - ls_pototal-totnetamt.
      lv_currval = ls_item-allcbdg *  -1 .
      IF lv_currval <= lv_bdgbal.
        ls_bdgitem-plant   = ls_item-plant.
        ls_bdgitem-deptid  = ls_item-deptid.
        ls_bdgitem-uuid    = ls_item-uuid.
        ls_bdgitem-bdgcode = ls_hdr-bdgcode.
        ls_bdgitem-actstss = ls_item-actstss.
        ls_bdgitem-allcbdg = ls_item-allcbdg.
*    ls_bdgitem-attachment = ls_item-Attachment.
        ls_bdgitem-bdgitxt = ls_item-bdgitxt.
        ls_bdgitem-curky = ls_item-curky.
*    ls_bdgitem-filename = ls_item-Filename.
        ls_bdgitem-lastchangedat = ls_item-lastchangedat.
        ls_bdgitem-localcreatedat = ls_item-localcreatedat.
        ls_bdgitem-localcreatedby = ls_item-localcreatedby.
        ls_bdgitem-locallastchangedat = ls_item-locallastchangedat.
        ls_bdgitem-locallastchangedby = ls_item-locallastchangedby.
*    ls_bdgitem-mimetype = ls_item-Mimetype.
        ls_bdgitem-remarks = ls_item-remarks.
        ls_bdgitem-actstss = 'X'.
        SELECT SINGLE MAX( itemno ) FROM zmm_app09_tb2
        WHERE plant = @ls_item-plant AND deptid = @ls_item-deptid
        AND uuid = @ls_item-uuid AND bdgcode = @ls_hdr-bdgcode INTO @DATA(ls_sno).
        IF sy-subrc = 0 AND NOT ls_sno IS INITIAL.
          ls_bdgitem-itemno = ls_sno + 1.
        ELSE.
          ls_bdgitem-itemno = 1.
        ENDIF.
        APPEND ls_bdgitem TO lt_bdgitem.
        zbp_mm_app09_rv=>gt_bdgitem = lt_bdgitem.

      ENDIF.
    ELSE.
      ls_bdgitem-plant = ls_item-plant.
      ls_bdgitem-deptid = ls_item-deptid.
      ls_bdgitem-uuid = ls_item-uuid.
      ls_bdgitem-bdgcode = ls_hdr-bdgcode.
      ls_bdgitem-actstss = ls_item-actstss.
      ls_bdgitem-allcbdg = ls_item-allcbdg.
*    ls_bdgitem-attachment = ls_item-Attachment.
      ls_bdgitem-bdgitxt = ls_item-bdgitxt.
      ls_bdgitem-curky = ls_item-curky.
*    ls_bdgitem-filename = ls_item-Filename.
      ls_bdgitem-lastchangedat = ls_item-lastchangedat.
      ls_bdgitem-localcreatedat = ls_item-localcreatedat.
      ls_bdgitem-localcreatedby = ls_item-localcreatedby.
      ls_bdgitem-locallastchangedat = ls_item-locallastchangedat.
      ls_bdgitem-locallastchangedby = ls_item-locallastchangedby.
*    ls_bdgitem-mimetype = ls_item-Mimetype.
      ls_bdgitem-remarks = ls_item-remarks.

      SELECT SINGLE MAX( itemno ) FROM zmm_app09_tb2
      WHERE plant = @ls_item-plant AND deptid = @ls_item-deptid
      AND uuid = @ls_item-uuid AND bdgcode = @ls_hdr-bdgcode INTO @DATA(ls2_sno).
      IF sy-subrc = 0 AND NOT ls2_sno IS INITIAL.
        ls_bdgitem-itemno = ls2_sno + 1.
      ELSE.
        ls_bdgitem-itemno = 1.
      ENDIF.
      APPEND ls_bdgitem TO lt_bdgitem.
      zbp_mm_app09_rv=>gt_bdgitem = lt_bdgitem.
    ENDIF.
**********************************************************************
    "**************** Existing released budget Line Value *************"
    SELECT SINGLE plant, deptid, bdgcode, SUM( allcbdg ) AS totbdg FROM zmm_app09_tb2
      WHERE plant = @ls_item-plant AND deptid = @ls_item-deptid AND uuid = @ls_item-uuid
      AND bdgcode = @ls_hdr-bdgcode " AND actstss = 'X'
      GROUP BY plant, deptid,bdgcode
      INTO @DATA(ls_totval).
    lv_totbdg = ls_totval-totbdg + ls_item-allcbdg.
    MOVE-CORRESPONDING ls_hdr TO ls_bdghdr.
    ls_bdghdr-talcbdg = lv_totbdg.
    APPEND ls_bdghdr TO lt_bdghdr.
    zbp_mm_app09_rv=>gt_updcode = lt_bdghdr.
  ENDMETHOD.
**********************************************************************
  METHOD upditem.
    DATA : lt_upditem TYPE TABLE OF zmm_app09_tb2,
           ls_upditem TYPE zmm_app09_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app09_rv IN LOCAL MODE
    ENTITY bdgitm
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).
    DATA(ls_item)  = lt_item[ 1 ].
    MOVE-CORRESPONDING ls_item TO ls_upditem.
    ls_upditem-curky = 'INR'.
    APPEND ls_upditem TO lt_upditem.
    zbp_mm_app09_rv=>gt_upditem = lt_upditem.
  ENDMETHOD.

  METHOD totval.
    DATA : lv_totval  TYPE zmm_app09_tb2-allcbdg,
           lv_diffamt TYPE zmm_app09_tb2-allcbdg.
**********************************************************************
    READ ENTITIES OF zmm_app09_rv IN LOCAL MODE
        ENTITY bdgcode
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_bdgcode)
        ENTITY bdgcode BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).
    DATA(ls_bdgcode) = lt_bdgcode[ 1 ].
**********************************************************************
    DATA itab TYPE TABLE OF zmm_app09_tb2-allcbdg WITH EMPTY KEY.
    itab = VALUE #( FOR j IN lt_items ( j-allcbdg ) ).
    DATA(lv_sum) = REDUCE zmm_app09_tb2-allcbdg( INIT x = 0 FOR wa IN itab NEXT x = x + wa ).
**********************************************************************
    DATA: itab1 TYPE RANGE OF zmm_app09_tb2-uuid,
          itab2 TYPE RANGE OF zmm_app09_tb2-uuid.

    itab1 =  VALUE #( FOR ls IN lt_items
                            LET s = 'I' o = 'EQ' IN sign = s  option = o
                          ( low = ls-uuid )  ).

************************** Exclude BDGCODE marked for deletion *****************************
    SELECT plant, deptid,uuid,bdgcode  FROM zmm_app09_tb1 WHERE plant = @ls_bdgcode-plant AND deptid = @ls_bdgcode-deptid AND delemrk = 'X'
    INTO TABLE @DATA(lt_delbdg).

    itab2 =  VALUE #( FOR ls1 IN lt_delbdg
                            LET s = 'I' o = 'EQ' IN sign = s  option = o
                          ( low = ls1-uuid )  ).

******************************* Total current Alloted Department budget*********************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
        DATA(lv_date) = lv_sydate+0(4) && lv_sydate+4(2) && lv_sydate+6(2).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
**********************************************************************
    SELECT SINGLE lbdg~plant, lbdg~deptid, SUM( lbdg~allcbdg ) AS totbdg FROM zmm_app09_tb2 AS lbdg
    INNER JOIN zmm_app09_tb1 AS mbdg ON mbdg~plant = lbdg~plant AND mbdg~deptid = lbdg~deptid
    WHERE lbdg~plant = @ls_bdgcode-plant AND lbdg~deptid = @ls_bdgcode-deptid AND mbdg~delemrk EQ 'X'
    AND mbdg~validon GE @lv_sydate AND mbdg~validto LE @lv_sydate
    AND lbdg~uuid NOT IN @itab1 AND lbdg~uuid NOT IN @itab2
    GROUP BY lbdg~plant, lbdg~deptid INTO @DATA(ls_bdctot).
******************************** Current Value + already allotted amount *******************
    lv_sum += ls_bdctot-totbdg.
**********************************************************************

    SELECT SINGLE h~plant,h~deptid,h~bdgyear, SUM( h~allcbdg ) AS baseamt
    FROM zmm_app08_tb1 AS i INNER JOIN zmm_app08_tb2 AS h
    ON i~plant = h~plant AND i~deptid = h~deptid AND i~bdgyear = h~bdgyear
    WHERE h~plant = @ls_bdgcode-plant AND h~deptid = @ls_bdgcode-deptid AND i~validon <= @lv_date AND i~validto >= @lv_date
    GROUP BY h~plant,h~deptid,h~bdgyear
    INTO @DATA(ls_depbdg).
    IF sy-subrc = 0 AND NOT ls_depbdg IS INITIAL.
      DATA(lv_baseamt) = ls_depbdg-baseamt.
    ENDIF.
    IF lv_baseamt IS INITIAL.
      APPEND VALUE #( %tky = ls_bdgcode-%tky ) TO failed-bdgcode.
      APPEND VALUE #( %tky = ls_bdgcode-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Department Base amount for this fiscal year is missing' )
                     ) TO reported-bdgcode.

    ELSEIF lv_sum > lv_baseamt.
      lv_diffamt = lv_sum - lv_baseamt.
      APPEND VALUE #( %tky = ls_bdgcode-%tky ) TO failed-bdgcode.
      APPEND VALUE #( %tky = ls_bdgcode-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Dept. Base amount' && '-'
                                                    && lv_baseamt && ' ' && ' exceeded by ' && lv_diffamt )
                     ) TO reported-bdgcode.
    ENDIF.

  ENDMETHOD.

  METHOD totval2.
    DATA : lv_currval TYPE zmm_app09_tb2-allcbdg.
**********************************************************************
    READ ENTITIES OF zmm_app09_rv IN LOCAL MODE
    ENTITY bdgcode
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr)
    ENTITY bdgitm
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).
    DATA(ls_item)  = lt_item[ 1 ].
    DATA(ls_hdr)  = lt_hdr[ 1 ].

**********************************************************************
    IF ls_item-allcbdg < 0.
      "******************* Total PO allocation Value *************************"
      SELECT SINGLE bdgcode, SUM( inramt ) AS totnetamt FROM zi_purord_data01
        WHERE bdgcode = @ls_hdr-bdgcode
        GROUP BY bdgcode
        INTO @DATA(ls_pototal).
      "**************** Existing released budget Line Value *************"
      SELECT SINGLE plant, deptid, bdgcode, SUM( allcbdg ) AS totbdg FROM zmm_app09_tb2
        WHERE plant = @ls_item-plant AND deptid = @ls_item-deptid AND uuid = @ls_item-uuid
        AND bdgcode = @ls_hdr-bdgcode  AND actstss = 'X'
        GROUP BY plant, deptid,bdgcode
        INTO @DATA(ls_bdctot).
      DATA(lv_bdgbal) = ls_bdctot-totbdg - ls_pototal-totnetamt.
      lv_currval = ls_item-allcbdg *  -1 .
      IF lv_currval > lv_bdgbal.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-bdgitm.
        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Current available Budget ' && ' '
                                                      && lv_bdgbal  && ' cannot be adjusted.'  )
                       ) TO reported-bdgitm.

      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app09_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app09_rv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-bdgcode IS NOT INITIAL.
      IF zbp_mm_app09_rv=>gt_bdgcode IS NOT INITIAL.
        DATA(lt_bdgcode) = zbp_mm_app09_rv=>gt_bdgcode.
        DATA(ls_bdgcode) = lt_bdgcode[ 1 ].
        IF ls_bdgcode-bdgcode IS NOT INITIAL.
          MODIFY zmm_app09_tb1 FROM TABLE @lt_bdgcode.
        ENDIF.
      ENDIF.
    ENDIF.
    IF create-bdgitm IS NOT INITIAL.
      IF zbp_mm_app09_rv=>gt_bdgitem IS NOT INITIAL.
        DATA(lt_bdgitem) = zbp_mm_app09_rv=>gt_bdgitem.
        DATA(ls_bdgitem) = lt_bdgitem[ 1 ].
        IF ls_bdgitem-bdgcode IS NOT INITIAL.
          MODIFY zmm_app09_tb2 FROM TABLE @lt_bdgitem.
        ENDIF.
      ENDIF.
    ENDIF.
**********************************************************************
    IF update-bdgitm IS NOT INITIAL.
      IF zbp_mm_app09_rv=>gt_upditem IS NOT INITIAL.
        DATA(lt_upditem) = zbp_mm_app09_rv=>gt_upditem.
        MODIFY zmm_app09_tb2 FROM TABLE @lt_upditem.
      ENDIF.
    ENDIF.
**********************************************************************
    IF zbp_mm_app09_rv=>gt_updcode IS NOT INITIAL.
      DATA(lt_updcode) = zbp_mm_app09_rv=>gt_updcode.
      MODIFY zmm_app09_tb1 FROM TABLE @lt_updcode.
    ENDIF.
**********************************************************************
    IF delete-bdgcode IS NOT INITIAL.
      LOOP AT delete-bdgcode INTO DATA(ls_bdg).
*        DELETE FROM zmm_app09_tb2 WHERE plant = @ls_bdg-Plant AND deptid = @ls_bdg-Deptid AND bdgcode = '0000000000' OR bdgcode = @ls_bdg-Bdgcode.
*        DELETE FROM zmm_app09_tb1 WHERE plant = @ls_bdg-Plant AND deptid = @ls_bdg-Deptid AND bdgcode = @ls_bdg-Bdgcode.

        SELECT SINGLE * FROM zmm_app09_tb1 WHERE plant = @ls_bdg-plant AND deptid = @ls_bdg-deptid AND uuid = @ls_bdg-uuid "AND bdgcode = @ls_bdg-Bdgcode
        INTO @DATA(ls_delrecd).
        "******************* PO allocation Check *************************"
        SELECT SINGLE purchaseorder,purchaseorderitem,purchasingdocumentdeletioncode FROM zi_purord_data01
          WHERE bdgcode = @ls_delrecd-bdgcode AND purchasingdocumentdeletioncode IS INITIAL
          INTO @DATA(ls_porecd).
        IF ls_porecd IS INITIAL.
          ls_delrecd-delemrk = 'X'.
          SELECT * FROM zmm_app09_tb2 WHERE plant = @ls_bdg-plant AND deptid = @ls_bdg-deptid AND uuid = @ls_bdg-uuid
          INTO TABLE @DATA(lt_delrecdl).
          LOOP AT lt_delrecdl ASSIGNING FIELD-SYMBOL(<fs_del>).
            <fs_del>-actstss = ' '.
          ENDLOOP.
          MODIFY zmm_app09_tb1 FROM  @ls_delrecd.
          MODIFY zmm_app09_tb2 FROM TABLE @lt_delrecdl.
        ENDIF.
      ENDLOOP.
    ENDIF.
*    IF delete-bdgitm IS NOT INITIAL.
*      LOOP AT delete-bdgitm INTO DATA(ls_itm).
*        DELETE FROM zmm_app09_tb2 WHERE plant = @ls_itm-Plant AND deptid = @ls_itm-Deptid AND uuid = @ls_itm-Uuid
*        AND bdgcode = @ls_itm-Bdgcode AND itemno = @ls_itm-Itemno.
*      ENDLOOP.
*    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
