CLASS lhc__dlvitm DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS GetData2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _DlvItm~GetData2.

ENDCLASS.

CLASS lhc__dlvitm IMPLEMENTATION.

  METHOD GetData2.
**********************************************************************
    DATA: lt_itmupd TYPE TABLE OF zsd_app01_tb2,
          ls_itmupd TYPE zsd_app01_tb2.
**********************************************************************
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr BY \_Item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_item).
    DATA(ls_item) = lt_item[ 1 ].
    ls_itmupd-batch = ls_item-Batch.
    ls_itmupd-material = ls_item-Material.
    ls_itmupd-matdesc = ls_item-Matdesc.
    ls_itmupd-ordqty = ls_item-Ordqty.
    ls_itmupd-ordunt = ls_item-Ordunt.
    ls_itmupd-plant = ls_item-Plant.
    ls_itmupd-sloc = ls_item-Sloc.
    ls_itmupd-uuid = ls_item-Uuid.
    ls_itmupd-soitem = ls_item-Soitem.
    APPEND ls_itmupd TO lt_itmupd.
    zbp_sd_app01_rv=>gt_itmupd = lt_itmupd.

  ENDMETHOD.

ENDCLASS.

CLASS lhc__DlvHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _DlvHdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _DlvHdr RESULT result.

    METHODS GetGross FOR MODIFY
      IMPORTING keys FOR ACTION _DlvHdr~GetGross RESULT result.

    METHODS GetTare FOR MODIFY
      IMPORTING keys FOR ACTION _DlvHdr~GetTare RESULT result.

    METHODS Pack FOR MODIFY
      IMPORTING keys FOR ACTION _DlvHdr~Pack RESULT result.

    METHODS PostGI FOR MODIFY
      IMPORTING keys FOR ACTION _DlvHdr~PostGI RESULT result.

    METHODS GetData1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _DlvHdr~GetData1.

ENDCLASS.

CLASS lhc__DlvHdr IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
            ENTITY _DlvHdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_status).
    result = VALUE #( FOR ls_data IN lt_status
 ( %tky =  ls_data-%tky
*        %features-%action = COND #( WHEN ls_data-status EQ 'X'
*                                            THEN if_abap_behv=>fc-o-disabled
*                                            ELSE if_abap_behv=>fc-o-enabled
*         )

%action = VALUE #( GetGross = COND #( WHEN ls_data-Grswgt IS INITIAL AND ls_data-Tarewgt IS NOT INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                   GetTare = COND #( WHEN ls_data-Tarewgt IS INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                   Pack = COND #( WHEN ls_data-Chbwgt IS INITIAL OR ls_data-Mark IS NOT INITIAL
                                   THEN if_abap_behv=>fc-o-disabled
                                   ELSE if_abap_behv=>fc-o-enabled )
                   PostGI = COND #( WHEN ls_data-Mark = 'X'
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )



) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD GetGross.
**********************************************************************
    DATA : lt_hdrupd TYPE TABLE OF zsd_app01_tb1,
           ls_hdrupd TYPE zsd_app01_tb1,
           lv_conval TYPE zsd_app01_tb1-chbwgt.

    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].

    ls_hdrupd-concrate = ls_header-Concrate.
    ls_hdrupd-cylinder = ls_header-Cylinder.
    ls_hdrupd-delvnum = ls_header-Delvnum.
    ls_hdrupd-drivername = ls_header-Drivername.
    ls_hdrupd-gidate = ls_header-Gidate.
    ls_hdrupd-gitime = ls_header-Gitime.
    ls_hdrupd-godate = ls_header-Godate.
    ls_hdrupd-gotime = ls_header-Gotime.
    ls_hdrupd-lrnumber = ls_header-Lrnumber.
    ls_hdrupd-sonum = ls_header-Sonum.
    ls_hdrupd-tokennum = ls_header-Tokennum.
    ls_hdrupd-totcyln = ls_header-Totcyln.
    ls_hdrupd-trspmode = ls_header-Trspmode.
    ls_hdrupd-trspname = ls_header-Trspname.
    ls_hdrupd-trucktyp = ls_header-Trucktyp.
    ls_hdrupd-uuid = ls_header-Uuid.
    ls_hdrupd-vehicleno = ls_header-Vehicleno.
    ls_hdrupd-wgtunit = ls_header-Wgtunit.
    ls_hdrupd-tarewgt = ls_header-Tarewgt.

    ls_hdrupd-grswgt = '34.000'.
    ls_hdrupd-netwgt = ls_hdrupd-grswgt - ls_header-Tarewgt.
    IF ls_header-Concrate IS INITIAL.
      ls_hdrupd-chbwgt = ls_hdrupd-netwgt.
    ELSE.
      lv_conval = ls_hdrupd-netwgt * ls_header-Concrate / 100.
      ls_hdrupd-chbwgt = ls_hdrupd-netwgt - lv_conval.
    ENDIF.

    APPEND ls_hdrupd TO lt_hdrupd.
    zbp_sd_app01_rv=>gt_hdrupd = lt_hdrupd.

