CLASS lhc_ZMM_APP03_RV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zmm_app03_rv RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_app03_rv RESULT result.

    METHODS CrtPO FOR MODIFY
      IMPORTING keys FOR ACTION zmm_app03_rv~CrtPO RESULT result.

    METHODS GetData1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR zmm_app03_rv~GetData1.

ENDCLASS.

CLASS lhc_ZMM_APP03_RV IMPLEMENTATION.

  METHOD get_instance_features.
    DATA: lv_lines TYPE i.

**********************************************************************
    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
        ENTITY zmm_app03_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_status)
        ENTITY zmm_app03_rv BY \_Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).
    lv_lines =  lines( lt_item ) .
    result = VALUE #( FOR ls_data IN lt_status
      ( %tky =  ls_data-%tky
**        %features-%action-Edit = COND #( WHEN ls_data-status EQ 'X'
**                                            THEN if_abap_behv=>fc-o-disabled
**                                            ELSE if_abap_behv=>fc-o-enabled
*         )

    %action = VALUE #( CrtPO = COND #( WHEN ls_data-Mark EQ 'X' OR  lv_lines < 1
                                        THEN if_abap_behv=>fc-o-disabled
                                        ELSE if_abap_behv=>fc-o-enabled
     ) ) ) ).

*        %features-%update = COND #( WHEN ls_data-status EQ 'X'
*                                            THEN if_abap_behv=>fc-o-disabled
*                                            ELSE if_abap_behv=>fc-o-enabled
*         )

*          ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CrtPO.
    DATA: lt_hdrupd  TYPE TABLE OF zmm_app03_tb1,
          ls_hdrupd  TYPE zmm_app03_tb1,
          lt_itemupd TYPE TABLE OF zmm_app03_tb2,
          ls_itemupd TYPE zmm_app03_tb2,
          lt_bdgupd  TYPE TABLE OF zmm_app01_tb2,
          ls_bdgupd  TYPE zmm_app01_tb2.
    DATA: lv_lines   TYPE i,
          lv_netbal1 TYPE  zmm_app03_tb2-netvalue,
          lv_netbal2 TYPE  zmm_app03_tb2-netvalue.
    TYPES: BEGIN OF ty_grp1,
             plant     TYPE werks_d,
             matkl     TYPE matkl,
             extmatgrp TYPE zmm_app03_tb2-extmatgrp,
             netvalue  TYPE  zmm_app03_tb2-netvalue,
           END OF ty_grp1.
    DATA : lt_grptot TYPE STANDARD TABLE OF ty_grp1.
**********************************************************************
    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
        ENTITY zmm_app03_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        ENTITY zmm_app03_rv BY \_Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    IF lt_item IS NOT INITIAL.
      LOOP AT lt_item INTO DATA(ls_itemt).
        SELECT SINGLE plant,prodgrp,exprdgrp,
        SUM( allcibdg ) AS totallcbdg,
        SUM( balcibdg ) AS totbalbdg
        FROM zmm_app01_tb2
        WHERE plant  = @ls_itemt-Werks AND prodgrp = @ls_itemt-Matkl
        AND exprdgrp = @ls_itemt-Extmatgrp
        GROUP BY plant, prodgrp, exprdgrp
        INTO @DATA(ls_budget).
        IF ls_itemt-Netvalue > ls_budget-totbalbdg .
          DATA(lv_error) = 'X'.
          APPEND VALUE #( %tky = ls_header-%tky
                  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                text = 'Budget Changed ' )
                 ) TO reported-zmm_app03_rv.

        ENDIF.
      ENDLOOP.
