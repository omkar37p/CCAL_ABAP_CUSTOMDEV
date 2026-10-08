CLASS lhc__poitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS upditm FOR DETERMINE ON SAVE
      IMPORTING keys FOR _poitem~upditm.
    METHODS reqty FOR VALIDATE ON SAVE
      IMPORTING keys FOR _poitem~reqty.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _poitem RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _poitem RESULT result.

    METHODS crtins FOR MODIFY
      IMPORTING keys FOR ACTION _poitem~crtins RESULT result.
    METHODS insrst FOR MODIFY
      IMPORTING keys FOR ACTION _poitem~insrst RESULT result.

ENDCLASS.

CLASS lhc__poitem IMPLEMENTATION.

  METHOD upditm.
**********************************************************************
    DATA : lt_itmupd TYPE TABLE OF zmm_app04_tb2,
           ls_itmupd TYPE zmm_app04_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_poitem).
    lt_itmupd = VALUE #( FOR wa IN lt_poitem ( CORRESPONDING #( wa )  ) ).
    zbp_mm_app04_rv=>gt_itmupd = lt_itmupd.
  ENDMETHOD.

  METHOD reqty.
**********************************************************************
*    DATA : lt_itmupd TYPE TABLE OF zmm_app04_tb2,
*           ls_itmupd TYPE zmm_app04_tb2.
***********************************************************************
*    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
*            ENTITY _gihdr
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_gihdr)
*            ENTITY _gihdr BY \_Item
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_poitem).
*    DATA(lv_lines) = lines( lt_poitem ).
*
*    DATA(ls_poitem) = lt_poitem[ 1 ].
*    DATA(ls_gihdr) = lt_gihdr[ 1 ].
*    MOVE-CORRESPONDING ls_poitem TO ls_itmupd.
*    IF lv_lines = 1.
*      ls_itmupd-rcvqty = ls_gihdr-Inetwgt.
*      ls_itmupd-rcvunt  = 'KG'.
*    ENDIF.
*    APPEND ls_itmupd TO lt_itmupd.
*    zbp_mm_app04_rv=>gt_itmupd = lt_itmupd.

  ENDMETHOD.

  METHOD get_instance_features.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_items).
    result = VALUE #( FOR ls_data IN lt_items
  ( %tky =  ls_data-%tky
  %action = VALUE #( crtins = COND #( WHEN ls_data-inspectionlot IS INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                      insrst = COND #( WHEN ls_data-inspectionlot IS NOT INITIAL AND ls_data-insresult IS INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled

  ) ) ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD crtins.
    DATA : lt_itmupd TYPE TABLE OF zmm_app04_tb2,
           ls_itmupd TYPE zmm_app04_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_hdr)
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_poline).
    DATA(ls_key) = keys[ 1 ].
    DATA(ls_hdr) = lt_hdr[ 1 ].
    DATA(ls_poline) = lt_poline[ uuid = ls_key-uuid ebelp = ls_key-ebelp  ].
*    LOOP AT lt_poline INTO DATA(ls_poline) WHERE Uuid = ls_key-Uuid AND Ebelp = ls_key-Ebelp.
    SELECT SINGLE product,plant,productplanthasinspectionsetup FROM i_productplantqtmanagement WHERE product = @ls_poline-matnr AND plant = @ls_poline-werks
    INTO @DATA(ls_prodqm).
    IF ls_prodqm-productplanthasinspectionsetup = 'X'.
**********************************************************************
      MODIFY ENTITY PRIVILEGED i_inspectionlottp_2
          CREATE FIELDS (   material plant inspectionlottype inspectionlotquantity inspectionlottext )
              WITH VALUE #( (
                  %cid = 'CID_001'
                  material = ls_poline-matnr
                  plant = ls_poline-werks
                  inspectionlottype = '89'
                  inspectionlotquantity = ls_poline-actphqty
                  inspectionlottext = ls_hdr-vehicleno
                   ) )
          MAPPED DATA(ls_mapped_qm)
          REPORTED DATA(ls_reported_qm)
          FAILED DATA(ls_failed_qm).
      IF ls_failed_qm IS INITIAL.
        zbp_mm_app04_rv=>cv_insp_lot = ls_mapped_qm.
        MOVE-CORRESPONDING ls_poline TO ls_itmupd.
        DATA(ls_insplot) = ls_mapped_qm-inspectionlot[ 1 ].
        ls_itmupd-inspectionlot = ls_insplot-inspectionlot.
        APPEND ls_itmupd TO lt_itmupd.
        CLEAR : ls_itmupd.
      ENDIF.
    ENDIF.
*    ENDLOOP.
    zbp_mm_app04_rv=>gt_updinsp = lt_itmupd.
    CLEAR lt_itmupd.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_hdr2).
    result = VALUE #( FOR ls_ord IN lt_hdr2
               ( %tky   = ls_ord-%tky
                 %param = ls_ord ) ).

  ENDMETHOD.

  METHOD insrst.
    DATA : lt_itmupd TYPE TABLE OF zmm_app04_tb2,
           ls_itmupd TYPE zmm_app04_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_poline).
    DATA(ls_key) = keys[ 1 ].
    DATA(ls_poline) = lt_poline[ uuid = ls_key-uuid ebelp = ls_key-ebelp  ].
