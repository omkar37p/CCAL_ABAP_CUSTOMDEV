CLASS lhc__head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _head RESULT result.

    METHODS getdata_header FOR DETERMINE ON SAVE
      IMPORTING keys FOR _head~getdata_header.
    METHODS update_head FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _head~update_head.
    METHODS print_view FOR MODIFY
      IMPORTING keys FOR ACTION _head~print_view RESULT result.

ENDCLASS.

CLASS lhc__head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getdata_header.

    DATA : it_hdrdata TYPE TABLE OF ZPP_QM_COA_TB1,
           ls_hdrdata TYPE ZPP_QM_COA_TB1.
    DATA : gs_iso TYPE ZGS_ISO.
    DATA : gs_date TYPE zgs_date.
    data : gs_f TYPE ZSUFIX_F.

********************************************************

    READ ENTITIES OF  zpp_qm_coa01_rv IN LOCAL MODE
    ENTITY _Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_header).
    DATA(gs_header) = it_header[ 1 ].

******************************************************
    if gs_header-Plant is not INITIAL.
        ls_hdrdata-uuid = gs_header-Uuid.
        ls_hdrdata-reportissueon    = cl_abap_context_info=>get_system_date(  ).

*********************************************************
    SELECT SINGLE MAX( serialno ) From ZPP_QM_COA_TB1 Into @DATA(gs_docnu).
        if sy-subrc = 0 and gs_docnu is NOT INITIAL.
        gs_date = ls_hdrdata-reportissueon+0(4).
        gs_iso = 'TC5190'.
        gs_f = 'F'.
        if gs_header-Nablformat ne 'GENERAL'.
        ls_hdrdata-serialno = gs_docnu + 1.
        ls_hdrdata-docno = ls_hdrdata-serialno.
        ls_hdrdata-ulrnum = |{ gs_iso }{ gs_date }{ ls_hdrdata-serialno }{ gs_f }|.

        ENDIF.
        ELSE.
        ls_hdrdata-docno = '0000000001'.
        ls_hdrdata-serialno = '0000000001'.
        ls_hdrdata-ulrnum = 'TC5190250000000001F'.
        ENDIF.
*********************************************************
        SELECT SINGLE MAX( Inspection ) From ZPP_QM_COA_TB1 Into @DATA(gs_insp).
        if sy-subrc = 0 and gs_insp is not INITIAL.
        ls_hdrdata-Inspection = gs_insp + 1.
        ELSE.
        ls_hdrdata-Inspection = '490000000000'.
        endif.
*********************************************************
        ls_hdrdata-product            = gs_header-product.
        ls_hdrdata-discipline         = 'Chemical Testing'.
        ls_hdrdata-coagroup          = gs_header-coagroup.
        ls_hdrdata-customer             = gs_header-customer.
        ls_hdrdata-truckno           = gs_header-truckno.
        ls_hdrdata-productdesc       = gs_header-Productdesc.
        ls_hdrdata-issuedto          = gs_header-Issuedto.
*********************************************************
        DATA: lv_cus(10) TYPE n.
        lv_cus = ls_hdrdata-customer.
        SELECT SINGLE * from zpp_qm_customer_vh WHERE customer = @lv_cus
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
        ls_hdrdata-createdby          = gs_header-createdby.
        ls_hdrdata-createdat          = gs_header-Createdat.
        ls_hdrdata-lastchangedby      = gs_header-lastchangedby.
        ls_hdrdata-lastchangedat      = gs_header-lastchangedat.

        APPEND ls_hdrdata to it_hdrdata.
        zbp_pp_qm_coa01_rv=>gt_header = it_hdrdata.

    ENDIF.

  ENDMETHOD.

  METHOD update_Head.

    DATA : it_uphead TYPE TABLE OF ZPP_QM_COA_TB1,
           is_uphead TYPE ZPP_QM_COA_TB1.

********************************************************
    READ ENTITIES OF zpp_qm_coa01_rv IN LOCAL MODE
    ENTITY _Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(it_upheader).
    DATA(gs_upheader) = it_upheader[ 1 ].
    MOVE-CORRESPONDING gs_upheader to is_uphead.
        APPEND is_uphead to it_uphead.
    zbp_pp_qm_coa01_rv=>gt_uphead = it_uphead.


  ENDMETHOD.

  METHOD Print_View.

****------These method is COA NABL Print Call Method--------******
    DATA: lv_system_date TYPE d.

*" Get the current system date using the recommended method
    lv_system_date = cl_abap_context_info=>get_system_date( ).

********************************************************
    READ ENTITIES OF zpp_qm_coa01_rv IN LOCAL MODE
    ENTITY _Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(gt_xmlhead)
    ENTITY _Head BY \_Item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(gt_xmlitem).

********************************************************
    DATA(gs_xmlhead) = gt_xmlhead[ 1 ].
    zbp_pp_qm_coa01_rv=>gs_inspno = gs_xmlhead-Inspection.   "these one PDF Save option Number generator

    DATA(it_xmlitem) = gt_xmlitem[].
    SORT it_xmlitem BY Inspectionitem ASCENDING.