**********************************************************************
      IF lv_error NE 'X'..
        MODIFY ENTITIES OF I_PurchaseOrderTP_2 PRIVILEGED
          ENTITY purchaseorder
           CREATE FIELDS ( purchaseordertype
                           companycode
                           purchasingorganization
                           purchasinggroup
                           supplier
                         )
           WITH VALUE #( ( %cid                   = 'CID_1'
                           purchaseordertype      = ls_header-Bsart
                           companycode            = '1000'
                           purchasingorganization = ls_header-Ekorg
                           purchasinggroup        = ls_header-Ekgrp
                           supplier               = ls_header-Lifnr
                       ) )
          CREATE BY \_purchaseorderitem
          FIELDS ( PurchaseOrderItem
                   PurchaseRequisition
                   PurchaseRequisitionItem
                   OrderQuantity
                   NetPriceAmount    )
                   WITH VALUE #( FOR ls_item IN lt_item
                              (    %cid_ref = 'CID_1'
                                   %target = VALUE #(
           (  %cid     = 'ItmCID_' && ls_item-Ebelp
                   PurchaseOrderItem = ls_item-Ebelp
                   PurchaseRequisition = ls_item-Banfn
                   PurchaseRequisitionItem  = ls_item-Bnfpo
                   OrderQuantity = ls_item-Menge
                   NetPriceAmount = ls_item-Netprice
                   )    )     )  )
                           REPORTED DATA(ls_po_reported)
          FAILED   DATA(ls_po_failed)
          MAPPED   DATA(ls_po_mapped).
**********************************************************************
        IF ls_po_failed IS INITIAL.
          zbp_mm_app03_rv=>cv_po_doc-purchaseorder = ls_po_mapped-purchaseorder.
          MOVE-CORRESPONDING ls_header TO ls_hdrupd.
          APPEND ls_hdrupd TO lt_hdrupd.
          zbp_mm_app03_rv=>gt_hdrupd = lt_hdrupd.
          lt_itemupd = VALUE #( FOR wa IN lt_item ( CORRESPONDING #( wa ) ) ).
          zbp_mm_app03_rv=>gt_itmupd = lt_itemupd.
**********************************************************************
          TRY.
              DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
            CATCH cx_abap_context_info_error.
              DATA(ls_v) = 1.
          ENDTRY.

          SELECT FROM zmm_app01_tb2 AS h INNER JOIN @lt_item AS i
          ON h~plant = i~Werks AND h~prodgrp = i~Matkl AND h~exprdgrp = i~Extmatgrp
          FIELDS h~*
*          h~plant,h~prodgrp,h~bdgcode,h~exprdgrp,h~utlzibdg,h~balcibdg
          WHERE h~validon <= @lv_sydate AND h~validto >= @lv_sydate
          INTO TABLE @DATA(lt_bdgrecd).
          SORT lt_bdgrecd BY balcibdg ASCENDING.
          DATA(lt_items_t1) = lt_item[].
          lt_grptot = VALUE #( FOR ls IN lt_item ( plant = ls-Werks
                                                   matkl = ls-Matkl
                                                   extmatgrp = ls-Extmatgrp
                                                   netvalue = ls-Netvalue  ) ).
          SELECT plant, matkl, extmatgrp, SUM( netvalue ) AS totnet
          FROM @lt_grptot AS i
          GROUP BY i~plant, i~matkl, i~extmatgrp
          INTO TABLE @DATA(lt_totnet).

          LOOP AT lt_totnet INTO DATA(ls_totnet).
            LOOP AT lt_bdgrecd INTO DATA(ls_bdgrecd) WHERE plant = ls_totnet-plant
                                                       AND prodgrp = ls_totnet-matkl
                                                       AND exprdgrp = ls_totnet-extmatgrp.
              MOVE-CORRESPONDING ls_bdgrecd TO ls_bdgupd.
              IF lv_netbal1 IS INITIAL.
                lv_netbal1 = ls_totnet-totnet.
              ENDIF.

              IF ls_bdgupd-balcibdg < lv_netbal1.
                lv_netbal1 = ls_totnet-totnet - ls_bdgupd-balcibdg .
                ls_bdgupd-utlzibdg += ls_bdgupd-balcibdg.
                ls_bdgupd-balcibdg = '0.00'.
                APPEND ls_bdgupd TO lt_bdgupd.
              ELSEIF ls_bdgupd-balcibdg > lv_netbal1.
                ls_bdgupd-balcibdg -= lv_netbal1.
                ls_bdgupd-utlzibdg += lv_netbal1.
                APPEND ls_bdgupd TO lt_bdgupd.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDLOOP.
          zbp_mm_app03_rv=>gt_bdgupd = lt_bdgupd.
        ENDIF.
