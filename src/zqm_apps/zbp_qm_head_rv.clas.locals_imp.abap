CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS getdata_header FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~getdata_header.
    METHODS print_view FOR MODIFY
      IMPORTING keys FOR ACTION head~print_view RESULT result.
    METHODS update_head FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~update_head.
    METHODS validateinsp FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~validateinsp.
    METHODS label_view FOR MODIFY
      IMPORTING keys FOR ACTION head~label_view RESULT result.

ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getdata_header.

    DATA : it_hdrdata TYPE TABLE OF ZQM_HEAD_DB,
           ls_hdrdata TYPE ZQM_HEAD_DB.
    DATA : gs_iso TYPE c LENGTH 6.
    DATA : gs_date TYPE n LENGTH 2.
    DATA : gs_f TYPE c LENGTH 1.

*    DATA : gs_iso TYPE ZGS_ISO.
*    DATA : gs_date TYPE zgs_date.
*    data : gs_f TYPE ZSUFIX_F.
    GET TIME STAMP FIELD Data(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
********************************************************

    READ ENTITIES OF  zqm_head_rv IN LOCAL MODE
    ENTITY Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_header).
    DATA(gs_header) = it_header[ 1 ].

******************************************************
    if gs_header-Inspection is not INITIAL.
        ls_hdrdata-uuid = gs_header-Uuid.
*        ls_hdrdata-reportissueon    = cl_abap_context_info=>get_system_date(  ).
        ls_hdrdata-reportissueon = gs_header-Reportissueon.
*********************************************************
    SELECT SINGLE MAX( serialno ) From ZQM_HEAD_DB Into @DATA(gs_docnu).
        if sy-subrc = 0 and gs_docnu is NOT INITIAL.
        gs_date = ls_hdrdata-reportissueon+0(4).
        gs_iso = 'TC5190'.
        gs_f = 'F'.
        if ( gs_header-Nablformat = 'BIS+NABL' or gs_header-Nablformat = 'NABL' ).
        ls_hdrdata-serialno = gs_docnu + 1.
*        ls_hdrdata-docno = ls_hdrdata-serialno.
        ls_hdrdata-ulrnum = |{ gs_iso }{ gs_date }{ ls_hdrdata-serialno }{ gs_f }|.

        ENDIF.
        ELSE.
*        ls_hdrdata-docno = '0000000001'.
        ls_hdrdata-serialno = '0000000001'.
        ls_hdrdata-ulrnum = 'TC5190250000000001F'.
        ENDIF.
*********************************************************
*        SELECT SINGLE MAX( Inspection ) From ZPP_QM_COA_TB1 Into @DATA(gs_insp).
*        if sy-subrc = 0 and gs_insp is not INITIAL.
*        ls_hdrdata-Inspection = gs_insp + 1.
*        ELSE.
*        ls_hdrdata-Inspection = '490000000000'.
*        endif.
        ls_hdrdata-Inspection = gs_header-Inspection.
*********************************************************
        ls_hdrdata-product            = gs_header-product.
        ls_hdrdata-discipline         = 'Chemical Testing'.
        ls_hdrdata-coagroup          = gs_header-coagroup.
        ls_hdrdata-customer             = gs_header-customer.
        ls_hdrdata-truckno           = gs_header-truckno.
        ls_hdrdata-issuedto          = gs_header-Issuedto.
*********************************************************
    if gs_header-Product is not INITIAL.
        SELECT SINGLE InspectionLot,ProductName  from zinspection_vh WITH PRIVILEGED ACCESS
                        where InspectionLot = @gs_header-Inspection
                        into @data(gs_prdes).
        if sy-subrc = 0.
        ls_hdrdata-productdesc       = gs_prdes-ProductName.
        endif.
    endif.
*********************************************************
        DATA: lv_cus(10) TYPE n.
        lv_cus = ls_hdrdata-customer.
        SELECT SINGLE * from ZQM_CUSTOMER_VH WHERE customer = @lv_cus
                                            into @DATA(gs_cus).
        if sy-subrc = 0.
        ls_hdrdata-partyaddress      = |{ gs_cus-StreetName } { gs_cus-CityName } { gs_cus-PostalCode } { gs_cus-Country }|.
        ENDIF.
