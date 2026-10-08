CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS pdf FOR MODIFY
      IMPORTING keys FOR ACTION header~pdf RESULT result.
    METHODS popdf FOR MODIFY
      IMPORTING keys FOR ACTION header~popdf RESULT result.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD pdf.

     READ ENTITIES OF zsd_app11_header IN LOCAL MODE
     ENTITY header
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(header)
     ENTITY header by \_Item
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(Item)
     FAILED DATA(Failes).

     data(wa_header) = header[ 1 ].

        if wa_header-BillingDocument is not INITIAL.
        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
             iv_name                  = 'ZADS_CS'
             iv_service_instance_name = 'ZADS_OUT_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_APP11_PRINT_SD'
                                                                  iv_root_node = 'ZSD_APP11_HEAD_CE' ) .


*            SELECT SINGLE * FROM zdt_printqueue
*           WHERE cbuser = @sy-uname
**             AND configdeprecationcode IS INITIAL
*            INTO @DATA(ls_queue).

*            IF sy-subrc IS NOT INITIAL.
            data: printque type c LENGTH 32.

              printque = 'ADOBE_DEFAULT'.

*            ENDIF.

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'SDInvoice' ).
                "   out->write( 'Schema found in form' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "  out->write( 'No schema in form found' ).
                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
                  "Upload service definition
*                  lo_store->set_schema(
*                    iv_form_name = 'GATEFORM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
                ELSE.

                ENDIF.
            ENDTRY.
**********************************************************************
        TYPES: BEGIN OF ty_schema_body,
                 xsd_schema  TYPE xstring,
                 schema_name TYPE c LENGTH 30,
                 note        TYPE c LENGTH 280,
               END OF ty_schema_body.
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA lv_xdp TYPE ty_schema_body.
        lv_xdp = VALUE #( note        = ''
                          schema_name = 'schema'
                          xsd_schema  = lo_fdp_util->get_xsd( ) ).
**********************************************************************

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'BILLINGDOCUMENT' ]-value = header[ 1 ]-BillingDocument.

            data(lt_xsd) = lo_fdp_util->get_xsd( ).
*            lt_xsd[ name = 'BILLINGDOCUMENT' ]-value = header[ 1 ]-BillingDocument.

             data(lv_text) = cl_web_http_utility=>decode_utf8( encoded = lt_xsd ).

            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*                DATA(get_xsd) = lo_fdp_util->get_xsd( lt_keys ).
**                DATA(get_xsdv2) = lo_fdp_util->get_xsd_v2( lt_keys ).
*                DATA(readdata) = lo_fdp_util->read_to_data( lt_keys ).
*                DATA(lv_xml_v2) = lo_fdp_util->read_to_xml_v2( lt_keys ).

                "out->write( 'Service data retrieved' ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY..


*****************************************************************************
***Testing purpose



***Testing purpose
*****************************************************************************
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'SDInvoice'
              iv_template_name = 'Invoice'
            ).

            cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                       "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                                 iv_xml_data     = lv_xml
                                                 iv_xdp_layout   = ls_template-xdp_template
                                                 is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                       IMPORTING
                                       " TODO: variable is assigned but never used (ABAP cleaner)
                                                 ev_trace_string = DATA(lv_trace)
                                                 ev_pdf          = DATA(lv_pdf) ).


            DATA: lv_name TYPE c LENGTH 120.
            lv_name = |Invoice { header[ 1 ]-BillingDocument }|.

            DATA(lv_gno) = VALUE #( header[ 1 ]-BillingDocument OPTIONAL ).

