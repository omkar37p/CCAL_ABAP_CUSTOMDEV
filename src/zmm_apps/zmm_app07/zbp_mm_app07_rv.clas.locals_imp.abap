CLASS lhc_prhdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR prhdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR prhdr RESULT result.

    METHODS crtpr FOR MODIFY
      IMPORTING keys FOR ACTION prhdr~crtpr RESULT result.

    METHODS getdata1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR prhdr~getdata1.

    METHODS updatepr FOR DETERMINE ON SAVE
      IMPORTING keys FOR prhdr~updatepr.
    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR prhdr RESULT result.

ENDCLASS.

CLASS lhc_prhdr IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
        ENTITY prhdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_hdr)
        ENTITY prhdr BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).
    DATA(ls_hdr) = lt_hdr[ 1 ].
**********************************************************************
    result = VALUE #( FOR ls_key IN keys
  ( %tky =  ls_key-%tky

    %action = VALUE #( crtpr = COND #( WHEN ls_hdr-purreqnum IS INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled ) )

                                   ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD crtpr.
    DATA: lt_hdrupd TYPE TABLE OF zmm_app07_tb1,
          ls_hdrupd TYPE zmm_app07_tb1.
    DATA: lv_lines TYPE i.
**********************************************************************
    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
        ENTITY prhdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        ENTITY prhdr BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    IF lt_item IS NOT INITIAL.
      MODIFY ENTITIES OF i_purchaserequisitiontp PRIVILEGED
      ENTITY purchaserequisition
               CREATE FIELDS ( purchaserequisitiontype )
               WITH VALUE #(  ( %cid                    = 'CID_1'
                                purchaserequisitiontype = ls_header-purreqtyp

                                 ) )
 CREATE BY \_purchaserequisitionitem
        FIELDS (       plant
*                       purchaserequisitionitemtext
*                       AccountAssignmentCategory
                       requestedquantity
                       baseunit
                       material
                       deliverydate
                       purchaserequisitionprice
*                       purreqnitemcurrency
*                       materialgroup
                       purchasinggroup
*                       purchasingorganization
*                     multipleacctassgmtdistribution

                        yy1_budget_code_pri
                        yy1_allotted_budget_pri
                        yy1_allotted_budget_pric
                        yy1_wbselementintid_pri
                        yy1_bdgdesc_pri
                          )
              WITH VALUE #( FOR ls_item IN lt_item
                            (    %cid_ref = 'CID_1'
                                 %target = VALUE #(
                                                  (  %cid                        = 'ItmCID_' && ls_item-purreqitm
                                                     plant                       = ls_item-plant
*                                                     purchaserequisitionitemtext = ''
*                                                     accountassignmentcategory   = 'Q'
                                                     requestedquantity           = ls_item-reqqty
                                                     baseunit                    = ls_item-uom
                                                     material                    = ls_item-material
                                                     deliverydate                = ls_item-delvdate
                                                     purchaserequisitionprice    = ls_item-valprice
*                                                     purreqnitemcurrency         = ls_item-Currency
*                                                     materialgroup               = ls_item-Matgrp
                                                     purchasinggroup             = ls_item-purgrp
*                                                     purchasingorganization      = ls_item-Purorg
*                                                     multipleacctassgmtdistribution = '1'

                                                    yy1_budget_code_pri = ls_item-bdgcode
                                                    yy1_allotted_budget_pri = ls_item-alltbdgamt
                                                    yy1_allotted_budget_pric = ls_item-currency
                                                    yy1_wbselementintid_pri = ls_item-wbselmt
                                                    yy1_bdgdesc_pri = ls_item-bdghtxt
                                                     )
                                                  )
                             )
                           )

            REPORTED DATA(ls_reported)
            MAPPED DATA(ls_mapped)
            FAILED DATA(ls_failed).
**********************************************************************
      IF ls_failed IS INITIAL.
        zbp_mm_app07_rv=>cv_pr_doc-purchaserequisition = ls_mapped-purchaserequisition.
        MOVE-CORRESPONDING ls_header TO ls_hdrupd.
        lv_lines =  lines( lt_item ) .
        ls_hdrupd-totitms = lv_lines.
        DATA itab TYPE TABLE OF zmm_app07_tb2-totvalue WITH EMPTY KEY.
        itab = VALUE #( FOR j IN lt_item ( j-totvalue ) ).
        DATA(sum) = REDUCE zmm_app07_tb2-totvalue( INIT x = 0 FOR wa IN itab NEXT x = x + wa ).
        ls_hdrupd-totnet = sum.
        APPEND ls_hdrupd TO lt_hdrupd.
        zbp_mm_app07_rv=>gt_hdrupd = lt_hdrupd.
      ENDIF.