*********************************************************
        ls_hdrdata-Reference           = gs_header-Reference.
        ls_hdrdata-samplereceipt     = gs_header-samplereceipt.
        ls_hdrdata-dateofanalyis    = gs_header-dateofanalyis.
        ls_hdrdata-batch              = gs_header-batch.
        ls_hdrdata-description        = gs_header-description.
        ls_hdrdata-plant              = gs_header-plant.
        ls_hdrdata-Nablformat         = gs_header-Nablformat.
        ls_hdrdata-termscond     = gs_header-Termscond.
        ls_hdrdata-status     = gs_header-status.
        ls_hdrdata-mark     = gs_header-Mark.
        ls_hdrdata-itmcnt     = gs_header-itmcnt.
        ls_hdrdata-mfgdate = gs_header-Mfgdate.
        ls_hdrdata-reportno = gs_header-Reportno.
        ls_hdrdata-createdby          = gs_header-createdby.
        ls_hdrdata-createdat          = gs_header-Createdat.
        ls_hdrdata-lastchangedby      = gs_header-lastchangedby.
        ls_hdrdata-lastchangedat      = gs_header-lastchangedat.

        ls_hdrdata-driver = gs_header-Driver.
        ls_hdrdata-conc = gs_header-Conc.

        APPEND ls_hdrdata to it_hdrdata.
        zbp_qm_head_rv=>gt_header = it_hdrdata.

    ENDIF.


**********************************************************************
        ""this one get result for Print purpose---
        if gs_header-Inspection is not iNITIAL.

            data: lt_res type table of zqm_result_db,
                  ls_res type zqm_result_db.

            select * from zqm_result_view with PRIVILEGED ACCESS
            where InspectionLot = @gs_header-Inspection
            into table @data(gt_result).

            sort gt_result ASCENDING BY InspectionCharacteristic.

            IF gt_result IS NOT INITIAL.

            lt_res = VALUE #(  FOR LS IN gt_result ( uuid = gs_header-uuid
                                             inspectionlot = LS-InspectionLot
                                             inspplanoperationinternalid = LS-InspPlanOperationInternalID
                                             inspectioncharacteristic =  ls-InspectionCharacteristic
                                             inspectioncharacteristictext = LS-inspectioncharacteristictext
                                             InspectionSpecification = LS-InspectionSpecification
                                             inspectioncodetext = LS-inspectioncodetext
                                             personfullname = ls-personfullname
                                             indicators = ls-indicators
                                             unitofmeasuretechnicalname = ls-unitofmeasuretechnicalname
                                             inspectionspecificationunit = ls-inspectionspecificationunit
                                             InspectionResultMeanValue = ls-InspectionResultMeanValue
                                             InspectionMeth = ls-InspectionMeth
                                             ResultMeanValue = ls-ResultMeanValue
                                             InspSpecificationName = ls-InspSpecificationName
                                              ) ).


                ENDIF.
            zbp_qm_head_rv=>get_result = lt_res.

           endif.


  ENDMETHOD.

  METHOD Print_View.

****------These method is COA NABL Print Call Method--------******
    DATA: lv_system_date TYPE d.
    DATA: gs_output TYPE c LENGTH 100.

*" Get the current system date using the recommended method
    lv_system_date = cl_abap_context_info=>get_system_date( ).

********************************************************
    READ ENTITIES OF zqm_head_rv IN LOCAL MODE
    ENTITY Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(gt_xmlhead).

*********************************************************
    DATA(gs_xmlhead) = VALUE #( gt_xmlhead[ 1 ] OPTIONAL ).

    if gs_xmlhead-Inspection is not INITIAL.
        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
             iv_name                  = 'ZADS_CS'
             iv_service_instance_name = 'ZADS_OUT_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZQM_HEAD_SD'
                                                                  iv_root_node = 'ZQM_HEAD_CE'
                                                                  ) .
