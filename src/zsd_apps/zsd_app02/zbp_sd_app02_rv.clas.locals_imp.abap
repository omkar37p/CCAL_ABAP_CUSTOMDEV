CLASS lhc_gatein DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR gatein RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR gatein RESULT result.

    METHODS gettare FOR MODIFY
      IMPORTING keys FOR ACTION gatein~gettare RESULT result.

    METHODS getdata1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR gatein~getdata1.

    METHODS gettareurl FOR MODIFY
      IMPORTING keys FOR ACTION gatein~gettareurl RESULT result.
    METHODS mandatory FOR VALIDATE ON SAVE
      IMPORTING keys FOR gatein~mandatory.

ENDCLASS.

CLASS lhc_gatein IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
    DATA: lv_delmrk TYPE c.

    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
            ENTITY gatein
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_status).
    DATA(ls_hdr) = lt_status[ 1 ].
**********************************************************************
********* Verify delivery Status & User, before deletion *************
    TRY.
        DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
      CATCH cx_abap_context_info_error INTO DATA(lv_error).
      data(lv_1) = 1.
    ENDTRY.
**********************************************************************
    SELECT SINGLE uuid, tokennum, delvnum  FROM zsd_app02_tb2 WHERE uuid = @ls_hdr-uuid INTO @DATA(ls_pckslp).
    IF sy-subrc = 0.
      IF ls_pckslp-delvnum IS NOT INITIAL.
        SELECT SINGLE deliverydocument, deletionindicator FROM i_deliverydocument WHERE deliverydocument = @ls_pckslp-delvnum INTO @DATA(ls_dlvdoc).
        IF ls_dlvdoc-deletionindicator IS NOT INITIAL.
          IF lv_user = '9980000011'.
            lv_delmrk = 'X'.
          ENDIF.
        ENDIF.
      ELSE.
        IF lv_user = '9980000011'.
          lv_delmrk = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.
**********************************************************************
    result = VALUE #( FOR ls_key IN keys
  ( %tky =  ls_key-%tky
    %update =  COND #( WHEN ls_hdr-mark IS INITIAL OR ls_hdr-tarewgt IS INITIAL
                                    THEN if_abap_behv=>fc-o-enabled
                                    ELSE if_abap_behv=>fc-o-disabled )
    %delete = COND #( WHEN lv_delmrk IS INITIAL
                                    THEN if_abap_behv=>fc-o-disabled
                                    ELSE if_abap_behv=>fc-o-enabled )
    %action = VALUE #( gettare = COND #(  WHEN ls_hdr-material IS NOT INITIAL AND ls_hdr-tarewgt IS INITIAL AND ( ls_hdr-divmark = 'C' OR ls_hdr-divmark = 'W'  )  "
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                       gettareurl = COND #( WHEN ls_hdr-material IS NOT INITIAL AND ls_hdr-tarewgt IS INITIAL AND ( ls_hdr-divmark = 'C' OR ls_hdr-divmark = 'W' )
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )             )

                    ) ) .
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD gettare.
**********************************************************************
    DATA: lt_hdrupd TYPE TABLE OF zsd_app02_tb3,
          ls_hdrupd TYPE zsd_app02_tb3,
          lt_itmupd TYPE TABLE OF zsd_app02_tb2,
          ls_itmupd TYPE zsd_app02_tb2.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header)
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_item).
    DATA(ls_header) = lt_header[ 1 ].
    DATA(ls_item) = lt_item[ 1 ].
    DATA(lt_keys) = keys.
    DATA(ls_keys) = lt_keys[ 1 ].

**********************************************************************
    MOVE-CORRESPONDING ls_header TO ls_hdrupd.
    ls_hdrupd-tarewgt = ls_keys-%param-weight.
    ls_hdrupd-wgtunit = ls_keys-%param-unit.
    ls_hdrupd-trwdate = cl_abap_context_info=>get_system_date(  ).
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA'
            INTO DATE DATA(lv_date) TIME DATA(lv_time)              .
    ls_hdrupd-trwtime = lv_time.
    APPEND ls_hdrupd TO lt_hdrupd.
    zbp_sd_app02_rv=>gt_hdrupd = lt_hdrupd.
    MOVE-CORRESPONDING ls_item TO ls_itmupd.
    ls_itmupd-tarewgt = ls_hdrupd-tarewgt.
    APPEND ls_itmupd TO lt_itmupd.
    zbp_sd_app02_rv=>gt_itmupd2 = lt_itmupd.