**********************************************************************
      READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
      ENTITY prhdr
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT FINAL(lt_hdr2).
      result = VALUE #( FOR ls_ord IN lt_hdr2
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).


*    MODIFY ENTITIES OF i_purchaserequisitiontp
*      ENTITY purchaserequisitionitem UPDATE
*      SET FIELDS WITH VALUE #( ( purchaserequisition = '0011136895'
*                               purchaserequisitionitem = '10'
*                               purchaserequisitionitemtext = 'Updated text'
*                               requestedquantity           = '20.00'
*                               baseunit                    = 'EA'
*
*
*                                ) ) .
*

    ENDIF.

  ENDMETHOD.

  METHOD getdata1.
**********************************************************************
    DATA: lt_hdrdata TYPE TABLE OF zmm_app07_tb1,
          ls_hdrdata TYPE zmm_app07_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
        ENTITY prhdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    SELECT SINGLE * FROM i_purchasingdocumenttypetext
    WHERE purchasingdocumenttype = @ls_header-purreqtyp AND language = 'E'
    INTO @DATA(ls_typtxt).

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
    TRY.
        DATA(lv_syuserid) = cl_abap_context_info=>get_user_business_partner_id( ).
      CATCH cx_abap_context_info_error.
        "handle exception
        DATA(lv_s1) = 1.
    ENDTRY.
**********************************************************************
    ls_hdrdata-uuid = ls_header-uuid.
    ls_hdrdata-purreqtyp = ls_header-purreqtyp.
    ls_hdrdata-prtypdesc = ls_typtxt-purchasingdocumenttypename.
    ls_hdrdata-createdat = ls_header-createdat.
    ls_hdrdata-createdby  = ls_header-createdby.
    ls_hdrdata-currency = 'INR'.
    ls_hdrdata-purreqdesc = lv_syuser && ' ' && lv_sydate.
    ls_hdrdata-userid = 'CB' && lv_syuserid.
    APPEND ls_hdrdata TO lt_hdrdata.
    zbp_mm_app07_rv=>gt_hdrdata = lt_hdrdata.

  ENDMETHOD.

  METHOD updatepr.
    DATA: lt_hdrupd TYPE TABLE OF zmm_app07_tb1,
          ls_hdrupd TYPE zmm_app07_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
        ENTITY prhdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        ENTITY prhdr BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).
    DATA(ls_header) = lt_header[ 1 ].
    IF ls_header-purreqnum IS NOT INITIAL AND ls_header-mark <> 'C'.
**********************************************************************
      MODIFY ENTITIES OF i_purchaserequisitiontp PRIVILEGED
            ENTITY purchaserequisitionitem UPDATE
            SET FIELDS WITH VALUE #( FOR ls_item IN lt_item (
                                     purchaserequisition = ls_header-purreqnum
                                     purchaserequisitionitem = ls_item-purreqitm
                                     accountassignmentcategory   = 'Q' ) )
      CREATE BY \_purchasereqnacctassgmt
        FIELDS ( wbselementinternalid )
               WITH VALUE #( FOR ls_item1 IN lt_item
                      ( %key-purchaserequisition = ls_header-purreqnum
                        %key-purchaserequisitionitem = ls_item1-purreqitm
                        %target  = VALUE #( ( %cid                = 'My%acctCID_' && ls_item1-purreqitm
                                              purchaserequisition = ls_header-purreqnum
                                              purchaserequisitionitem = ls_item1-purreqitm
                                              wbselementinternalid = ls_item1-wbselmt ) )
                       )
                      )

          REPORTED DATA(ls_reported)
          FAILED DATA(ls_failed).
      IF ls_failed IS INITIAL.
        MOVE-CORRESPONDING ls_header TO ls_hdrupd.
        ls_hdrupd-mark = 'C'.
        APPEND ls_hdrupd TO lt_hdrupd.
        zbp_mm_app07_rv=>gt_hdrupd2 = lt_hdrupd.
      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD get_global_features.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_pritem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR pritem~calculatetotalprice.

    METHODS getdata2 FOR DETERMINE ON save
      IMPORTING keys FOR pritem~getdata2.

    METHODS totval FOR VALIDATE ON SAVE
      IMPORTING keys FOR pritem~totval.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR pritem RESULT result.