**********************************************************************
        READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
        ENTITY zmm_app03_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_hdr2).
        result = VALUE #( FOR ls_ord IN lt_hdr2
                       ( %tky   = ls_ord-%tky
                         %param = ls_ord ) ).

      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD GetData1.
**********************************************************************
    DATA: lt_hdrdata TYPE TABLE OF zmm_app03_tb1,
          ls_hdrdata TYPE zmm_app03_tb1,
          lt_itmdata TYPE TABLE OF zmm_app03_tb2,
          ls_itmdata TYPE zmm_app03_tb2,
          lv_line    TYPE zmm_app03_tb2-ebelp VALUE 10.

**********************************************************************
    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
        ENTITY zmm_app03_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    SELECT SINGLE * FROM I_PurchasingDocumentTypeText
    WHERE PurchasingDocumentType = @ls_header-Bsart AND Language = 'E'
    INTO @DATA(ls_typtxt).
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
*    TRY.
*        DATA(lv_syuserid) = cl_abap_context_info=>get_user_business_partner_id( ).
*      CATCH cx_abap_context_info_error.
*        "handle exception
*        DATA(lv_ss) = 1.
*    ENDTRY.
*    SELECT SINGLE * FROM zmm_app01_rpv1
*    WHERE Bupartner = @lv_syuserid INTO @DATA(ls_userid).
**********************************************************************
    ls_hdrdata-uuid = ls_header-Uuid.
    ls_hdrdata-banfn = ls_header-Banfn.
    ls_hdrdata-bedat = lv_sydate.
    ls_hdrdata-bsart = ls_header-Bsart.
*ls_hdrdata-bukrs =
    ls_hdrdata-doctypdesc = ls_typtxt-PurchasingDocumentTypeName.
    ls_hdrdata-ekgrp = ls_header-Ekgrp.
    ls_hdrdata-ekorg = '1000'.
    ls_hdrdata-lifnr = ls_header-Lifnr.
    ls_hdrdata-suppname = ls_header-Suppname.
    ls_hdrdata-waers = 'INR'.
    APPEND ls_hdrdata TO lt_hdrdata.

**********************************************************************
    IF ls_header-Banfn IS NOT INITIAL.
      READ ENTITIES OF i_purchaserequisitiontp PRIVILEGED
         ENTITY PurchaseRequisitionItem
         FROM VALUE #( ( purchaserequisition = ls_header-Banfn  ) )
         RESULT DATA(lt_pr_details).
      IF lt_pr_details IS NOT INITIAL.
        LOOP AT lt_pr_details INTO DATA(ls_prdetail).
**********************************************************************

*          SELECT SINGLE plant,prodgrp,exprdgrp,
*          SUM( allcibdg ) AS totallcbdg,
*          SUM( balcibdg ) AS totbalbdg
*          FROM zmm_app01_tb2
*          WHERE plant  = @ls_prdetail-Plant AND prodgrp = @ls_prdetail-MaterialGroup
*          AND exprdgrp = @ls_userid-Exprdgrp
*          GROUP BY plant, prodgrp, exprdgrp
*          INTO @DATA(ls_budget).
*          IF ls_budget IS NOT INITIAL.
          ls_itmdata-uuid = ls_header-Uuid.
          ls_itmdata-ebelp = lv_line.
          ls_itmdata-banfn = ls_prdetail-PurchaseRequisition.
          ls_itmdata-bnfpo = ls_prdetail-PurchaseRequisitionItem.
          ls_itmdata-werks = ls_prdetail-Plant.
          ls_itmdata-matnr = ls_prdetail-Material.
          ls_itmdata-matkl = ls_prdetail-MaterialGroup.