**********************************************************************
            data: printque type c LENGTH 32.

              printque = 'ADOBE_DEFAULT'.
**********************************************************************
            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'ZCOANABL' ).
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
            lt_keys[ name = 'UUID' ]-value = gt_xmlhead[ 1 ]-Uuid.

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
***Testing purpose



***Testing purpose
*****************************************************************************
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'ZCOANABL'
              iv_template_name = 'coaform'
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
            lv_name = |Invoice { gt_xmlhead[ 1 ]-Inspection }|.

            DATA(lv_gno) = VALUE #( gt_xmlhead[ 1 ]-Inspection OPTIONAL ).

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
*        "out->write( 'Finished processing.' ).
    if lv_pdf is not iNITIAL.
        data: gt_formupdate TYPE TABLE OF ZQM_HEAD_DB,
              gs_formupdate TYPE ZQM_HEAD_DB.
**********************************************************************
        READ ENTITIES OF zqm_head_rv IN LOCAL MODE
        enTITY Head
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(GT_HEAD)
        FAILED DATA(gt_failed).

        data(gs_head) = gt_head[ 1 ].
        data(coaform) = |Inspection-{ gs_head-Inspection }|.
**********************************************************************
        MOVE-CORRESPONDING gs_head to gs_formupdate.
        gs_formupdate-coaattachment =  lv_pdf.
        gs_formupdate-coafilename =  coaform.
        gs_formupdate-coamimetype =  'application/pdf'.

        APPEND gs_formupdate TO gt_formupdate.
        zbp_qm_head_rv=>gt_formcoa = gt_formupdate.
    endif.
    endif.

