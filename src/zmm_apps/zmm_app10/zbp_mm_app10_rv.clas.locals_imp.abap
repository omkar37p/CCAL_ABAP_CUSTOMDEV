CLASS lhc__GIHDR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _gihdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _gihdr RESULT result.

    METHODS GetGross FOR MODIFY
      IMPORTING keys FOR ACTION _gihdr~GetGross RESULT result.

    METHODS GetData1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _gihdr~GetData1.

    METHODS Upddata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _gihdr~Upddata.

ENDCLASS.

CLASS lhc__GIHDR IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
*    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
*            ENTITY _gihdr
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_status)
*            ENTITY _gihdr BY \_Item
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_items).
*    result = VALUE #( FOR ls_data IN lt_status
*  ( %tky =  ls_data-%tky
*    %action = VALUE #( GetGross = COND #( WHEN ls_data-Mark EQ ' '
*                                   THEN if_abap_behv=>fc-o-disabled
*                                   ELSE if_abap_behv=>fc-o-enabled
*  ) ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD GetGross.
  ENDMETHOD.

  METHOD GetData1.
**********************************************************************
    DATA : lt_gidata  TYPE TABLE OF zmm_app10_tb1,
           lt_itmdata TYPE TABLE OF zmm_app10_tb2,
           ls_gidata  TYPE zmm_app10_tb1,
           ls_itmdata TYPE zmm_app10_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************

    MOVE-CORRESPONDING ls_header TO ls_gidata.
    ls_gidata-tckdate = cl_abap_context_info=>get_system_date(  ).
    ls_gidata-tcktime = cl_abap_context_info=>get_system_time(  ).
    SELECT SINGLE MAX( ticketnum ) FROM zmm_app10_rv INTO @DATA(lv_ticket).
    IF sy-subrc = 0 AND lv_ticket IS NOT INITIAL.
      ls_gidata-ticketnum = lv_ticket + 1.
    ELSE.
      ls_gidata-ticketnum = '3000000001'.
    ENDIF.
    APPEND ls_gidata TO  lt_gidata.
**********************************************************************
    zbp_mm_app10_rv=>gt_gidata = lt_gidata.

  ENDMETHOD.

  METHOD Upddata.
**********************************************************************
    DATA : lt_giupd TYPE TABLE OF zmm_app10_tb1,
           ls_giupd TYPE zmm_app10_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    IF ls_header-Ticketnum IS NOT INITIAL.
      MOVE-CORRESPONDING ls_header TO ls_giupd.
      ls_giupd-wgtunit = 'KG'.
      APPEND ls_giupd TO lt_giupd.
      zbp_mm_app10_rv=>gt_giupd = lt_giupd.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc__Poitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _Poitem RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _Poitem RESULT result.

    METHODS CrtIns FOR MODIFY
      IMPORTING keys FOR ACTION _Poitem~CrtIns RESULT result.

    METHODS InsRst FOR MODIFY
      IMPORTING keys FOR ACTION _Poitem~InsRst RESULT result.

    METHODS UpdItm FOR DETERMINE ON SAVE
      IMPORTING keys FOR _Poitem~UpdItm.

ENDCLASS.