****------To Generate the our customizing XML file to the COA Form-------
    DATA: lv_xml TYPE string.

    lv_xml = |<?xml version="1.0" encoding="UTF-8"?>| &&
             |<form1>| &&
                |<main>| &&
                    |<MainHead/>| &&
                    |<MainHeader>| &&
                    |<Insp>| && gs_xmlhead-Inspection && |</Insp>| &&
                    |<Rep>| && gs_xmlhead-Reportissueon && |</Rep>| &&
                    |<Ulr>| && gs_xmlhead-Ulrnum && |</Ulr>| &&
                    |<Dis>| && gs_xmlhead-Discipline && |</Dis>| &&
                    |<group>| && gs_xmlhead-Coagroup && |</group>| &&
                    |<truck>| && gs_xmlhead-Truckno && |</truck>| &&
                    |<issu>| && gs_xmlhead-Issuedto && |</issu>| &&
                    |<partadd>| && gs_xmlhead-Partyaddress && |</partadd>| &&
                    |<ref>| && gs_xmlhead-Reference && |</ref>| &&
                    |<prddes>| && gs_xmlhead-Productdesc && |</prddes>| &&
                    |<samrec>| && gs_xmlhead-Samplereceipt && |</samrec>| &&
                    |<datean>| && gs_xmlhead-Dateofanalyis && |</datean>| &&
                    |<batch>| && gs_xmlhead-Batch && |</batch>| &&
                    |<des>| && gs_xmlhead-Description && |</des>| &&
                    |<plant>| && gs_xmlhead-Plant && |</plant>| &&
                    |<prod>| && gs_xmlhead-Plant && |</prod>| &&
                    |<cus>| && gs_xmlhead-Customer && |</cus>| &&
                    |</MainHeader>| .

data(lv_count) = 1.
           LOOP at it_xmlitem INTO DATA(gs_xmlitem).
                lv_xml = lv_xml &&
                        |<item>| &&
                            |<Table1>| &&
                                |<HeaderRow/>| &&
                                |<Row1>| &&
                                |<slno>| && lv_count && |</slno>| &&
                                |<param>| && gs_xmlitem-Mastericdes && |</param>| &&
                                |<unit>| && gs_xmlitem-Valueunit && |</unit>| &&
                                |<value>| && gs_xmlitem-Value && |</value>| &&
                                |<meth>| && gs_xmlitem-Method && |</meth>| &&
                                |</Row1>| &&
                            |</Table1>| &&
                         |</item>|.
            lv_count += 1.
           ENDLOOP.

               lv_xml = lv_xml &&
                |</main>| &&
              |</form1>|.
**********************************************************************
    zbp_pp_qm_coa01_rv=>gs_xmldata = lv_xml.


    DATA: ls_data     TYPE ZQM_S_BINDING,
          ls_req      TYPE ZQM_S_BODY,
          ls_response TYPE ZQM_RP_BODY.


**********************************************************************
    TRY.
        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
        comm_scenario = 'ZADS_CS'
        comm_system_id = 'ZADS'
        service_id = 'ZADS_OUT_REST'

        ).
           CATCH cx_http_dest_provider_error INTO DATA(lx_error).
    ENDTRY.

**********************************************************************
    TRY.

        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

      CATCH cx_web_http_client_error INTO DATA(lx_client_error).
     ENDTRY.
    DATA(lo_request) = lo_client->get_http_request(  ).
    lo_request->set_header_fields( VALUE #(
    ( name = 'Accept' value = 'application/json, text/plain, */*' )
    ( name = 'Content-Type' value = 'application/json;charset=utf-8' )
     ) ).

**********************************************************************
    DATA(lv_base64_data) = cl_web_http_utility=>encode_base64( unencoded = zbp_pp_qm_coa01_rv=>gs_xmldata ).


*    ls_req-xdp_template = 'ZCOANABL/coaform'.
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
*
*    ENDTRY.
*
*    DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_response-filecontent  ).
*    DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).
*
*    zbp_pp_qm_coa01_rv=>gs_print_data = lv_print_data.
*    zbp_pp_qm_coa01_rv=>gs_pqitem_id = lv_qitem_id.

  ENDMETHOD.

ENDCLASS.

CLASS lhc__item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _item RESULT result.

    METHODS getdata_item FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~getdata_item.
    METHODS update_item FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _item~update_item.

ENDCLASS.

CLASS lhc__item IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD getdata_item.

    DATA : it_item TYPE TABLE OF ZPP_QM_COA_TB2,
           gs_item TYPE ZPP_QM_COA_TB2.

***************************************************************
    READ ENTITIES OF zpp_qm_coa01_rv IN LOCAL MODE
          ENTITY _Head
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_Head)
          ENTITY _Head BY \_Item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_item).

    DATA(ls_head) = lt_Head[ 1 ].
    DATA(ls_item) = lt_item[ 1 ].
***************************************************************
    gs_item-uuid = ls_item-Uuid.
    gs_item-inspection = ls_head-Inspection.

