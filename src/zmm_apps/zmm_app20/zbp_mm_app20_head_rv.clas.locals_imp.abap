CLASS lhc_rejhead DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR rejhead RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR rejhead RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR rejhead RESULT result.

    METHODS getpdf FOR MODIFY
      IMPORTING keys FOR ACTION rejhead~getpdf RESULT result.

    METHODS getdata FOR DETERMINE ON SAVE
      IMPORTING keys FOR rejhead~getdata.
    METHODS migovalid FOR VALIDATE ON SAVE
      IMPORTING keys FOR rejhead~migovalid.
    METHODS uphead FOR DETERMINE ON MODIFY
      IMPORTING keys FOR rejhead~uphead.

ENDCLASS.

CLASS lhc_rejhead IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD getpdf.
**********************************************************************
        data : lv_base64 TYPE string,
               lv_token TYPE string,
               lv_message type string.
        DATA : gt_header TYPE table of zmm_reject_hdb,
               gt_item TYPE table of zmm_reject_idb,
               gtup_formhead TYPE TABLE of zmm_reject_hdb,
               gsup_formhead TYPE zmm_reject_hdb.
**********************************************************************
        READ ENTITIES OF zmm_app20_head_rv IN LOCAL MODE
            ENTITY RejHead
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT data(lt_head)
            ENTITY RejHead BY \_Item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_item).
***********************************************************************

          data(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

            if ls_head-Materialdocument is NOT INITIAL.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
             iv_name                  = 'ZADS_CS'
             iv_service_instance_name = 'ZADS_OUT_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZREJ_NOTE_CE'
                                                                  iv_root_node = 'ZREJ_NOTE_HEAD_CE'
                                                                  ) .
**********************************************************************
            data: printque type c LENGTH 32.

              printque = 'ADOBE_DEFAULT'.
**********************************************************************
            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'ZMM_REJ' ).
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

            lt_keys[ name = 'UUID' ]-value = lt_head[ 1 ]-Uuid.

            data(lt_xsd) = lo_fdp_util->get_xsd( ).
*            lt_xsd[ name = 'BILLINGDOCUMENT' ]-value = header[ 1 ]-BillingDocument.

             data(lv_text) = cl_web_http_utility=>decode_utf8( encoded = lt_xsd ).

            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
                "out->write( 'Service data retrieved' ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
              data(lo_error3) = 3.
            ENDTRY..

*****************************************************************************
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'ZMM_REJ'
              iv_template_name = 'MM_REJ'
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
            lv_name = |Invoice { lt_head[ 1 ]-Materialdocument }|.

            DATA(lv_gno) = VALUE #( lt_head[ 1 ]-Materialdocument OPTIONAL ).

**********************************************************************
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = printque
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_name
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
            " out->write( 'Exception occurred.' ).
            data(lo_error) = 2.
        ENDTRY.
        "out->write( 'Finished processing.' ).
    if lv_pdf is not iNITIAL.
        data: gt_formupdate TYPE TABLE OF ZMM_REJECT_HDB,
              gs_formupdate TYPE ZMM_REJECT_HDB.
**********************************************************************
        READ ENTITIES OF zmm_app20_head_rv IN LOCAL MODE
            ENTITY RejHead
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT data(Gt_head).

        data(gs_head) = gt_head[ 1 ].
        data(coaform) = |Form-{ gs_head-Materialdocument }|.
**********************************************************************
        MOVE-CORRESPONDING gs_head to gs_formupdate.
        gs_formupdate-attachmentsul =  lv_pdf.
        gs_formupdate-filenameul =  coaform.
        gs_formupdate-mimetypeul =  'application/pdf'.

        APPEND gs_formupdate TO gt_formupdate.
        zbp_mm_app20_head_rv=>update_form = gt_formupdate.
    endif.



            endif.