**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).


  ENDMETHOD.

  METHOD getdata1.
**********************************************************************
    DATA: lt_hdrdata   TYPE TABLE OF zsd_app02_tb3,
          ls_hdrdata   TYPE zsd_app02_tb3,
          lt_itmdata   TYPE TABLE OF zsd_app02_tb2,
          ls_itmdata   TYPE zsd_app02_tb2,
          lv_plantname TYPE zi_plant_vh1-shpname.

**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header).
    DATA(ls_header) = lt_header[ 1 ].
**********************************************************************
    IF ls_header-plant IS NOT INITIAL OR ls_header-material IS NOT INITIAL.
      SELECT SINGLE MAX( tokennum ) FROM zsd_app02_tb3 INTO @DATA(lv_token).
      IF sy-subrc = 0 AND lv_token IS NOT INITIAL.
        ls_hdrdata-tokennum = lv_token + 1.
        ls_itmdata-tokennum = ls_hdrdata-tokennum.
      ELSE.
        ls_hdrdata-tokennum = '2000000001'.
        ls_itmdata-tokennum = ls_hdrdata-tokennum.
      ENDIF.
      ls_hdrdata-uuid = ls_header-uuid.
      ls_itmdata-uuid = ls_header-uuid.
      GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA'
              INTO DATE DATA(lv_date) TIME DATA(lv_time)              .
      ls_hdrdata-gitime = lv_time.
      ls_hdrdata-gidate = cl_abap_context_info=>get_system_date(  ).
      ls_hdrdata-drivername = ls_header-drivername.
      ls_hdrdata-vehicleno = ls_header-vehicleno.
      ls_hdrdata-trucktyp = ls_header-trucktyp.
      ls_hdrdata-trspname = ls_header-trspname.
      ls_hdrdata-trspmode = ls_header-trspmode.
      ls_hdrdata-createdat = ls_header-createdat.
      ls_hdrdata-createdby = ls_header-createdby.
      ls_hdrdata-lastchangedat = ls_header-lastchangedat.
      ls_hdrdata-lastchangedby = ls_header-lastchangedby.
      ls_hdrdata-lrnumber = ls_header-lrnumber.
      ls_hdrdata-plant = ls_header-plant.
      SELECT SINGLE shpname FROM zi_plant_vh1 WHERE shpoint = @ls_header-plant INTO @lv_plantname.
      ls_hdrdata-plantname = lv_plantname.
      ls_hdrdata-wgtunit = 'TO'.
      ls_hdrdata-sloc =  ls_header-sloc.
      ls_hdrdata-batch =  ls_header-batch.
      ls_hdrdata-material = ls_header-material.
      SELECT SINGLE p~product,p~division,d~productdescription FROM i_product AS p
      INNER JOIN i_productdescription_2 AS d ON d~product = p~product
      WHERE p~product = @ls_header-material AND d~language = @sy-langu
      INTO @DATA(ls_matdata).
      ls_hdrdata-matdesc = ls_matdata-productdescription.
      ls_hdrdata-division = ls_matdata-division.
      IF ls_matdata-division IS NOT INITIAL.
        SELECT SINGLE * FROM i_divisiontext WHERE division = @ls_matdata-division
        INTO @DATA(ls_division).
        ls_hdrdata-divname = ls_division-divisionname.
        SELECT SINGLE * FROM zsd_apps02_1_tb1 WHERE division = @ls_hdrdata-division
        INTO @DATA(ls_divmrk).
        IF sy-subrc = 0 AND NOT ls_divmrk IS INITIAL.
          CASE ls_divmrk-whgmark.
            WHEN 'X'.
              IF ls_divmrk-cncmark = 'X'.
                ls_hdrdata-divmark = 'C'.
              ELSE.
                ls_hdrdata-divmark = 'W'.
              ENDIF.
            WHEN ' '.
              ls_hdrdata-divmark = 'E'.
          ENDCASE.
        ENDIF.
      ELSE.
        ls_hdrdata-divmark = 'E'.
      ENDIF.

      APPEND ls_hdrdata TO lt_hdrdata.
      APPEND ls_itmdata TO lt_itmdata.
      zbp_sd_app02_rv=>gt_hdrdata = lt_hdrdata.
      zbp_sd_app02_rv=>gt_itmdata = lt_itmdata.
    ELSE.

    ENDIF.
  ENDMETHOD.

  METHOD gettareurl.