*    LOOP AT lt_poline INTO DATA(ls_poline).
    MOVE-CORRESPONDING ls_poline TO ls_itmupd.
    SELECT SINGLE i~*,t~* FROM i_insplotusagedecision AS i INNER JOIN i_usagedecisioncodetext AS t
    ON t~usagedecisioncodegroup = i~insplotusagedecisioncodegroup AND t~usagedecisioncode = i~inspectionlotusagedecisioncode AND t~language = 'E'
    WHERE inspectionlot = @ls_poline-inspectionlot INTO @DATA(ls_usage).
    IF sy-subrc = 0 AND NOT ls_usage IS INITIAL.
      ls_itmupd-insresult =  ls_usage-t-usagedecisioncodetext.
    ENDIF.
    APPEND ls_itmupd TO lt_itmupd.
*    ENDLOOP.
    zbp_mm_app04_rv=>gt_itmupd = lt_itmupd.
    CLEAR lt_itmupd.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_hdr2).
    result = VALUE #( FOR ls_ord IN lt_hdr2
               ( %tky   = ls_ord-%tky
                 %param = ls_ord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc__gohdr DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS getdata2 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _gohdr~getdata2.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _gohdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _gohdr RESULT result.

    METHODS postgr FOR MODIFY
      IMPORTING keys FOR ACTION _gohdr~postgr RESULT result.
    METHODS gettare FOR MODIFY
      IMPORTING keys FOR ACTION _gohdr~gettare RESULT result.
    METHODS insprst FOR VALIDATE ON SAVE
      IMPORTING keys FOR _gohdr~insprst.
    METHODS puttare FOR MODIFY
      IMPORTING keys FOR ACTION _gohdr~puttare RESULT result.
*    METHODS UpdGO FOR DETERMINE ON SAVE
*      IMPORTING keys FOR _gohdr~UpdGO.

ENDCLASS.

CLASS lhc__gohdr IMPLEMENTATION.

  METHOD getdata2.
    DATA : lt_giupd  TYPE TABLE OF zmm_app04_tb1,
           lt_itmupd TYPE TABLE OF zmm_app04_tb2,
           ls_giupd  TYPE zmm_app04_tb1,
           ls_itmupd TYPE zmm_app04_tb2.
    DATA ts_conv TYPE timestamp.
**********************************************************************
    DATA : lt_godata TYPE TABLE OF zmm_app04_tb3,
           ls_godata TYPE zmm_app04_tb3.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_inspsts).
    data(ls_count) = VALUE #( lt_inspsts[ 1 ] OPTIONAL ).

    DATA(lt_count) = lt_inspsts[].
    DELETE lt_count WHERE inspectionlot IS INITIAL.
    DELETE lt_count WHERE insresult IS NOT INITIAL.
    DATA(lv_lines) = lines( lt_count ).
*    IF lv_lines <= 0.
    IF ls_count-Inspectionlot is NOT INITIAL.

**********************************************************************
      READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
              ENTITY _gihdr
              ALL FIELDS WITH CORRESPONDING #( keys )
              RESULT FINAL(lt_header).
      DATA(ls_header) = lt_header[ 1 ].
      READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
              ENTITY _gohdr
              ALL FIELDS WITH CORRESPONDING #( keys )
              RESULT FINAL(lt_gorecd).
      DATA(ls_gorecd) = lt_gorecd[ 1 ].
**********************************************************************
*      TRY.
*          DATA(lv_sydate) = CONV d( xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value ).
*        CATCH cx_abap_context_info_error.
*          DATA(ls_v) = 1.
*      ENDTRY.
*      TRY.
*          DATA(lv_sytime) = CONV d( xco_cp=>sy->time( )->as( xco_cp_time=>format->abap )->value ).
*        CATCH cx_abap_context_info_error.
*          DATA(ls_v1) = 1.
*      ENDTRY.
**********************************************************************
      ls_godata-drivername = ls_header-drivername.
**********************************************************************
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
      ls_godata-godate = cl_abap_context_info=>get_system_date( ).
      ls_godata-gotim = lv_time.
**********************************************************************
*      CONVERT DATE ls_godata-godate
*          TIME ls_godata-gotime
*          INTO TIME STAMP ts_conv
*          TIME ZONE 'IST'.
      ls_godata-lrnumber = ls_header-lrnumber.
      ls_godata-ogrswgt = ls_header-igrswgt.
      ls_godata-pcklistid = ls_gorecd-pcklistid .
      ls_godata-wgtunit = ls_header-wgtunit.
      ls_godata-vhlistid = ls_gorecd-vhlistid.
      ls_godata-veninvno = ls_header-veninvno.
      ls_godata-vehicleno = ls_header-vehicleno.
      ls_godata-uuid = ls_header-uuid.
      ls_godata-trspname = ls_header-trspname.
      ls_godata-trspmode = ls_header-trspmode.
      ls_godata-trcuktyp = ls_header-trcuktyp.
      ls_godata-ticketnum = ls_header-ticketnum.
      ls_godata-cylinder = ls_gorecd-cylinder.
      ls_godata-concrate = ls_gorecd-concrate.
      ls_godata-oitarewgt = ls_gorecd-oitarewgt.
      ls_godata-onetwgt = ls_header-igrswgt - ls_gorecd-oitarewgt.
      APPEND ls_godata TO lt_godata.
      zbp_mm_app04_rv=>gt_godata = lt_godata.