*********************************************************
*    gs_output = |{ gs_xmlhead-Inspection }-{ gs_xmlhead-Truckno }-{ gs_xmlhead-Nablformat }|.
**    zbp_qm_head_rv=>gs_inspno = gs_xmlhead-Inspection.   "these one PDF Save option Number generator
*    zbp_qm_head_rv=>gs_inspno = gs_output.   "these one PDF Save option Number generator
*
*     SELECT * FROM zqm_result_view WHERE InspectionLot = @gs_xmlhead-Inspection
*                    INTO TABLE @DATA(gt_xmlitem).
*
*    DATA(it_xmlitem) = gt_xmlitem[].
*    DATA(gs_chname) = gt_xmlitem[ 1 ].
*    SORT it_xmlitem BY InspectionCharacteristic ASCENDING.
*    DATA: test TYPE c LENGTH 10.
*
*
*****------To Generate the our customizing XML file to the COA Form-------
*    DATA: lv_xml TYPE string.
*           REPLACE ALL OCCURRENCES OF '&' IN gs_xmlhead-Partyaddress WITH 'and'.
*           REPLACE ALL OCCURRENCES OF '&' IN gs_xmlhead-Description WITH 'and'.
*           REPLACE ALL OCCURRENCES OF '&' IN gs_xmlhead-Issuedto WITH 'and'.
*    lv_xml = |<?xml version="1.0" encoding="UTF-8"?>| &&
*             |<form1>| &&
*                |<main>| &&
*                    |<MainHead/>| &&
*                    |<MainHeader>| &&
*                    |<Insp>| && gs_xmlhead-Inspection && |</Insp>| &&
**                    |<Insp>| && test && |</Insp>| &&
*                    |<Rep>| && gs_xmlhead-Reportissueon && |</Rep>| &&
*                    |<Ulr>| && gs_xmlhead-Ulrnum && |</Ulr>| &&
*                    |<Dis>| && gs_xmlhead-Discipline && |</Dis>| &&
*                    |<group>| && gs_xmlhead-Coagroup && |</group>| &&
*                    |<repno>| && gs_xmlhead-Reportno && |</repno>| &&
*                    |<truck>| && gs_xmlhead-Truckno && |</truck>| &&
*                    |<issu>| && gs_xmlhead-Issuedto && |</issu>| &&
*                    |<partadd>| && gs_xmlhead-Partyaddress && |</partadd>| &&
*                    |<ref>| && gs_xmlhead-Reference && |</ref>| &&
*                    |<prddes>| && gs_xmlhead-Productdesc && |</prddes>| &&
*                    |<samrec>| && gs_xmlhead-Samplereceipt && |</samrec>| &&
*                    |<datean>| && gs_xmlhead-Dateofanalyis && |</datean>| &&
*                    |<batch>| && gs_xmlhead-Batch && |</batch>| &&
*                    |<mfgdate>| && gs_xmlhead-Mfgdate && |</mfgdate>| &&
*                    |<des>| && gs_xmlhead-Description && |</des>| &&
*                    |<plant>| && gs_xmlhead-Plant && |</plant>| &&
*                    |<prod>| && gs_xmlhead-Termscond && |</prod>| &&
*                    |<cus>| && gs_xmlhead-Nablformat && |</cus>| &&
*                    |<chmname>| && gs_chname-PersonFullName && |</chmname>| &&
*                    |</MainHeader>| .
*
*data(lv_count) = 1.
*DATA(lv_method) = 'Method'.
**    test = 'mg/l'.
*           LOOP at it_xmlitem INTO DATA(gs_xmlitem).
*           REPLACE ALL OCCURRENCES OF '&' IN gs_xmlitem-InspectionCharacteristicText WITH 'and'.
*           REPLACE ALL OCCURRENCES OF '&' IN gs_xmlitem-InspectionMeth WITH 'and'.
*           REPLACE ALL OCCURRENCES OF '&' IN gs_xmlitem-InspSpecificationName WITH 'and'.
*                lv_xml = lv_xml &&
*                        |<item>| &&
*                            |<Table1>| &&
*                                |<HeaderRow/>| &&
*                                |<Row1>| &&
*                                |<slno>| && lv_count && |</slno>| &&
*                                |<param>| && gs_xmlitem-InspectionCharacteristicText && |</param>| &&
*                                |<unit>| && gs_xmlitem-UnitOfMeasureTechnicalName && |</unit>| &&
*                                |<value>| && gs_xmlitem-ResultMeanValue && |</value>| &&
*                                |<meth>| && gs_xmlitem-InspectionMeth && |</meth>|.
*                                if ( gs_xmlhead-Nablformat = 'BIS+NABL' or gs_xmlhead-Nablformat = 'NABL' ).
*                                lv_xml = lv_xml &&
*                                |<InspSpec>| && gs_xmlitem-InspSpecificationName && |</InspSpec>|.
*                                endif.
*                                lv_xml = lv_xml &&
*                                |</Row1>| &&
*                            |</Table1>| &&
*                         |</item>|.
*            lv_count += 1.
*           ENDLOOP.
*
*               lv_xml = lv_xml &&
*                |</main>| &&
*              |</form1>|.
***********************************************************************
*
*
*    zbp_qm_head_rv=>gs_xmldata = lv_xml.
*
*    DATA: ls_data     TYPE ZCOA_S_BINDING,
*          ls_req      TYPE ZCOA_S_BODY,
*          ls_response TYPE ZCOA_RP_BODY.
*
***********************************************************************
*    TRY.
*        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
*        comm_scenario = 'ZADS_CS'
*        comm_system_id = 'ZADS'
*        service_id = 'ZADS_OUT_REST'
*
*        ).
*           CATCH cx_http_dest_provider_error INTO DATA(lx_error).
*           data(error) = 1.
*    ENDTRY.
*
***********************************************************************
*     TRY.
*
*        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
*
*      CATCH cx_web_http_client_error INTO DATA(lx_client_error).
*      data(error1) = 1.
*     ENDTRY.
*    DATA(lo_request) = lo_client->get_http_request(  ).
*    lo_request->set_header_fields( VALUE #(
*    ( name = 'Accept' value = 'application/json, text/plain, */*' )
*    ( name = 'Content-Type' value = 'application/json;charset=utf-8' )
*     ) ).
*
***********************************************************************
*    DATA(lv_base64_data) = cl_web_http_utility=>encode_base64( unencoded = zbp_qm_head_rv=>gs_xmldata ).
*
*    ls_req-xdp_template = 'ZCOANABL/coaform'.
**    ls_req-xdp_template = 'ztestcoa/zcoatest'.
*    ls_req-xml_data     = lv_base64_data.
*    ls_req-form_type    = 'print'.
*    ls_req-form_locale  = 'en_US'.
*    ls_req-tagged_pdf = 1.
*    ls_req-embed_font = 0.
*    ls_req-change_not_allowed = abap_false.
*    ls_req-print_not_allowed = abap_false.
*
*       TRY.
*        CALL METHOD /ui2/cl_json=>serialize
*          EXPORTING
*            data        = ls_req
*            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
*          RECEIVING
*            r_json      = DATA(lv_body).
*
*      CATCH cx_root INTO DATA(lx_root).
*      data(error2) = 1.
*    ENDTRY.
*    lo_request->set_text(
*    EXPORTING
*    i_text = lv_body ).
*
*     TRY.
*
*        DATA(lo_response) = lo_client->execute(
*        i_method = if_web_http_client=>post
*        i_timeout = 0  ).
*
*      CATCH cx_web_http_client_error INTO lx_client_error.
*      data(error3) = 1.
*    ENDTRY.
*
*    DATA(lv_response) = lo_response->get_text(  ).
*    DATA(ls_status) = lo_response->get_status(  ).
*
*    TRY.
*        CALL METHOD /ui2/cl_json=>deserialize
*          EXPORTING
*            json          = lv_response
*            assoc_arrays  = abap_true
*            name_mappings = VALUE #( ( json = 'filecontent' abap = 'FILECONTENT' ) )
*          CHANGING
*            data          = ls_response.
*      CATCH cx_root INTO lx_root.
*        data(error4) = 1.
*    ENDTRY.
*
*    DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_response-filecontent  ).
*    DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).
*
*    zbp_qm_head_rv=>gs_print_data = lv_print_data.
*    zbp_qm_head_rv=>gs_pqitem_id = lv_qitem_id.
*
***********************************************************************
**        "testing purpose
**    DATA(lv_text) = cl_web_http_utility=>encode_base64( lv_base64_data ).
**    DATA lv_decoded TYPE string.
**    DATA lv_reencoded  TYPE string.
**    lv_decoded = cl_web_http_utility=>decode_base64( encoded = lv_base64_data ).
**    data(lv_decoded) = cl_web_http_utility=>decode_base64( encoded = lv_text ).
**    REPLACE 'ENVIRONMENT' IN lv_decoded WITH 'Orignal'.
**    lv_reencoded = cl_web_http_utility=>encode_base64( lv_decoded ).
**    lv_print_data = cl_web_http_utility=>decode_x_base64( encoded = lv_reencoded  ).
*
***********************************************************************
*    if lv_print_data is not iNITIAL.
*        data: gt_formupdate TYPE TABLE OF ZQM_HEAD_DB,
*              gs_formupdate TYPE ZQM_HEAD_DB.
***********************************************************************
*        READ ENTITIES OF zqm_head_rv IN LOCAL MODE
*        enTITY Head
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(GT_HEAD)
*        FAILED DATA(gt_failed).
*
*        data(gs_head) = gt_head[ 1 ].
*        data(coaform) = |Inspection-{ gs_head-Inspection }|.
***********************************************************************
*        MOVE-CORRESPONDING gs_head to gs_formupdate.
*        gs_formupdate-coaattachment =  lv_print_data.
*        gs_formupdate-coafilename =  coaform.
*        gs_formupdate-coamimetype =  'application/pdf'.
*
*        APPEND gs_formupdate TO gt_formupdate.
*        zbp_qm_head_rv=>gt_formcoa = gt_formupdate.
*    endif.
***********************************************************************
*IF ls_status-reason = 'OK' and ls_status-code = '200'.
*
*append value #( %tky = gs_xmlhead-%tky
*%msg =  new_message_with_text( severity = if_abap_behv_message=>severity-success
*                                                        text = 'Printed Successfully' )
*                         ) TO reported-head.
*else.
*APPEND VALUE #( %tky = gs_xmlhead-%tky ) TO failed-head.
*append value #( %tky = gs_xmlhead-%tky
*%msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                        text = 'Not Printed' )
*                         ) TO reported-head.
*
*ENDIF.

 result = VALUE #( FOR ls_ord IN gt_xmlhead
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