CLASS lhc__Poitem IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
*    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
*            ENTITY _gihdr BY \_Item
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_items).
*    result = VALUE #( FOR ls_data IN lt_items
*  ( %tky =  ls_data-%tky
*  %action = VALUE #( CrtIns = COND #( WHEN ls_data-Inspectionlot IS INITIAL
*                                   THEN if_abap_behv=>fc-o-enabled
*                                   ELSE if_abap_behv=>fc-o-disabled )
*                      InsRst = COND #( WHEN ls_data-Inspectionlot IS NOT INITIAL AND ls_data-Insresult IS INITIAL
*                                   THEN if_abap_behv=>fc-o-enabled
*                                   ELSE if_abap_behv=>fc-o-disabled
*
*  ) ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CrtIns.
*    DATA : lt_itmupd TYPE TABLE OF zmm_app10_tb2,
*           ls_itmupd TYPE zmm_app10_tb2.
***********************************************************************
*    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
*            ENTITY _gihdr
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_pohdr)
*            ENTITY _gihdr BY \_Item
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_poline).
*    DATA(ls_pohdr) = lt_pohdr[ 1 ].
*    DATA(ls_key) = keys[ 1 ].
*    DATA(ls_poline) = lt_poline[ Uuid = ls_key-Uuid Ebelp = ls_key-Ebelp  ].
**    LOOP AT lt_poline INTO DATA(ls_poline) WHERE Uuid = ls_key-Uuid AND Ebelp = ls_key-Ebelp.
*    SELECT SINGLE * FROM I_Productplantqtmanagement WHERE Product = @ls_poline-Matnr AND plant = @ls_pohdr-Plant
*    INTO @DATA(ls_prodqm).
*    IF ls_prodqm-ProductPlantHasInspectionSetup = 'X'.
***********************************************************************
*      MODIFY ENTITY PRIVILEGED I_InspectionLotTP_2
*          CREATE FIELDS (   material plant inspectionlottype inspectionlotquantity )
*              WITH VALUE #( (
*                  %cid = 'CID_001'
*                  material = ls_poline-Matnr
*                  plant = ls_pohdr-Plant
*                  inspectionlottype = '89'
*                  inspectionlotquantity = ls_poline-Vdinvqty ) )
*          MAPPED DATA(ls_mapped_qm)
*          REPORTED DATA(ls_reported_qm)
*          FAILED DATA(ls_failed_qm).
*      IF ls_failed_qm IS INITIAL.
*        zbp_mm_app10_rv=>cv_insp_lot = ls_mapped_qm.
*        MOVE-CORRESPONDING ls_poline TO ls_itmupd.
*        DATA(ls_insplot) = ls_mapped_qm-inspectionlot[ 1 ].
*        ls_itmupd-inspectionlot = ls_insplot-InspectionLot.
*        APPEND ls_itmupd TO lt_itmupd.
*        CLEAR : ls_itmupd.
*      ENDIF.
*    ENDIF.
**    ENDLOOP.
*    zbp_mm_app10_rv=>gt_updinsp = lt_itmupd.
*    CLEAR lt_itmupd.
***********************************************************************
*    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
*            ENTITY _gihdr BY \_Item
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_hdr2).
*    result = VALUE #( FOR ls_ord IN lt_hdr2
*               ( %tky   = ls_ord-%tky
*                 %param = ls_ord ) ).

  ENDMETHOD.

  METHOD InsRst.
  ENDMETHOD.

  METHOD UpdItm.
**********************************************************************
    DATA : lt_itmupd TYPE TABLE OF zmm_app10_tb2,
           ls_itmupd TYPE zmm_app10_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_hdr)
            ENTITY _gihdr BY \_Item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_poitem).
    DATA(ls_hdr) = lt_hdr[ 1 ].

**********************************************************************
    LOOP AT lt_poitem INTO DATA(ls_poitem).
      ls_itmupd-bedat = cl_abap_context_info=>get_system_date(  ).
      SELECT SINGLE MAX( ebelp ) FROM zmm_app10_tb2 WHERE uuid = @ls_hdr-Uuid INTO @DATA(lv_line).
      IF lv_line IS NOT INITIAL AND sy-subrc = 0.
        ls_itmupd-ebelp = lv_line + 10.
      ELSE.
        ls_itmupd-ebelp = '0010'.
      ENDIF.

      ls_itmupd-matnr = ls_poitem-Matnr.
*      SELECT SINGLE * FROM I_ProductDescriptionTP_2 WHERE Product = @ls_poitem-Matnr INTO @DATA(ls_matdes).
      ls_itmupd-maktx = ls_poitem-Maktx.
      ls_itmupd-rcvunt = ls_poitem-Rcvunt.
      ls_itmupd-uuid = ls_hdr-Uuid.
      ls_itmupd-vdinvqty = ls_poitem-Vdinvqty.
      APPEND ls_itmupd TO lt_itmupd.
    ENDLOOP.
    zbp_mm_app10_rv=>gt_itmupd = lt_itmupd.
  ENDMETHOD.