**********************************************************************
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_hdr2).
    result = VALUE #( FOR ls_ord IN lt_hdr2
                   ( %tky   = ls_ord-%tky
                     %param = ls_ord ) ).


  ENDMETHOD.

  METHOD GetTare.
**********************************************************************
    DATA : lt_hdrupd TYPE TABLE OF zsd_app01_tb1,
           ls_hdrupd TYPE zsd_app01_tb1.

    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    ls_hdrupd-chbwgt = ls_header-Chbwgt.
    ls_hdrupd-concrate = ls_header-Concrate.
    ls_hdrupd-cylinder = ls_header-Cylinder.
    ls_hdrupd-delvnum = ls_header-Delvnum.
    ls_hdrupd-drivername = ls_header-Drivername.
    ls_hdrupd-gidate = ls_header-Gidate.
    ls_hdrupd-gitime = ls_header-Gitime.
    ls_hdrupd-godate = ls_header-Godate.
    ls_hdrupd-gotime = ls_header-Gotime.
    ls_hdrupd-grswgt = ls_header-Grswgt.
    ls_hdrupd-lrnumber = ls_header-Lrnumber.
    ls_hdrupd-netwgt = ls_header-Netwgt.
    ls_hdrupd-sonum = ls_header-Sonum.
    ls_hdrupd-tokennum = ls_header-Tokennum.
    ls_hdrupd-totcyln = ls_header-Totcyln.
    ls_hdrupd-trspmode = ls_header-Trspmode.
    ls_hdrupd-trspname = ls_header-Trspname.
    ls_hdrupd-trucktyp = ls_header-Trucktyp.
    ls_hdrupd-uuid = ls_header-Uuid.
    ls_hdrupd-vehicleno = ls_header-Vehicleno.
    ls_hdrupd-wgtunit = ls_header-Wgtunit.
    ls_hdrupd-tarewgt = '25.000'.

    APPEND ls_hdrupd TO lt_hdrupd.
    zbp_sd_app01_rv=>gt_hdrupd = lt_hdrupd.
**********************************************************************
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_hdr2).
    result = VALUE #( FOR ls_ord IN lt_hdr2
                   ( %tky   = ls_ord-%tky
                     %param = ls_ord ) ).



  ENDMETHOD.

  METHOD Pack.
    DATA : lt_hdrupd2 TYPE TABLE OF zsd_app01_tb1,
           ls_hdrupd2 TYPE zsd_app01_tb1.
**********************************************************************
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr BY \_Item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_item).
    DATA(ls_item) = lt_item[ 1 ].

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
              DeliveryDocumentType = if_abap_behv=>mk-on )
            ShippingPoint = ls_item-Plant
            DeliverySelectionDate = lv_sydate
            DeliveryDocumentType = 'LF'
            _ReferenceSDDocumentItem = VALUE #(
              ( %control = VALUE #(
                  ReferenceSDDocument = if_abap_behv=>mk-on
                  ReferenceSDDocumentItem = if_abap_behv=>mk-on   )
                ReferenceSDDocument = ls_header-Sonum
                ReferenceSDDocumentItem = ls_item-Soitem ) ) ) ) )
      MAPPED DATA(ls_mapped)
      REPORTED DATA(ls_reported_modify)
      FAILED DATA(ls_failed_modify).

    IF ls_failed_modify IS INITIAL.
      zbp_sd_app01_rv=>cv_dlv_doc-outbounddelivery = ls_mapped-outbounddelivery.
      MOVE-CORRESPONDING ls_header TO ls_hdrupd2.
      APPEND ls_hdrupd2 TO lt_hdrupd2.
      zbp_sd_app01_rv=>gt_hdrupd2 = lt_hdrupd2.
    ENDIF.
