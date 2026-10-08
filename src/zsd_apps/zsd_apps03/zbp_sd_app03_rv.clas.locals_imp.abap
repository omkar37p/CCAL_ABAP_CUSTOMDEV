CLASS lhc_pcklst DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR pcklst RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR pcklst RESULT result.

    METHODS CrtDlv FOR MODIFY
      IMPORTING keys FOR ACTION pcklst~CrtDlv RESULT result.

    METHODS PckDlv FOR MODIFY
      IMPORTING keys FOR ACTION pcklst~PckDlv RESULT result.
    METHODS Updata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR pcklst~Updata.
    METHODS PostGI FOR MODIFY
      IMPORTING keys FOR ACTION pcklst~PostGI RESULT result.
    METHODS CrtSo FOR MODIFY
      IMPORTING keys FOR ACTION pcklst~CrtSo RESULT result.
*    METHODS Upddlv FOR DETERMINE ON SAVE
*      IMPORTING keys FOR pcklst~Upddlv.

ENDCLASS.

CLASS lhc_pcklst IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zsd_app03_rv IN LOCAL MODE
            ENTITY pcklst
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_status).
    DATA(ls_hdr) = lt_status[ 1 ].

    result = VALUE #( FOR ls_key IN keys
  ( %tky =  ls_key-%tky
    %update =  COND #( WHEN ls_hdr-delvnum IS INITIAL
                                    THEN if_abap_behv=>fc-o-enabled
                                    ELSE if_abap_behv=>fc-o-disabled )
    %action = VALUE #(
*                       CrtSo = COND #( WHEN ls_hdr-Contnum IS NOT INITIAL AND ls_hdr-sonum IS INITIAL
*                                   THEN if_abap_behv=>fc-o-enabled
*                                   ELSE if_abap_behv=>fc-o-disabled )
                       CrtDlv = COND #( WHEN ls_hdr-sonum IS NOT INITIAL AND ls_hdr-delvnum IS INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                       PostGI  = COND #( WHEN ls_hdr-delvnum IS NOT INITIAL AND ls_hdr-Mark IS NOT INITIAL AND ( ls_hdr-Divmark <> 'E' )
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                         PckDlv  =   if_abap_behv=>fc-o-disabled
                    ) ) ) .

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CrtDlv.
**********************************************************************
    DATA : lt_itmupd TYPE TABLE OF zsd_app02_tb2,
           ls_itmupd TYPE zsd_app02_tb2.
**********************************************************************
    READ ENTITIES OF zsd_app03_rv IN LOCAL MODE
          ENTITY pcklst
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_hdr) = lt_header[ 1 ].
**********************************************************************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
**********************************************************************
    MODIFY ENTITIES OF I_OutboundDeliveryTP PRIVILEGED
      ENTITY OutboundDelivery
      EXECUTE CreateDlvFromSalesDocument
      FROM VALUE #(
        ( %cid = 'DLV001'
          %param = VALUE #(
            %control = VALUE #(
              ShippingPoint = if_abap_behv=>mk-on
              DeliverySelectionDate = if_abap_behv=>mk-on
              DeliveryDocumentType = if_abap_behv=>mk-on   )
            ShippingPoint = ls_hdr-Plant
            DeliverySelectionDate = lv_sydate
            DeliveryDocumentType = 'LF'
            _ReferenceSDDocumentItem = VALUE #(
              ( %control = VALUE #(
                  ReferenceSDDocument = if_abap_behv=>mk-on
*                  ReferenceSDDocumentItem = if_abap_behv=>mk-on
 )
                ReferenceSDDocument = ls_hdr-Sonum
*                ReferenceSDDocumentItem = ls_hdr-Soitem
 ) )
                 ) ) )
      MAPPED DATA(ls_mapped)
      REPORTED DATA(ls_reported_modify)
      FAILED DATA(ls_failed_modify).

    IF ls_failed_modify IS INITIAL.

      zbp_sd_app03_rv=>cv_dlv_doc-outbounddelivery = ls_mapped-outbounddelivery.
      MOVE-CORRESPONDING ls_hdr TO ls_itmupd.
      APPEND ls_itmupd TO lt_itmupd.
      zbp_sd_app03_rv=>gt_itmupd2 = lt_itmupd.
    ENDIF.
**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

  METHOD PckDlv.
