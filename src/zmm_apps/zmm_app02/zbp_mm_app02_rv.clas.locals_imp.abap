CLASS lhc_zmm_app02_iv1 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS GetData2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_app02_iv1~GetData2.

    METHODS CalculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_app02_iv1~CalculateTotalPrice.
    METHODS Totval FOR VALIDATE ON SAVE
      IMPORTING keys FOR zmm_app02_iv1~Totval.

ENDCLASS.

CLASS lhc_zmm_app02_iv1 IMPLEMENTATION.

  METHOD GetData2.
**********************************************************************
    DATA: lt_itmdata  TYPE TABLE OF zmm_app02_tb2,
          ls_itmdata  TYPE zmm_app02_tb2,
          lv_material TYPE i_product-Product.
**********************************************************************
    READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
        ENTITY zmm_app02_rv BY \_Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).

**********************************************************************
    DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
    LOOP AT lt_items INTO DATA(ls_item).
      SELECT SINGLE plant, plantname, DefaultPurchasingOrganization AS purorg FROM I_Plant
      WHERE plant = @ls_item-Plant
      INTO @DATA(ls_plant).
      CONDENSE ls_item-Material.
      lv_material = | { ls_item-Material ALPHA = IN }|.
      CONDENSE lv_material.
      SELECT SINGLE  FROM i_product AS i
      FIELDS i~Product,i~ProductGroup, i~BaseUnit, i~ExternalProductGroup
      WHERE i~product = @lv_material
      INTO @DATA(ls_mat1).

      SELECT SINGLE  FROM  I_ProductDescription_2 AS desc
      FIELDS desc~Product, desc~ProductDescription AS prddesc
      WHERE desc~Product = @lv_material AND desc~Language = 'E'
      INTO @DATA(ls_matdesc).

      SELECT SINGLE product, PurchasingGroup  FROM   I_ProductPlantBasic
       WHERE Product = @lv_material AND Plant = @ls_item-Plant
      INTO @DATA(ls_matpurc).

      SELECT SINGLE       product,
      ValuationArea,
      Currency,
      StandardPrice,
      PriceUnitQty,
      InventoryValuationProcedure AS valproc,
      MovingAveragePrice
      FROM I_ProductValuationBasic
      WHERE Product = @lv_material AND ValuationArea = @ls_item-Plant
      INTO @DATA(ls_matprice).
      IF sy-subrc = 0.

        SELECT SINGLE plant,prodgrp,exprdgrp,
        SUM( allcibdg ) AS totallcbdg,
        SUM( balcibdg ) AS totbalbdg
        FROM zmm_app01_tb2
        WHERE plant  = @ls_item-Plant AND prodgrp = @ls_mat1-ProductGroup
        AND exprdgrp = @ls_mat1-ExternalProductGroup
        GROUP BY plant, prodgrp, exprdgrp
        INTO @DATA(ls_budget).

        ls_itmdata-uuid = ls_item-Uuid.
        ls_itmdata-purreqitm = '10'.  "ls_item-Purreqitm.
        ls_itmdata-reqqty  = ls_item-Reqqty.
        ls_itmdata-itemcreatedat = ls_item-ItemCreatedAt.
        ls_itmdata-itemcreatedby = ls_item-ItemCreatedBy.
        ls_itmdata-itemlastchangedat = ls_item-ItemLastChangedAt.
        ls_itmdata-itemlastchangedby = ls_item-ItemLastChangedBy.
        ls_itmdata-material = ls_item-Material.
        ls_itmdata-plant = ls_item-Plant.
        ls_itmdata-plantdesc = ls_plant-PlantName.
        ls_itmdata-purorg = ls_plant-purorg.
        ls_itmdata-extmatgrp = ls_item-Extmatgrp.
        ls_itmdata-matgrp = ls_mat1-ProductGroup.
        ls_itmdata-uom   = ls_mat1-BaseUnit.
        ls_itmdata-matdesc = ls_matdesc-prddesc.
        ls_itmdata-purgrp = ls_matpurc-PurchasingGroup.
*          ls_itmdata-purgrpdesc
        CASE ls_matprice-valproc.
          WHEN 'V'.
            ls_itmdata-valprice = ls_matprice-MovingAveragePrice.
          WHEN 'S'.
            ls_itmdata-valprice = ls_matprice-StandardPrice.
        ENDCASE.
        ls_itmdata-currency = ls_matprice-Currency.
        ls_itmdata-alltbdgamt = ls_budget-totallcbdg.
        ls_itmdata-avlbdgamt = ls_budget-totbalbdg.
        ls_itmdata-delvdate = lv_sydate + 10.
        ls_itmdata-totvalue = ls_itmdata-valprice * ls_itmdata-reqqty.
        IF ls_itmdata-totvalue GT ls_itmdata-avlbdgamt.
          APPEND VALUE #( %tky = ls_item-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'PR Item Value exceeding available Budget' )
                         ) TO reported-zmm_app02_iv1.
          ls_itmdata-reqqty = '0.00'.
          ls_itmdata-totvalue = '0.00'.
        ENDIF.
        APPEND ls_itmdata TO lt_itmdata.
      ENDIF.
    ENDLOOP.

    IF lt_itmdata IS NOT INITIAL.
      zbp_mm_app02_rv=>gt_itmdata = lt_itmdata.
    ENDIF.