*         MOVE-CORRESPONDING lt_head to gt_header.
*         MOVE-CORRESPONDING lt_item to gt_item.
***********************************************************************
*
*            zcl_btp_adobe_form=>get_ouath_token(
*              EXPORTING
*                im_oauth_url    = 'ADS_OAUTH_URL'
*                im_client_id    = 'ADS_CLIENTID'
*                im_clientsecret = 'ADS_CLIENTSECRET'
*              IMPORTING
*                ex_token        = lv_token
*                ex_message      = lv_message
*            ).
*
***********************************************************************
*            zbp_mm_app20_head_rv=>get_pdf_xml(
*              EXPORTING
*                im_head    = gt_header
*                im_item    = gt_item
*              IMPORTING
*                ex_base_64 = lv_base64
*            ).
*
***********************************************************************
*            data: lv_form_name TYPE string.
*                  lv_form_name = 'ZMM_REJECTION/REJECTION'.
***********************************************************************
*            zcl_btp_adobe_form=>get_pdf_api(
*              EXPORTING
*                im_url           = 'ADS_URL'
*                im_url_path      = '/v1/adsRender/pdf?TraceLevel=2&templateSource=storageName'
*                im_client_id     = 'ADS_CLIENTID'
*                im_clientsecret  = 'ADS_CLIENTSECRET'
*                im_token         = lv_token
*                im_base64_encode = lv_base64
*                im_xdp_template  = lv_form_name
*              IMPORTING
*                ex_base64_decode = DATA(lv_base64_decode)
*                ex_message       = lv_message
*            ).
***********************************************************************
*        DATA: gt_formupdate TYPE TABLE of zmm_reject_hdb,
*              gs_formupdate TYPE zmm_reject_hdb.
***********************************************************************
*            READ ENTITIES OF zmm_app20_head_rv IN LOCAL MODE
*            ENTITY RejHead
*            ALL FIELDS WITH CORRESPONDING #( keys )
*            RESULT DATA(gt_formout).
*
*            DATA(gs_formout) =  gt_formout[ 1 ].
*
*            MOVE-CORRESPONDING gs_formout to gs_formupdate.
*
*            gs_formupdate-attachmentsul = lv_base64_decode.
*            gs_formupdate-filenameul = 'Form'.
*            gs_formupdate-mimetypeul = 'application/pdf'.
*
*            APPEND gs_formupdate to gt_formupdate.
*            zbp_mm_app20_head_rv=>update_form = gt_formupdate.
***********************************************************************
******Automatic Email Triger---



*            data: lv_sender type c LENGTH 512,
*                  lv_reciever type c length 512.
*
*                lv_sender = 'SAPAutomail@ccal.in'.
*                lv_reciever = 'tharmaraj.seenikkalai@zietatech.com'.
*                DATA : iv_content      TYPE string .
*                iv_content = |<p>Dear Sir / Madam,</p><p></p><p>Please confirm the Rejection Note Form.</p><p></p><p>Thanking you,</p><p>CCAL</p>|.
*
*  try.
*
*           data(lo_mail) = cl_bcs_mail_message=>create_instance(  ).
*           lo_mail->set_sender( lv_sender ).
*           lo_mail->add_recipient( lv_reciever ).
*           lo_mail->set_subject( 'Rejection Note Form' ) .
*    "-----------------------------------------------------------
*    " Add HTML body
*    "-----------------------------------------------------------
*    lo_mail->set_main(
*        cl_bcs_mail_textpart=>create_instance(
*            iv_content      = iv_content
*            iv_content_type = 'text/html'
*        )
*    ).
*        "---------------------------------------------------------------
*    " Add PDF attachment from Base64
*    "---------------------------------------------------------------
*    lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
*                            iv_content = lv_base64_decode   " PDF Base64 from ADS
*                            iv_content_type = 'application/pdf'
*                            iv_filename     = 'Rejection_Note.pdf' ) ).
*    "-----------------------------------------------------------
*    " Send Email & Capture Status
*    "-----------------------------------------------------------
*    lo_mail->send(
*        IMPORTING et_status = DATA(lt_status)
*    ).
*        CATCH cx_bcs_mail INTO data(lx_mail1).
*          " TODO: log failure
*      ENDTRY.
*    "--------------------------------------------------
*    " Validate Send Status
*    "--------------------------------------------------
*    LOOP AT lt_status ASSIGNING FIELD-SYMBOL(<fs_status>).
*
*    ENDLOOP.

            result = VALUE #( for ls_output in Gt_head ( %tky = ls_output-%tky
                                                            %param = ls_output ) ).

