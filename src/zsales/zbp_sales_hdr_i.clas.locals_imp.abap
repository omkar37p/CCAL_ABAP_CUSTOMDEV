CLASS lhc_zsales_hdr_i DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zsales_hdr_i RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsales_hdr_i RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zsales_hdr_i RESULT result.

    METHODS pdf FOR MODIFY
      IMPORTING keys FOR ACTION zsales_hdr_i~pdf RESULT result.

ENDCLASS.

CLASS lhc_zsales_hdr_i IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD pdf.
**********************************************************************
        data : lv_base64 TYPE string,
               lv_token TYPE string,
               lv_message type string.
        DATA : gt_header TYPE table of zsales_hdr,

               gtup_formhead TYPE TABLE of zsales_hdr,
               gsup_formhead TYPE zsales_hdr.
**********************************************************************
        READ ENTITIES OF zsales_hdr_i IN LOCAL MODE
            ENTITY zsales_hdr_i
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT data(lt_head)
            ENTITY zsales_hdr_i BY \_item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_item).
***********************************************************************

          data(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).

            if ls_head-SalesDocument is NOT INITIAL.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
             iv_name                  = 'ZADS_CS'
             iv_service_instance_name = 'ZADS_OUT_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSALES_PRINTSD'
                                                                  iv_root_node = 'ZSALES_CUSENTITY'
                                                                  ) .
**********************************************************************
            data: printque type c LENGTH 32.

              printque = 'ADOBE_DEFAULT'.
**********************************************************************
            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'ZSALES' ).
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

            lt_keys[ name = 'SALESDOCUMENT' ]-value = lt_head[ 1 ]-SalesDocument.

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
              iv_form_name     = 'ZSALES'
              iv_template_name = 'SALESORDER_FORM'
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
            lv_name = |Invoice { lt_head[ 1 ]-SalesDocument }|.

            DATA(lv_gno) = VALUE #( lt_head[ 1 ]-SalesDocument OPTIONAL ).

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
        data: gt_formupdate TYPE TABLE OF zsales_table,
              gs_formupdate TYPE zsales_table.
**********************************************************************

        data(gs_head) = lt_head[ 1 ].
        data(coaform) = |Form-{ gs_head-SalesDocument }|.
**********************************************************************
*       MOVE-CORRESPONDING gs_head to gs_formupdate.
        gs_formupdate-salesdocument = gs_head-SalesDocument.
        gs_formupdate-attachment =  lv_pdf.
        gs_formupdate-filename =  coaform.
        gs_formupdate-mimetype =  'application/pdf'.

        APPEND gs_formupdate TO gt_formupdate.
        ZBP_sales_hdr_i=>gt_header = gt_formupdate.
    endif.



            endif.

            result = VALUE #( for ls_output in lt_head ( %tky = ls_output-%tky
                                                            %param = ls_output ) ).

******************************************************************************

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsales_hdr_i DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsales_hdr_i IMPLEMENTATION.

  METHOD save_modified.
    if  ZBP_sales_hdr_i=>gt_header is not INITIAL.
        MODIFY zsales_table FROM TABLE @ZBP_sales_hdr_i=>gt_header.

    endif.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