*      zbp_mm_app04_rv=>gt_goupd2 = lt_godata.
**********************************************************************
      READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
              ENTITY _gihdr BY \_item
              ALL FIELDS WITH CORRESPONDING #( keys )
              RESULT FINAL(lt_item).
      DATA(lv_itmlns) = lines( lt_item ).
      LOOP AT lt_item INTO DATA(ls_item).
        MOVE-CORRESPONDING ls_header TO ls_giupd.
        ls_giupd-itarewgt =  ls_gorecd-oitarewgt.
        ls_giupd-inetwgt = ls_giupd-igrswgt - ls_giupd-itarewgt.
        APPEND ls_giupd TO lt_giupd.
        IF lv_itmlns = 1.
          MOVE-CORRESPONDING ls_item TO ls_itmupd.
          ls_itmupd-rcvqty = ls_giupd-inetwgt.
          APPEND ls_itmupd TO lt_itmupd.
        ENDIF.
      ENDLOOP.
      zbp_mm_app04_rv=>gt_itmupd = lt_itmupd.
      zbp_mm_app04_rv=>gt_giupd = lt_giupd.

    ENDIF.
  ENDMETHOD.

  METHOD get_instance_features.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gohdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_status).
    result = VALUE #( FOR ls_data IN lt_status
  ( %tky =  ls_data-%tky

  %action = VALUE #(
                    gettare = COND #( WHEN ls_data-ticketnum EQ ' ' OR ls_data-mark EQ 'C'
                                   THEN if_abap_behv=>fc-o-disabled
                                   ELSE if_abap_behv=>fc-o-enabled )
                    puttare = COND #( WHEN ls_data-ticketnum EQ ' ' OR ls_data-mark EQ 'C'
                                   THEN if_abap_behv=>fc-o-disabled
                                   ELSE if_abap_behv=>fc-o-enabled )
                    postgr = COND #( WHEN ls_data-ticketnum EQ ' ' OR ls_data-mark EQ 'C'
                                   THEN if_abap_behv=>fc-o-disabled
                                   ELSE if_abap_behv=>fc-o-enabled
  ) ) ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD postgr.
**********************************************************************
    DATA : lt_gout TYPE TABLE OF zmm_app04_tb3,
           ls_gout TYPE zmm_app04_tb3.
***********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_pohdr)
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_poitems)
            ENTITY _gihdr BY \_gout
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
               ENTITY materialdocument
               CREATE FROM VALUE #( ( %cid                          = 'CID_001'
                                      goodsmovementcode             = '01'
                                      postingdate                   = lv_sydate
                                      documentdate                  = lv_sydate
                                      referencedocument             = ls_pohdr-ebeln
                                      %control-goodsmovementcode                    = cl_abap_behv=>flag_changed
                                      %control-postingdate                          = cl_abap_behv=>flag_changed
                                      %control-documentdate                         = cl_abap_behv=>flag_changed
                                      %control-referencedocument                    = cl_abap_behv=>flag_changed
                                  ) )
               ENTITY materialdocument
               CREATE BY \_materialdocumentitem
               FROM VALUE #( FOR ls_poitem IN lt_poitems (
                               %cid_ref = 'CID_001'
                               %target = VALUE #( ( %cid                           = 'CID_ITM_0' && ls_poitem-ebelp
*                                                    plant                          = ls_poitem-
                                                    material                       = ls_poitem-matnr
*                                                    Batch                          = ls_hdr-Batch
                                                    goodsmovementtype              = '101'
*                                                    storagelocation                = ls_hdr-Sloc
                                                    quantityinentryunit            = ls_poitem-rcvqty
                                                    entryunit                      = ls_pohdr-wgtunit
                                                    purchaseorder                  = ls_pohdr-ebeln
                                                    purchaseorderitem              = ls_poitem-ebelp
                                                    goodsmovementrefdoctype        = 'B'
*                                                    IsCompletelyDelivered          = 'X'
                                                    materialdocumentitemtext       = ls_pohdr-ticketnum
*                                                    %control-plant                 = cl_abap_behv=>flag_changed
                                                    %control-material              = cl_abap_behv=>flag_changed
                                                    %control-goodsmovementtype     = cl_abap_behv=>flag_changed
*                                                    %control-storagelocation       = cl_abap_behv=>flag_changed
                                                    %control-quantityinentryunit   = cl_abap_behv=>flag_changed
                                                    %control-entryunit             = cl_abap_behv=>flag_changed
*                                                    %control-Batch                 = cl_abap_behv=>flag_changed
                                                    %control-purchaseorder         = cl_abap_behv=>flag_changed
                                                    %control-purchaseorderitem     = cl_abap_behv=>flag_changed
                                                    %control-goodsmovementrefdoctype  = cl_abap_behv=>flag_changed
                                                    %control-materialdocumentitemtext = cl_abap_behv=>flag_changed