******************************************************************************
  ENDMETHOD.

  METHOD getdata.

**********************************************************************
        DATA: it_header type table of zmm_reject_hdb,
              ls_header type zmm_reject_hdb.

        get TIME STAMP FIELD DATA(ts).
        CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).

**********************************************************************
        READ ENTITIES OF zmm_app20_head_rv IN LOCAL MODE
        ENTITY RejHead
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_head).

**********************************************************************
        data(gs_head) = gt_head[ 1 ].

        if gs_head-Materialdocument is not INITIAL.
            MOVE-CORRESPONDING gs_head to ls_header.


            SELECT SINGLE MAX( mdn ) from zmm_reject_hdb wiTH PRIVILEGED ACCESS
            where plant = @gs_head-Plant
            into @DATA(gs_serial).
            if gs_head-Plant = '1100'.
            if sy-subrc = 0 and gs_serial is not INITIAL.
                    ls_header-mdn = gs_serial + 1.
                    ls_header-mdnno = |MDN{ ls_header-mdn }|.
                ELSE.
                    ls_header-mdn = '1100000001'.
                    ls_header-mdnno = 'MDN1100000001'.
            ENDIF.
            elseif gs_head-Plant = '2100'.
            if sy-subrc = 0 and gs_serial is not INITIAL.
                    ls_header-mdn = gs_serial + 1.
                    ls_header-mdnno = |MDN{ ls_header-mdn }|.
                ELSE.
                    ls_header-mdn = '2100000001'.
                    ls_header-mdnno = 'MDN2100000001'.
            ENDIF.
            elseif gs_head-Plant = '3100'.
            if sy-subrc = 0 and gs_serial is not INITIAL.
                    ls_header-mdn = gs_serial + 1.
                    ls_header-mdnno = |MDN{ ls_header-mdn }|.
                ELSE.
                    ls_header-mdn = '3100000001'.
                    ls_header-mdnno = 'MDN3100000001'.
            ENDIF.
            ENDIF.
                    ls_header-mdndate = lv_date.
            SELECT SINGLE * from zmm_migo_head WITH PRIVILEGED ACCESS
                    WHERE MaterialDocument = @gs_head-Materialdocument
                    and MaterialDocumentYear = @gs_head-Materialdocumentyear
                    into @DATA(wa_head).

                    ls_header-purchaseorder = wa_head-PurchaseOrder.
                    ls_header-purchaseorderdate = wa_head-PurchaseOrderDate.
                    ls_header-purchaseorderitem = wa_head-PurchaseOrderItem.
                    ls_header-supplier = wa_head-Supplier.
                    ls_header-supplierfullname = wa_head-SupplierFullName.
                    ls_header-street1 = wa_head-street1.
                    ls_header-street2 = wa_head-street2.
                    ls_header-cityname = wa_head-CityName.
                    ls_header-postalcode = wa_head-PostalCode.

                    APPEND ls_header to it_header.
                    zbp_mm_app20_head_rv=>gt_header = it_header.

**********************************************************************
        DATA: lt_getitem type table of zmm_reject_idb,
              ls_getitem TYPE zmm_reject_idb.