**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).
  ENDMETHOD.

  METHOD PostGI.
    DATA : lt_hdrupd3 TYPE TABLE OF zsd_app01_tb1,
           ls_hdrupd3 TYPE zsd_app01_tb1.
**********************************************************************
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr BY \_Item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_items).
    DATA(ls_items) = lt_items[ 1 ].
**********************************************************************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.

**********************************************************************
    MODIFY ENTITIES OF I_OutboundDeliveryTP PRIVILEGED
      ENTITY OutboundDeliveryItem
        UPDATE
          FIELDS ( ActualDeliveredQtyInOrderUnit OrderQuantityUnit  )
          WITH VALUE #( ( ActualDeliveredQtyInOrderUnit = ls_header-Chbwgt
                          OrderQuantityUnit             = ls_header-Wgtunit
                          Batch                         = ls_items-Batch
                          StorageLocation               = ls_items-Sloc
                          %tky-OutboundDelivery         = ls_header-Delvnum
                          %tky-OutboundDeliveryItem     = '000010' ) )
      FAILED   DATA(ls_failed_upd)
      REPORTED DATA(ls_reported_upd).
    IF ls_failed_upd IS INITIAL.
**********************************************************************
*      MODIFY ENTITIES OF i_materialdocumenttp PRIVILEGED
*                 ENTITY MaterialDocument
*                 CREATE FROM VALUE #( ( %cid                          = 'CID_001'
*                                        goodsmovementcode             = '01'
*                                        postingdate                   = lv_sydate
*                                        documentdate                  = lv_sydate
*                                        %control-goodsmovementcode                    = cl_abap_behv=>flag_changed
*                                        %control-postingdate                          = cl_abap_behv=>flag_changed
*                                        %control-documentdate                         = cl_abap_behv=>flag_changed
*                                    ) )
*                 ENTITY MaterialDocument
*                 CREATE BY \_MaterialDocumentItem
*                 FROM VALUE #( (
*                                 %cid_ref = 'CID_001'
*                                 %target = VALUE #( ( %cid                           = 'CID_ITM_001'
*                                                      plant                          = ls_items-Plant
**                                                      material                       = ls_items-Material
*                                                      Batch                          = ls_items-Batch
**                                                      GoodsMovementType              = '601'
*                                                      storagelocation                = ls_items-Sloc
*                                                      QuantityInEntryUnit            = ls_header-Chbwgt
*                                                      entryunit                      = ls_items-Ordunt
*                                                      DeliveryDocument               = ls_header-Delvnum
*                                                      DeliveryDocumentItem           = '000010'
*                                                      %control-plant                 = cl_abap_behv=>flag_changed
**                                                      %control-material              = cl_abap_behv=>flag_changed
**                                                      %control-GoodsMovementType     = cl_abap_behv=>flag_changed
*                                                      %control-storagelocation       = cl_abap_behv=>flag_changed
*                                                      %control-QuantityInEntryUnit   = cl_abap_behv=>flag_changed
*                                                      %control-entryunit             = cl_abap_behv=>flag_changed
*                                                      %control-Batch                 = cl_abap_behv=>flag_changed
*                                                      %control-DeliveryDocument      = cl_abap_behv=>flag_changed
*                                                      %control-DeliveryDocumentItem  = cl_abap_behv=>flag_changed
*                                                  ) )                         ) )
*                 MAPPED   DATA(ls_create_mapped)
*                 FAILED   DATA(ls_create_failed)
*                 REPORTED DATA(ls_create_reported).
*      IF ls_create_failed IS INITIAL.
*        zbp_sd_app01_rv=>cv_mat_doc-materialdocument = ls_create_mapped-materialdocument.
      MOVE-CORRESPONDING ls_header TO ls_hdrupd3.
      APPEND ls_hdrupd3 TO lt_hdrupd3.
      zbp_sd_app01_rv=>gt_hdrupd3 = lt_hdrupd3.
