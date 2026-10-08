CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS esign FOR MODIFY
      IMPORTING keys FOR ACTION header~esign RESULT result.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
***this Action is working if the purchase order status completed
***the E-sign Button it automatically enable other wise disable
**********************************************************************
        READ ENTITIES OF zmm_app17_pohd_rv IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(postatus).

        DATA(ls_postatus) = postatus[ 1 ].

**********************************************************************
        result = VALUE #( for ls_key in keys
                        (    %tky = ls_key-%tky

                          %action = VALUE #( Esign = COND #( WHEN ls_postatus-Purchasestatus = 'COMPLETED'
                                                THEN if_abap_behv=>fc-o-enabled
                                                ELSE if_abap_behv=>fc-o-disabled ) )
                          ) ) .
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD esign.

**********************************************************************
    DATA : lv_gpdf_url TYPE string.
    DATA : lv_copytyp           TYPE string,
           lv_formb64           TYPE xstring,
           lv_dscb64            TYPE string,
           ls_req               TYPE zmm_app17_str1,
           ls_dscresponse       TYPE zmm_app17_str2,
           ls_qrresponse        TYPE zmm_app17_str2,
           ls_response          TYPE zmm_app17_str2,
           ls_response2         TYPE zmm_app17_str2,
           lv_dsc_url           TYPE string,
           lo_http_response     TYPE REF TO if_web_http_response,
           lo_http_destination  TYPE REF TO if_http_destination,
           lo_http_client       TYPE REF TO if_web_http_client,
           lo_http_responseq    TYPE REF TO if_web_http_response,
           lo_http_destinationq TYPE REF TO if_http_destination,
           lo_http_clientq      TYPE REF TO if_web_http_client,
           lv_dscrespb1         TYPE string,
*           lv_response          TYPE string,
           lv_expinv            TYPE string.

**********************************************************************
****Get data from Custom Application PO header & Item

    READ ENTITIES OF zmm_app17_pohd_rv IN LOCAL MODE
    ENTITY header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_pohead)
    ENTITY header BY \_item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_poitem).

    DATA(ls_pohead) = lt_pohead[ 1 ].
    data(ls_item) = lt_poitem[ 1 ].
    zbp_mm_app17_pohd_rv=>gv_ponum = ls_pohead-purchaseorder.

**********************************************************************

      try.
        data(system_url) = cl_abap_context_info=>get_system_url(  ).
        CATCH cx_abap_context_info_error.
        data(ls_systemerror) = 1.
        ENDTRY.

**********************************************************************
******************************* User Validations **********************

    TRY.
        DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
      CATCH cx_abap_context_info_error.
        DATA(ls_x1) = 1.
    ENDTRY.
    DATA(lv_cbuser) = 'CB' && lv_user.

    SELECT SINGLE * FROM zmm_app19_tb1 WHERE userid = @lv_cbuser
                                       AND ccode = @ls_pohead-companycode
                                       AND cplant = @ls_item-plant
    INTO @DATA(ls_authsign).

***********************************************************************
***********************************************************************
        if sy-subrc = 0 AND not ls_authsign is INITIAL.

        "this one using at Get Purchase Order PDF Form API Calls
    DATA: lv_request_string TYPE string,
          lo_hhtp_response  TYPE REF TO if_web_http_response.
    DATA: lo_http_destination1 TYPE REF TO if_http_destination,
          lo_http_client1      TYPE REF TO if_web_http_client,
          lv_response1         TYPE string,
          xml_data type string,
          ebeln TYPE ebeln.
**********************************************************************
    ebeln = ls_pohead-PurchaseOrder.
*    ebeln = '2300000473'.
**********************************************************************
******get the Purchase Order Header text node from API Call
    data: lv_systemurl TYPE c LENGTH 50.
    lv_systemurl = system_url(8).

if lv_systemurl = 'my414007'.      "this one CHEMFAB Development system "old

***********************************************************************
    lv_request_string = |https://my414007-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PURCHASEORDER_PROCESS_SRV/GetPDF?PurchaseOrder='{ ebeln }'&OutputType='PURCHASE_ORDER'&OutputDevice='LOCL'&OutputFormat='PDF'&Language='EN'|.