*          ls_itmdata-bprme = ls_prdetail-PurchaseRequisitionPrice.
*            ls_itmdata-extmatgrp = ls_userid-Exprdgrp.
          ls_itmdata-ktmng = ls_prdetail-RequestedQuantity.
          ls_itmdata-meins = ls_prdetail-baseUnit.
*            ls_itmdata-netvalue = ls_prdetail-PurchaseRequisitionPrice * ls_prdetail-RequestedQuantity.
*          ls_itmdata-netprice = ls_prdetail-PurchaseRequisitionPrice.
          ls_itmdata-peinh = 'INR'.
*            ls_itmdata-alltbdgamt = ls_budget-totallcbdg.
*            ls_itmdata-avlbdgamt = ls_budget-totbalbdg.
*        ls_itmdata-
          APPEND ls_itmdata TO lt_itmdata.
          lv_line += 10.
*          ELSE.
*            APPEND VALUE #( %tky = ls_header-%tky
*                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                          text = 'No Budget record available ' )
*                           ) TO reported-zmm_app03_rv.
*         ENDIF.


        ENDLOOP.
        zbp_mm_app03_rv=>gt_hdrdata = lt_hdrdata.
        zbp_mm_app03_rv=>gt_itmdata = lt_itmdata.
      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZMM_APP03_IV1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_app03_iv1~CalculateTotalPrice.

    METHODS GetData2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_app03_iv1~GetData2.

    METHODS Totval FOR VALIDATE ON SAVE
      IMPORTING keys FOR zmm_app03_iv1~Totval.

ENDCLASS.

CLASS lhc_ZMM_APP03_IV1 IMPLEMENTATION.

  METHOD CalculateTotalPrice.
**********************************************************************
    DATA: lt_itmupd TYPE TABLE OF zmm_app03_tb2,
          ls_itmupd TYPE zmm_app03_tb2.

    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
        ENTITY zmm_app03_iv1
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      MOVE-CORRESPONDING <fs_items> TO ls_itmupd.
      IF <fs_items>-Menge IS NOT INITIAL.
        ls_itmupd-netvalue = <fs_items>-Menge * <fs_items>-Netprice.
        IF <fs_items>-Extmatgrp IS NOT INITIAL.
          SELECT SINGLE plant,prodgrp,exprdgrp,
            SUM( allcibdg ) AS totallcbdg,
            SUM( balcibdg ) AS totbalbdg
            FROM zmm_app01_tb2
            WHERE plant  = @<fs_items>-Werks AND prodgrp = @<fs_items>-Matkl
            AND exprdgrp = @<fs_items>-Extmatgrp
            GROUP BY plant, prodgrp, exprdgrp
            INTO @DATA(ls_budget).
          ls_itmupd-alltbdgamt = ls_budget-totallcbdg.
          ls_itmupd-avlbdgamt =  ls_budget-totbalbdg.
        ENDIF.
        APPEND ls_itmupd TO lt_itmupd.
      ENDIF.
    ENDLOOP.
    zbp_mm_app03_rv=>gt_itmupd = lt_itmupd.

  ENDMETHOD.

  METHOD GetData2.
    DATA: lt_itmdata TYPE TABLE OF zmm_app03_tb2,
          ls_itmdata TYPE zmm_app03_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
        ENTITY zmm_app03_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].



  ENDMETHOD.

  METHOD Totval.
    DATA : lv_totval TYPE zmm_app03_tb2-netvalue.