*            SELECT SINGLE * FROM zdt_gatehead
*              WHERE id =  @lv_gno INTO @DATA(ls_files).
*            IF sy-subrc IS INITIAL.
*              ls_files-attachment = lv_pdf.
*              ls_files-mimetype   = 'application/pdf'.
*              ls_files-filename   = lv_name.
*              MODIFY zdt_gatehead FROM @ls_files.
*            ELSE.
**
*              CLEAR ls_files.
*              ls_files-id = lv_gno.
*              ls_files-attachment = lv_pdf.
*              ls_files-mimetype = 'application/pdf'.
*              ls_files-filename = lv_name.
*
**        ENDIF.
*              MODIFY zdt_gatehead FROM @ls_files.
*            ENDIF.






            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = printque
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_name
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
            " out->write( 'Exception occurred.' ).
        ENDTRY.
        "out->write( 'Finished processing.' ).
          data: gt_att type table of zsd_form_db,
                gs_att type zsd_form_db.

                if lv_pdf is not iNITIAL.
                    gs_att-billingdocument = wa_header-BillingDocument.
                    gs_att-attachment = lv_pdf.
                    gs_att-filename = wa_header-BillingDocument.
                    gs_att-mimetype = 'application/pdf'.

                 APPEND gs_att to gt_att.
                 zbp_sd_app11_header=>up_attach = gt_att.
                endif.
        endif.
**********************************************************************
    result = VALUE #( FOR ls_ord IN header
                         ( %tky   = ls_ord-%tky
                           %param = ls_ord ) ).

  ENDMETHOD.

  METHOD POPDF.
**********************************************************************
*****get the Purchase Order Header text node from API Call
     READ ENTITIES OF zsd_app11_header IN LOCAL MODE
     ENTITY header
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(header)
     ENTITY header by \_Item
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(Item)
     FAILED DATA(Failes).

     data(wa_header) = header[ 1 ].

**********************************************************************
    DATA : lv_gpdf_url TYPE string.
    DATA : lv_copytyp           TYPE string,
           lv_formb64           TYPE xstring,
           lv_dscb64            TYPE string,
           ls_req               TYPE zsd_app05_str1,
           ls_dscresponse       TYPE zsd_app05_str2,
           ls_qrresponse        TYPE zsd_app05_str2,
           ls_response          TYPE zsd_app05_str2,
           ls_response2         TYPE zsd_app05_str2,
           lv_dsc_url           TYPE string,
           lo_http_response     TYPE REF TO if_web_http_response,
           lo_http_destination  TYPE REF TO if_http_destination,
           lo_http_client       TYPE REF TO if_web_http_client,
           lo_http_responseq    TYPE REF TO if_web_http_response,
           lo_http_destinationq TYPE REF TO if_http_destination,
           lo_http_clientq      TYPE REF TO if_web_http_client,
           lv_response          TYPE string,
           lv_dscrespb1         TYPE string,
           lv_expinv            TYPE string,
           lv_packlist          TYPE string,
           lv_respqrbn          TYPE string,
           ebeln TYPE ebeln.
**********************************************************************

    DATA: lv_request_string TYPE string,
          lo_hhtp_response  TYPE REF TO if_web_http_response.
    DATA: lo_http_destination1 TYPE REF TO if_http_destination,
          lo_http_client1      TYPE REF TO if_web_http_client,
          lv_response1         TYPE string,
          xml_data type string,
          lv_req1 type string,
          lv_req2 type string.
**********************************************************************
            ebeln = '4500000573'.
            lv_req1 = |https://my414007-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrder/|.
            lv_req2 = |4500000573/SAP__self.GetOutputBinaryData()?OutputType='PURCHASE_ORDER'&OutputFormat='PDF'&Language='EN'|.
*('{ ls_pohead-purchaseorder }')/to_PurchaseOrderNote
*    lv_request_string = |https://my414007-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PURCHASEORDER_PROCESS_SRV/GetPDF?PurchaseOrder='{ ebeln }'&OutputType='PURCHASE_ORDER'&OutputDevice='LOCL'&OutputFormat='PDF'&Language='EN'|.

            lv_request_string = |{ lv_req1 }{ lv_req2 }|.