*    IF lv_mark = 'X'.
*      READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
*      ENTITY zmm_app02_iv1
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT FINAL(lt_item2).
*      LOOP AT lt_item2 ASSIGNING FIELD-SYMBOL(<fs_item2>).
**        APPEND VALUE #( %tky = <fs_item2>-%tky ) TO failed-zmm_app02_iv1.
*        APPEND VALUE #( %tky = <fs_item2>-%tky
*                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                      text = 'Total Item Value exceeding available Budget' )
*                       ) TO reported-zmm_app02_iv1.
*
*      ENDLOOP.
*
*    ENDIF.

  ENDMETHOD.

  METHOD CalculateTotalPrice.
**********************************************************************
    DATA: lt_itmupd TYPE TABLE OF zmm_app02_tb2,
          ls_itmupd TYPE zmm_app02_tb2.

    READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
        ENTITY zmm_app02_iv1
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      MOVE-CORRESPONDING <fs_items> TO ls_itmupd.
      IF <fs_items>-Valprice IS NOT INITIAL.
        ls_itmupd-Totvalue = <fs_items>-Reqqty * <fs_items>-Valprice.
        IF <fs_items>-Extmatgrp IS NOT INITIAL.
          SELECT SINGLE plant,prodgrp,exprdgrp,
            SUM( allcibdg ) AS totallcbdg,
            SUM( balcibdg ) AS totbalbdg
            FROM zmm_app01_tb2
            WHERE plant  = @<fs_items>-Plant AND prodgrp = @<fs_items>-Matgrp
            AND exprdgrp = @<fs_items>-Extmatgrp
            GROUP BY plant, prodgrp, exprdgrp
            INTO @DATA(ls_budget).
          ls_itmupd-alltbdgamt = ls_budget-totallcbdg.
          ls_itmupd-avlbdgamt =  ls_budget-totbalbdg.
        ENDIF.
        APPEND ls_itmupd TO lt_itmupd.
      ENDIF.
    ENDLOOP.
    zbp_mm_app02_rv=>gt_itmupd = lt_itmupd.

*    MODIFY ENTITIES OF zmm_app02_rv IN LOCAL MODE
*    ENTITY zmm_app02_iv1
*    UPDATE FIELDS ( Totvalue )
*    WITH VALUE #( FOR ls_items IN lt_items ( %tky = ls_items-%tky
*                                             Totvalue = ls_items-Totvalue ) ).

  ENDMETHOD.

  METHOD Totval.
    DATA : lv_totval TYPE zmm_app02_tb2-totvalue.
**********************************************************************
    READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
        ENTITY zmm_app02_iv1
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_items).
    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      lv_totval = <fs_items>-Reqqty * <fs_items>-Valprice.
      IF lv_totval > <fs_items>-Avlbdgamt.
        APPEND VALUE #( %tky = <fs_items>-%tky ) TO failed-zmm_app02_iv1.
        APPEND VALUE #( %tky = <fs_items>-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Total Item Value exceeding available Budget' )
                       ) TO reported-zmm_app02_iv1.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZMM_APP02_RV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_app02_rv RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zmm_app02_rv RESULT result.

    METHODS crtpr FOR MODIFY
      IMPORTING keys FOR ACTION zmm_app02_rv~crtpr RESULT result.

    METHODS getdata1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR zmm_app02_rv~getdata1.


ENDCLASS.

CLASS lhc_ZMM_APP02_RV IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_instance_features.
    DATA: lv_lines TYPE i.

**********************************************************************
    READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
        ENTITY zmm_app02_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_status)
        ENTITY zmm_app02_rv BY \_Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).
    lv_lines =  lines( lt_item ) .
    result = VALUE #( FOR ls_data IN lt_status
      ( %tky =  ls_data-%tky
**        %features-%action-Edit = COND #( WHEN ls_data-status EQ 'X'
**                                            THEN if_abap_behv=>fc-o-disabled
**                                            ELSE if_abap_behv=>fc-o-enabled
*         )

    %action = VALUE #( CrtPr = COND #( WHEN ls_data-Mark EQ 'X' OR  lv_lines < 1
                                        THEN if_abap_behv=>fc-o-disabled
                                        ELSE if_abap_behv=>fc-o-enabled
     ) ) ) ).