**********************************************************************
  ENDMETHOD.

  METHOD update_Head.

    DATA : it_uphead TYPE TABLE OF ZQM_HEAD_DB,
           is_uphead TYPE ZQM_HEAD_DB.

********************************************************

    READ ENTITIES OF zqm_head_rv IN LOCAL MODE
    ENTITY Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_upheader).
    DATA(gs_upheader) = it_upheader[ 1 ].
    MOVE-CORRESPONDING gs_upheader to is_uphead.
        APPEND is_uphead to it_uphead.
    zbp_qm_head_rv=>gt_uphead = it_uphead.

  ENDMETHOD.

  METHOD ValidateInsp.

**********************************************************************
        READ ENTITY IN LOCAL MODE zqm_head_rv
        FIELDS ( Inspection )
        WITH CORRESPONDING #( keys )
        RESULT DATA(gt_inspection).

    DATA: it_inspe TYPE SORTED TABLE OF ZINSPECTION_VH WITH UNIQUE KEY InspectionLot.

    it_inspe = CORRESPONDING #( gt_inspection DISCARDING DUPLICATES MAPPING InspectionLot = Inspection ).

    DELETE it_inspe WHERE InspectionLot is INITIAL.

        SELECT
            FROM ZINSPECTION_VH
                FIELDS InspectionLot
                FOR ALL ENTRIES IN @it_inspe
                WHERE InspectionLot = @it_inspe-InspectionLot
                INTO TABLE @DATA(gt_insp).