*      ENDIF.

    ENDIF.
**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

  METHOD GetData1.
**********************************************************************
    DATA: lt_hdrdata TYPE TABLE OF zsd_app01_tb1,
          ls_hdrdata TYPE zsd_app01_tb1,
          lt_itmdata TYPE TABLE OF zsd_app01_tb2,
          ls_itmdata TYPE zsd_app01_tb2.
**********************************************************************
**********************************************************************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
    TRY.
        DATA(lv_sytime) = CONV d( xco_cp=>sy->time( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v1) = 1.
    ENDTRY.
**********************************************************************
    READ ENTITIES OF zsd_app01_rv IN LOCAL MODE
          ENTITY _DlvHdr
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    SELECT SINGLE MAX( tokennum ) FROM zsd_app01_rv INTO @DATA(lv_token).
    IF sy-subrc = 0 AND lv_token IS NOT INITIAL.
      ls_hdrdata-tokennum = lv_token + 1.
    ELSE.
      ls_hdrdata-tokennum = '2000000001'.
    ENDIF.
    ls_hdrdata-uuid = ls_header-Uuid.
    ls_hdrdata-gitime = lv_sytime.
    ls_hdrdata-gidate = lv_sydate.
    ls_hdrdata-concrate = ls_header-Concrate.
    ls_hdrdata-cylinder = ls_header-Cylinder.
    ls_hdrdata-drivername = ls_header-Drivername.
    ls_hdrdata-vehicleno = ls_header-Vehicleno.
    ls_hdrdata-trucktyp = ls_header-Trucktyp.
    ls_hdrdata-trspname = ls_header-Trspname.
    ls_hdrdata-trspmode = ls_header-Trspmode.
    ls_hdrdata-totcyln = ls_header-Totcyln.
*    ls_hdrdata-tarewgt = ls_header-Tarewgt.
    ls_hdrdata-sonum = ls_header-Sonum.
    ls_hdrdata-lrnumber = ls_header-Lrnumber.
*    ls_hdrdata-grswgt = ls_header-

*    ls_hdrdata-
*    ls_hdrdata-
*    ls_hdrdata-
*
    IF  ls_header-Sonum IS NOT INITIAL.
      READ ENTITIES OF i_salesordertp PRIVILEGED
        ENTITY SalesOrder BY \_Item
        FROM VALUE #( ( SalesOrder = ls_header-Sonum  ) )
        RESULT DATA(lt_soitem).
      LOOP AT lt_soitem INTO DATA(ls_soitem).
        ls_hdrdata-wgtunit = ls_soitem-OrderQuantityUnit.
*          ls_itmdata-division = ls_soitem-
        ls_itmdata-batch = ls_soitem-Batch.
        ls_itmdata-material = ls_soitem-Product.
        ls_itmdata-ordqty = ls_soitem-RequestedQuantity.
        ls_itmdata-uuid = ls_header-Uuid.
        ls_itmdata-soitem = ls_soitem-SalesOrderItem.
        ls_itmdata-sloc = ls_soitem-StorageLocation.
        ls_itmdata-plant = ls_soitem-Plant.
        ls_itmdata-ordunt = ls_soitem-OrderQuantityUnit.
        APPEND ls_itmdata TO lt_itmdata.
      ENDLOOP.
      APPEND ls_hdrdata TO lt_hdrdata.
    ENDIF.

    zbp_sd_app01_rv=>gt_hdrdata = lt_hdrdata.
    zbp_sd_app01_rv=>gt_itmdata = lt_itmdata.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZSD_APP01_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZSD_APP01_RV IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
    TRY.
        DATA(lv_sytime) = CONV d( xco_cp=>sy->time( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v1) = 1.
    ENDTRY.

**********************************************************************
    IF create-_dlvhdr IS NOT INITIAL.
      IF zbp_sd_app01_rv=>gt_hdrdata IS NOT INITIAL.
        DATA(lt_hdrdata) = zbp_sd_app01_rv=>gt_hdrdata.
        MODIFY zsd_app01_tb1 FROM TABLE @lt_hdrdata.
      ENDIF.
      IF zbp_sd_app01_rv=>gt_itmdata IS NOT INITIAL.
        DATA(lt_itmdata) = zbp_sd_app01_rv=>gt_itmdata.
        MODIFY zsd_app01_tb2 FROM TABLE @lt_itmdata.
      ENDIF.
    ENDIF.

**********************************************************************
    IF zbp_sd_app01_rv=>gt_hdrupd IS NOT INITIAL.
      DATA(lt_hdrupd) = zbp_sd_app01_rv=>gt_hdrupd.
      MODIFY zsd_app01_tb1 FROM TABLE @lt_hdrupd.
    ENDIF.
**********************************************************************
    IF zbp_sd_app01_rv=>cv_dlv_doc IS NOT INITIAL.
      LOOP AT zbp_sd_app01_rv=>cv_dlv_doc-outbounddelivery ASSIGNING FIELD-SYMBOL(<fs_dlv_mapped>).
        CONVERT KEY OF I_OutboundDeliveryTP FROM <fs_dlv_mapped>-%pid TO DATA(ls_dlv_key).
        <fs_dlv_mapped>-OutboundDelivery = ls_dlv_key-OutboundDelivery.
      ENDLOOP.
      IF zbp_sd_app01_rv=>gt_hdrupd2 IS NOT INITIAL.
        DATA(lt_hrdupd2) = zbp_sd_app01_rv=>gt_hdrupd2.
        LOOP AT lt_hrdupd2 ASSIGNING FIELD-SYMBOL(<fs_upd>).
          <fs_upd>-delvnum = ls_dlv_key-OutboundDelivery.
          <fs_upd>-mark = 'X'.
        ENDLOOP.
        MODIFY zsd_app01_tb1 FROM TABLE @lt_hrdupd2.
      ENDIF.
    ENDIF.
**********************************************************************
*    IF zbp_sd_app01_rv=>cv_mat_doc IS NOT INITIAL.
*      LOOP AT zbp_sd_app01_rv=>cv_mat_doc-materialdocument ASSIGNING FIELD-SYMBOL(<fs_mdoc_mapped>).
*        CONVERT KEY OF I_MaterialDocumentTP FROM <fs_mdoc_mapped>-%pid TO DATA(ls_mdoc_key).
*        <fs_mdoc_mapped>-MaterialDocument = ls_mdoc_key-MaterialDocument.
*      ENDLOOP.
    IF zbp_sd_app01_rv=>gt_hdrupd3 IS NOT INITIAL.
      DATA(lt_hrdupd3) = zbp_sd_app01_rv=>gt_hdrupd3.
      LOOP AT lt_hrdupd3 ASSIGNING FIELD-SYMBOL(<fs_upd3>).
*          <fs_upd3>- = ls_mdoc_key-MaterialDocument.
        <fs_upd3>-godate = lv_sydate.
        <fs_upd3>-gotime = lv_sytime.
        <fs_upd3>-mark = 'C'.
      ENDLOOP.
      MODIFY zsd_app01_tb1 FROM TABLE @lt_hrdupd3.
    ENDIF.
*    ENDIF.
**********************************************************************
    IF zbp_sd_app01_rv=>gt_itmupd IS NOT INITIAL.
      DATA(lt_itmupd) = zbp_sd_app01_rv=>gt_itmupd.
      MODIFY zsd_app01_tb2 FROM TABLE @lt_itmupd.
    ENDIF.

*************** Delete Root & Child entity records *******************
    IF delete-_dlvhdr IS NOT INITIAL.
      LOOP AT delete-_dlvhdr INTO DATA(ls_hdr).
        DELETE FROM zsd_app01_tb2 WHERE uuid = @ls_hdr-Uuid.
        DELETE FROM zsd_app01_tb1 WHERE uuid = @ls_hdr-Uuid.
      ENDLOOP.
    ENDIF.
    IF delete-_dlvitm IS NOT INITIAL.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