*                                                    %control-IsCompletelyDelivered  = cl_abap_behv=>flag_changed
                                                ) )                         ) )
               MAPPED   DATA(ls_create_mapped)
               FAILED   DATA(ls_create_failed)
               REPORTED DATA(ls_create_reported).
    IF ls_create_failed IS INITIAL.
      zbp_mm_app04_rv=>cv_mat_doc = ls_create_mapped.
      MOVE-CORRESPONDING ls_goutln TO ls_gout.
      ls_gout-mark = 'C'.
      APPEND ls_gout TO lt_gout.
      zbp_mm_app04_rv=>gt_goupd = lt_gout.
    ENDIF.

  ENDMETHOD.

  METHOD gettare.
**********************************************************************
    DATA : lt_goupd  TYPE TABLE OF zmm_app04_tb3,
           ls_goupd  TYPE zmm_app04_tb3,
           lt_giupd  TYPE TABLE OF zmm_app04_tb1,
           ls_giupd  TYPE zmm_app04_tb1,
           lv_weight TYPE zmm_app04_tb1-igrswgt.
    DATA ts_conv TYPE timestamp.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_gihdr)
            ENTITY _gihdr BY \_gout
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_gout).
    DATA(ls_gout) = lt_gout[ 1 ].
    DATA(ls_gihdr) = lt_gihdr[ 1 ].
**********************************************************************
    """ HTTP Communication via URL   """

    DATA: lv_request_string TYPE string,
          lo_hhtp_response  TYPE REF TO if_web_http_response.
    DATA: lo_http_destination TYPE REF TO if_http_destination,
          lo_http_client      TYPE REF TO if_web_http_client,
          lv_response         TYPE string.
    "  static link
*    lv_request_string = |https://absolutely-golden-viper.ngrok-free.app/run-exe| .
    lv_request_string = |https://monitor-fond-boxer.ngrok-free.app/run-exe|.

**********************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
        " adding Header fields

        lo_http_client->get_http_request(  )->set_header_fields( VALUE #( ( name = if_web_http_header=>content_type value = if_web_http_header=>accept_application_json )
                                                                           ( name = if_web_http_header=>accept      value = if_web_http_header=>accept_application_json  ) ) ).

        " execute HTTP POST-request and store response
        lo_hhtp_response = lo_http_client->execute( if_web_http_client=>post ).

        DATA(ls_status) = lo_hhtp_response->get_status(  ).

        lv_response = lo_hhtp_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error).
*        RAISE EXCEPTION TYPE cx_web_http_client_error.
*        DATA(lv_1) = 1.
*        RAISE EXCEPTION TYPE cx_http_dest_provider_error.
        DATA(lv_2) = 2.
    ENDTRY.
***********************************************************************
if ls_status-code = '200'.

    IF lv_response IS NOT INITIAL.
*      SPLIT lv_response AT '+' INTO DATA(lv_text1) DATA(lv_text2).
*      SPLIT lv_text2 AT '.' INTO DATA(lv_wgtval) DATA(lv_text3).

      SPLIT lv_response AT 'AM:' INTO DATA(lv_text4) DATA(lv_text5).

      if lv_text5 is iNITIAL.
      SPLIT lv_response AT 'PM:' INTO lv_text4 lv_text5.
      endif.

      SPLIT lv_text5 AT '\n' INTO DATA(lv_wgtval) DATA(lv_text6).
      CONDENSE lv_wgtval.
***********************************************************************
    if ( lv_wgtval = '00000' or lv_wgtval = '00010' or lv_wgtval = 'Error in weight' ).

      APPEND VALUE #( %tky = ls_gihdr-%tky ) TO failed-_gihdr.
      APPEND VALUE #( %tky = ls_gihdr-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'No Vehicle in Weight Machine' )
                               ) TO reported-_gihdr.

    else.
***********************************************************************
      lv_weight = lv_wgtval.
      lv_weight = lv_weight / 1000.
      MOVE-CORRESPONDING ls_gout TO ls_goupd.
      MOVE-CORRESPONDING ls_gihdr TO ls_giupd.

      ls_goupd-oitarewgt = lv_weight.
*      ls_goupd-wgtunit = 'KG'.
      ls_goupd-wgtunit = 'TO'.
**********************************************************************
         GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
      ls_goupd-wghgodate = cl_abap_context_info=>get_system_date( ).
      ls_goupd-wghgotim = lv_time.
**********************************************************************
*      CONVERT DATE ls_goupd-wghgodate
*              TIME ls_goupd-wghgotime
*              INTO TIME STAMP ts_conv
*              TIME ZONE 'IST'.
      ls_goupd-onetwgt = ls_goupd-ogrswgt - ls_goupd-oitarewgt.
      APPEND ls_goupd TO lt_goupd.
      ls_giupd-itarewgt = ls_goupd-oitarewgt.
      ls_giupd-inetwgt = ls_giupd-igrswgt - ls_goupd-oitarewgt.
      APPEND ls_giupd TO lt_giupd.
      zbp_mm_app04_rv=>gt_goupd = lt_goupd.
      zbp_mm_app04_rv=>gt_giupd = lt_giupd.

    ENDIF.
