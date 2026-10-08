CLASS lhc__hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _hdr RESULT result.

    METHODS submit FOR MODIFY
      IMPORTING keys FOR ACTION _hdr~submit RESULT result.

ENDCLASS.

CLASS lhc__hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD submit.
    READ ENTITIES OF zfi_app01_rv IN LOCAL MODE
    ENTITY _hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr).
    DATA(ls_hdr) = lt_hdr[ 1 ].

**********************************************************************
    DATA: lv_request_url      TYPE string,
          lo_http_destination TYPE REF TO if_http_destination,
          lo_http_client      TYPE REF TO if_web_http_client,
          lo_http_request     TYPE REF TO if_web_http_request,
          lo_http_response    TYPE REF TO if_web_http_response,
          lv_response         TYPE string,
          lv_payload          TYPE string.
**********************************************************************
    TRY.
        DATA(system_url) = cl_abap_context_info=>get_system_url(  ).
        DATA(lv_url) = system_url(8).
      CATCH cx_abap_context_info_error.
        DATA(ls_systemerror) = 1.
    ENDTRY.
    IF lv_url = 'my414007'.      "this one CHEMFAB Development system
**********************************************************************
      lv_request_url = |https://bfin001-qa.bankflow.io/getstatus| . " https://gateway-dev.bankflow.io/getstatus
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
        |<AccountNumber>| && '917020084965720' && |</AccountNumber>| && "  "913020037652969 (Dev )
       |<TransactionReference>| && ls_hdr-accountingdocument && |</TransactionReference>| &&
       |<UniqueTransactionReference>| && ls_hdr-OriginalReferenceDocument && |</UniqueTransactionReference>| &&
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
        TYPES: BEGIN OF ty_transaction_status,
BankFlowException          TYPE string,
         UniqueTransactionReference TYPE string,
         UTR                        TYPE string,
         Status                     TYPE string,
         TransactionStatus          TYPE string,
         ErrorMessage               TYPE string,
               END OF ty_transaction_status.

        DATA: lt_transaction_status TYPE STANDARD TABLE OF ty_transaction_status,
              ls_transaction_status TYPE ty_transaction_status.
        DATA: lt_chdr TYPE TABLE OF zfi_app01_ct,
              ls_chdr TYPE zfi_app01_ct.
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


          CATCH cx_root INTO DATA(lx).
            DATA(lv_err1) = 1.

        ENDTRY.

**********************************************************************
        ls_chdr-belnr = ls_hdr-accountingdocument.
        ls_chdr-gjahr = ls_hdr-fiscalyear.
        ls_chdr-bukrs = ls_hdr-companycode.
        ls_chdr-awkey = ls_hdr-originalreferencedocument.
        ls_chdr-blart = ls_hdr-accountingdocumenttype.
        ls_chdr-bldat = ls_hdr-documentdate.
        ls_chdr-budat = ls_hdr-postingdate.
        ls_chdr-bktxt = ls_transaction_status-utr.
        ls_chdr-xblnr = ls_transaction_status-transactionstatus.
        ls_chdr-mark = 'X'.



**********************************************************************

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error12).
        DATA(lv_12) = 2.

    ENDTRY.
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




    <je>-accountingdocument = ls_hdr-accountingdocument.
    <je>-fiscalyear         = ls_hdr-fiscalyear.
    <je>-companycode        = ls_hdr-companycode.
    <je>-%param = VALUE #(   documentheadertext          = ls_transaction_status-utr
                             documentreferenceid = ls_transaction_status-transactionstatus
                            %control                     =  ls_header_control
                              ) .

    MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
         ENTITY journalentry
         EXECUTE change FROM lt_je
           FAILED DATA(ls_failed_deep)
           REPORTED DATA(ls_reported_deep)
           MAPPED DATA(ls_mapped_deep).
    IF ls_failed_deep IS INITIAL.
      APPEND ls_chdr TO lt_chdr.
      zbp_fi_app01_rv=>gt_hdr  = lt_chdr.
    ELSE.
    ENDIF.

**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_hdr
                        ( %tky   = ls_ord-%tky
                          %param = ls_ord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zfi_app01_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfi_app01_rv IMPLEMENTATION.

  METHOD save_modified.
    IF zbp_fi_app01_rv=>gt_hdr IS NOT INITIAL.

      MODIFY zfi_app01_ct FROM TABLE @zbp_fi_app01_rv=>gt_hdr.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