*        %features-%update = COND #( WHEN ls_data-status EQ 'X'
*                                            THEN if_abap_behv=>fc-o-disabled
*                                            ELSE if_abap_behv=>fc-o-enabled
*         )

*          ) ).



  ENDMETHOD.

  METHOD CrtPr.
**********************************************************************
*    DATA: lt_temp_key TYPE zmm_app02_trns_handler=>tt_temp_key,
*          ls_temp_key LIKE LINE OF lt_temp_key.
    DATA: lt_hdrupd TYPE TABLE OF zmm_app02_tb1,
          ls_hdrupd TYPE zmm_app02_tb1.
    DATA: lv_lines TYPE i.
**********************************************************************
    READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
        ENTITY zmm_app02_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        ENTITY zmm_app02_rv BY \_Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    IF lt_item IS NOT INITIAL.
      MODIFY ENTITIES OF i_purchaserequisitiontp PRIVILEGED
      ENTITY purchaserequisition
               CREATE FIELDS ( purchaserequisitiontype )
               WITH VALUE #(  ( %cid                    = 'CID_1'
                                purchaserequisitiontype = ls_header-Purreqtyp ) )

              CREATE BY \_purchaserequisitionitem
              FIELDS ( plant
*                       purchaserequisitionitemtext
*                       accountassignmentcategory
                       requestedquantity
                       baseunit
                       material
                       DeliveryDate
                       purchaserequisitionprice
*                       purreqnitemcurrency
*                       materialgroup
*                       purchasinggroup
*                       purchasingorganization
*                     multipleacctassgmtdistribution

                          )
              WITH VALUE #( FOR ls_item IN lt_item
                            (    %cid_ref = 'CID_1'
                                 %target = VALUE #(
                                                  (  %cid                        = 'ItmCID_' && ls_item-Purreqitm
                                                     plant                       = ls_item-Plant
*                                                     purchaserequisitionitemtext = ''
*                                                     accountassignmentcategory   = ''
                                                     requestedquantity           = ls_item-Reqqty
                                                     baseunit                    = ls_item-Uom
                                                     material                    = ls_item-Material
                                                     DeliveryDate                = ls_item-Delvdate
                                                     purchaserequisitionprice    = ls_item-Valprice
*                                                     purreqnitemcurrency         = ls_item-Currency
*                                                     materialgroup               = ls_item-Matgrp
*                                                     purchasinggroup             = ls_item-Purgrp
*                                                     purchasingorganization      = ls_item-Purorg
*                                                   multipleacctassgmtdistribution = '1'
                                                     )
                                                  )
                             )
                           )

            REPORTED DATA(ls_reported)
            MAPPED DATA(ls_mapped)
            FAILED DATA(ls_failed).
**********************************************************************
      IF ls_failed IS INITIAL.
        zbp_mm_app02_rv=>cv_pr_doc-purchaserequisition = ls_mapped-purchaserequisition.
        MOVE-CORRESPONDING ls_header TO ls_hdrupd.
        lv_lines =  lines( lt_item ) .
        ls_hdrupd-totitms = lv_lines.
        DATA itab TYPE TABLE OF zmm_app02_tb2-totvalue WITH EMPTY KEY.
        itab = VALUE #( FOR j IN lt_item ( j-Totvalue ) ).
        DATA(sum) = REDUCE zmm_app02_tb2-totvalue( INIT x = 0 FOR wa IN itab NEXT x = x + wa ).
        ls_hdrupd-totnet = sum.
        APPEND ls_hdrupd TO lt_hdrupd.
        zbp_mm_app02_rv=>gt_hdrupd = lt_hdrupd.
      ENDIF.
**********************************************************************
      READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
      ENTITY zmm_app02_rv
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT FINAL(lt_hdr2).
      result = VALUE #( FOR ls_ord IN lt_hdr2
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

    ENDIF.
**********************************************************************
*      IF ls_failed IS NOT INITIAL.
*        LOOP AT ls_reported-purchaserequisition INTO DATA(ls_report).
*          APPEND VALUE #( uuid = ls_report-%cid
*                          %create = if_abap_behv=>mk-on
*                          %is_draft = if_abap_behv=>mk-on
*                          %msg = ls_report-%msg ) TO reported-zmm_app02_rv.
*        ENDLOOP.
*      ENDIF.
***********************************************************************
*      LOOP AT ls_mapped-purchaserequisition INTO DATA(ls_pr_mapped).
*        ls_temp_key-cid = ls_pr_mapped-%cid.
*        ls_temp_key-pid = ls_pr_mapped-%pid.
*        APPEND ls_temp_key TO lt_temp_key.
*      ENDLOOP.
*    ENDIF.