**********************************************************************
            SELECT * from ZMM_MIGO_ITEM  WITH PRIVILEGED ACCESS
            where MaterialDocument = @gs_head-Materialdocument
            and MaterialDocumentYear = @gs_head-Materialdocumentyear
            INto table @data(gt_migo).
                if gt_migo is not initial.

                    lt_getitem = VALUE #( for ls in gt_migo ( uuid = gs_head-Uuid
                                                              materialdocument = ls-MaterialDocument
                                                              materialdocumentitem = ls-MaterialDocumentItem
                                                              materialdocumentyear = ls-MaterialDocumentYear
                                                              plant = ls-Plant
                                                              companycode = ls-Plant
                                                              companycodecurrency = ls-CompanyCodeCurrency
                                                              material = ls-Material
                                                              productdescription = ls-ProductDescription
                                                              materialbaseunit = ls-MaterialBaseUnit
                                                              migoqty = ls-MigoQty
                                                              poqty = ls-POQty
                                                              createdat = gs_head-Createdat
                                                              createdby = gs_head-Createdby
                                                              lastchangedat = gs_head-Lastchangedat
                                                              lastchangedby = gs_head-Lastchangedby ) ).
                ENDIF.
                    zbp_mm_app20_head_rv=>gt_getitems = lt_getitem.

        ENDIF.

  ENDMETHOD.

  METHOD MigoValid.
**********************************************************************
            READ ENTITIES OF zmm_app20_head_rv IN LOCAL MODE
            ENTITY RejHead
            ALL FIELDS WITH CORRESPONDING #( Keys )
            reSULT dATA(get_head)
            fAILED dATA(get_failed).

            data(gets_head) = get_head[ 1 ].

            seleCT singLE  * frOM ZMM_REJECT_HDB wiTH PRIVILEGED ACCESS
            where materialdocument = @gets_head-Materialdocument
            and   materialdocumentyear = @gets_head-Materialdocumentyear
            inTO @data(wa_migo).
**********************************************************************
            if wa_migo is not inITIAL.
                apPEND value #( %tky = gets_head-%tky )
                    to failed-rejhead.
                APPEND VALUE #( %tky = gets_head-%tky
                                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                text = 'This Migo Number is there' && gets_head-Materialdocument )
                                %element-Materialdocument = if_abap_behv=>mk-on )
                                to reported-rejhead.
            enDIF.
  ENDMETHOD.

  METHOD uphead.

            data: gt_uphd type table of zmm_reject_hdb,
                  gs_uphd type zmm_reject_hdb.

            READ ENTITIES OF zmm_app20_head_rv IN LOCAL MODE
            ENTITY RejHead
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_head)
            FAILED DATA(lt_failed).

            data(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

            if lt_head is not INITIAL.

                MOVE-CORRESPONDING ls_head to gs_uphd.
                APPEND gs_uphd to gt_uphd.
                zbp_mm_app20_head_rv=>gt_upheader = gt_uphd.
            endif.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_rejitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR rejitem~updateitem.
    METHODS validqty FOR VALIDATE ON SAVE
      IMPORTING keys FOR rejitem~validqty.

ENDCLASS.

CLASS lhc_rejitem IMPLEMENTATION.

  METHOD updateitem.

**********************************************************************
        data: lt_upitem type table of zmm_reject_idb,
              ls_upitem TYPE zmm_reject_idb.

**********************************************************************
        READ ENTITIES OF zmm_app20_head_rv IN LOCAL MODE
        ENTITY RejHead
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_rejhead)
        ENTITY RejHead BY \_Item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_upitem).
**********************************************************************

        LOOP at gt_upitem INTO DATA(gs_upitem).
            MOVE-CORRESPONDING gs_upitem to ls_upitem.
            APPEND ls_upitem to lt_upitem.
        ENDLOOP.
            zbp_mm_app20_head_rv=>gt_upitem = lt_upitem.

  ENDMETHOD.

  METHOD ValidQty.
**********************************************************************
            read ENTITIES OF zmm_app20_head_rv iN LOCAL MODE
            ENTITY RejHead
            aLL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(head)
            ENTITY RejHead BY \_Item
            ALL FIELDS WITH CORRESPONDING #( Keys )
            RESULT DATA(item)
            fAILED dATA(data_failed).