ENDCLASS.

CLASS lhc__GOHDR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _gohdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _gohdr RESULT result.

    METHODS GetTare FOR MODIFY
      IMPORTING keys FOR ACTION _gohdr~GetTare RESULT result.

    METHODS PostGR FOR MODIFY
      IMPORTING keys FOR ACTION _gohdr~PostGR RESULT result.

    METHODS GetData2 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _gohdr~GetData2.

    METHODS Insprst FOR VALIDATE ON SAVE
      IMPORTING keys FOR _gohdr~Insprst.

ENDCLASS.

CLASS lhc__GOHDR IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
*    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
*            ENTITY _gohdr
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_status).
*    result = VALUE #( FOR ls_data IN lt_status
*  ( %tky =  ls_data-%tky
*    %action = VALUE #( GetTare = COND #( WHEN ls_data-Mark EQ ' ' OR ls_data-Mark EQ 'C'
*                                   THEN if_abap_behv=>fc-o-disabled
*                                   ELSE if_abap_behv=>fc-o-enabled )
*                       PostGR = COND #( WHEN ls_data-Mark EQ 'C'
*                                   THEN if_abap_behv=>fc-o-disabled
*                                   ELSE if_abap_behv=>fc-o-enabled
*  ) ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD GetTare.
  ENDMETHOD.

  METHOD PostGR.
**********************************************************************
    DATA : lt_gout TYPE TABLE OF zmm_app10_tb3,
           ls_gout TYPE zmm_app10_tb3.
***********************************************************************
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_pohdr)
            ENTITY _gihdr BY \_Item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_poitems)
            ENTITY _gihdr BY \_Gout
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_goutln).
    DATA(ls_pohdr) = lt_pohdr[ 1 ].
    DATA(ls_goutln) = lt_goutln[ 1 ].
**********************************************************************
    TRY.
        DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
      CATCH cx_abap_context_info_error.
        DATA(ls_v) = 1.
    ENDTRY.
**********************************************************************
    MODIFY ENTITIES OF i_materialdocumenttp PRIVILEGED
               ENTITY MaterialDocument
               CREATE FROM VALUE #( ( %cid                          = 'CID_001'
                                      goodsmovementcode             = '01'
                                      postingdate                   = lv_sydate
                                      documentdate                  = lv_sydate
*                                      ReferenceDocument             = ls_pohdr-Ebeln
                                      %control-goodsmovementcode                    = cl_abap_behv=>flag_changed
                                      %control-postingdate                          = cl_abap_behv=>flag_changed
                                      %control-documentdate                         = cl_abap_behv=>flag_changed
*                                      %control-ReferenceDocument                    = cl_abap_behv=>flag_changed
                                  ) )
               ENTITY MaterialDocument
               CREATE BY \_MaterialDocumentItem
               FROM VALUE #( FOR ls_poitem IN lt_poitems (
                               %cid_ref = 'CID_001'
                               %target = VALUE #( ( %cid                           = 'CID_ITM_0' && ls_poitem-Ebelp
                                                    plant                          = ls_pohdr-Plant
                                                    material                       = ls_poitem-Matnr
*                                                    Batch                          = ls_hdr-Batch
                                                    GoodsMovementType              = '101'
*                                                    storagelocation                = ls_hdr-Sloc
                                                    QuantityInEntryUnit            = ls_poitem-Vdinvqty
                                                    entryunit                      = ls_pohdr-Wgtunit
*                                                    PurchaseOrder                  = ls_pohdr-Ebeln
*                                                    PurchaseOrderItem              = ls_poitem-Ebelp
*                                                    GoodsMovementRefDocType        = 'B'
*                                                    IsCompletelyDelivered          = 'X'
                                                    %control-plant                 = cl_abap_behv=>flag_changed
                                                    %control-material              = cl_abap_behv=>flag_changed
                                                    %control-GoodsMovementType     = cl_abap_behv=>flag_changed
*                                                    %control-storagelocation       = cl_abap_behv=>flag_changed
                                                    %control-QuantityInEntryUnit   = cl_abap_behv=>flag_changed
                                                    %control-entryunit             = cl_abap_behv=>flag_changed