***********************************************************************
    DATA: lt_hdrupd TYPE TABLE OF zsd_app02_tb3,
          ls_hdrupd TYPE zsd_app02_tb3,
          lv_weight TYPE zsd_app02_tb3-tarewgt.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
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
**********************************************************************
    lv_request_string = |https://absolutely-golden-viper.ngrok-free.app/run-exe| .
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
    IF lv_response IS NOT INITIAL.
      SPLIT lv_response AT '+' INTO DATA(lv_text1) DATA(lv_text2).
      SPLIT lv_text2 AT '.' INTO DATA(lv_wgtval) DATA(lv_text3).
      lv_weight = lv_wgtval.
      lv_weight = lv_weight / 1000.

      MOVE-CORRESPONDING ls_header TO ls_hdrupd.
      ls_hdrupd-tarewgt = lv_weight.
      ls_hdrupd-wgtunit = 'TO'.
      ls_hdrupd-trwdate = cl_abap_context_info=>get_system_date(  ).
      GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA'
              INTO DATE DATA(lv_date) TIME DATA(lv_time)              .
      ls_hdrupd-trwtime = lv_time.
      APPEND ls_hdrupd TO lt_hdrupd.
      zbp_sd_app02_rv=>gt_hdrupd = lt_hdrupd.

    ELSE.

    ENDIF.
**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_header
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

  METHOD mandatory.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gatein).

    DATA(ls_gatein) = lt_gatein[ 1 ].
    IF ls_gatein-plant IS INITIAL.
      APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
      APPEND VALUE #( %tky = ls_gatein-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Shipping point is mandatory' )
                     ) TO reported-gatein.
    ELSEIF ls_gatein-material IS INITIAL.
      APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
      APPEND VALUE #( %tky = ls_gatein-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Material is mandatory' )
                     ) TO reported-gatein.
    ELSEIF ls_gatein-drivername IS INITIAL.
      APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
      APPEND VALUE #( %tky = ls_gatein-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Driver Name is mandatory' )
                     ) TO reported-gatein.
    ELSEIF ls_gatein-trspname IS INITIAL.
      APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
      APPEND VALUE #( %tky = ls_gatein-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Transporter is mandatory' )
                     ) TO reported-gatein.
    ELSEIF ls_gatein-drivername IS INITIAL.
      APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
      APPEND VALUE #( %tky = ls_gatein-%tky
                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Driver Name is mandatory' )
                     ) TO reported-gatein.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_gateout DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR gateout RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR gateout RESULT result.

    METHODS getgross FOR MODIFY
      IMPORTING keys FOR ACTION gateout~getgross RESULT result.

    METHODS getdata2 FOR DETERMINE ON SAVE
      IMPORTING keys FOR gateout~getdata2.
    METHODS upddata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR gateout~upddata.
    METHODS getgrossurl FOR MODIFY
      IMPORTING keys FOR ACTION gateout~getgrossurl RESULT result.
    METHODS weigh FOR VALIDATE ON SAVE
      IMPORTING keys FOR gateout~weigh.
    METHODS compgate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR gateout~compgate.

ENDCLASS.

CLASS lhc_gateout IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
            ENTITY gatein
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_hdr)
            ENTITY gatein BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_item).
    DATA(ls_hdr) = lt_hdr[ 1 ].
    DATA(ls_item) = lt_item[ 1 ].
**********************************************************************
    result = VALUE #( FOR ls_key IN keys
  ( %tky =  ls_key-%tky
*    %update =  COND #( WHEN ls_item-Loadsts IS INITIAL
*                                    THEN if_abap_behv=>fc-o-enabled
*                                    ELSE if_abap_behv=>fc-o-disabled )
    %delete = if_abap_behv=>fc-o-disabled
    %action = VALUE #( getgross = COND #( WHEN ls_item-grswgt IS INITIAL AND ls_hdr-tarewgt IS NOT INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                       getgrossurl = COND #( WHEN ls_item-grswgt IS INITIAL AND ls_hdr-tarewgt IS NOT INITIAL
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
                    ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getgross.