endif.
***********************************************************************
else.

      APPEND VALUE #( %tky = ls_gihdr-%tky ) TO failed-_gihdr.
      APPEND VALUE #( %tky = ls_gihdr-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'Re-Start the Weight Machine Apps' )
                               ) TO reported-_gihdr.

enDIF.
***********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
    ENTITY _gohdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_hdr2).
    result = VALUE #( FOR ls_ord IN lt_hdr2
                   ( %tky   = ls_ord-%tky
                     %param = ls_ord ) ).

***********************************************************************
  ENDMETHOD.

*  METHOD UpdGO.
**********************************************************************
*    DATA : lt_giupd  TYPE TABLE OF zmm_app04_tb1,
*           lt_itmupd TYPE TABLE OF zmm_app04_tb2,
*           lt_goupd  TYPE TABLE OF zmm_app04_tb3,
*           ls_giupd  TYPE zmm_app04_tb1,
*           ls_itmupd TYPE zmm_app04_tb2,
*           ls_goupd  TYPE zmm_app04_tb3.
***********************************************************************
*    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
*            ENTITY _gihdr
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_header).
*    DATA(ls_header) = lt_header[ 1 ].
*    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
*            ENTITY _gihdr BY \_Item
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_item).
*    DATA(ls_item) = lt_item[ 1 ].
*    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
*            ENTITY _gihdr BY \_Gout
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_gout).
*    DATA(ls_gout) = lt_gout[ 1 ].
*    MOVE-CORRESPONDING ls_gout TO ls_goupd.
*    ls_goupd-onetwgt = ls_goupd-ogrswgt - ls_goupd-oitarewgt.
*    APPEND ls_goupd TO lt_goupd.
*    MOVE-CORRESPONDING ls_header TO ls_giupd.
*    ls_giupd-itarewgt =  ls_goupd-oitarewgt.
*    ls_giupd-inetwgt = ls_giupd-igrswgt - ls_giupd-itarewgt.
*    APPEND ls_giupd TO lt_giupd.
*    MOVE-CORRESPONDING ls_item TO ls_itmupd.
*    ls_itmupd-rcvqty = ls_giupd-inetwgt.
*    APPEND ls_itmupd TO lt_itmupd.
*    IF ls_header-Ticketnum IS NOT INITIAL.
*    zbp_mm_app04_rv=>gt_itmupd = lt_itmupd.
*    zbp_mm_app04_rv=>gt_giupd = lt_giupd.
*    zbp_mm_app04_rv=>gt_goupd = lt_goupd.
*    ENDIF.
*  ENDMETHOD.

  METHOD insprst.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_inspsts).
    DATA(ls_poitm) = lt_inspsts[ 1 ].
    DATA(lt_count) = lt_inspsts[].
    DELETE lt_count WHERE inspectionlot IS INITIAL.
    DELETE lt_count WHERE insresult IS NOT INITIAL.
    DATA(lv_lines) = lines( lt_count ).
*    IF lv_lines > 0.
    IF ls_poitm-Inspectionlot is INITIAL.

      APPEND VALUE #( %tky = ls_poitm-%tky ) TO failed-_poitem.
      APPEND VALUE #( %tky = ls_poitm-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                    text = 'Inspection Lot result missing' )
                                                    text = 'Inspection Lot missing' )
                     ) TO reported-_poitem.
    ENDIF.
  ENDMETHOD.

  METHOD puttare.
**********************************************************************
    DATA : lt_goupd  TYPE TABLE OF zmm_app04_tb3,
           ls_goupd  TYPE zmm_app04_tb3,
           lt_giupd  TYPE TABLE OF zmm_app04_tb1,
           ls_giupd  TYPE zmm_app04_tb1,
           lt_itmupd TYPE TABLE OF zmm_app04_tb2,
           ls_itmupd TYPE zmm_app04_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_gihdr)
            ENTITY _gihdr BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_item)
            ENTITY _gohdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    DATA(ls_gihdr) = lt_gihdr[ 1 ].
    DATA(lt_keys) = keys.
    DATA(ls_keys) = lt_keys[ 1 ].
    MOVE-CORRESPONDING ls_header TO ls_goupd.
    MOVE-CORRESPONDING ls_gihdr TO ls_giupd.
    ls_goupd-oitarewgt = ls_keys-%param-weight.
    ls_goupd-wgtunit = ls_keys-%param-unit.
**********************************************************************
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
    ls_goupd-wghgodate = cl_abap_context_info=>get_system_date( ).
    ls_goupd-wghgotim = lv_time.
**********************************************************************
    ls_goupd-onetwgt = ls_goupd-ogrswgt - ls_goupd-oitarewgt.
    APPEND ls_goupd TO lt_goupd.
    ls_giupd-itarewgt = ls_goupd-oitarewgt.
    ls_giupd-inetwgt = ls_giupd-igrswgt - ls_goupd-oitarewgt.
    APPEND ls_giupd TO lt_giupd.
    zbp_mm_app04_rv=>gt_goupd = lt_goupd.
    zbp_mm_app04_rv=>gt_giupd = lt_giupd.