**********************************************************************
            data(wa_head) = head[ 1 ].
            loop at item into data(wa_item).

                select single MaterialDocument,MaterialDocumentItem,MaterialDocumentYear,
                             POQty from ZMM_MIGO_ITEM wiTH PRIVILEGED ACCESS
                where MaterialDocument = @wa_item-Materialdocument
                and MaterialDocumentItem = @wa_item-Materialdocumentitem
                and MaterialDocumentYear = @wa_item-Materialdocumentyear
                into @data(wa_po).
                if wa_po-POQty < wa_item-Acceptedqty.
                apPEND value #( %tky = wa_head-%tky )
                    to failed-RejHead.

                APPEND VALUE #( %tky = wa_head-%tky
                                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                text = 'Accepted Qty is more then PO Qty' ) )
                                to reported-rejhead.
                ELSEIF wa_po-POQty < wa_item-Receivedqty.
                apPEND value #( %tky = wa_head-%tky )
                    to failed-RejHead.

                APPEND VALUE #( %tky = wa_head-%tky
                                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                text = 'Received Qty is more then PO Qty' ) )
                                to reported-rejhead.

                ELSEIF wa_po-POQty < wa_item-Rejectedqty.

                apPEND value #( %tky = wa_head-%tky )
                    to failed-RejHead.

                APPEND VALUE #( %tky = wa_head-%tky
                                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                text = 'Rejected Qty is more then PO Qty' ) )
                                to reported-rejhead.
                ELSEIF wa_po-POQty < wa_item-Invoiceqty.
                apPEND value #( %tky = wa_head-%tky )
                    to failed-RejHead.

                APPEND VALUE #( %tky = wa_head-%tky
                                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                text = 'Invoice Qty is more then PO Qty' ) )
                                to reported-rejhead.
                enDIF.
            enDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app20_head_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app20_head_rv IMPLEMENTATION.

  METHOD save_modified.

**********************************************************************
        if create-rejhead is not INITIAL.
            if zbp_mm_app20_head_rv=>gt_header is not INITIAL.
                MODIFY zmm_reject_hdb FROM TABLE @zbp_mm_app20_head_rv=>gt_header.
            ENDIF.
            if zbp_mm_app20_head_rv=>gt_getitems is not INITIAL.
                MODIFY zmm_reject_idb FROM TABLE @zbp_mm_app20_head_rv=>gt_getitems.
            ENDIF.
        ENDIF.
**********************************************************************
        if delete-rejhead is NOT INITIAL.
            loop at delete-rejhead INTO DATA(wa_hddelete).
                DELETE FROM zmm_reject_hdb WHERE uuid = @wa_hddelete-Uuid
                                            and materialdocument = @wa_hddelete-Materialdocument.
            ENDLOOP.
        ENDIF.

**********************************************************************
         if zbp_mm_app20_head_rv=>update_form is NOT INITIAL.
                DATA(gtupdate) = zbp_mm_app20_head_rv=>update_form.
                MODIFY zmm_reject_hdb FROM TABLE @gtupdate.
         ENDIF.

         if zbp_mm_app20_head_rv=>gt_upheader is not INITIAL.
                MODIFY zmm_reject_hdb from table @zbp_mm_app20_head_rv=>gt_upheader.
         endif.
**********************************************************************
*        if update-rejitem is NOT INITIAL.
            if zbp_mm_app20_head_rv=>gt_upitem is not INITIAL.
                MODIFY zmm_reject_idb from table @zbp_mm_app20_head_rv=>gt_upitem.
            ENDIF.
*       ENDIF.
**********************************************************************
        if delete-rejitem is not INITIAL.
            loop at delete-rejitem into data(wa_itdelete).
                DELETE FROM zmm_reject_idb WHERE uuid = @wa_itdelete-Uuid
                                           AND materialdocument = @wa_itdelete-Materialdocument
                                           and materialdocumentitem = @wa_itdelete-Materialdocumentitem.
            ENDLOOP.
        ENDIF.
**********************************************************************
**********************************************************************
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