**********************************************************************
    DATA: lt_itmupd TYPE TABLE OF zsd_app02_tb2,
          ls_itmupd TYPE zsd_app02_tb2,
          lt_hdrupd TYPE TABLE OF zsd_app02_tb3,
          ls_hdrupd TYPE zsd_app02_tb3,
          lv_conval TYPE zsd_app02_tb2-chbwgt.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gatein)
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_item).
    DATA(ls_item) = lt_item[ 1 ].
    DATA(ls_gatein) = lt_gatein[ 1 ].
    DATA(lt_keys) = keys.
    DATA(ls_keys) = lt_keys[ 1 ].
**********************************************************************
    MOVE-CORRESPONDING ls_item TO ls_itmupd.
    ls_itmupd-wgtunit = ls_keys-%param-unit.
    ls_itmupd-grswgt = ls_keys-%param-weight.
    ls_itmupd-grsdate = cl_abap_context_info=>get_system_date(  ).
    GET TIME STAMP FIELD DATA(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA'
            INTO DATE DATA(lv_date) TIME DATA(lv_time)              .
    ls_itmupd-grstime = lv_time.

    ls_itmupd-netwgt = ls_itmupd-grswgt - ls_itmupd-tarewgt.
    IF ls_itmupd-concnrate IS INITIAL.
      ls_itmupd-chbwgt = ls_itmupd-netwgt.
    ELSE.
      lv_conval = ls_itmupd-netwgt * ls_itmupd-concnrate / 100.
*      ls_itmupd-chbwgt = ls_itmupd-netwgt - lv_conval.
      ls_itmupd-chbwgt =  lv_conval.
    ENDIF.
    APPEND ls_itmupd TO lt_itmupd.
    zbp_sd_app02_rv=>gt_itmupd = lt_itmupd.
**********************************************************************
    IF ls_itmupd-loadsts = 'X'.
      MOVE-CORRESPONDING ls_gatein TO ls_hdrupd.
      ls_hdrupd-status = 'LOADED'.
      ls_hdrupd-mark = 'X'.
      APPEND ls_hdrupd TO lt_hdrupd.
      zbp_sd_app02_rv=>gt_hdrupd2 = lt_hdrupd.
    ENDIF.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_upd).
    result = VALUE #( FOR ls_ord IN lt_upd
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

  METHOD getdata2.
**********************************************************************
    DATA : lt_itmupd TYPE TABLE OF zsd_app02_tb2,
           ls_itmupd TYPE zsd_app02_tb2.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gin)
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gout).
    DATA(ls_gout) = lt_gout[ 1 ].
    DATA(ls_gin) = lt_gin[ 1 ].
*    ls_itmupd-batch = ls_gout-Batch.
    ls_itmupd-concnrate = ls_gout-concnrate.
    ls_itmupd-cylinder  = ls_gout-cylinder.
    ls_itmupd-wgtunit  = ls_gout-wgtunit.
    ls_itmupd-uuid = ls_gout-uuid.
    ls_itmupd-totcyln = ls_gout-totcyln.
    ls_itmupd-tokennum = ls_gout-tokennum.
    ls_itmupd-tarewgt = ls_gin-tarewgt.
    ls_itmupd-sealnum = ls_gout-sealnum.
    ls_itmupd-totcyln = ls_gout-totcyln.
    ls_itmupd-cylnvol = ls_gout-cylnvol.
    ls_itmupd-remarks = ls_gout-remarks.
    ls_itmupd-frgtrms = ls_gout-frgtrms.
    ls_itmupd-dlvplace = ls_gout-dlvplace.
    ls_itmupd-grswgt = ls_gout-grswgt.
    ls_itmupd-chbwgt = ls_gout-chbwgt.
    ls_itmupd-netwgt = ls_gout-netwgt.
    ls_itmupd-wgtunit = ls_gin-wgtunit.
    ls_itmupd-loadsts = ls_gout-loadsts.
    ls_itmupd-grsdate = ls_gout-grsdate.
    ls_itmupd-grstime = ls_gout-grstime.

    APPEND ls_itmupd TO lt_itmupd.
    zbp_sd_app02_rv=>gt_itmupd = lt_itmupd.
  ENDMETHOD.

  METHOD upddata.