*                                                    %control-Batch                 = cl_abap_behv=>flag_changed
*                                                    %control-PurchaseOrder         = cl_abap_behv=>flag_changed
*                                                    %control-PurchaseOrderItem     = cl_abap_behv=>flag_changed
*                                                    %control-GoodsMovementRefDocType  = cl_abap_behv=>flag_changed
*                                                    %control-IsCompletelyDelivered  = cl_abap_behv=>flag_changed
                                                ) )                         ) )
               MAPPED   DATA(ls_create_mapped)
               FAILED   DATA(ls_create_failed)
               REPORTED DATA(ls_create_reported).
    IF ls_create_failed IS INITIAL.
      zbp_mm_app10_rv=>cv_mat_doc = ls_create_mapped.
      MOVE-CORRESPONDING ls_goutln TO ls_gout.
      ls_gout-mark = 'C'.
      APPEND ls_gout TO lt_gout.
      zbp_mm_app10_rv=>gt_goupd = lt_gout.
    ENDIF.

  ENDMETHOD.

  METHOD GetData2.
    DATA : lt_giupd  TYPE TABLE OF zmm_app10_tb1,
           lt_itmupd TYPE TABLE OF zmm_app10_tb2,
           ls_giupd  TYPE zmm_app10_tb1,
           ls_itmupd TYPE zmm_app10_tb2.
**********************************************************************
    DATA : lt_godata TYPE TABLE OF zmm_app10_tb3,
           ls_godata TYPE zmm_app10_tb3.
**********************************************************************
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gihdr BY \_Item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_inspsts).
*    DATA(lt_count) = lt_inspsts[].
*    DELETE lt_count WHERE Inspectionlot IS INITIAL.
*    DELETE lt_count WHERE insresult IS NOT INITIAL.
*    DATA(lv_lines) = lines( lt_count ).
*    IF lv_lines <= 0.
**********************************************************************
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gohdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_gorecd).
    DATA(ls_gorecd) = lt_gorecd[ 1 ].

**********************************************************************
    ls_godata-godate = cl_abap_context_info=>get_system_date(  ).
    ls_godata-gotime = cl_abap_context_info=>get_system_time(  ).
    ls_godata-ogrswgt = ls_header-Igrswgt.
    ls_godata-wgtunit = ls_header-Wgtunit.
    ls_godata-uuid = ls_header-Uuid.
    ls_godata-ticketnum = ls_header-Ticketnum.
    ls_godata-oitarewgt = ls_gorecd-Oitarewgt.
    ls_godata-onetwgt = ls_header-Igrswgt - ls_gorecd-Oitarewgt.
    APPEND ls_godata TO lt_godata.
    zbp_mm_app10_rv=>gt_godata = lt_godata.

*      READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
*              ENTITY _gihdr BY \_Item
*              ALL FIELDS WITH CORRESPONDING #( keys )
*              RESULT FINAL(lt_item).
*      DATA(lv_itmlns) = lines( lt_item ).
*      LOOP AT lt_item INTO DATA(ls_item).
*        MOVE-CORRESPONDING ls_header TO ls_giupd.
*        ls_giupd-itarewgt =  ls_gorecd-Oitarewgt.
*        ls_giupd-inetwgt = ls_giupd-igrswgt - ls_giupd-itarewgt.
*        APPEND ls_giupd TO lt_giupd.
**        IF lv_itmlns = 1.
*        MOVE-CORRESPONDING ls_item TO ls_itmupd.
*        ls_itmupd-vdinvqty = ls_giupd-inetwgt.
*        APPEND ls_itmupd TO lt_itmupd.
**        ENDIF.
*      ENDLOOP.
*      zbp_mm_app10_rv=>gt_itmupd = lt_itmupd.
*      zbp_mm_app10_rv=>gt_giupd = lt_giupd.

*    ENDIF.

  ENDMETHOD.

  METHOD Insprst.