**********************************************************************
    DATA(lv_itmlns) = lines( lt_item ).
    IF lv_itmlns = 1.
      DATA(ls_item) = lt_item[ 1 ].
      MOVE-CORRESPONDING ls_item TO ls_itmupd.
      ls_itmupd-rcvqty = ls_giupd-inetwgt.
      APPEND ls_itmupd TO lt_itmupd.
    ENDIF.
    zbp_mm_app04_rv=>gt_itmupd = lt_itmupd.
**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc__gihdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _gihdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _gihdr RESULT result.

    METHODS getgross FOR MODIFY
      IMPORTING keys FOR ACTION _gihdr~getgross RESULT result.

    METHODS getdata1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR _gihdr~getdata1.
    METHODS upddata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _gihdr~upddata.
    METHODS putgross FOR MODIFY
      IMPORTING keys FOR ACTION _gihdr~putgross RESULT result.
*    METHODS CrtIns FOR MODIFY
*      IMPORTING keys FOR ACTION _gihdr~CrtIns RESULT result.

ENDCLASS.

CLASS lhc__gihdr IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
*    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
*            ENTITY _gihdr
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_status)
*            ENTITY _gihdr BY \_Item
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_items).
*    result = VALUE #( FOR ls_data IN lt_status
*  ( %tky =  ls_data-%tky
***        %features-%action-Edit = COND #( WHEN ls_data-status EQ 'X'
***                                            THEN if_abap_behv=>fc-o-disabled
***                                            ELSE if_abap_behv=>fc-o-enabled
**         )
*
*  %action = VALUE #( GetGross = COND #( WHEN ls_data-Mark EQ ' '
*                                   THEN if_abap_behv=>fc-o-disabled
*                                   ELSE if_abap_behv=>fc-o-enabled
*  ) ) ) ).
*
**    result = VALUE #( FOR ls_items IN lt_items
**     ( %tky =  ls_items-%tky
**    %action = VALUE #( GetGross = COND #( WHEN ls_data-Mark EQ ' '
**                                       THEN if_abap_behv=>fc-o-disabled
**                                       ELSE if_abap_behv=>fc-o-enabled
**    ) ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getgross.
*********************************************************************
    DATA : lt_giupd  TYPE TABLE OF zmm_app04_tb1,
           ls_giupd  TYPE zmm_app04_tb1,
           lv_weight TYPE zmm_app04_tb1-igrswgt.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    """ HTTP Communication via URL   """

    DATA: lv_request_string TYPE string,
          lo_hhtp_response  TYPE REF TO if_web_http_response.
    DATA: lo_http_destination TYPE REF TO if_http_destination,
          lo_http_client      TYPE REF TO if_web_http_client,
          lv_response         TYPE string.
    "  static link
*    lv_request_string = |https://absolutely-golden-viper.ngrok-free.app/run-exe| .
    lv_request_string = |https://monitor-fond-boxer.ngrok-free.app/run-exe|.

**********************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
        " adding Header fields

        lo_http_client->get_http_request(  )->set_header_fields( VALUE #( ( name = if_web_http_header=>content_type value = if_web_http_header=>accept_application_json )
                                                                           ( name = if_web_http_header=>accept      value = if_web_http_header=>accept_application_json  ) ) ).

        " execute HTTP POST-request and store response
        lo_hhtp_response = lo_http_client->execute( if_web_http_client=>post ).

        DATA(ls_status) = lo_hhtp_response->get_status(  ).

        lv_response = lo_hhtp_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error).
*        RAISE EXCEPTION TYPE cx_web_http_client_error.
*        DATA(lv_1) = 1.
*        RAISE EXCEPTION TYPE cx_http_dest_provider_error.
        DATA(lv_2) = 2.
    ENDTRY.
***********************************************************************
* test case
*        lv_response = '{"data":"2026-03-09 06 18:03:26 PM: 50000\n","status":"success"}'.
*        lv_response = '{"data":"2026-03-10 11 11:04:00 AM: Error in weight\n","status":"success"}'.
***********************************************************************
if ls_status-code = '200'.

    IF lv_response IS NOT INITIAL.
*      SPLIT lv_response AT '+' INTO DATA(lv_text1) DATA(lv_text2).
*      SPLIT lv_text2 AT '.' INTO DATA(lv_wgtval) DATA(lv_text3).

      SPLIT lv_response AT 'AM:' INTO DATA(lv_text4) DATA(lv_text5).

      if lv_text5 is iNITIAL.
      SPLIT lv_response AT 'PM:' INTO lv_text4 lv_text5.
      endif.

      SPLIT lv_text5 AT '\n' INTO DATA(lv_wgtval) DATA(lv_text6).
      CONDENSE lv_wgtval.
***********************************************************************
    if ( lv_wgtval = '00000' or lv_wgtval = '00010' or lv_wgtval = 'Error in weight' ).

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-_gihdr.
      APPEND VALUE #( %tky = ls_header-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'No Vehicle in Weight Machine' )
                               ) TO reported-_gihdr.

    else.
***********************************************************************
      lv_weight = lv_wgtval.
      lv_weight = lv_weight / 1000.

      MOVE-CORRESPONDING ls_header TO ls_giupd.
      GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
      ls_giupd-igrswgt = lv_weight.