**********************************************************************
    DATA : lt_itmupd TYPE TABLE OF zsd_app02_tb2,
           ls_itmupd TYPE zsd_app02_tb2,
           lt_hdrupd TYPE TABLE OF zsd_app02_tb3,
           ls_hdrupd TYPE zsd_app02_tb3,
           lv_conval TYPE zsd_app02_tb2-chbwgt.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gin)
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gout).
    DATA(ls_gout) = lt_gout[ 1 ].
    DATA(ls_gin) = lt_gin[ 1 ].
    MOVE-CORRESPONDING ls_gout TO ls_itmupd.
    MOVE-CORRESPONDING ls_gin TO ls_hdrupd.
    CASE ls_gin-divmark.
      WHEN 'E'.
        ls_itmupd-chbwgt = ls_itmupd-netwgt.
        ls_itmupd-loadsts = ls_itmupd-loadsts.
        IF ls_itmupd-concnrate > 0.
          ls_itmupd-concnrate = '0.00'.
        ENDIF.
        IF ls_itmupd-loadsts = 'X'.
          ls_hdrupd-status = 'LOADED'.
          ls_hdrupd-mark = 'X'.
        ENDIF.
      WHEN 'C'.
        IF ls_itmupd-concnrate IS INITIAL OR ls_itmupd-concnrate <= '0.00' .
          ls_itmupd-chbwgt = '0.00'.
          ls_itmupd-loadsts = ' '.
        ELSE.
          lv_conval = ls_itmupd-netwgt * ls_itmupd-concnrate / 100.
          ls_itmupd-chbwgt = lv_conval.
          ls_itmupd-loadsts = ls_itmupd-loadsts.
          IF ls_itmupd-loadsts = 'X'.
            ls_hdrupd-status = 'LOADED'.
            ls_hdrupd-mark = 'X'.
          ENDIF.
        ENDIF.
      WHEN 'W'.
        ls_itmupd-chbwgt = ls_itmupd-netwgt.
        ls_itmupd-loadsts = ls_itmupd-loadsts.
        IF ls_itmupd-concnrate > 0.
          ls_itmupd-concnrate = '0.00'.
        ENDIF.
        IF ls_itmupd-loadsts = 'X'.
          ls_hdrupd-status = 'LOADED'.
          ls_hdrupd-mark = 'X'.
        ENDIF.
    ENDCASE.

    APPEND ls_itmupd TO lt_itmupd.
    APPEND ls_hdrupd TO lt_hdrupd.
    zbp_sd_app02_rv=>gt_itmupd2 = lt_itmupd.
    zbp_sd_app02_rv=>gt_hdrupd2 = lt_hdrupd.
  ENDMETHOD.

  METHOD getgrossurl.
**********************************************************************
    DATA: lt_itmupd TYPE TABLE OF zsd_app02_tb2,
          ls_itmupd TYPE zsd_app02_tb2,
          lt_hdrupd TYPE TABLE OF zsd_app02_tb3,
          ls_hdrupd TYPE zsd_app02_tb3,
          lv_conval TYPE zsd_app02_tb2-chbwgt,
          lv_weight TYPE zsd_app02_tb3-tarewgt.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gatein)
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_item).
    DATA(ls_item) = lt_item[ 1 ].
    DATA(ls_gatein) = lt_gatein[ 1 ].
**********************************************************************
    """ HTTP Communication via URL   """

    DATA: lv_request_string TYPE string,
          lo_hhtp_response  TYPE REF TO if_web_http_response.
    DATA: lo_http_destination TYPE REF TO if_http_destination,
          lo_http_client      TYPE REF TO if_web_http_client,
          lv_response         TYPE string.
***********************************************************************************
    "  static link
    lv_request_string = |https://absolutely-golden-viper.ngrok-free.app/run-exe| .
