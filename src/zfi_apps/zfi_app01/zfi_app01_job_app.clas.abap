CLASS zfi_app01_job_app DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .

    TYPES: BEGIN OF ty_transaction_status,
BankFlowException          TYPE string,
         UniqueTransactionReference TYPE string,
         UTR                        TYPE string,
         Status                     TYPE string,
         TransactionStatus          TYPE string,
         ErrorMessage               TYPE string,
           END OF ty_transaction_status.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: tt_zfi_app01_ct TYPE TABLE OF zfi_app01_ct WITH DEFAULT KEY.
    METHODS:
      get_pending_data RETURNING VALUE(rt_data) TYPE tt_zfi_app01_ct,
      get_bankflow_status IMPORTING iv_docno         TYPE belnr_d
                                    iv_unid          TYPE   awkey
                          RETURNING VALUE(rv_status) TYPE ty_transaction_status,
      process_entry IMPORTING is_entry TYPE zfi_app01_ct,
      update_standard_je IMPORTING is_entry  TYPE zfi_app01_ct
                                   iv_status TYPE ty_transaction_status,
      update_custom_table IMPORTING is_entry  TYPE zfi_app01_ct
                                    iv_status TYPE ty_transaction_status.
ENDCLASS.



CLASS ZFI_APP01_JOB_APP IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.


  METHOD get_bankflow_status.

**********************************************************************
    DATA: lv_request_url        TYPE string,
          lo_http_destination   TYPE REF TO if_http_destination,
          lo_http_client        TYPE REF TO if_web_http_client,
          lo_http_request       TYPE REF TO if_web_http_request,
          lo_http_response      TYPE REF TO if_web_http_response,
          lv_response           TYPE string,
          lv_payload            TYPE string,
          ls_transaction_status TYPE ty_transaction_status.
**********************************************************************
    TRY.
        DATA(system_url) = cl_abap_context_info=>get_system_url(  ).
        DATA(lv_url) = system_url(8).
      CATCH cx_abap_context_info_error.
        DATA(ls_systemerror) = 1.
    ENDTRY.
    IF lv_url = 'my414007'.      "this one CHEMFAB Development system
**********************************************************************
      lv_request_url = |https://bfin001-qa.bankflow.io/getstatus| . "https://gateway-dev.bankflow.io/getstatus
    ELSE.
      lv_request_url = |https://bfin001.bankflow.io/getstatus| .
    ENDIF.
**********************************************************************
    TRY.
        " Create destination and client
        lo_http_destination = cl_http_destination_provider=>create_by_url( lv_request_url ).
        lo_http_client      = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
        lo_http_request     = lo_http_client->get_http_request( ).

**********************************************************************
        " Prepare payload (example XML)
        lv_payload = |<GetTransactionStatus>| &&
        |<AccountNumber>| && '917020084965720' && |</AccountNumber>| &&
       |<TransactionReference>| && iv_docno && |</TransactionReference>| &&
       |<UniqueTransactionReference>| && iv_unid && |</UniqueTransactionReference>| &&
       |</GetTransactionStatus>|.
**********************************************************************

        lo_http_client->get_http_request( )->set_header_fields( VALUE #( ( name = if_web_http_header=>accept value = if_web_http_header=>accept_application_xml )
                                                                        ( name = if_web_http_header=>content_type value = if_web_http_header=>accept_application_json  ) ) ).
* DATA(lv_base64) = cl_web_http_utility=>encode_base64( lv_payload ).
        lo_http_client->get_http_request(  )->set_text( i_text = lv_payload ).

**********************************************************************

        lo_http_response = lo_http_client->execute( if_web_http_client=>post ).

        DATA(ls_status1) = lo_http_response->get_status(  ).

        lv_response = lo_http_response->get_text(  ).
**********************************************************************
        TRY.
            /ui2/cl_json=>deserialize(
              EXPORTING
                json         = lv_response
                pretty_name  = /ui2/cl_json=>pretty_mode-camel_case " Auto-converts names
                assoc_arrays = abap_true
              CHANGING
                data         = ls_transaction_status
            ).
            " You can now access the internal table via ls_root-d-results
