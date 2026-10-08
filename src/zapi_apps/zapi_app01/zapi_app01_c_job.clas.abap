CLASS zapi_app01_c_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************************************************************
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .
**********************************************************************
    TYPES : BEGIN OF ty_item,
              invoicenumber TYPE string,
              invoiceitemno TYPE string,
              product       TYPE string,
              itemdesc      TYPE string,
              plant         TYPE string,
              quantity      TYPE string,
              basevalue     TYPE string,
              netvalue      TYPE string,
              taxvalue      TYPE string,
              igstvalue     TYPE string,
              cgstvalue     TYPE string,
              sgstvalue     TYPE string,
              freightvalue  TYPE string,
              tcsvalue      TYPE string,
              currency      TYPE string,
            END OF ty_item.

    TYPES : BEGIN OF ty_invoice,
              invoicenumber TYPE string,
              invoicedate   TYPE string,
              invoicetime   TYPE string,
              invoicetype   TYPE string,
              to_item       TYPE STANDARD TABLE OF ty_item WITH DEFAULT KEY,
            END OF ty_invoice.


**********************************************************************

  PROTECTED SECTION.
    DATA : ls_json TYPE ty_invoice.
    DATA lv_json TYPE string.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZAPI_APP01_C_JOB IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

**********************************************************************

    et_parameter_def = VALUE #(
  " 1. Date Range Field
  ( selname        = 'ZDATE'
    param_text     = 'Invoice Date Range'
    datatype       = 'D'
    length         = 8
    kind           = if_apj_dt_exec_object=>select_option
    changeable_ind = abap_true
    mandatory_ind  = abap_true )

**********************************************************************

  " 2. Time Range Field
  ( selname        = 'ZTIME'
    param_text     = 'Invoice Time Range'
    datatype       = 'T'
    length         = 6
    kind           = if_apj_dt_exec_object=>select_option
    changeable_ind = abap_true
    mandatory_ind  = abap_true )
).

**********************************************************************




  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
**********************************************************************



**********************************************************************

    DATA: lt_date_range TYPE RANGE OF d,
          lt_time_range TYPE RANGE OF t.


    lt_date_range = VALUE #( FOR param IN it_parameters WHERE ( selname = 'ZDATE' )
                             ( sign   = param-sign
                               option = param-option
                               low    = param-low
                               high   = param-high ) ).

    lt_time_range = VALUE #( FOR param IN it_parameters WHERE ( selname = 'ZTIME' )
                             ( sign   = param-sign
                               option = param-option
                               low    = param-low
                               high   = param-high ) ).

**********************************************************************


    DATA(lv_date_l) = VALUE #( lt_date_range[ 1 ]-low OPTIONAL ).
    DATA(lv_date_h) = VALUE #( lt_date_range[ 1 ]-high DEFAULT lv_date_l ).

    DATA(lv_time_l) = VALUE #( lt_time_range[ 1 ]-low DEFAULT '000000' ).
    DATA(lv_time_h) = VALUE #( lt_time_range[ 1 ]-high DEFAULT '235959' ).

**********************************************************************

    SELECT *
    FROM zapi_app01_rv
    WHERE creationdate BETWEEN @lv_date_l AND @lv_date_h AND creationtime BETWEEN @lv_time_l AND @lv_time_h
    INTO TABLE @DATA(gt_data).

**********************************************************************
    IF sy-subrc = 0.
      LOOP AT gt_data INTO DATA(gw_data) GROUP BY ( billingdocument  = gw_data-billingdocument ) INTO DATA(lg_grp).
        gw_data = VALUE #( gt_data[ billingdocument = lg_grp-billingdocument ] OPTIONAL ).
        ls_json-invoicenumber = gw_data-billingdocument.
        ls_json-invoicetype = gw_data-billingdocumenttype.
        ls_json-invoicedate = gw_data-creationdate.
        ls_json-invoicetime = gw_data-creationtime.

        LOOP AT GROUP lg_grp INTO DATA(lw_grp).
          APPEND VALUE ty_item( invoicenumber = gw_data-billingdocument
          invoiceitemno = lw_grp-billingdocumentitem
          product = lw_grp-product
          itemdesc = lw_grp-billingdocumentitemtext
          netvalue = lw_grp-taxblevalue
          basevalue = lw_grp-basevalue
          cgstvalue = lw_grp-cgstvalue
          sgstvalue = lw_grp-sgstvalue
          igstvalue = lw_grp-igstvalue
          freightvalue = lw_grp-freight
          quantity = lw_grp-quantity
          taxvalue = lw_grp-taxamount
          tcsvalue = lw_grp-tcsvalue
          currency = lw_grp-curr
           ) TO ls_json-to_item.

        ENDLOOP.
        TRY.
        CALL METHOD /ui2/cl_json=>serialize
          EXPORTING
            data        = ls_json
            pretty_name = /ui2/cl_json=>pretty_mode-pascal_case
          RECEIVING
            r_json      = lv_json.

      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_err4) = 1.
    ENDTRY.

    clear ls_json-to_item.


    IF lv_json IS NOT INITIAL.
      TRY.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZAPI_APP01_CS'
                                      service_id    = 'ZAPI_APP01_INV_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          lo_request->set_text( lv_json ).
          FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close( ).
          CLEAR lv_json.

        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
      ENDTRY.
    ENDIF.

      ENDLOOP.

    ENDIF.













  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