*    METHODS updateitem FOR DETERMINE ON SAVE
*      IMPORTING keys FOR pritem~updateitem.
*    METHODS get_global_features FOR GLOBAL FEATURES
*      IMPORTING REQUEST requested_features FOR pritem RESULT result.

ENDCLASS.

CLASS lhc_pritem IMPLEMENTATION.

  METHOD calculatetotalprice.
**********************************************************************
    DATA: lt_itmupd TYPE TABLE OF zmm_app07_tb2,
          ls_itmupd TYPE zmm_app07_tb2,
          lv_ordamt TYPE zmm_app07_tb2-alltbdgamt.

    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
      ENTITY prhdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_hdr)
        ENTITY pritem
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).
    DATA(ls_hdr) = lt_hdr[ 1 ].
    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      MOVE-CORRESPONDING <fs_items> TO ls_itmupd.
      IF <fs_items>-valprice IS NOT INITIAL.
*        IF ls_hdr-Purreqtyp = 'ZOXI'.
*        SELECT * FROM I_ExchangeRateRawData
*        ELSE.
        ls_itmupd-totvalue = <fs_items>-reqqty * <fs_items>-valprice.
*        ENDIF.
        IF <fs_items>-bdgcode IS NOT INITIAL.
          SELECT SINGLE bdgcode, SUM( inramt ) AS totnetamt FROM zi_purord_data01
          WHERE bdgcode = @<fs_items>-bdgcode
          GROUP BY bdgcode
          INTO @DATA(ls_pototal).
          ls_itmupd-avlbdgamt =  ls_itmupd-alltbdgamt - ls_pototal-totnetamt.
        ENDIF.
        APPEND ls_itmupd TO lt_itmupd.
      ENDIF.
    ENDLOOP.
    zbp_mm_app07_rv=>gt_itmupd = lt_itmupd.

  ENDMETHOD.

  METHOD getdata2.
**********************************************************************
    DATA: lt_itmdata  TYPE TABLE OF zmm_app07_tb2,
          ls_itmdata  TYPE zmm_app07_tb2,
*          lv_material TYPE i_product-product.
          lv_material TYPE n LENGTH 18.

**********************************************************************
    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
        ENTITY prhdr BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).
    DATA(lt_temp) = lt_items[].
    SORT lt_temp BY purreqitm DESCENDING.
    DATA(ls_temp) = lt_temp[ 1 ].
**********************************************************************
    DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).

    LOOP AT lt_items INTO DATA(ls_item) WHERE purreqitm = '00000'.
      SELECT SINGLE plant, plantname, defaultpurchasingorganization AS purorg FROM i_plant
      WHERE plant = @ls_item-plant
      INTO @DATA(ls_plant).
      CONDENSE ls_item-material.
      lv_material = | { ls_item-material ALPHA = IN }|.
      CONDENSE lv_material.
      SELECT SINGLE productgroup,baseunit  FROM i_product with PRIVILEGED ACCESS
      WHERE product = @lv_material
      INTO @DATA(ls_mat1).

      SELECT SINGLE product, productdescription AS prddesc FROM  i_productdescription_2 with PRIVILEGED ACCESS AS desc
*      FIELDS desc~product, desc~productdescription AS prddesc
      WHERE product = @lv_material
      AND language = 'E'
      INTO @DATA(ls_matdesc).

*      SELECT SINGLE product, PurchasingGroup  FROM   I_ProductPlantBasic
*       WHERE Product = @lv_material AND Plant = @ls_item-Plant
*      INTO @DATA(ls_matpurc).

      SELECT SINGLE       product,
      valuationarea,
      currency,
      standardprice,
      priceunitqty,
      inventoryvaluationprocedure AS valproc,
      movingaverageprice
      FROM i_productvaluationbasic WITH PRIVILEGED ACCESS
      WHERE product = @lv_material AND valuationarea = @ls_item-plant
      INTO @DATA(ls_matprice).
      IF sy-subrc = 0.
        TRY.
            DATA(lv_syuserid) = cl_abap_context_info=>get_user_business_partner_id( ).
          CATCH cx_abap_context_info_error.
            "handle exception
            DATA(lv_s) = 1.
        ENDTRY.

        ls_itmdata-uuid = ls_item-uuid.
        ls_itmdata-userid = 'CB' && lv_syuserid .
        ls_itmdata-purreqitm = ls_temp-purreqitm + 10.
        ls_itmdata-reqqty  = ls_item-reqqty.
        ls_itmdata-itemcreatedat = ls_item-itemcreatedat.
        ls_itmdata-itemcreatedby = ls_item-itemcreatedby.
        ls_itmdata-itemlastchangedat = ls_item-itemlastchangedat.
        ls_itmdata-itemlastchangedby = ls_item-itemlastchangedby.
        ls_itmdata-material = ls_item-material.
        ls_itmdata-plant = ls_item-plant.
        ls_itmdata-plantdesc = ls_plant-plantname.
        ls_itmdata-purorg = ls_plant-purorg.