*            ls_transaction_status = lt_transaction_status[ 1 ].
            rv_status = ls_transaction_status.

          CATCH cx_root INTO DATA(lx).

            DATA(lv_err1) = 1.
*            rv_status = ''.

        ENDTRY.


      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error12).
        DATA(lv_12) = 2.

    ENDTRY.



  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA(lt_pending) = get_pending_data( ).
    IF lt_pending IS INITIAL.
      RETURN. " No records to process
    ENDIF.

    LOOP AT lt_pending INTO DATA(ls_entry).
      process_entry( ls_entry ).
    ENDLOOP.



  ENDMETHOD.


  METHOD get_pending_data.

    SELECT *
    FROM zfi_app01_ct
    WHERE mark = 'X'
      AND ( xblnr = 'PENDING' OR xblnr = '' )
    INTO TABLE @rt_data.

  ENDMETHOD.


  METHOD process_entry.

    DATA(lv_new_status) = get_bankflow_status( iv_docno = is_entry-belnr  iv_unid = is_entry-awkey  ).

    " If API failed or returned blank
    IF lv_new_status-transactionstatus IS INITIAL.
      RETURN.
    ENDIF.

    " If status didn’t change → skip updates
    IF lv_new_status-transactionstatus = is_entry-xblnr.
      RETURN.
    ENDIF.

    " Update custom & standard table only if changed
    update_custom_table(
      is_entry  = is_entry
      iv_status = lv_new_status ).

    update_standard_je(
      is_entry  = is_entry
      iv_status = lv_new_status ).

  ENDMETHOD.


  METHOD update_custom_table.
    DATA : lt_chdr TYPE TABLE OF zfi_app01_ct,
           ls_chdr TYPE zfi_app01_ct.


    ls_chdr-belnr = is_entry-belnr.
    ls_chdr-gjahr = is_entry-gjahr.
    ls_chdr-bukrs = is_entry-bukrs.
    ls_chdr-awkey = is_entry-awkey.
    ls_chdr-blart = is_entry-blart.
    ls_chdr-bldat = is_entry-bldat.
    ls_chdr-budat = is_entry-budat.
    ls_chdr-bktxt = iv_status-utr.
    ls_chdr-xblnr = iv_status-transactionstatus.
    ls_chdr-mark = 'C'.


    APPEND ls_chdr TO lt_chdr.
    MODIFY zfi_app01_ct FROM TABLE @lt_chdr.


  ENDMETHOD.


  METHOD update_standard_je.
**********************************************************************
    DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
          lv_cid TYPE abp_behv_cid.
**********************************************************************
    TRY.
        lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
**********************************************************************
    APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).

* Header Control
    DATA ls_header_control LIKE <je>-%param-%control.
    ls_header_control-documentheadertext           = if_abap_behv=>mk-on.
    ls_header_control-documentreferenceid          = if_abap_behv=>mk-on.




    <je>-accountingdocument = is_entry-belnr.
    <je>-fiscalyear         = is_entry-gjahr.
    <je>-companycode        = is_entry-bukrs.
    <je>-%param = VALUE #(   documentheadertext          = iv_status-utr
                             documentreferenceid = iv_status-transactionstatus
                            %control                     =  ls_header_control
                              ) .

    MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
         ENTITY journalentry
         EXECUTE change FROM lt_je
           FAILED DATA(ls_failed_deep)
           REPORTED DATA(ls_reported_deep)
           MAPPED DATA(ls_mapped_deep).

    IF ls_failed_deep IS NOT INITIAL.
      ROLLBACK ENTITIES.
    ELSE.
      COMMIT ENTITIES BEGIN
        RESPONSE OF i_journalentrytp
          FAILED DATA(lt_commit_failed)
          REPORTED DATA(lt_commit_reported).
      COMMIT ENTITIES END.
    ENDIF.
**********************************************************************

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception).
        job_scheduling_exception->get_text(  ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