***************************************************************
    SELECT SINGLE MAX( inspectionitem ) FROM ZPP_QM_COA_TB2
          WHERE uuid = @ls_head-Uuid
          INTO @DATA(ls_sno).
    if sy-subrc = 0 AND ls_sno is NOT INITIAL.
    gs_item-inspectionitem = ls_sno + 10.
    ELSE.
    gs_item-inspectionitem = 10.
    endif.
***************************************************************
    gs_item-masteric =  ls_item-Masteric.
    gs_item-mastericdes = ls_item-Mastericdes.
    gs_item-value =  ls_item-Value.
    gs_item-valueunit = ls_item-Valueunit.
    gs_item-method =  ls_item-Method.
    gs_item-createdat = ls_item-Createdat.
    gs_item-createdby =  ls_item-createdby.
    gs_item-lastchangedat = ls_item-lastchangedat.
    gs_item-lastchangedby = ls_item-lastchangedby.
***************************************************************
    APPEND gs_item TO it_item.
    zbp_pp_qm_coa01_rv=>gt_item = it_item.

  ENDMETHOD.

  METHOD update_Item.

    DATA : it_upitem TYPE TABLE OF ZPP_QM_COA_TB2,
           is_upitem TYPE ZPP_QM_COA_TB2.
***************************************************************
    READ ENTITIES OF   zpp_qm_coa01_rv IN LOCAL MODE
    ENTITY _Item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gtup_data).

***************************************************************
    LOOP AT gtup_data ASSIGNING FIELD-SYMBOL(<ts>).
    MOVE-CORRESPONDING <ts> to is_upitem.
    APPEND is_upitem to it_upitem.
    ENDLOOP.
    zbp_pp_qm_coa01_rv=>gt_upitem = it_upitem.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zpp_qm_coa01_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zpp_qm_coa01_rv IMPLEMENTATION.

  METHOD save_modified.

*********************************************************************
  if create-_head is NOT INITIAL.
    if zbp_pp_qm_coa01_rv=>gt_header is NOT INITIAL.
        DATA(gt_head) = zbp_pp_qm_coa01_rv=>gt_header.
        MODIFY zpp_qm_coa_tb1 FROM TABLE @gt_head.
    ENDIF.
  ENDIF.
*********************************************************************
    if zbp_pp_qm_coa01_rv=>gt_uphead is NOT INITIAL.
        DATA(gt_uhead) = zbp_pp_qm_coa01_rv=>gt_uphead.
        MODIFY zpp_qm_coa_tb1 FROM TABLE @gt_uhead.
    ENDIF.
*********************************************************************
  if create-_item is NOT INITIAL.
    if zbp_pp_qm_coa01_rv=>gt_item is NOT INITIAL.
        DATA(gt_item) = zbp_pp_qm_coa01_rv=>gt_item.
        MODIFY ZPP_QM_COA_TB2 FROM TABLE @gt_item.
    ENDIF.
  ENDIF.

*********************************************************************
    if update-_item is NOT INITIAL.
    if zbp_pp_qm_coa01_rv=>gt_upitem is NOT INITIAL.
        DATA(gt_uitem) = zbp_pp_qm_coa01_rv=>gt_upitem.
        MODIFY ZPP_QM_COA_TB2 FROM TABLE @gt_uitem.
    ENDIF.
    ENDIF.
**********************************************************************
    IF delete-_head IS NOT INITIAL.
      LOOP AT delete-_head INTO DATA(ls_hd).
        DELETE FROM zpp_qm_coa_tb1 WHERE uuid = @ls_hd-Uuid.
      ENDLOOP.
    ENDIF.

    IF delete-_item IS NOT INITIAL.
      LOOP AT delete-_item INTO DATA(ls_it).
        DELETE FROM ZPP_QM_COA_TB2 WHERE uuid = @ls_it-Uuid AND
                                        inspectionitem = @ls_it-Inspectionitem.
      ENDLOOP.
    ENDIF.
*********************************************************************

*********---these one is the Final COA PDF Form Get part-----*********

*    if zbp_pp_qm_coa01_rv=>gs_print_data is not INITIAL.
*        DATA(wa_print_data) = zbp_pp_qm_coa01_rv=>gs_print_data.
*        DATA(wa_pqitem_id) = zbp_pp_qm_coa01_rv=>gs_pqitem_id.
*        DATA(wa_inspno) = zbp_pp_qm_coa01_rv=>gs_inspno.
*
*        cl_print_queue_utils=>create_queue_item_by_data(
*          EXPORTING
*            iv_qname            = 'ZPRINT'
*            iv_print_data       =  wa_print_data
*            iv_name_of_main_doc = 'NABL-' && wa_inspno
*            iv_itemid           = wa_pqitem_id
**            iv_pages            =
**            iv_number_of_copies =
**            it_attachment_data  =
*          IMPORTING
*            ev_err_msg          = DATA(gs_error_msg)
**          RECEIVING
**            rv_itemid           =
*        ).
*
*    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