**********************************************************************
        loop at gt_inspection assigning FIELD-SYMBOL(<gs_inspection>).

          if <gs_inspection> is INITIAL or
                not line_exists( gt_insp[ InspectionLot = <gs_inspection>-Inspection ] ).
                    APPEND VALUE #( %tky = <gs_inspection>-%tky )
                        TO failed-head.
                    APPEND VALUE #( %tky = <gs_inspection>-%tky
                                    %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                    text = 'Inspection Number is Wrong_' && <gs_inspection>-Inspection )
                                    %element-Inspection = if_abap_behv=>mk-on )
                        TO reported-head.
          ENDIF.
        endloop.

  ENDMETHOD.

  METHOD Label_View.


********************************************************
    READ ENTITIES OF zqm_head_rv IN LOCAL MODE
    ENTITY Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(gt_labelxml).

**********************************************************************
    DATA(gs_labelxml) = gt_labelxml[ 1 ].
**********************************************************************
    SELECT InspectionLot,PersonFullName FROM zqm_result_view WITH PRIVILEGED ACCESS
    where InspectionLot = @gs_labelxml-Inspection
    INTO table @data(gt_crname).

    DATA(gs_crname) = gt_crname[ 1 ].
**********************************************************************

    DATA: gs_labeloutput TYPE c LENGTH 100.

    gs_labeloutput = gs_labelxml-Truckno.

    zbp_qm_head_rv=>gs_labelno = gs_labeloutput.

****------To Generate the our customizing XML file to the COA Form-------
    DATA: lv_xml TYPE string.

    lv_xml = |<?xml version="1.0" encoding="UTF-8"?>| &&
             |<form1>| &&
                |<Main>| &&
                    |<Head>| &&
                        |<date>| && gs_labelxml-Reportissueon && |</date>| &&
                        |<tank>| && gs_labelxml-Truckno && |</tank>| &&
                        |<driver>| && gs_labelxml-Driver && |</driver>| &&
                        |<product>| && gs_labelxml-Productdesc  && |</product>| &&
                        |<conc>| && gs_labelxml-Conc && |</conc>| &&
                        |<chemist>| && gs_crname-PersonFullName && |</chemist>| &&
                    |</Head>| &&
                |</Main>| &&
            |</form1>|.

      zbp_qm_head_rv=>gs_labelxml = lv_xml.

    DATA: ls_data     TYPE ZCOA_S_BINDING,
          ls_req      TYPE ZCOA_S_BODY,
          ls_response TYPE ZCOA_RP_BODY.