**********************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination1 = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client1 = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination1 ).
        " adding Header fields
        lo_http_client1->get_http_request(  )->set_header_fields( VALUE #( ( name = if_web_http_header=>authorization value = 'Basic Q1BNX0NPTV9VU0VSUzphdXFbOC83bEw5RmRdS10jUFwpYyg1cSZ3a293OUtrWUZIc0p0SDdB' )
                                                                           ( name = if_web_http_header=>accept
                                                                           value = if_web_http_header=>accept_application_json  ) ) ).

        " execute HTTP POST-request and store response


        lo_hhtp_response = lo_http_client1->execute( if_web_http_client=>get ).

        DATA(ls_status1) = lo_hhtp_response->get_status(  ).

        lv_response1 = lo_hhtp_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error12).
        DATA(lv_12) = 2.
    ENDTRY.

**********************************************************************
TYPES: BEGIN OF ty_root,
         OutputBinaryData TYPE string,
       END OF ty_root.

DATA: ls_json        TYPE ty_root,
      lv_pdf_xstring1 TYPE xstring.

"/ Deserialize JSON
/ui2/cl_json=>deserialize(
  EXPORTING
    json = lv_response1
  CHANGING
    data = ls_json
).

"============================================================
" STEP 2: Deserialize JSON
"============================================================
*TYPES: BEGIN OF ty_pdf,
**         PurchaseOrderBinary TYPE string,
*         OutputBinaryData type string,
*       END OF ty_pdf.
*
*TYPES: BEGIN OF ty_getpdf,
*         GetPDF TYPE ty_pdf,
*       END OF ty_getpdf.
*
*TYPES: BEGIN OF ty_root,
*         d TYPE ty_getpdf,
*       END OF ty_root.
*
*    DATA ls_json TYPE ty_root.
*
* /ui2/cl_json=>deserialize(
*   EXPORTING
*     json = lv_response1
*   CHANGING
*     data = ls_json
* ).
*"============================================================
*" STEP 3: Decode Base64 → XSTRING
*"============================================================
DATA lv_pdf_xstring TYPE string.
*DATA lv_pdf_xstring1 TYPE xstring.
*
     lv_pdf_xstring = ls_json-outputbinarydata.

*     data(lv_pdf) = xco_cp=>string( lv_pdf_xstring
*            )->as_xstring( xco_cp_binary=>text_encoding->base64
*            )->value.

**     lv_pdf_xstring1 = lo_http_response->get_binary(  ).
*    DATA(lv_invpdfb64) = xco_cp=>string( lv_pdf_xstring
*            )->as_xstring( xco_cp_binary=>text_encoding->base64
*            )->value.
*lv_pdf_xstring = cl_web_http_utility=>encode_base64(
*                   unencoded = ls_json-d-getpdf-purchaseorderbinary
*                 ).
**********************************************************************
*       xml_data = lv_pdf_xstring.
*
*    DATA(lv_print_data) = cl_web_http_utility=>encode_x_base64( lv_pdf  ).
    data(print) = cl_web_http_utility=>decode_x_base64( encoded = lv_pdf_xstring ).

        "out->write( 'Finished processing.' ).
