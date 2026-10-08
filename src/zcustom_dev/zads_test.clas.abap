CLASS zads_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES :if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZADS_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
 DATA: ls_data     TYPE ztest_s_binding,
          ls_req      TYPE ztest_s_body,
          ls_response TYPE ztest_rp_body.

    TRY.

        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
        comm_scenario = 'ZADS_CS'
        comm_system_id = 'ZADS'
        service_id = 'ZADS_OUT_REST'

        ).


      CATCH cx_http_dest_provider_error INTO DATA(lx_error).
    ENDTRY.

    TRY.

        DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

      CATCH cx_web_http_client_error INTO DATA(lx_client_error).

    ENDTRY.
    DATA(lo_request) = lo_client->get_http_request(  ).
    lo_request->set_header_fields( VALUE #(
    ( name = 'Accept' value = 'application/json, text/plain, */*' )
    ( name = 'Content-Type' value = 'application/json;charset=utf-8' )
     ) ).

    ls_data = VALUE #( Textfield1 = 'Test form'
                        Datefield1 = '20250312'
                        Decimalfield1 = '55.89' ).
    TRY.
        CALL TRANSFORMATION ztest_tr_binding
        SOURCE form = ls_data
        RESULT XML  DATA(lv_xml).

      CATCH cx_root INTO DATA(lo_root).

    ENDTRY.
    DATA(lv_base64_data) = cl_web_http_utility=>encode_x_base64( unencoded = lv_xml ).

    ls_req-xdp_template = 'ZTEST/Test'.
    ls_req-xml_data     = lv_base64_data.
    ls_req-form_type    = 'print'.
    ls_req-form_locale  = 'tr_TR'.
    ls_req-tagged_pdf = 1.
    ls_req-embed_font = 0.
    ls_req-change_not_allowed = abap_false.
    ls_req-print_not_allowed = abap_false.

    TRY.
        CALL METHOD /ui2/cl_json=>serialize
          EXPORTING
            data        = ls_req
            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
          RECEIVING
            r_json      = DATA(lv_body).

      CATCH cx_root INTO DATA(lx_root).
    ENDTRY.
    lo_request->set_text(
    EXPORTING
    i_text = lv_body ).


    TRY.

        DATA(lo_response) = lo_client->execute(
        i_method = if_web_http_client=>post
        i_timeout = 0  ).

      CATCH cx_web_http_client_error INTO lx_client_error.
    ENDTRY.
    DATA(lv_response) = lo_response->get_text(  ).
    DATA(ls_status) = lo_response->get_status(  ).

    TRY.
        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json          = lv_response
            assoc_arrays  = abap_true
            name_mappings = VALUE #( ( json = 'filecontent' abap = 'FILECONTENT' ) )
          CHANGING
            data          = ls_response.
      CATCH cx_root INTO lx_root.

    ENDTRY.

  out->write( ls_response-filecontent ).
    DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_response-filecontent  ).
    DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).

    cl_print_queue_utils=>create_queue_item_by_data(
    EXPORTING
             iv_qname = 'ZPRINT'
             iv_print_data = lv_print_data
             iv_name_of_main_doc = 'ZTEST'
              iv_itemid = lv_qitem_id
        IMPORTING
        ev_err_msg = DATA(lv_error_msg)

     ).

ENDMETHOD.
ENDCLASS.