**********************************************************************
    READ ENTITIES OF zmm_app03_rv IN LOCAL MODE
        ENTITY zmm_app03_iv1
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).
    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      IF <fs_items>-menge > <fs_items>-Ktmng.
        APPEND VALUE #( %tky = <fs_items>-%tky ) TO failed-zmm_app03_iv1.
        APPEND VALUE #( %tky = <fs_items>-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'PO Quantity greater than PR Quantity' )
                       ) TO reported-zmm_app03_iv1.
      ELSE.

        lv_totval = <fs_items>-menge * <fs_items>-netprice.
        IF lv_totval > <fs_items>-Avlbdgamt.
          APPEND VALUE #( %tky = <fs_items>-%tky ) TO failed-zmm_app03_iv1.
          APPEND VALUE #( %tky = <fs_items>-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Total Item Value exceeding available Budget' )
                         ) TO reported-zmm_app03_iv1.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_APP03_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_APP03_RV IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-zmm_app03_rv IS NOT INITIAL.
      IF zbp_mm_app03_rv=>gt_hdrdata IS NOT INITIAL.
        DATA(lt_hrdata) = zbp_mm_app03_rv=>gt_hdrdata.
        MODIFY zmm_app03_tb1 FROM TABLE @lt_hrdata.
      ENDIF.
      IF zbp_mm_app03_rv=>gt_itmdata IS NOT INITIAL.
        DATA(lt_itmdata) = zbp_mm_app03_rv=>gt_itmdata.
        MODIFY zmm_app03_tb2 FROM TABLE @lt_itmdata.
      ENDIF.

*      DELETE FROM zmm_app03_tb2 WHERE uuid =  '53DCA3715C741EDFA7CF4CF272F8D498'.
*      DELETE FROM zmm_app03_tb1 WHERE uuid =  '53DCA3715C741EDFA7CF4CF272F8D498'.
    ENDIF.
**********************************************************************
    IF zbp_mm_app03_rv=>gt_itmupd IS NOT INITIAL.
      DATA(lt_itmupd) = zbp_mm_app03_rv=>gt_itmupd.
      MODIFY zmm_app03_tb2 FROM TABLE @lt_itmupd.
    ENDIF.
**********************************************************************
    IF zbp_mm_app03_rv=>cv_po_doc IS NOT INITIAL .
      LOOP AT zbp_mm_app03_rv=>cv_po_doc-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_po_mapped>).
        CONVERT KEY OF I_PurchaseOrderTP_2 FROM <fs_po_mapped>-%pid TO DATA(ls_po_key).
        <fs_po_mapped>-PurchaseOrder = ls_po_key-PurchaseOrder.
      ENDLOOP.
      IF zbp_mm_app03_rv=>gt_hdrupd IS NOT INITIAL.
        DATA(lt_hdrupd) = zbp_mm_app03_rv=>gt_hdrupd.
        LOOP AT lt_hdrupd ASSIGNING FIELD-SYMBOL(<fs_upd>).
          <fs_upd>-ebeln = ls_po_key-PurchaseOrder.
          <fs_upd>-mark = 'X'.
        ENDLOOP.
        MODIFY zmm_app03_tb1 FROM TABLE @lt_hdrupd.
        IF zbp_mm_app03_rv=>gt_itmupd IS NOT INITIAL.
          DATA(lt_itemupd) = zbp_mm_app03_rv=>gt_itmupd.
          LOOP AT lt_itemupd ASSIGNING FIELD-SYMBOL(<fs_iupd>).
            <fs_iupd>-ebeln = ls_po_key-PurchaseOrder.
          ENDLOOP.
          MODIFY zmm_app03_tb2 FROM TABLE @lt_itemupd.
        ENDIF.

      ENDIF.
      IF zbp_mm_app03_rv=>gt_bdgupd IS NOT INITIAL.
        DATA(lt_bdgupd) = zbp_mm_app03_rv=>gt_bdgupd.
        MODIFY zmm_app01_tb2 FROM TABLE @lt_bdgupd.
      ENDIF.
    ENDIF.

*************** Delete Root & Child entity records *******************
    IF delete-zmm_app03_rv IS NOT INITIAL.
      LOOP AT delete-zmm_app03_rv INTO DATA(ls_hdr).
        DELETE FROM zmm_app03_tb1 WHERE uuid = @ls_hdr-Uuid.
      ENDLOOP.
    ENDIF.

    IF delete-zmm_app03_iv1 IS NOT INITIAL.
      LOOP AT delete-zmm_app03_iv1 INTO DATA(ls_itm).
        DELETE FROM zmm_app03_tb2 WHERE uuid =  @ls_hdr-Uuid
                AND ebelp = @ls_itm-Ebelp.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