**********************************************************************
    TRY.
        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
        comm_scenario = 'ZADS_CS'
        comm_system_id = 'ZADS'
        service_id = 'ZADS_OUT_REST'

        ).
           CATCH cx_http_dest_provider_error INTO DATA(lx_error).
          data(error5) = 1.
    ENDTRY.

**********************************************************************
     TRY.

        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

      CATCH cx_web_http_client_error INTO DATA(lx_client_error).
      data(error6) = 1.
     ENDTRY.
    DATA(lo_request) = lo_client->get_http_request(  ).
    lo_request->set_header_fields( VALUE #(
    ( name = 'Accept' value = 'application/json, text/plain, */*' )
    ( name = 'Content-Type' value = 'application/json;charset=utf-8' )
     ) ).

**********************************************************************
    DATA(lv_base64_data) = cl_web_http_utility=>encode_base64( unencoded = zbp_qm_head_rv=>gs_labelxml ).


    ls_req-xdp_template = 'zcoa_label/coalabel'.
    ls_req-xml_data     = lv_base64_data.
    ls_req-form_type    = 'print'.
    ls_req-form_locale  = 'en_US'.
    ls_req-tagged_pdf = 1.
    ls_req-embed_font = 0.
    ls_req-change_not_allowed = abap_false.
    ls_req-print_not_allowed = abap_false.

**********************************************************************
       TRY.
        CALL METHOD /ui2/cl_json=>serialize
          EXPORTING
            data        = ls_req
            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
          RECEIVING
            r_json      = DATA(lv_body).

      CATCH cx_root INTO DATA(lx_root).
      data(error7) = 1.
    ENDTRY.
    lo_request->set_text(
    EXPORTING
    i_text = lv_body ).

     TRY.

        DATA(lo_response) = lo_client->execute(
        i_method = if_web_http_client=>post
        i_timeout = 0  ).

      CATCH cx_web_http_client_error INTO lx_client_error.
      data(error8) = 1.
    ENDTRY.

    DATA(lv_response) = lo_response->get_text(  ).
    DATA(ls_status) = lo_response->get_status(  ).

**********************************************************************
    TRY.
        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json          = lv_response
            assoc_arrays  = abap_true
            name_mappings = VALUE #( ( json = 'filecontent' abap = 'FILECONTENT' ) )
          CHANGING
            data          = ls_response.
      CATCH cx_root INTO lx_root.
      data(error9) = 1.

    ENDTRY.

    DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_response-filecontent  ).
    DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).

    zbp_qm_head_rv=>gs_labelprint = lv_print_data.
    zbp_qm_head_rv=>gs_labelpqitem_id = lv_qitem_id.

**********************************************************************
if lv_print_data is not iNITIAL.
        data: gt_labelform TYPE TABLE OF ZQM_HEAD_DB,
              gs_labelform tYPE ZQM_HEAD_DB.

**********************************************************************
        READ ENTITIES OF zqm_head_rv IN LOCAL MODE
        ENTITY Head
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_label)
        FAILED DATA(gt_labelfailed).

        data(gs_label) = gt_label[ 1 ].
        data(labelname) = |Label-{ gs_label-Inspection }|.
**********************************************************************
        MOVE-CORRESPONDING gs_label to gs_labelform.
        gs_labelform-lapattachment = lv_print_data.
        gs_labelform-lapfilename = labelname.
        gs_labelform-lapmimetype = 'application/pdf'.

        APPEND gs_labelform TO gt_labelform.
        zbp_qm_head_rv=>gt_formlabel = gt_labelform.

enDIF.
**********************************************************************
IF ls_status-reason = 'OK' and ls_status-code = '200'.