*    zmm_app02_trns_handler=>get_instance( )->set_temp_key( lt_temp_key ).

  ENDMETHOD.

  METHOD GetData1.
**********************************************************************
    DATA: lt_hdrdata TYPE TABLE OF zmm_app02_tb1,
          ls_hdrdata TYPE zmm_app02_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app02_rv IN LOCAL MODE
        ENTITY zmm_app02_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    SELECT SINGLE * FROM I_PurchasingDocumentTypeText
    WHERE PurchasingDocumentType = @ls_header-Purreqtyp AND Language = 'E'
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
**********************************************************************
    ls_hdrdata-uuid = ls_header-Uuid.
    ls_hdrdata-purreqtyp = ls_header-Purreqtyp.
    ls_hdrdata-prtypdesc = ls_typtxt-PurchasingDocumentTypeName.
    ls_hdrdata-createdat = ls_header-CreatedAt.
    ls_hdrdata-createdby  = ls_header-CreatedBy.
    ls_hdrdata-currency = 'INR'.
    ls_hdrdata-purreqdesc = lv_syuser && ' ' && lv_sydate.
    APPEND ls_hdrdata TO lt_hdrdata.
    zbp_mm_app02_rv=>gt_hdrdata = lt_hdrdata.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_APP02_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_APP02_RV IMPLEMENTATION.

  METHOD save_modified.
*    DATA: Lt_create TYPE TABLE OF zmm_app02_tb1,
*          lt_delete TYPE TABLE OF zmm_app02_tb1.
*
*
*    lt_create = CORRESPONDING #( create-zmm_app02_rv MAPPING FROM ENTITY ).
*    lt_delete = CORRESPONDING #( delete-zmm_app02_rv MAPPING FROM ENTITY ).
*    zmm_app02_trns_handler=>get_instance( )->additional_save( it_create = lt_create
*                                                                it_delete = lt_delete ).
**********************************************************************
    IF create-zmm_app02_rv IS NOT INITIAL.
      IF zbp_mm_app02_rv=>gt_hdrdata IS NOT INITIAL.
        DATA(lt_hrdata) = zbp_mm_app02_rv=>gt_hdrdata.
        MODIFY zmm_app02_tb1 FROM TABLE @lt_hrdata.
      ENDIF.
    ENDIF.
**********************************************************************
*    IF create-zmm_app02_iv1 IS NOT INITIAL.
    IF zbp_mm_app02_rv=>gt_itmdata IS NOT INITIAL.
      DATA(lt_itmdata) = zbp_mm_app02_rv=>gt_itmdata.
      MODIFY zmm_app02_tb2 FROM TABLE @lt_itmdata.
    ENDIF.
*    ENDIF.
**********************************************************************
    IF zbp_mm_app02_rv=>gt_itmupd IS NOT INITIAL.
      DATA(lt_itmupd) = zbp_mm_app02_rv=>gt_itmupd.
      MODIFY zmm_app02_tb2 FROM TABLE @lt_itmupd.
    ENDIF.
**********************************************************************
    IF zbp_mm_app02_rv=>cv_pr_doc IS NOT INITIAL .
      LOOP AT zbp_mm_app02_rv=>cv_pr_doc-purchaserequisition ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
        CONVERT KEY OF i_purchaserequisitiontp FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
        <fs_pr_mapped>-purchaserequisition = ls_pr_key-purchaserequisition.
      ENDLOOP.
      IF zbp_mm_app02_rv=>gt_hdrupd IS NOT INITIAL.
        DATA(lt_hdrupd) = zbp_mm_app02_rv=>gt_hdrupd.
        LOOP AT lt_hdrupd ASSIGNING FIELD-SYMBOL(<fs_upd>).
          <fs_upd>-purreqnum = ls_pr_key-PurchaseRequisition.
          <fs_upd>-mark = 'X'.
        ENDLOOP.
        MODIFY zmm_app02_tb1 FROM TABLE @lt_hdrupd.
      ENDIF.
    ENDIF.
**********************************************************************
*************** Delete Root & Child entity records *******************
    IF delete-zmm_app02_rv IS NOT INITIAL.
      LOOP AT delete-zmm_app02_rv INTO DATA(ls_hdr).
        DELETE FROM zmm_app02_tb1 WHERE uuid = @ls_hdr-Uuid.
      ENDLOOP.
    ENDIF.

    IF delete-zmm_app02_iv1 IS NOT INITIAL.
      LOOP AT delete-zmm_app02_iv1 INTO DATA(ls_itm).
        DELETE FROM zmm_app02_tb2 WHERE uuid = @ls_itm-Uuid AND purreqitm = @ls_itm-purreqitm.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.

  METHOD cleanup_finalize.
*    zmm_app02_trns_handler=>get_instance( )->clean_up( ).
  ENDMETHOD.

ENDCLASS.