**********************************************************************
*    DATA : lt_itmupd TYPE TABLE OF zsd_app02_tb2,
*           ls_itmupd TYPE zsd_app02_tb2.
***********************************************************************
*    READ ENTITIES OF zsd_app03_rv IN LOCAL MODE
*          ENTITY pcklst
*          ALL FIELDS WITH CORRESPONDING #( keys )
*          RESULT FINAL(lt_hdr).
*    DATA(ls_hdr) = lt_hdr[ 1 ].
*    MOVE-CORRESPONDING ls_hdr TO ls_itmupd.
***********************************************************************
*    MODIFY ENTITIES OF I_OutboundDeliveryTP PRIVILEGED
*      ENTITY OutboundDeliveryItem
*        UPDATE
*          FIELDS ( ActualDeliveredQtyInOrderUnit OrderQuantityUnit yy1_pcklist_dli   )
*          WITH VALUE #( ( ActualDeliveredQtyInOrderUnit = ls_hdr-Chbwgt
*                          OrderQuantityUnit             = ls_hdr-Wgtunit
**                          Batch                         = ls_hdr-Batch
**                          StorageLocation               = ls_hdr-Sloc
*                          yy1_pcklist_dli               = ls_hdr-Tokennum
*                          %tky-OutboundDelivery         = ls_hdr-Delvnum
*                          %tky-OutboundDeliveryItem     = '000010' ) )
*      FAILED   DATA(ls_failed_upd)
*      REPORTED DATA(ls_reported_upd).
*    IF ls_failed_upd IS INITIAL.
*      MOVE-CORRESPONDING ls_hdr TO ls_itmupd.
*      APPEND ls_itmupd TO lt_itmupd.
*      zbp_sd_app03_rv=>gt_itmupd3 = lt_itmupd.
*    ENDIF.
**    MODIFY ENTITIES OF I_OutboundDeliveryTP PRIVILEGED
**      ENTITY OutboundDelivery
**      CREATE BY \_Item
**        FROM VALUE #( ( %tky = VALUE #( OutboundDelivery = ls_hdr-Delvnum )
**                        %target = VALUE #(
**                          %control = VALUE #( Material = if_abap_behv=>mk-on
**                                              ActualDeliveredQtyInOrderUnit = if_abap_behv=>mk-on
**                                              OrderQuantityUnit = if_abap_behv=>mk-on
**                                              ReferenceSDDocument = if_abap_behv=>mk-on
**                                              ReferenceSDDocumentItem = if_abap_behv=>mk-on
**                                              ReferenceSDDocumentCategory = if_abap_behv=>mk-on
***                                              StorageLocation = if_abap_behv=>mk-on
***                                              Batch = if_abap_behv=>mk-on
***                                              PickQuantityInOrderUnit = if_abap_behv=>mk-on
**                                              yy1_pcklist_dli = if_abap_behv=>mk-on )
**                          ( %cid = 'I001'
**                            Material = ls_hdr-material
**                            ActualDeliveredQtyInOrderUnit = ls_hdr-chbwgt
**                            OrderQuantityUnit = ls_hdr-Wgtunit
**                            ReferenceSDDocument = ls_hdr-sonum
**                            ReferenceSDDocumentItem = ls_hdr-soitem
**                            ReferenceSDDocumentCategory = 'C'
***                            StorageLocation =  ls_hdr-sloc
***                            Batch =  ls_hdr-batch
***                            PickQuantityInOrderUnit = ls_hdr-chbwgt
**                            yy1_pcklist_dli = ls_hdr-Tokennum
**                             ) ) ) )
**      MAPPED DATA(ls_mapped)
**      REPORTED DATA(ls_reported)
**      FAILED DATA(ls_failed).
**    IF ls_failed IS INITIAL.
**      MOVE-CORRESPONDING ls_hdr TO ls_itmupd.
**      APPEND ls_itmupd TO lt_itmupd.
**      zbp_sd_app03_rv=>gt_itmupd3 = lt_itmupd.
**    ENDIF.
*
***********************************************************************
*    result = VALUE #( FOR ls_ord IN lt_hdr
*                     ( %tky   = ls_ord-%tky
*                       %param = ls_ord ) ).
*
  ENDMETHOD.

  METHOD Updata.
**********************************************************************
    DATA : lt_itmupd TYPE TABLE OF zsd_app02_tb2,
           ls_itmupd TYPE zsd_app02_tb2.
**********************************************************************
    READ ENTITIES OF zsd_app03_rv IN LOCAL MODE
          ENTITY pcklst
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_hdr).
    DATA(ls_hdr) = lt_hdr[ 1 ].
    MOVE-CORRESPONDING ls_hdr TO ls_itmupd.
    ls_itmupd-soitem = '000010'.
    SELECT SINGLE soh~*,soi~*,mat~* FROM I_SalesDocument AS soh
    INNER JOIN I_SalesDocumentItem AS soi ON soi~SalesDocument = soh~SalesDocument AND soi~SalesDocument = '000010'
    INNER JOIN I_Product AS mat ON mat~Product = soi~Product
    WHERE soh~SalesDocument = @ls_hdr-sonum
    INTO @DATA(ls_sodata).
    ls_itmupd-custref = ls_sodata-soh-PurchaseOrderByCustomer.