append value #( %tky = gs_labelxml-%tky
%msg =  new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                        text = 'Label Printed Successfully' )
                         ) TO reported-head.
else.
APPEND VALUE #( %tky = gs_labelxml-%tky ) TO failed-head.
append value #( %tky = gs_labelxml-%tky
%msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Label Not Printed' )
                         ) TO reported-head.

ENDIF.

 result = VALUE #( FOR ls_ord IN gt_labelxml
                     ( %tky   = ls_ord-%tky
                       %param = ls_ord ) ).

**********************************************************************

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zqm_head_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zqm_head_rv IMPLEMENTATION.

  METHOD save_modified.
*********************************************************************
  if create-head is NOT INITIAL.
    if zbp_qm_head_rv=>gt_header is NOT INITIAL.
        DATA(gt_head) = zbp_qm_head_rv=>gt_header.
        MODIFY ZQM_HEAD_DB FROM TABLE @gt_head.
    ENDIF.
  ENDIF.
*********************************************************************
    IF delete-head IS NOT INITIAL.
      LOOP AT delete-head INTO DATA(ls_hd).
        DELETE FROM ZQM_HEAD_DB WHERE uuid = @ls_hd-Uuid.
      ENDLOOP.
    ENDIF.

*********************************************************************
    if zbp_qm_head_rv=>gt_uphead is NOT INITIAL.
        DATA(gt_uhead) = zbp_qm_head_rv=>gt_uphead.
        MODIFY ZQM_HEAD_DB FROM TABLE @gt_uhead.
    ENDIF.
*********************************************************************


*********---these one is the Final COA PDF Form Get part-----*********
*    if zbp_qm_head_rv=>gs_print_data is not INITIAL.
*        DATA(wa_print_data) = zbp_qm_head_rv=>gs_print_data.
*        DATA(wa_pqitem_id) = zbp_qm_head_rv=>gs_pqitem_id.
*        DATA(wa_inspno) = zbp_qm_head_rv=>gs_inspno.
*
*        cl_print_queue_utils=>create_queue_item_by_data(
*          EXPORTING
*            iv_qname            = 'ZCOAPRINT'
**            iv_qname            = 'ZDEVPRINT'
*            iv_print_data       =  wa_print_data
*            iv_name_of_main_doc = 'NABL-' && wa_inspno
*            iv_itemid           = wa_pqitem_id
*          IMPORTING
*            ev_err_msg          = DATA(gs_error_msg)
*        ).
*    endif.

          if zbp_qm_head_rv=>gt_formcoa is not iNITIAL.
            MODIFY ZQM_HEAD_DB from tABLE @zbp_qm_head_rv=>gt_formcoa.
          endif.
**********************************************************************
*****----These one is the final Label PDF Form Get Part--********
*     if zbp_qm_head_rv=>gs_labelprint is not INITIAL.
*        DATA(wa_labelprint) = zbp_qm_head_rv=>gs_labelprint.
*        DATA(wa_labelpqitem_id) = zbp_qm_head_rv=>gs_labelpqitem_id.
*        DATA(wa_labelno) = zbp_qm_head_rv=>gs_labelno.
*
*        cl_print_queue_utils=>create_queue_item_by_data(
*          EXPORTING
**            iv_qname            = 'ZDEVPRINT'
*            iv_qname            = 'ZLABELPRINT'
*            iv_print_data       =  wa_labelprint
*            iv_name_of_main_doc = 'Label-' && wa_labelno
*            iv_itemid           = wa_labelpqitem_id
*          IMPORTING
*            ev_err_msg          = DATA(gs_labelerror_msg)
*        ).
*
*     endif.
*****----These one is the final Label PDF Form Get Part--********
        if zbp_qm_head_rv=>gt_formlabel is not iNITIAL.
            MODIFY ZQM_HEAD_DB FROM TABLE @zbp_qm_head_rv=>gt_formlabel.
        endif.
**********************************************************************
        if zbp_qm_head_rv=>get_result is not iNITIAL.
            moDIFY zqm_result_db from table @zbp_qm_head_rv=>get_result.
        endif.



  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