**********************************************************************
    READ ENTITIES OF zmm_app10_rv IN LOCAL MODE
            ENTITY _gihdr BY \_Item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_inspsts).
    DATA(ls_poitm) = lt_inspsts[ 1 ].
    DATA(lt_count) = lt_inspsts[].
    DELETE lt_count WHERE Inspectionlot IS INITIAL.
    DELETE lt_count WHERE insresult IS NOT INITIAL.
    DATA(lv_lines) = lines( lt_count ).
    IF lv_lines > 0.
      APPEND VALUE #( %tky = ls_poitm-%tky ) TO failed-_poitem.
      APPEND VALUE #( %tky = ls_poitm-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Inspection Lot result missing' )
                     ) TO reported-_poitem.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_APP10_RV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_APP10_RV IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-_gihdr IS NOT INITIAL.
      IF zbp_mm_app10_rv=>gt_gidata IS NOT INITIAL.
        DATA(lt_gidata) = zbp_mm_app10_rv=>gt_gidata.
        MODIFY zmm_app10_tb1 FROM TABLE @lt_gidata.
      ENDIF.
*      IF zbp_mm_app10_rv=>gt_itmdata IS NOT INITIAL.
*        DATA(lt_itmdata) = zbp_mm_app10_rv=>gt_itmdata.
*        MODIFY zmm_app10_tb2 FROM TABLE @lt_itmdata.
*      ENDIF.
    ENDIF.
**********************************************************************
    IF create-_gohdr IS NOT INITIAL.
      IF zbp_mm_app10_rv=>gt_godata IS NOT INITIAL.
        DATA(lt_godata) = zbp_mm_app10_rv=>gt_godata.
        MODIFY zmm_app10_tb3 FROM TABLE @lt_godata.
      ENDIF.
    ENDIF.
**********************************************************************
*    IF create-_poitem IS NOT INITIAL.
    IF zbp_mm_app10_rv=>gt_itmupd IS NOT INITIAL.
      DATA(lt_itmupd) = zbp_mm_app10_rv=>gt_itmupd.
      MODIFY zmm_app10_tb2 FROM TABLE @lt_itmupd.
    ENDIF.
*    ENDIF.
**********************************************************************
    IF zbp_mm_app10_rv=>gt_giupd IS NOT INITIAL.
      DATA(lt_giupd) = zbp_mm_app10_rv=>gt_giupd.
      MODIFY zmm_app10_tb1 FROM TABLE @lt_giupd.
    ENDIF.
**********************************************************************
    IF zbp_mm_app10_rv=>gt_goupd IS NOT INITIAL.
      DATA(lt_goupd) = zbp_mm_app10_rv=>gt_goupd.
      MODIFY zmm_app10_tb3 FROM TABLE @lt_goupd.
    ENDIF.
**********************************************************************
*    IF zbp_mm_app10_rv=>gt_updinsp IS NOT INITIAL.
*      DATA(lt_updinsp) = zbp_mm_app10_rv=>gt_updinsp.
*      MODIFY zmm_app10_tb2 FROM TABLE @lt_updinsp.
*    ENDIF.
*************** Delete Root & Child entity records *******************
    IF delete-_gihdr IS NOT INITIAL.
      LOOP AT delete-_gihdr INTO DATA(ls_hdr).
        DELETE FROM zmm_app10_tb3 WHERE uuid = @ls_hdr-Uuid.
        DELETE FROM zmm_app10_tb2 WHERE uuid = @ls_hdr-Uuid.
        DELETE FROM zmm_app10_tb1 WHERE uuid = @ls_hdr-Uuid.
      ENDLOOP.
    ENDIF.
    IF delete-_poitem IS NOT INITIAL.
      LOOP AT delete-_poitem INTO DATA(ls_poitm).
        DELETE FROM zmm_app10_tb2 WHERE uuid = @ls_poitm-Uuid.
      ENDLOOP.
    ENDIF.
    IF delete-_gohdr IS NOT INITIAL.
      LOOP AT delete-_gohdr INTO DATA(ls_gohdr).
        DELETE FROM zmm_app10_tb3 WHERE uuid = @ls_gohdr-Uuid.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