*      ls_giupd-wgtunit = 'KG'.
      ls_giupd-wgtunit = 'TO'.
**********************************************************************
      ls_giupd-grsdate = cl_abap_context_info=>get_system_date( ).
      ls_giupd-grstim = lv_time.
**********************************************************************
      APPEND ls_giupd TO lt_giupd.
      zbp_mm_app04_rv=>gt_giupd = lt_giupd.

    ENDIF.
    endif.
***********************************************************************

else.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-_gihdr.
      APPEND VALUE #( %tky = ls_header-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'Re-Start the Weight Machine Apps' )
                               ) TO reported-_gihdr.
endif.
***********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
    ENTITY _gihdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_hdr2).
    result = VALUE #( FOR ls_ord IN lt_hdr2
                   ( %tky   = ls_ord-%tky
                     %param = ls_ord ) ).

***********************************************************************
  ENDMETHOD.

  METHOD getdata1.
**********************************************************************
    DATA : lt_gidata  TYPE TABLE OF zmm_app04_tb1,
           lt_itmdata TYPE TABLE OF zmm_app04_tb2,
           ls_gidata  TYPE zmm_app04_tb1,
           ls_itmdata TYPE zmm_app04_tb2.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
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

    MOVE-CORRESPONDING ls_header TO ls_gidata.
*****************************OLD*****************************************
*    ls_gidata-tckdate = lv_sydate.
*    ls_gidata-tcktime = lv_sytime.
*****************************OLD****************************************
********************ADDED BY OMKAR ***********************
 GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
**********************************************************************

*****************************ADDED BY OMKAR *****************************************
    ls_gidata-tckdate = lv_date.
    ls_gidata-tcktim = lv_time.
**********************************************************************
    SELECT SINGLE MAX( ticketnum ) FROM zmm_app04_rv INTO @DATA(lv_ticket).
    IF sy-subrc = 0 AND lv_ticket IS NOT INITIAL.
      ls_gidata-ticketnum = lv_ticket + 1.
    ELSE.
      ls_gidata-ticketnum = '2000000001'.
    ENDIF.
    APPEND ls_gidata TO  lt_gidata.
**********************************************************************
    IF ls_header-ebeln IS NOT INITIAL.
      READ ENTITIES OF i_purchaseordertp_2 PRIVILEGED
       ENTITY purchaseorder
       FROM VALUE #( ( purchaseorder = ls_header-ebeln  ) )
       RESULT DATA(lt_pohdr).
      DATA(ls_pohdr) = lt_pohdr[ 1 ].
      SELECT SINGLE supplier, suppliername FROM i_supplier WHERE supplier = @ls_pohdr-supplier
      INTO @DATA(ls_suppname).

      READ ENTITIES OF i_purchaseordertp_2 PRIVILEGED
      ENTITY purchaseorder BY \_purchaseorderitem
      FROM VALUE #( ( purchaseorder = ls_header-ebeln  ) )
      RESULT DATA(lt_poitem).

      LOOP AT lt_poitem INTO DATA(ls_podata) WHERE iscompletelydelivered NE 'X'.
        ls_itmdata-bedat = ls_pohdr-purchaseorderdate.
        ls_itmdata-ebelp = ls_podata-purchaseorderitem.
        ls_itmdata-lifnr = ls_pohdr-supplier.
        ls_itmdata-suppname = ls_suppname-suppliername.
        ls_itmdata-matnr = ls_podata-material.
        SELECT SINGLE * FROM i_productdescription WHERE product = @ls_podata-material
        INTO @DATA(ls_matdesc).
        ls_itmdata-maktx = ls_matdesc-productdescription.
        ls_itmdata-meins = ls_podata-baseunit.
        ls_itmdata-poqty = ls_podata-orderquantity.
        ls_itmdata-uuid = ls_header-uuid.
        ls_itmdata-rcvunt = 'KG'.
        ls_itmdata-werks = ls_podata-plant.
        APPEND ls_itmdata TO lt_itmdata.
      ENDLOOP.
    ELSE.

    ENDIF.

    zbp_mm_app04_rv=>gt_gidata = lt_gidata.
    zbp_mm_app04_rv=>gt_itmdata = lt_itmdata.
  ENDMETHOD.

  METHOD upddata.
**********************************************************************
    DATA : lt_giupd TYPE TABLE OF zmm_app04_tb1,
           ls_giupd TYPE zmm_app04_tb1.
**********************************************************************
    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    IF ls_header-ticketnum IS NOT INITIAL.
      MOVE-CORRESPONDING ls_header TO ls_giupd.
      ls_giupd-wgtunit = 'KG'.
      APPEND ls_giupd TO lt_giupd.
      zbp_mm_app04_rv=>gt_giupd = lt_giupd.
    ENDIF.
  ENDMETHOD.

  METHOD putgross.
**********************************************************************
    DATA : lt_giupd TYPE TABLE OF zmm_app04_tb1,
           ls_giupd TYPE zmm_app04_tb1.

    READ ENTITIES OF zmm_app04_rv IN LOCAL MODE
            ENTITY _gihdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
    DATA(lt_keys) = keys.
    DATA(ls_keys) = lt_keys[ 1 ].
    MOVE-CORRESPONDING ls_header TO ls_giupd.
    ls_giupd-igrswgt = ls_keys-%param-weight.
    ls_giupd-wgtunit = ls_keys-%param-unit.