***********************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination1 = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client1 = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination1 ).
        " adding Header fields
        lo_http_client1->get_http_request(  )->set_header_fields( VALUE #( ( name = if_web_http_header=>authorization value = 'Basic Q1BNX0NPTV9VU0VSUzphdXFbOC83bEw5RmRdS10jUFwpYyg1cSZ3a293OUtrWUZIc0p0SDdB' )
                                                                           ( name = if_web_http_header=>accept      value = if_web_http_header=>accept_application_json  ) ) ).

        " execute HTTP POST-request and store response


        lo_hhtp_response = lo_http_client1->execute( if_web_http_client=>get ).

        DATA(ls_status1) = lo_hhtp_response->get_status(  ).

        lv_response1 = lo_hhtp_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error12).
        DATA(lv_12) = 2.
    ENDTRY.

ELSEIF lv_systemurl = 'my416192'.       "this one is CHEMFAB Quality System
***********************************************************************
    lv_request_string = |https://my416192-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PURCHASEORDER_PROCESS_SRV/GetPDF?PurchaseOrder='{ ebeln }'&OutputType='PURCHASE_ORDER'&OutputDevice='LOCL'&OutputFormat='PDF'&Language='EN'|.
***********************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination1 = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client1 = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination1 ).
        " adding Header fields
        lo_http_client1->get_http_request(  )->set_header_fields( VALUE #( ( name = if_web_http_header=>authorization value = 'Basic Q1BNX0NPTV9VU0VSUzomTFVya3cjPWQ5aH5QWSQ+WzlMN257N3FMdlIoKVZnPn10VWF1WjJB' )
                                                                           ( name = if_web_http_header=>accept      value = if_web_http_header=>accept_application_json  ) ) ).

        " execute HTTP POST-request and store response


        lo_hhtp_response = lo_http_client1->execute( if_web_http_client=>get ).

        ls_status1 = lo_hhtp_response->get_status(  ).

        lv_response1 = lo_hhtp_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO lx_error12.
        lv_12 = 2.
    ENDTRY.

ELSEIF lv_systemurl = 'my418555'.     "this one is CHEMFAB Production system  "old
***********************************************************************
    lv_request_string = |https://my418555-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PURCHASEORDER_PROCESS_SRV/GetPDF?PurchaseOrder='{ ebeln }'&OutputType='PURCHASE_ORDER'&OutputDevice='LOCL'&OutputFormat='PDF'&Language='EN'|.

***********************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination1 = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client1 = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination1 ).
        " adding Header fields
        lo_http_client1->get_http_request(  )->set_header_fields( VALUE #( ( name = if_web_http_header=>authorization value = 'Basic Q1BNX0NPTV9VU0VSUzoze3ZcXER4MjhbaFotUVZdbX4kbVdjbVlAcW1rOFE0LytvTTJSRFBS' )
                                                                           ( name = if_web_http_header=>accept      value = if_web_http_header=>accept_application_json  ) ) ).

        " execute HTTP POST-request and store response


        lo_hhtp_response = lo_http_client1->execute( if_web_http_client=>get ).

        ls_status1 = lo_hhtp_response->get_status(  ).

        lv_response1 = lo_hhtp_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO lx_error12.
        lv_12 = 2.
    ENDTRY.

ENDIF.
***********************************************************************
"============================================================
" STEP 2: Deserialize JSON
"============================================================
            TYPES: BEGIN OF ty_pdf,
                    PurchaseOrderBinary TYPE string,
            END OF ty_pdf.

            TYPES: BEGIN OF ty_getpdf,
                   GetPDF TYPE ty_pdf,
            END OF ty_getpdf.

            TYPES: BEGIN OF ty_root,
                     d TYPE ty_getpdf,
            END OF ty_root.

            DATA ls_json TYPE ty_root.

             /ui2/cl_json=>deserialize(
               EXPORTING
                 json = lv_response1
               CHANGING
                 data = ls_json
                             ).
"============================================================
" STEP 3: Decode Base64 → XSTRING
"============================================================
            DATA lv_pdf_string TYPE string.

                 lv_pdf_string = ls_json-d-getpdf-purchaseorderbinary.

*************************************************************************
        if lv_pdf_string is nOT iNITIAL.
    "  static link
*        lv_dsc_url = |https://esign.chemfabalkalis.com:820/RESTAPI/SignPDF_Base64String|.
*        lv_dsc_url = |https://esign.chemfabalkalis.com:810/Sandbox_RESTAPI/SignPDF_Base64String|.
        lv_dsc_url = |http://117.239.241.162:82/RESTAPI/SignPDF_Base64String|.

    TRY.
        " Create HTTP destination via URL
        lo_http_destination = cl_http_destination_provider=>create_by_url( lv_dsc_url ).
        " Create HTTP client by HTTP destination
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
        " adding Header fields
        DATA(lo_httpreqst) = lo_http_client->get_http_request(  ).
        lo_httpreqst->set_header_field( i_name  = 'Authorization'
                            i_value = 'Basic UnNjI0AxIWVSMDk0NDUkQHN2YjpzY0VSTDBAIUdAY3ZydGN4Ug==' ).
        lo_httpreqst->set_content_type( 'application/json' ).
      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error1).
        DATA(lv_2) = 2.
    ENDTRY.