*    ls_itmupd-division = ls_sodata-mat-Division.
*    SELECT SINGLE * FROM zsd_apps02_1_tb1 WHERE division = @ls_itmupd-division
*    INTO @DATA(ls_divmrk).
*    IF sy-subrc = 0 AND NOT ls_divmrk IS INITIAL.
*      CASE ls_divmrk-whgmark.
*        WHEN 'X'.
*          IF ls_divmrk-cncmark = 'X'.
*            ls_itmupd-divmark = 'C'.
*          ELSE.
*            ls_itmupd-divmark = 'W'.
*          ENDIF.
*        WHEN ' '.
*          ls_itmupd-divmark = 'E'.
*      ENDCASE.
*
*    ENDIF.
    APPEND ls_itmupd TO lt_itmupd.
    zbp_sd_app03_rv=>gt_itmupd = lt_itmupd.
  ENDMETHOD.

  METHOD PostGI.
    DATA : lt_itmupd TYPE TABLE OF zsd_app02_tb2,
           ls_itmupd TYPE zsd_app02_tb2.
**********************************************************************
    READ ENTITIES OF zsd_app03_rv IN LOCAL MODE
          ENTITY pcklst
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_hdr).
    DATA(ls_hdr) = lt_hdr[ 1 ].
    MOVE-CORRESPONDING ls_hdr TO ls_itmupd.
    IF ls_hdr-delvnum IS NOT INITIAL.
***********************************************************************
      MODIFY ENTITIES OF I_OutboundDeliveryTP PRIVILEGED
        ENTITY OutboundDeliveryItem
          UPDATE
            FIELDS ( ActualDeliveredQtyInOrderUnit OrderQuantityUnit  )
            WITH VALUE #( ( ActualDeliveredQtyInOrderUnit = ls_hdr-chbwgt
                            OrderQuantityUnit             = ls_hdr-Wgtunit
*                            PickQuantityInOrderUnit       = ls_hdr-chbwgt
*                            PickConfirmationStatus        = 'C'
*                            PickQuantityInBaseUnit        = ls_hdr-chbwgt
*                            OriginalDeliveryQuantity      = ls_hdr-chbwgt
                            %tky-OutboundDelivery         = ls_hdr-delvnum
                            %tky-OutboundDeliveryItem     = '000010'
                             ) )
        FAILED   DATA(ls_failed_upddlv)
        REPORTED DATA(ls_reported_upddlv).
      IF ls_failed_upddlv IS INITIAL.

***********************************************************************
*        TRY.
*            DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
*          CATCH cx_abap_context_info_error.
*            DATA(ls_v) = 1.
*        ENDTRY.
***********************************************************************
*        MODIFY ENTITIES OF i_materialdocumenttp PRIVILEGED
*                   ENTITY MaterialDocument
*                   CREATE FROM VALUE #( ( %cid                          = 'CID_001'
*                                          goodsmovementcode             = '06'
*                                          postingdate                   = lv_sydate
*                                          documentdate                  = lv_sydate
*                                          ReferenceDocument             = ls_hdr-Delvnum
*                                          %control-goodsmovementcode                    = cl_abap_behv=>flag_changed
*                                          %control-postingdate                          = cl_abap_behv=>flag_changed
*                                          %control-documentdate                         = cl_abap_behv=>flag_changed
*                                          %control-ReferenceDocument                    = cl_abap_behv=>flag_changed
*                                      ) )
*                   ENTITY MaterialDocument
*                   CREATE BY \_MaterialDocumentItem
*                   FROM VALUE #( (
*                                   %cid_ref = 'CID_001'
*                                   %target = VALUE #( ( %cid                           = 'CID_ITM_001'
*                                                        plant                          = ls_hdr-Plant
*                                                        material                       = ls_hdr-Material
*                                                        Batch                          = ls_hdr-Batch
*                                                        GoodsMovementType              = '601'
*                                                        storagelocation                = ls_hdr-Sloc
*                                                        QuantityInEntryUnit            = ls_hdr-Chbwgt
*                                                        entryunit                      = ls_hdr-Wgtunit
*                                                        DeliveryDocument               = ls_hdr-Delvnum
*                                                        DeliveryDocumentItem           = '000010'
*                                                        GoodsMovementRefDocType        = 'L'
*                                                        IsCompletelyDelivered          = 'X'
*                                                        %control-plant                 = cl_abap_behv=>flag_changed
*                                                        %control-material              = cl_abap_behv=>flag_changed
*                                                        %control-GoodsMovementType     = cl_abap_behv=>flag_changed
*                                                        %control-storagelocation       = cl_abap_behv=>flag_changed
*                                                        %control-QuantityInEntryUnit   = cl_abap_behv=>flag_changed
*                                                        %control-entryunit             = cl_abap_behv=>flag_changed
*                                                        %control-Batch                 = cl_abap_behv=>flag_changed
*                                                        %control-DeliveryDocument      = cl_abap_behv=>flag_changed
*                                                        %control-DeliveryDocumentItem  = cl_abap_behv=>flag_changed
*                                                        %control-GoodsMovementRefDocType  = cl_abap_behv=>flag_changed
*                                                        %control-IsCompletelyDelivered  = cl_abap_behv=>flag_changed
*                                                    ) )                         ) )
*                   MAPPED   DATA(ls_create_mapped)
*                   FAILED   DATA(ls_create_failed)
*                   REPORTED DATA(ls_create_reported).
*        IF ls_create_failed IS INITIAL.
*          zbp_sd_app03_rv=>cv_mat_doc = ls_create_mapped.
        MOVE-CORRESPONDING ls_hdr TO ls_itmupd.
        ls_itmupd-mark = 'X'.
        APPEND ls_itmupd TO lt_itmupd.
        zbp_sd_app03_rv=>gt_itmupd3 = lt_itmupd.
      ENDIF.
    ENDIF.