**********************************************************************
*    ls_giupd-grsdate = cl_abap_context_info=>get_system_date( ).
*    ls_giupd-grstime = cl_abap_context_info=>get_system_time(  ).
**********************************************************************
******************************OMKAR****************************************
 GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
**********************************************************************
   ls_giupd-grsdate = lv_date.
   ls_giupd-grstim = lv_time.
**********************************************************************
    APPEND ls_giupd TO lt_giupd.
    zbp_mm_app04_rv=>gt_giupd = lt_giupd.
**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app04_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app04_rv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
    IF create-_gihdr IS NOT INITIAL.
      IF zbp_mm_app04_rv=>gt_gidata IS NOT INITIAL.
        DATA(lt_gidata) = zbp_mm_app04_rv=>gt_gidata.
        MODIFY zmm_app04_tb1 FROM TABLE @lt_gidata.
      ENDIF.
      IF zbp_mm_app04_rv=>gt_itmdata IS NOT INITIAL.
        DATA(lt_itmdata) = zbp_mm_app04_rv=>gt_itmdata.
        MODIFY zmm_app04_tb2 FROM TABLE @lt_itmdata.
      ENDIF.
    ENDIF.
**********************************************************************
    IF create-_gohdr IS NOT INITIAL.
      IF zbp_mm_app04_rv=>gt_godata IS NOT INITIAL.
        DATA(lt_godata) = zbp_mm_app04_rv=>gt_godata.
        MODIFY zmm_app04_tb3 FROM TABLE @lt_godata.
      ENDIF.
    ENDIF.
**********************************************************************
*    IF update-_poitem IS NOT INITIAL.
    IF zbp_mm_app04_rv=>gt_itmupd IS NOT INITIAL.
      DATA(lt_itmupd) = zbp_mm_app04_rv=>gt_itmupd.
      MODIFY zmm_app04_tb2 FROM TABLE @lt_itmupd.
    ENDIF.
*    ENDIF.
**********************************************************************
    IF zbp_mm_app04_rv=>gt_giupd IS NOT INITIAL.
      DATA(lt_giupd) = zbp_mm_app04_rv=>gt_giupd.
      MODIFY zmm_app04_tb1 FROM TABLE @lt_giupd.
    ENDIF.
**********************************************************************
*    IF update-_gohdr IS NOT INITIAL.
    IF zbp_mm_app04_rv=>gt_goupd2 IS NOT INITIAL.
      DATA(lt_goupd2) = zbp_mm_app04_rv=>gt_goupd2.
      MODIFY zmm_app04_tb3 FROM TABLE @lt_goupd2.
    ENDIF.
*    ENDIF.
**********************************************************************
    IF zbp_mm_app04_rv=>gt_goupd IS NOT INITIAL.
      DATA(lt_goupd) = zbp_mm_app04_rv=>gt_goupd.
      MODIFY zmm_app04_tb3 FROM TABLE @lt_goupd.
    ENDIF.
**********************************************************************
*    IF zbp_mm_app04_rv=>cv_insp_lot IS NOT INITIAL.
*      LOOP AT zbp_mm_app04_rv=>cv_insp_lot-inspectionlot ASSIGNING FIELD-SYMBOL(<fs_lot_mapped>).
**        CONVERT KEY OF I_InspectionLotTP_2 FROM <fs_lot_mapped>-%pid TO DATA(ls_lot_key).
*      ENDLOOP.
    IF zbp_mm_app04_rv=>gt_updinsp IS NOT INITIAL.
      DATA(lt_updinsp) = zbp_mm_app04_rv=>gt_updinsp.
*        LOOP AT lt_updinsp ASSIGNING FIELD-SYMBOL(<fs_upd>).
*          <fs_upd>-inspectionlot = <fs_lot_mapped>-InspectionLot.
*        ENDLOOP.
      MODIFY zmm_app04_tb2 FROM TABLE @lt_updinsp.
    ENDIF.
*    ENDIF.
*************** Delete Root & Child entity records *******************
    IF delete-_gihdr IS NOT INITIAL.
      LOOP AT delete-_gihdr INTO DATA(ls_hdr).
        DELETE FROM zmm_app04_tb3 WHERE uuid = @ls_hdr-uuid.
        DELETE FROM zmm_app04_tb2 WHERE uuid = @ls_hdr-uuid.
        DELETE FROM zmm_app04_tb1 WHERE uuid = @ls_hdr-uuid.
      ENDLOOP.
    ENDIF.
    IF delete-_poitem IS NOT INITIAL.
      LOOP AT delete-_poitem INTO DATA(ls_poitm).
        DELETE FROM zmm_app04_tb2 WHERE uuid = @ls_poitm-uuid.
      ENDLOOP.
    ENDIF.
    IF delete-_gohdr IS NOT INITIAL.
      LOOP AT delete-_gohdr INTO DATA(ls_gohdr).
        DELETE FROM zmm_app04_tb3 WHERE uuid = @ls_gohdr-uuid.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