**********************************************************************
        " Budget Validation   "
**********************************************************************
        IF ls_item-bdgcode IS NOT INITIAL.
          ls_itmdata-bdgcode = ls_item-bdgcode.
          SELECT SINGLE bdgcode, SUM( allcbdg ) AS allcbdg FROM zmm_app09_tb2 WITH PRIVILEGED ACCESS
          WHERE bdgcode = @ls_item-bdgcode AND actstss = 'X'
          GROUP BY bdgcode
          INTO @DATA(ls_bdgdata).
          ls_itmdata-alltbdgamt = ls_bdgdata-allcbdg.
          SELECT SINGLE bdgcode,  SUM( inramt ) AS totnetamt FROM zi_purord_data01 WITH PRIVILEGED ACCESS
          WHERE bdgcode = @ls_item-bdgcode
          GROUP BY  bdgcode
          INTO @DATA(ls_pototal).
          SELECT SINGLE bdgcode, bdghtxt,  wbselmt FROM zmm_app09_tb1 WITH PRIVILEGED ACCESS
          WHERE bdgcode = @ls_item-bdgcode
          INTO @DATA(ls_bdgwbs).
**********************************************************************
          ls_itmdata-avlbdgamt =  ls_itmdata-alltbdgamt - ls_pototal-totnetamt.
          ls_itmdata-matgrp = ls_mat1-productgroup.
          ls_itmdata-uom   = ls_mat1-baseunit.
          ls_itmdata-matdesc = ls_matdesc-prddesc.
          ls_itmdata-purgrp = ls_item-purgrp. "ls_matpurc-PurchasingGroup.
          SELECT SINGLE purchasinggroup, purchasinggroupname FROM i_purchasinggroup WITH PRIVILEGED ACCESS
           WHERE purchasinggroup = @ls_item-purgrp
          INTO @DATA(ls_ekgrp).
          ls_itmdata-purgrpdesc = ls_ekgrp-purchasinggroupname.
          CASE ls_matprice-valproc.
            WHEN 'V'.
              ls_itmdata-valprice = ls_matprice-movingaverageprice.
            WHEN 'S'.
              ls_itmdata-valprice = ls_matprice-standardprice.
          ENDCASE.
          ls_itmdata-currency = ls_itmdata-currency.
          ls_itmdata-delvdate = ls_item-Delvdate.   "old one
*          ls_itmdata-delvdate =  ls_item-Delvdate.         " new one
          ls_itmdata-totvalue = ls_itmdata-valprice * ls_itmdata-reqqty.
          ls_itmdata-wbselmt = ls_bdgwbs-wbselmt.
          ls_itmdata-bdghtxt = ls_bdgwbs-bdghtxt.
          APPEND ls_itmdata TO lt_itmdata.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_itmdata IS NOT INITIAL.
      zbp_mm_app07_rv=>gt_itmdata = lt_itmdata.
    ENDIF.

  ENDMETHOD.

  METHOD totval.
    DATA : lv_totval TYPE zmm_app07_tb2-totvalue.
**********************************************************************
    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
        ENTITY prhdr BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).
***********************************************************************
        get TIME STAMP FIELD DATA(ts).
        CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
***********************************************************************
    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      lv_totval = <fs_items>-reqqty * <fs_items>-valprice.
**********************************************************************
      " **** Budget Validation   **** "