*    ENDIF.

**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_hdr
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

*  METHOD Upddlv.
***********************************************************************
*    READ ENTITIES OF zsd_app03_rv IN LOCAL MODE
*          ENTITY pcklst
*          ALL FIELDS WITH CORRESPONDING #( keys )
*          RESULT FINAL(lt_hdr).
*    DATA(ls_hdr) = lt_hdr[ 1 ].
*    IF ls_hdr-delvnum IS NOT INITIAL.
***********************************************************************
*      MODIFY ENTITIES OF I_OutboundDeliveryTP PRIVILEGED
*        ENTITY OutboundDeliveryItem
*          UPDATE
*            FIELDS ( ActualDeliveredQtyInOrderUnit OrderQuantityUnit  )
*            WITH VALUE #( ( ActualDeliveredQtyInOrderUnit = ls_hdr-chbwgt
*                            OrderQuantityUnit             = ls_hdr-Wgtunit
*                            %tky-OutboundDelivery         = ls_hdr-delvnum
*                            %tky-OutboundDeliveryItem     = '000010' ) )
*        FAILED   DATA(ls_failed_upddlv)
*        REPORTED DATA(ls_reported_upddlv).
*      IF ls_failed_upddlv IS INITIAL.
*      ENDIF.
*    ENDIF.
*
*  ENDMETHOD.

  METHOD CrtSo.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZSD_APP03_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZSD_APP03_RV IMPLEMENTATION.

  METHOD save_modified.

**********************************************************************
    IF zbp_sd_app03_rv=>gt_itmupd IS NOT INITIAL.
      DATA(lt_itmupd) = zbp_sd_app03_rv=>gt_itmupd.
      MODIFY zsd_app02_tb2 FROM TABLE @lt_itmupd.
    ENDIF.
**********************************************************************
    IF zbp_sd_app03_rv=>cv_dlv_doc IS NOT INITIAL.
      LOOP AT zbp_sd_app03_rv=>cv_dlv_doc-outbounddelivery ASSIGNING FIELD-SYMBOL(<fs_dlv_mapped>).
        CONVERT KEY OF I_OutboundDeliveryTP FROM <fs_dlv_mapped>-%pid TO DATA(ls_dlv_key).
        <fs_dlv_mapped>-OutboundDelivery = ls_dlv_key-OutboundDelivery.
      ENDLOOP.
      IF zbp_sd_app03_rv=>gt_itmupd2 IS NOT INITIAL.
        DATA(lt_itmupd2) = zbp_sd_app03_rv=>gt_itmupd2.
        LOOP AT lt_itmupd2 ASSIGNING FIELD-SYMBOL(<fs_upd>).
          <fs_upd>-delvnum = ls_dlv_key-OutboundDelivery.
          <fs_upd>-mark = 'D'.
        ENDLOOP.
        MODIFY zsd_app02_tb2 FROM TABLE @lt_itmupd2.
      ENDIF.
    ENDIF.
**********************************************************************
    IF zbp_sd_app03_rv=>cv_mat_doc IS NOT INITIAL.
      LOOP AT zbp_sd_app03_rv=>cv_mat_doc-materialdocument ASSIGNING FIELD-SYMBOL(<fs_mdoc_mapped>).
        CONVERT KEY OF I_MaterialDocumentTP FROM <fs_mdoc_mapped>-%pid TO DATA(ls_mdoc_key).
        <fs_mdoc_mapped>-MaterialDocument = ls_mdoc_key-MaterialDocument.
      ENDLOOP.

      IF zbp_sd_app03_rv=>gt_itmupd3 IS NOT INITIAL.
        DATA(lt_itmupd3) = zbp_sd_app03_rv=>gt_itmupd3.
        MODIFY zsd_app02_tb2 FROM TABLE @lt_itmupd3.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