***********************************************************************************
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
    IF lv_response IS NOT INITIAL.
      SPLIT lv_response AT '+' INTO DATA(lv_text1) DATA(lv_text2).
      SPLIT lv_text2 AT '.' INTO DATA(lv_wgtval) DATA(lv_text3).
      lv_weight = lv_wgtval.
      lv_weight = lv_weight / 1000.

**********************************************************************
      MOVE-CORRESPONDING ls_item TO ls_itmupd.
      ls_itmupd-wgtunit = 'TO'.
      ls_itmupd-grswgt = lv_weight.
      ls_itmupd-tarewgt = ls_gatein-tarewgt.
      ls_itmupd-netwgt = ls_itmupd-grswgt - ls_itmupd-tarewgt.
      IF ls_itmupd-concnrate IS INITIAL.
        ls_itmupd-chbwgt = ls_itmupd-netwgt.
      ELSE.
        lv_conval = ls_itmupd-netwgt * ls_itmupd-concnrate / 100.
        ls_itmupd-chbwgt = lv_conval.
      ENDIF.
      ls_itmupd-grsdate = cl_abap_context_info=>get_system_date(  ).
      GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA'
              INTO DATE DATA(lv_date) TIME DATA(lv_time)              .
      ls_itmupd-grstime = lv_time.
      APPEND ls_itmupd TO lt_itmupd.
      zbp_sd_app02_rv=>gt_itmupd = lt_itmupd.
**********************************************************************
      MOVE-CORRESPONDING ls_gatein TO ls_hdrupd.
      ls_hdrupd-status = 'LOADED'.
      ls_hdrupd-mark = 'X'.
      APPEND ls_hdrupd TO lt_hdrupd.
      zbp_sd_app02_rv=>gt_hdrupd2 = lt_hdrupd.
    ENDIF.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_upd).
    result = VALUE #( FOR ls_ord IN lt_upd
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

  ENDMETHOD.

  METHOD weigh.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gatein)
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gateout).
    DATA(ls_gateout) = lt_gateout[ 1 ].
    DATA(ls_gatein) = lt_gatein[ 1 ].

    CASE ls_gatein-divmark.
      WHEN 'W'.
        IF ls_gateout-grswgt IS INITIAL OR ls_gateout-tarewgt IS INITIAL.
          APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
          APPEND VALUE #( %tky = ls_gatein-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Weigh-Scale Tare and Gross Weights are mandatory' )
                         ) TO reported-gatein.
        ENDIF.
      WHEN 'C'.
        IF ls_gateout-grswgt IS INITIAL OR ls_gateout-tarewgt IS INITIAL.
          APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
          APPEND VALUE #( %tky = ls_gatein-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Weigh-Scale Tare and Gross Weights are mandatory' )
                         ) TO reported-gatein.
        ELSE.
          IF ls_gateout-concnrate IS INITIAL.
            APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
            APPEND VALUE #( %tky = ls_gatein-%tky
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Concentration Rate is mandatory' )
                           ) TO reported-gatein.
          ENDIF.
        ENDIF.

      WHEN 'E'.
        IF ls_gateout-grswgt IS NOT INITIAL OR ls_gateout-tarewgt IS NOT INITIAL.
          APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
          APPEND VALUE #( %tky = ls_gatein-%tky
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Weigh-Scale Tare and Gross Weights are not required' )
                         ) TO reported-gatein.

        ELSE.
          IF ls_gatein-division NE '10'.
            IF ls_gateout-sealnum IS INITIAL OR ls_gateout-totcyln IS INITIAL.
              APPEND VALUE #( %tky = ls_gatein-%tky ) TO failed-gatein.
              APPEND VALUE #( %tky = ls_gatein-%tky
                              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                            text = 'Maintain Cylinder Detials' )
                             ) TO reported-gatein.

            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD compgate.
**********************************************************************
    DATA : lt_itmupd TYPE TABLE OF zsd_app02_tb2,
           ls_itmupd TYPE zsd_app02_tb2,
           lt_hdrupd TYPE TABLE OF zsd_app02_tb3,
           ls_hdrupd TYPE zsd_app02_tb3.
**********************************************************************
    READ ENTITIES OF zsd_app02_rv IN LOCAL MODE
          ENTITY gatein
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gatein)
          ENTITY gatein BY \_item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_gateout).
    DATA(ls_gateout) = lt_gateout[ 1 ].
    DATA(ls_gatein) = lt_gatein[ 1 ].
    IF ls_gateout-loadsts = 'X'.