**********************************************************************
      IF <fs_items>-bdgcode IS INITIAL.
        APPEND VALUE #( %tky = <fs_items>-%tky ) TO failed-pritem.
        APPEND VALUE #( %tky = <fs_items>-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Budget Code not selected' )
                       ) TO reported-pritem.
      ENDIF.
      IF <fs_items>-avlbdgamt IS NOT INITIAL.
        IF lv_totval > <fs_items>-avlbdgamt.
          APPEND VALUE #( %tky = <fs_items>-%tky ) TO failed-pritem.
          APPEND VALUE #( %tky = <fs_items>-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Total Item Value exceeding available Budget' )
                         ) TO reported-pritem.
        ENDIF.
      ENDIF.
**********************************************************************
      " **** Delivery Date Validation   **** "
**********************************************************************
       if <fs_items>-Delvdate is NOT INITIAL.
       if <fs_items>-Delvdate < lv_date .
          data(lv_msge) = |Past Delivery Date Not Allowed-{ <fs_items>-Delvdate }|.
          APPEND VALUE #( %tky = <fs_items>-%tky ) TO failed-pritem.
          APPEND VALUE #( %tky = <fs_items>-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = lv_msge )
                         ) TO reported-pritem.

       endif.
       endif.
    ENDLOOP.
  ENDMETHOD.

*  METHOD get_global_features.
***********************************************************************
**    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
**        ENTITY prhdr
**        ALL FIELDS WITH CORRESPONDING #(  )
**        RESULT FINAL(lt_hdr).
**    DATA(ls_hdr) = lt_hdr[ 1 ].
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
*
*
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD get_instance_features.
**********************************************************************
    READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
        ENTITY prhdr
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_hdr).
    DATA(ls_hdr) = lt_hdr[ 1 ].
    result = VALUE #( FOR ls_key IN keys
  ( %tky =  ls_key-%tky

*    %delete = COND #( WHEN ls_hdr-Purreqnum IS INITIAL
*                                   THEN if_abap_behv=>fc-o-enabled
*                                   ELSE if_abap_behv=>fc-o-disabled )
    %update = COND #( WHEN ls_hdr-purreqnum IS INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                                   ) ).

  ENDMETHOD.

*  METHOD updateitem.
***********************************************************************
*    data: gt_upitem type TABLE of zmm_app07_tb2,
*          gs_upitem TYPE zmm_app07_tb2.
***********************************************************************
*         READ ENTITIES OF zmm_app07_rv IN LOCAL MODE
*         ENTITY prhdr
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(gt_hd)
*         ENTITY prhdr by \_Item
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(gt_item).
*
***********************************************************************
*        LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<gs_item>).
*        if <gs_item> is ASSIGNED.
*
*            MOVE-CORRESPONDING <gs_item> to gs_upitem.
*
*            APPEND gs_upitem to gt_upitem.
*        endif.
*        ENDLOOP.
*
*         if gt_upitem is not INITIAL.
*            zbp_mm_app07_rv=>gt_itmupd = gt_upitem.
*         endif.
*
*
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app07_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app07_rv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-prhdr IS NOT INITIAL.
      IF zbp_mm_app07_rv=>gt_hdrdata IS NOT INITIAL.
        DATA(lt_hrdata) = zbp_mm_app07_rv=>gt_hdrdata.
        MODIFY zmm_app07_tb1 FROM TABLE @lt_hrdata.
      ENDIF.
    ENDIF.
**********************************************************************
*    IF update-pritem IS NOT INITIAL.
    IF zbp_mm_app07_rv=>gt_itmdata IS NOT INITIAL.
      DATA(lt_itmdata) = zbp_mm_app07_rv=>gt_itmdata.
      MODIFY zmm_app07_tb2 FROM TABLE @lt_itmdata.
    ENDIF.
*    ENDIF.
***********************************************************************
*    IF zbp_mm_app07_rv=>gt_itmupd IS NOT INITIAL.
*      DATA(lt_itmupd) = zbp_mm_app07_rv=>gt_itmupd.
*      MODIFY zmm_app07_tb2 FROM TABLE @lt_itmupd.
*    ENDIF.
***********************************************************************
    IF zbp_mm_app07_rv=>cv_pr_doc IS NOT INITIAL .
      LOOP AT zbp_mm_app07_rv=>cv_pr_doc-purchaserequisition ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
        CONVERT KEY OF i_purchaserequisitiontp FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
        <fs_pr_mapped>-purchaserequisition = ls_pr_key-purchaserequisition.
      ENDLOOP.
      IF zbp_mm_app07_rv=>gt_hdrupd IS NOT INITIAL.
        DATA(lt_hdrupd) = zbp_mm_app07_rv=>gt_hdrupd.
        LOOP AT lt_hdrupd ASSIGNING FIELD-SYMBOL(<fs_upd>).
          <fs_upd>-purreqnum = ls_pr_key-purchaserequisition.
          <fs_upd>-mark = 'X'.
        ENDLOOP.
        MODIFY zmm_app07_tb1 FROM TABLE @lt_hdrupd.
      ENDIF.
    ENDIF.