***********************************************************************
**      """ HTTP Communication via URL   """
                TRY.
                    lo_httpreqst->set_text( '{    "AuthorizedSignatory": "Chemfab",'

                               && '    "SignerName": "'
                               && ls_authsign-signername
                               && '",'
                               && '    "TopLeft": 0,'
                && '    "BottomLeft": 0,'
                && '    "TopRight": 0,'
                && '    "BottomRight": 0,'
                && '    "ExcludePageNo": "",'
                && '    "InvoiceNumber": "'
                && ls_pohead-PurchaseOrder
                && '",'
                && '    "pageNo": -1,'
                && '    "PrintDateTime": "",'
                && '    "FindAuth": "Authorised",'
                && '    "FindAuthLocation": 0,'
                && '    "fontsize": 24,'
                && '    "adjustCoordinates": 0,'
                && '    "signOnlySearchTextPage": 1,'
                && '    "pdfByte1": "'
                && lv_pdf_string
                &&  '" }'      ).

            " execute HTTP POST-request and store response
            lo_http_response = lo_http_client->execute( if_web_http_client=>post ).
            DATA(ls_status) = lo_http_response->get_status(  ).
            CLEAR: lv_dscrespb1.
            lv_dscrespb1 = lo_http_response->get_text(  ).
          CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error2).
            DATA(lv_3) = 3.
        ENDTRY.

        enDIF.
***********************************************************************
    IF lv_dscrespb1 IS NOT INITIAL.
      CLEAR ls_dscresponse.
          TRY.
              CALL METHOD /ui2/cl_json=>deserialize
                EXPORTING
                  json          = lv_dscrespb1
                  assoc_arrays  = abap_true
                  name_mappings = VALUE #( ( json = 'file' abap = 'FILECONTENT' ) )
                CHANGING
                  data          = ls_dscresponse.
            CATCH cx_root INTO DATA(lx_root).
              DATA(lv_err1) = 1.
          ENDTRY.

***********************************************************************
      DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_dscresponse-filecontent  ).
      DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).

***********************************************************************
      zbp_mm_app17_pohd_rv=>gs_print_data = lv_print_data.
      zbp_mm_app17_pohd_rv=>gs_pqitem_id = lv_qitem_id.
      zbp_mm_app17_pohd_rv=>gv_printq = ls_authsign-prntque.

    ENDIF.
***********************************************************************


    IF ls_status-reason = 'OK' AND ls_status-code = '200'.

      APPEND VALUE #( %tky = ls_pohead-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                              text = 'Printed Successfully' )
                               ) TO reported-header.
    ELSE.
      APPEND VALUE #( %tky = ls_pohead-%tky ) TO failed-header.
      APPEND VALUE #( %tky = ls_pohead-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'Not Printed' )
                               ) TO reported-header.

    ENDIF.

**********************************************************************
    ELSE.
          APPEND VALUE #( %tky = ls_pohead-%tky ) to failed-header.
          APPEND VALUE #( %tky = ls_pohead-%tky
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                        text = 'User Authorization not Maintained' )
                                        ) to reported-header.
    ENDIF.

***********************************************************************
    result = VALUE #( FOR ls_pord  IN lt_pohead
                            ( %tky = ls_pord-%tky
                              %param = ls_pord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app17_pohd_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app17_pohd_rv IMPLEMENTATION.

  METHOD save_modified.

**********************************************************************
    IF zbp_mm_app17_pohd_rv=>gs_print_data IS NOT INITIAL.

      DATA(wa_print_data) = zbp_mm_app17_pohd_rv=>gs_print_data.
      DATA(wa_pqitem_id) = zbp_mm_app17_pohd_rv=>gs_pqitem_id.

      DATA(wa_ponum) = zbp_mm_app17_pohd_rv=>gv_ponum.

      cl_print_queue_utils=>create_queue_item_by_data(
        EXPORTING
          iv_qname            = zbp_mm_app17_pohd_rv=>gv_printq
          iv_print_data       =  wa_print_data
          iv_name_of_main_doc = 'DSC-' && wa_ponum
          iv_itemid           = wa_pqitem_id
        IMPORTING
          ev_err_msg          = DATA(gs_error_msg)
      ).

    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