*          data: gt_att type table of zsd_form_db,
*                gs_att type zsd_form_db.
*
*                if print is not iNITIAL.
*                    gs_att-billingdocument = wa_header-BillingDocument.
*                    gs_att-attachment = print.
*                    gs_att-filename = |{ wa_header-BillingDocument }.PDF|.
*                    gs_att-mimetype = 'application/pdf'.
*
*                 APPEND gs_att to gt_att.
*                 zbp_sd_app11_header=>up_attach = gt_att.
*                endif.
**********************************************************************
*        if lv_pdf_xstring is nOT iNITIAL.
*         data(signername) = 'NAGARAJAN S'.
*         data(billdoc) = '4500000550'.
*        "  static link
**        lv_dsc_url = |https://esign.chemfabalkalis.com:820/RESTAPI/SignPDF_Base64String|.
*        "  Public link
*        lv_dsc_url = |http://117.239.241.162:82/RESTAPI/SignPDF_Base64String|.
*        "Sandbox link
**        lv_dsc_url = |https://esign.chemfabalkalis.com:810/Sandbox_RESTAPI/SignPDF_Base64String|.
*
*        TRY.
*            " Create HTTP destination via URL
*            lo_http_destination = cl_http_destination_provider=>create_by_url( lv_dsc_url ).
*            " Create HTTP client by HTTP destination
*            lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
*            " adding Header fields
*            DATA(lo_httpreqst) = lo_http_client->get_http_request(  ).
*            lo_httpreqst->set_header_field( i_name  = 'Authorization'
*                                i_value = 'Basic UnNjI0AxIWVSMDk0NDUkQHN2YjpzY0VSTDBAIUdAY3ZydGN4Ug==' ).
*            lo_httpreqst->set_content_type( 'application/json' ).
*          CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error1).
*            DATA(lv_2) = 2.
*        ENDTRY.
*************************************************************************
**      """ HTTP Communication via URL   """
*        TRY.
*            lo_httpreqst->set_text(
*            '{    "AuthorizedSignatory": "'
*        &&    'Chemfab'
**      && ls_authsign-userid
*        && '",'
*        && '    "SignerName": "'
**      && 'NAGARAJAN S'
*        && signername
*        && '",'
*        && '    "TopLeft": 0,'
*        && '    "BottomLeft": 0,'
*        && '    "TopRight": 0,'
*        && '    "BottomRight": 0,'
*        && '    "ExcludePageNo": "",'
*        && '    "InvoiceNumber": "'
*        && billdoc
*        && '",'
*        && '    "pageNo": -1,'
*        && '    "PrintDateTime": "",'
*        && '    "FindAuth": "Authori",'
*        && '    "FindAuthLocation": 0,'
*        && '    "fontsize": 24,'
*        && '    "adjustCoordinates": 0,'
*        && '    "signOnlySearchTextPage": 1,'
*        && '    "pdfByte1": "'
*        && lv_pdf_xstring
*        &&  '" }'     ).
*            " execute HTTP POST-request and store response
*            lo_http_response = lo_http_client->execute( if_web_http_client=>post ).
*            DATA(ls_status) = lo_http_response->get_status(  ).
*            CLEAR: lv_dscrespb1.
*            lv_dscrespb1 = lo_http_response->get_text(  ).
*          CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error2).
*            DATA(lv_3) = 3.
*        ENDTRY.
*
*        if lv_dscrespb1 is noT iNITIAL.
*          CLEAR ls_dscresponse.
*          TRY.
*              CALL METHOD /ui2/cl_json=>deserialize
*                EXPORTING
*                  json          = lv_dscrespb1
*                  assoc_arrays  = abap_true
*                  name_mappings = VALUE #( ( json = 'file' abap = 'FILECONTENT' ) )
*                CHANGING
*                  data          = ls_dscresponse.
*            CATCH cx_root INTO DATA(lx_root).
*              DATA(lv_err1) = 1.
*          ENDTRY.
***********************************************************************
*          DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_dscresponse-filecontent  ).
*          DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).
***********************************************************************
*          data: gt_att type table of zsd_form_db,
*                gs_att type zsd_form_db.
*
*                if lv_print_data is not iNITIAL.
*                    gs_att-billingdocument = wa_header-BillingDocument.
*                    gs_att-attachment = lv_print_data.
*                    gs_att-filename = wa_header-BillingDocument.
*                    gs_att-mimetype = 'application/pdf'.
*
*                 APPEND gs_att to gt_att.
*                 zbp_sd_app11_header=>up_attach = gt_att.
*                endif.
*        enDIF.
*
*        endIF.
***********************************************************************
    result = VALUE #( FOR ls_ord IN header
                         ( %tky   = ls_ord-%tky
                           %param = ls_ord ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsd_app11_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsd_app11_header IMPLEMENTATION.

  METHOD save_modified.
  if zbp_sd_app11_header=>up_attach is NOT INITIAL.
    MODIFY zsd_form_db FROM TABLE @zbp_sd_app11_header=>up_attach.
  endif.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