*      IF ls_gatein-Divmark = 'C' OR ls_gatein-Divmark = 'W'.
*
*        IF ls_gateout-Chbwgt > 0.
      MOVE-CORRESPONDING ls_gatein TO ls_hdrupd.
      MOVE-CORRESPONDING ls_gateout TO ls_itmupd.
      ls_hdrupd-status = 'LOADED'.
      ls_hdrupd-mark = 'X'.
*      ls_hdrupd-godate = cl_abap_context_info=>get_system_date(  ).
*      ls_hdrupd-gotime = cl_abap_context_info=>get_system_time(  ).
      APPEND ls_hdrupd TO lt_hdrupd.
*      APPEND ls_itmupd TO lt_itmupd.
      zbp_sd_app02_rv=>gt_hdrupd2 = lt_hdrupd.
*      zbp_sd_app02_rv=>gt_itmupd2 = lt_itmupd.
*        ENDIF.
*      ELSE.
*        MOVE-CORRESPONDING ls_gatein TO ls_hdrupd.
*        MOVE-CORRESPONDING ls_gateout TO ls_itmupd.
**        ls_hdrupd-status = 'LOADED'.
**        ls_hdrupd-mark = 'X'.
*        ls_hdrupd-godate = cl_abap_context_info=>get_system_date(  ).
*        ls_hdrupd-gotime = cl_abap_context_info=>get_system_time(  ).
*        APPEND ls_hdrupd TO lt_hdrupd.
*        APPEND ls_itmupd TO lt_itmupd.
*        zbp_sd_app02_rv=>gt_hdrupd2 = lt_hdrupd.
*        zbp_sd_app02_rv=>gt_itmupd2 = lt_itmupd.
*      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsd_app02_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsd_app02_rv IMPLEMENTATION.

  METHOD save_modified.

**********************************************************************
    IF create-gatein IS NOT INITIAL.
      IF zbp_sd_app02_rv=>gt_hdrdata IS NOT INITIAL.
        DATA(lt_hdrdata) = zbp_sd_app02_rv=>gt_hdrdata.
        MODIFY zsd_app02_tb3 FROM TABLE @lt_hdrdata.
      ENDIF.
      IF zbp_sd_app02_rv=>gt_itmdata IS NOT INITIAL.
        DATA(lt_itmdata) = zbp_sd_app02_rv=>gt_itmdata.
        MODIFY zsd_app02_tb2 FROM TABLE @lt_itmdata.
      ENDIF.
    ENDIF.

**********************************************************************
    IF zbp_sd_app02_rv=>gt_hdrupd IS NOT INITIAL.
      DATA(lt_hdrupd) = zbp_sd_app02_rv=>gt_hdrupd.
      MODIFY zsd_app02_tb3 FROM TABLE @lt_hdrupd.
    ENDIF.

    IF zbp_sd_app02_rv=>gt_itmupd IS NOT INITIAL.
      DATA(lt_itmupd) = zbp_sd_app02_rv=>gt_itmupd.
      MODIFY zsd_app02_tb2 FROM TABLE @lt_itmupd.
    ENDIF.

    IF zbp_sd_app02_rv=>gt_hdrupd2 IS NOT INITIAL.
      DATA(lt_hdrupd2) = zbp_sd_app02_rv=>gt_hdrupd2.
      MODIFY zsd_app02_tb3 FROM TABLE @lt_hdrupd2.
    ENDIF.

    IF zbp_sd_app02_rv=>gt_itmupd2 IS NOT INITIAL.
      DATA(lt_itmupd2) = zbp_sd_app02_rv=>gt_itmupd2.
      MODIFY zsd_app02_tb2 FROM TABLE @lt_itmupd2.
    ENDIF.
*************** Delete Root & Child entity records *******************
    IF delete-gatein IS NOT INITIAL.
      LOOP AT delete-gatein INTO DATA(ls_hdr).
        DELETE FROM zsd_app02_tb2 WHERE uuid = @ls_hdr-uuid.
        DELETE FROM zsd_app02_tb3 WHERE uuid = @ls_hdr-uuid.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