**********************************************************************
    IF zbp_mm_app07_rv=>gt_hdrupd2 IS NOT INITIAL.
      DATA(lt_hdrupd2) = zbp_mm_app07_rv=>gt_hdrupd2.
      MODIFY zmm_app07_tb1 FROM TABLE @lt_hdrupd2.
    ENDIF.

*************** Delete Root & Child entity records *******************
    IF delete-prhdr IS NOT INITIAL.

      LOOP AT delete-prhdr INTO DATA(ls_hdr).
        SELECT SINGLE * FROM zmm_app07_tb1 WHERE uuid = @ls_hdr-uuid INTO @DATA(ls_tbdata1)  .
        IF ls_tbdata1-purreqnum IS INITIAL.
          DELETE FROM zmm_app07_tb2 WHERE uuid = @ls_hdr-uuid.
          DELETE FROM zmm_app07_tb1 WHERE uuid = @ls_hdr-uuid.
        ELSE.
          TRY.
              DATA(lv_syuser) = cl_abap_context_info=>get_user_business_partner_id( ).
            CATCH cx_abap_context_info_error.
              "handle exception
              DATA(lv_s) = 1.
          ENDTRY.
          IF lv_syuser = '9980000000' OR lv_syuser = '9980000045' OR lv_syuser = '9980000019'.
            SELECT SINGLE purchaserequisition FROM i_purchaserequisitionitemapi01 WITH PRIVILEGED ACCESS
            WHERE purchaserequisition = @ls_tbdata1-purreqnum AND isclosed NE 'X' INTO @DATA(ls_check).
            IF sy-subrc NE 0.
              SELECT * FROM zmm_app07_tb2 WHERE uuid = @ls_hdr-uuid INTO TABLE @DATA(lt_tb2data).
              LOOP AT lt_tb2data ASSIGNING FIELD-SYMBOL(<fs_tab2>).
                <fs_tab2>-delmark = 'X'.
              ENDLOOP.
              ls_tbdata1-delmark = 'X'.
              MODIFY zmm_app07_tb2 FROM TABLE @lt_tb2data.
              MODIFY zmm_app07_tb1 FROM  @ls_tbdata1.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF delete-pritem IS NOT INITIAL.
      LOOP AT delete-pritem INTO DATA(ls_itm).
        SELECT SINGLE uuid, purreqnum FROM zmm_app07_tb1 WHERE uuid = @ls_itm-uuid INTO @DATA(ls_tbdata2)  .
        IF ls_tbdata2-purreqnum IS INITIAL.
          DELETE FROM zmm_app07_tb2 WHERE uuid = @ls_itm-uuid AND purreqitm = @ls_itm-purreqitm.
        ELSE.
          TRY.
              DATA(lv_syuser1) = cl_abap_context_info=>get_user_business_partner_id( ).
            CATCH cx_abap_context_info_error.
              "handle exception
              DATA(lv_s1) = 1.
          ENDTRY.
          IF lv_syuser1 = '9980000000' OR lv_syuser1 = '9980000045' OR lv_syuser1 = '9980000019'.
            SELECT SINGLE purchaserequisition FROM i_purchaserequisitionitemapi01 WITH PRIVILEGED ACCESS
            WHERE purchaserequisition = @ls_tbdata1-purreqnum
            AND purchaserequisitionitem = @ls_itm-purreqitm
            AND isclosed = 'X' INTO @DATA(ls_check2).
            IF sy-subrc EQ 0.
              SELECT SINGLE * FROM zmm_app07_tb2 WHERE uuid = @ls_hdr-uuid AND purreqitm = @ls_itm-purreqitm INTO @DATA(ls_tb2data).
              ls_tb2data-delmark = 'X'.
              MODIFY zmm_app07_tb2 FROM @ls_tb2data.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
**********************************************************************

        if zbp_mm_app07_rv=>gt_itmupd is not INITIAL.
            MODIFY ZMM_APP07_TB2 FROM TABLE @zbp_mm_app07_rv=>gt_itmupd.
        endif.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
