CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS Email FOR MODIFY
      IMPORTING keys FOR ACTION header~Email RESULT result.
    METHODS esign FOR MODIFY
      IMPORTING keys FOR ACTION header~esign RESULT result.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_features.
**********************************************************************
        READ ENTITIES OF zsd_app09_dmrv IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gt_head)
        FAILED DATA(gt_failed).

        data(gs_head) =   gt_head[ 1 ].
**********************************************************************
        result = VALUE #( for ls_keys in keys
                        ( %tky = ls_keys-%tky

                        %action = VALUE #( Email = COND #( WHEN gs_head-dscstatus = 'X'
                                                then if_abap_behv=>fc-o-enabled
                                                ELSE if_abap_behv=>fc-o-disabled ) )
                                                 ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD esign.
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
           lv_respqrbn          TYPE string.


**********************************************************************
    READ ENTITIES OF zsd_app09_dmrv IN LOCAL MODE
    ENTITY header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_billhdr)
    ENTITY header BY \_item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_billitm).
    DATA(ls_billhdr) = lt_billhdr[ 1 ].
    DATA(ls_billitm) = lt_billitm[ 1 ].

**********************************************************************
    READ ENTITIES OF i_billingdocumenttp PRIVILEGED
     ENTITY billingdocument
     EXECUTE getlatestpdf
     FROM VALUE #( ( billingdocument = ls_billhdr-billdoc  ) )

     RESULT DATA(lt_result)
     FAILED DATA(ls_failed)
     REPORTED DATA(ls_reported).
    IF lt_result IS INITIAL.
      APPEND VALUE #( %tky = ls_billhdr-%tky ) TO failed-header.
      APPEND VALUE #( %tky = ls_billhdr-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'Output Determination Failed(Form Template)' )
                               ) TO reported-header.
    ELSE.
      DATA(ls_result) = lt_result[ 1 ].
******************************* User Validations **********************

      TRY.
          DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
        CATCH cx_abap_context_info_error.
          DATA(ls_x1) = 1.
      ENDTRY.
      DATA(lv_cbuser) = 'CB' && lv_user.

      SELECT SINGLE * FROM zsd_app10_tb1 WHERE userid = @lv_cbuser AND ccode = @ls_billhdr-ccode
      AND division = @ls_billhdr-divsn AND distchnl = @ls_billhdr-distchn
      INTO @DATA(ls_authsign).
      IF sy-subrc = 0 AND NOT ls_authsign IS INITIAL.
***********************************************************************
        "  static link
*        lv_dsc_url = |https://esign.chemfabalkalis.com:820/RESTAPI/SignPDF_Base64String|.
        "  Public link
        lv_dsc_url = |http://117.239.241.162:82/RESTAPI/SignPDF_Base64String|.
        "Sandbox link
*        lv_dsc_url = |https://esign.chemfabalkalis.com:810/Sandbox_RESTAPI/SignPDF_Base64String|.

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
**********************************************************************
        DATA(lv_pdfbinary) = ls_result-%param-billingdocoutputdatabinary.

        DATA(lv_invpdfb64) = xco_cp=>xstring( lv_pdfbinary
            )->as_string( xco_cp_binary=>text_encoding->base64
            )->value.

************************************************************************
*      """ HTTP Communication via URL   """
        TRY.
            lo_httpreqst->set_text(
            '{    "AuthorizedSignatory": "'
        &&    'Chemfab'
*      && ls_authsign-userid
        && '",'
        && '    "SignerName": "'
*      && 'NAGARAJAN S'
        && ls_authsign-signername
        && '",'
        && '    "TopLeft": 0,'
        && '    "BottomLeft": 0,'
        && '    "TopRight": 0,'
        && '    "BottomRight": 0,'
        && '    "ExcludePageNo": "",'
        && '    "InvoiceNumber": "'
        && ls_billhdr-billdoc
        && '",'
        && '    "pageNo": -1,'
        && '    "PrintDateTime": "",'
        && '    "FindAuth": "Authorised",'
        && '    "FindAuthLocation": 0,'
        && '    "fontsize": 24,'
        && '    "adjustCoordinates": 0,'
        && '    "signOnlySearchTextPage": 1,'
        && '    "pdfByte1": "'
        && lv_invpdfb64
        &&  '" }'     ).
            " execute HTTP POST-request and store response
            lo_http_response = lo_http_client->execute( if_web_http_client=>post ).
            DATA(ls_status) = lo_http_response->get_status(  ).
            CLEAR: lv_dscrespb1.
            lv_dscrespb1 = lo_http_response->get_text(  ).
          CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error2).
            DATA(lv_3) = 3.
        ENDTRY.
**********************************************************************
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
**********************************************************************
          DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_dscresponse-filecontent  ).
          DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).
**********************************************************************
          zbp_sd_app09_dmrv=>gs_print_data_oc = lv_print_data.
          zbp_sd_app09_dmrv=>gs_pqitem_id_oc = lv_qitem_id.
          zbp_sd_app09_dmrv=>gv_tag_oc = '-OC'.
          zbp_sd_app09_dmrv=>gv_invnum = ls_billhdr-billdoc.
          zbp_sd_app09_dmrv=>gv_printq = ls_authsign-prntque.

**********************************************************************
          IF ls_status-reason = 'OK' AND ls_status-code = '200'.
**********************************************************************
*****------Attachment Process for the DSC Output-----Start Process
            data: gt_attach type table of ZSD_DSC_FILE_DB,
                  gs_attach TYPE ZSD_DSC_FILE_DB.

            read ENTITIES OF zsd_app09_dmrv in LOCAL MODE
            ENTITY Header
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(gt_head)
            FAILED FINAL(gt_failed).
**********************************************************************
            data(gs_head) =  gt_head[ 1 ].
            data(lv_doc_name) = |Invoice :{ gs_head-billdoc }|.

            if gs_head-billdoc is not initial.
              gs_attach-billdoc = gs_head-billdoc.
              gs_attach-attachment = lv_print_data.
              gs_attach-mimetype = 'application/pdf'.
              gs_attach-filename = lv_doc_name.
              gs_attach-dscstatus   = 'X'.
              APPEND gs_attach to gt_attach.
              zbp_sd_app09_dmrv=>up_attach = gt_attach.
            endif.
*****------Attachment Process for the DSC Output-----End Process
**********************************************************************


*************************** Export Invoice ************************
            IF ls_billhdr-distchn = '30'.
              IF ls_billhdr-divsn = '04' OR ls_billhdr-divsn = '09'.

****************** Batch Char Data ************************************

                SELECT bi~billingdocument,
                       bi~billingdocumentitem,
                       bi~batch,
                       bi~product,
                       bcn~charcfromdecimalvalue AS netwt,
                       bcg~charcfromdecimalvalue AS grswt
                FROM i_billingdocumentitem AS bi
                LEFT OUTER JOIN i_batchcharacteristicvaluetp_2 AS bcn ON bi~product = bcn~material AND bi~batch = bcn~batch
                AND bcn~charcinternalid = '0000000833'
                LEFT OUTER JOIN i_batchcharacteristicvaluetp_2 AS bcg ON bi~product = bcg~material AND bi~batch = bcg~batch
                AND bcn~charcinternalid = '0000000832'
                WHERE bi~billingdocument = @ls_billhdr-billdoc AND bi~batch IS NOT INITIAL
                INTO TABLE @DATA(lt_batchdata).

***********************************************************************
                TRY.

                    DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
                    comm_scenario = 'ZADS_CS'
                    comm_system_id = 'ZADS'
                    service_id = 'ZADS_OUT_REST'      ).

                  CATCH cx_http_dest_provider_error INTO DATA(lx_error).
                    lv_err1 = 1.
                ENDTRY.
**********************************************************************
                TRY.
                    DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
                  CATCH cx_web_http_client_error INTO DATA(lx_client_error).
                    DATA(lv_err2) = 1.
                ENDTRY.
                DATA(lo_request) = lo_client->get_http_request(  ).
                lo_request->set_header_fields( VALUE #(
                ( name = 'Accept' value = 'application/json, text/plain, */*' )
                ( name = 'Content-Type' value = 'application/json;charset=utf-8' )
                 ) ).
**********************************************************************
                ls_req-xdp_template = 'ZSDEXPORT_INVOICE/EXPORT_INVOICE' .   " 'ZPNDYFGINV/ZPFITEMP'.
                ls_req-form_type    = 'print'.
                ls_req-form_locale  = 'en_US'.
                ls_req-tagged_pdf = 1.
                ls_req-embed_font = 0.
                ls_req-change_not_allowed = abap_false.
                ls_req-print_not_allowed = abap_false.

******************************** Bill To Address **************************************
                SELECT SINGLE * FROM i_customer AS cust INNER JOIN i_address_2  WITH PRIVILEGED ACCESS AS addr
                 ON addr~addressid = cust~addressid
                 WHERE addr~addressid = @ls_billhdr-pyraddrid
                 INTO @DATA(ls_bpaddress) .
********************************** Ship To Address ************************************
                SELECT SINGLE * FROM i_customer AS cust INNER JOIN i_address_2  WITH PRIVILEGED ACCESS AS addr
                     ON addr~addressid = cust~addressid
                     WHERE addr~addressid = @ls_billhdr-shpaddrid
                     INTO @DATA(ls_shaddress) .
**********************************************************************
                DATA(lv_xml_exinv) = |<?xml version="1.0" encoding="utf-8"?>| &&
                                     |<Form xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/">| &&
                                        |<BillingDocumentNode>| &&
            |<AbsltAccountingExchangeRate></AbsltAccountingExchangeRate>| &&
            |<AccountingDocument>| && ls_billhdr-accdoc && |</AccountingDocument>| &&
            |<AckDate>| && ls_billhdr-ackdate && |</AckDate>| &&
            |<AckNumber>| && ls_billhdr-ackno && |</AckNumber>| &&
            |<AckTime>00:00:00</AckTime>| &&
            |<AmountInWords></AmountInWords>| &&
|<BankBranch></BankBranch>| &&
|<BillingDate>| && ls_billhdr-billdate && |</BillingDate>| &&
|<BillingDocument>| && ls_billhdr-billdoc && |</BillingDocument>| &&
|<BillingDocumentCategory></BillingDocumentCategory>| &&
|<BillingDocumentType></BillingDocumentType>| &&
|<BillingDocumentTypeName>Invoice</BillingDocumentTypeName>| &&
|<BillingSDDocumentCategory>M</BillingSDDocumentCategory>| &&
|<BillingSDDocumentCategoryName>Invoice</BillingSDDocumentCategoryName>| &&
|<CancelledBillingDocument></CancelledBillingDocument>| &&
|<ConditionAmountLocCurr>0.00</ConditionAmountLocCurr>| &&
|<ConditionBaseValueLocCurr>0.00</ConditionBaseValueLocCurr>| &&
|<ContactName>| && lv_user  && |</ContactName>| &&
|<Country></Country>| &&
|<CrrtnInvoiceIsDifferential>false</CrrtnInvoiceIsDifferential>| &&
|<CustomerBranchCode></CustomerBranchCode>| &&
|<CustomerInvoice></CustomerInvoice>| &&
|<CustomerInvoiceDate>0000-00-00T00:00:00</CustomerInvoiceDate>| &&
|<DocumentReferenceID>| && ls_billhdr-refdoc && |</DocumentReferenceID>| &&
|<EwbNumber>000000000000</EwbNumber>| &&
|<EwbValidfromDate>0000-00-00T00:00:00</EwbValidfromDate>| &&
|<EwbValidfromTime>00:00:00</EwbValidfromTime>| &&
|<EwbValidtoDate>0000-00-00T00:00:00</EwbValidtoDate>| &&
|<EwbValidtoTime>00:00:00</EwbValidtoTime>| &&
|<ExchangeRate>0.00000</ExchangeRate>| &&
|<ExchangeRateDate>0000-00-00T00:00:00</ExchangeRateDate>| &&
|<ExchangeRateIsIndirect></ExchangeRateIsIndirect>| &&
|<ExemptionLetterDate>0000-00-00T00:00:00</ExemptionLetterDate>| &&
|<ExemptionLetterNumber></ExemptionLetterNumber>| &&
|<GloLocalCurr></GloLocalCurr>| &&
|<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
|<ID_TaxInvoiceSigner></ID_TaxInvoiceSigner>| &&
|<IndicatorVatSplit></IndicatorVatSplit>| &&
|<InvoiceListStatus></InvoiceListStatus>| &&
|<Irn>| && ls_billhdr-irn && |</Irn>| &&
|<LocCurr></LocCurr>| &&
|<PaymentReference></PaymentReference>| &&
|<PrelimBillingDocument></PrelimBillingDocument>| &&
|<PricingProcedure></PricingProcedure>| &&
|<PurchaseOrderByCustomer>| && ls_billhdr-ordrefdat && |</PurchaseOrderByCustomer>| &&
|<QrcodeBitmap></QrcodeBitmap>| &&
|<ReferenceSDDocument></ReferenceSDDocument>| &&
|<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
|<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
|<RemunerationTotalNetAmount>0.00</RemunerationTotalNetAmount>| &&
|<SalesContract></SalesContract>| &&
|<SalesDocument></SalesDocument>| &&
|<SalesOrderDate>0000-00-00T00:00:00</SalesOrderDate>| &&
|<SalesOrderReason></SalesOrderReason>| &&
|<SalesOrderReasonText></SalesOrderReasonText>| &&
|<SalesOrganization>| && ls_billhdr-sorg && |</SalesOrganization>| &&
|<SalesOrganizationName>| && ls_billhdr-sorgtxt && |</SalesOrganizationName>| &&
|<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
|<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
|<SolutionOrder></SolutionOrder>| &&
|<Status></Status>| &&
|<SupplyDate>0000-00-00T00:00:00</SupplyDate>| &&
|<TaxReportingDate>0000-00-00T00:00:00</TaxReportingDate>| &&
|<TotGrssAmtAsText></TotGrssAmtAsText>| &&
|<TotalDiscount>0.00</TotalDiscount>| &&
|<TotalDiscountLoccurr>0.00</TotalDiscountLoccurr>| &&
|<TotalGrossAmount></TotalGrossAmount>| &&
|<TotalGrossAmountLocurr>0.00</TotalGrossAmountLocurr>| &&
|<TotalNetAmount>| && ls_billhdr-netamt && |</TotalNetAmount>| &&
|<TotalNetAmountLocurr>0.00</TotalNetAmountLocurr>| &&
|<TotalOtherCharges>0.00</TotalOtherCharges>| &&
|<TotalOtherChargesLoccurr>0.00</TotalOtherChargesLoccurr>| &&
|<TotalSalesAmount>0.00</TotalSalesAmount>| &&
|<TotalSalesAmountLoccurr>0.00</TotalSalesAmountLoccurr>| &&
|<TotalTaxAmount>| && ls_billhdr-taxamt && |</TotalTaxAmount>| &&
|<TotalWth>0.00</TotalWth>| &&
|<TotalWthLoccur>0.00</TotalWthLoccur>| &&
|<TransactionCurrency>USD</TransactionCurrency>| &&
|<TransporterGstin></TransporterGstin>| &&
|<TransporterName>| && ls_billhdr-transporter && |</TransporterName>| &&
|<Uuid></Uuid>| &&
|<VehicleNumber></VehicleNumber>| &&
|<YY1_AccountNumber_BDH>000000000000000</YY1_AccountNumber_BDH>| &&
|<YY1_AccountNumber_BDHF>3</YY1_AccountNumber_BDHF>| &&
|<YY1_BILL_PAN_BDH>| && ls_billhdr-pan && |</YY1_BILL_PAN_BDH>| &&
|<YY1_BILL_PAN_BDHF>3</YY1_BILL_PAN_BDHF>| &&
|<YY1_BankName_BDH></YY1_BankName_BDH>| &&
|<YY1_BankName_BDHF>3</YY1_BankName_BDHF>| &&
|<YY1_BankName_BDHT></YY1_BankName_BDHT>| &&
|<YY1_Branch_BDH></YY1_Branch_BDH>| &&
|<YY1_Branch_BDHF>3</YY1_Branch_BDHF>| &&
|<YY1_CHARWT_BDH>0.000</YY1_CHARWT_BDH>| &&
|<YY1_CHARWT_BDHF>3</YY1_CHARWT_BDHF>| &&
|<YY1_CHARWT_BDHT></YY1_CHARWT_BDHT>| &&
|<YY1_CHARWT_BDHU></YY1_CHARWT_BDHU>| &&
|<YY1_CONCN_BDH>| && ls_billhdr-concnwt && |</YY1_CONCN_BDH>| &&
|<YY1_CONCN_BDHF>3</YY1_CONCN_BDHF>| &&
|<YY1_CONCN_BDHT></YY1_CONCN_BDHT>| &&
|<YY1_CONCN_BDHU></YY1_CONCN_BDHU>| &&
|<YY1_CylinderDetailSeal_BDH>| && ls_billhdr-cylinderdetailseal && |</YY1_CylinderDetailSeal_BDH>| &&
|<YY1_CylinderDetailSeal_BDHF>3</YY1_CylinderDetailSeal_BDHF>| &&
|<YY1_DistributionChanne_BDH>| && ls_billhdr-distchn && |</YY1_DistributionChanne_BDH>| &&
|<YY1_DistributionChanne_BDHF>3</YY1_DistributionChanne_BDHF>| &&
|<YY1_Division_BDH>| && ls_billhdr-divsn && |</YY1_Division_BDH>| &&
|<YY1_Division_BDHF>3</YY1_Division_BDHF>| &&
|<YY1_DriverDetails_BDH>| && ls_billhdr-driverdetails && |</YY1_DriverDetails_BDH>| &&
|<YY1_DriverDetails_BDHF>3</YY1_DriverDetails_BDHF>| &&
|<YY1_EINVOICE_QRTEXT_BDH></YY1_EINVOICE_QRTEXT_BDH>| &&
|<YY1_EINVOICE_QRTEXT_BDHF>3</YY1_EINVOICE_QRTEXT_BDHF>| &&
|<YY1_FreightIndicatorSD_BDH>false</YY1_FreightIndicatorSD_BDH>| &&
|<YY1_FreightIndicatorSD_BDHF>3</YY1_FreightIndicatorSD_BDHF>| &&
|<YY1_FreightTerms_BDH>| && ls_billhdr-freightterms && |</YY1_FreightTerms_BDH>| &&
|<YY1_FreightTerms_BDHF>3</YY1_FreightTerms_BDHF>| &&
|<YY1_FreightTerms_BDHT>| && ls_billhdr-freightterms && |</YY1_FreightTerms_BDHT>| &&
|<YY1_GrossWT_BDH>| && ls_billhdr-grosswt && |</YY1_GrossWT_BDH>| &&
|<YY1_GrossWT_BDHF>3</YY1_GrossWT_BDHF>| &&
|<YY1_GrossWT_BDHT></YY1_GrossWT_BDHT>| &&
|<YY1_GrossWT_BDHU></YY1_GrossWT_BDHU>| &&
|<YY1_IFSCCode_BDH></YY1_IFSCCode_BDH>| &&
|<YY1_IFSCCode_BDHF>3</YY1_IFSCCode_BDHF>| &&
|<YY1_ModeOfTransport_BDH>| && ls_billhdr-modeoftransport && |</YY1_ModeOfTransport_BDH>| &&
|<YY1_ModeOfTransport_BDHF>3</YY1_ModeOfTransport_BDHF>| &&
|<YY1_NETWT_BDH>| && ls_billhdr-netwt && |</YY1_NETWT_BDH>| &&
|<YY1_NETWT_BDHF>3</YY1_NETWT_BDHF>| &&
|<YY1_NETWT_BDHT></YY1_NETWT_BDHT>| &&
|<YY1_NETWT_BDHU></YY1_NETWT_BDHU>| &&
|<YY1_NOOFCylinder_BDH>| && ls_billhdr-yy1_noofcylinder_dlh && |</YY1_NOOFCylinder_BDH>| &&
|<YY1_NOOFCylinder_BDHF>3</YY1_NOOFCylinder_BDHF>| &&
|<YY1_Place_BDH></YY1_Place_BDH>| &&
|<YY1_Place_BDHF>3</YY1_Place_BDHF>| &&
|<YY1_Place_BDHT></YY1_Place_BDHT>| &&
|<YY1_SD_PONO_BDH></YY1_SD_PONO_BDH>| &&
|<YY1_SD_PONO_BDHF>3</YY1_SD_PONO_BDHF>| &&
|<YY1_SwiftCode_BDH></YY1_SwiftCode_BDH>| &&
|<YY1_SwiftCode_BDHF>3</YY1_SwiftCode_BDHF>| &&
|<YY1_TAREWT_BDH>0.000</YY1_TAREWT_BDH>| &&
|<YY1_TAREWT_BDHF>3</YY1_TAREWT_BDHF>| &&
|<YY1_TAREWT_BDHT></YY1_TAREWT_BDHT>| &&
|<YY1_TAREWT_BDHU></YY1_TAREWT_BDHU>| &&
|<YY1_Transporter_BDH>| && ls_billhdr-transporter && |</YY1_Transporter_BDH>| &&
|<YY1_Transporter_BDHF>3</YY1_Transporter_BDHF>| &&
|<YY1_VehicleNumber_BDH>| && ls_billhdr-vehiclenumber && |</YY1_VehicleNumber_BDH>| &&
|<YY1_VehicleNumber_BDHF>3</YY1_VehicleNumber_BDHF>| &&
|<YY1_VolumePerCylinder_BDH>| && ls_billhdr-volumepercylinder && |</YY1_VolumePerCylinder_BDH>| &&
|<YY1_VolumePerCylinder_BDHF>3</YY1_VolumePerCylinder_BDHF>| &&
|<YY1_VolumePerCylinder_BDHT></YY1_VolumePerCylinder_BDHT>| &&
|<YY1_VolumePerCylinder_BDHU>| && ls_billhdr-unit && |</YY1_VolumePerCylinder_BDHU>| &&
|<BillToParty>| &&
|<AddressID>| && ls_billhdr-pyraddrid && |</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>| && ls_bpaddress-cust-businesspartnername1 && |</AddressLine2Text>| &&
|<AddressLine3Text>| && ls_bpaddress-cust-businesspartnername2 && |</AddressLine3Text>| &&
|<AddressLine4Text>| && ls_bpaddress-cust-bpaddrstreetname && |</AddressLine4Text>| &&
|<AddressLine5Text>| && ls_bpaddress-addr-streetsuffixname1 && |</AddressLine5Text>| &&
          |<AddressLine6Text>| && ls_bpaddress-cust-postalcode && ' ' && ls_bpaddress-cust-bpaddrcityname &&  |</AddressLine6Text>| &&
          |<AddressLine7Text></AddressLine7Text>| &&
          |<AddressLine8Text>| && lv_copytyp && |</AddressLine8Text>| &&
          |<AddressType>1</AddressType>| &&
          |<City></City>| &&
          |<Countryname></Countryname>| &&
          |<FaxNumber></FaxNumber>| &&
          |<FullName>| && ls_billhdr-payertxt && |</FullName>| &&
          |<Partner>| && ls_billhdr-payerid && |</Partner>| &&
          |<PartnerFunction>BP</PartnerFunction>| &&
          |<PartnerFunctionName></PartnerFunctionName>| &&
          |<Person></Person>| &&
          |<PostalCode></PostalCode>| &&
          |<Region>| && ls_billhdr-billtoregion && |</Region>| &&
          |<RegionName>| && ls_billhdr-pystate && |</RegionName>| &&
          |<Street></Street>| &&
          |<TelephoneNumber></TelephoneNumber>| &&
|</BillToParty>| &&
|<ClearedDownPayment/>| &&
|<ClearedDownPaymentOvw>| &&
|<BillingDocument></BillingDocument>| &&
|<DocumentDescription></DocumentDescription>| &&
|<DownPaymentGrossAmount>0.00</DownPaymentGrossAmount>| &&
|<DownPaymentNetAmount>0.00</DownPaymentNetAmount>| &&
|<DownPaymentTaxAmount>0.00</DownPaymentTaxAmount>| &&
|</ClearedDownPaymentOvw>| &&
|<Company>| &&
|<AddressID></AddressID>| &&
            |<AddressLine1Text>| && ls_billhdr-street && |</AddressLine1Text>| &&
            |<AddressLine2Text></AddressLine2Text>| &&
            |<AddressLine3Text></AddressLine3Text>| &&
            |<AddressLine4Text></AddressLine4Text>| &&
            |<AddressLine5Text></AddressLine5Text>| &&
            |<AddressLine6Text></AddressLine6Text>| &&
            |<AddressLine7Text></AddressLine7Text>| &&
            |<AddressLine8Text></AddressLine8Text>| &&
            |<AddressType></AddressType>| &&
            |<BankAccKey></BankAccKey>| &&
            |<City></City>| &&
            |<CompanyCode>| && ls_billhdr-ccode && |</CompanyCode>| &&
            |<CompanyName>| && ls_billhdr-ccodetxt && |</CompanyName>| &&
            |<Country></Country>| &&
            |<Countryname></Countryname>| &&
            |<EmailAddress></EmailAddress>| &&
            |<FullName></FullName>| &&
            |<Person></Person>| &&
            |<PhoneNumber></PhoneNumber>| &&
            |<PostalCode></PostalCode>| &&
            |<Region></Region>| &&
            |<RegionName></RegionName>| &&
|</Company>| &&
|<CustomerProject>| &&
|<CustomerProject></CustomerProject>| &&
|<CustomerProjectName></CustomerProjectName>| &&
|<EndDate>0000-00-00T00:00:00</EndDate>| &&
|<ProjectManagerName></ProjectManagerName>| &&
|<StartDate>0000-00-00T00:00:00</StartDate>| &&
|</CustomerProject>| &&
|<DownPaymentOverview>| &&
|<DownPaymentGrossAmount>0.00</DownPaymentGrossAmount>| &&
|<DownPaymentNetAmount>0.00</DownPaymentNetAmount>| &&
|<DownPaymentSettlementAmount>0.00</DownPaymentSettlementAmount>| &&
|<DownPaymentTaxAmount>0.00</DownPaymentTaxAmount>| &&
|<DwnPaytRoundingDiffAmount>0.00</DwnPaytRoundingDiffAmount>| &&
|<DwnPaytSettlementNetAmount>0.00</DwnPaytSettlementNetAmount>| &&
|<DwnPaytSettlementTaxAmount>0.00</DwnPaytSettlementTaxAmount>| &&
|<OpenTotalGrossAmount>0.00</OpenTotalGrossAmount>| &&
|<OpenTotalTaxAmount>0.00</OpenTotalTaxAmount>| &&
|<TransactionCurrency></TransactionCurrency>| &&
|<DownPayments/>| &&
|</DownPaymentOverview>| &&
|<DownPaymentProcessingOverview>| &&
|<DownPaymentSettlementGrossAmount>0.00</DownPaymentSettlementGrossAmount>| &&
|<DownPaymentSettlementNetAmount>0.00</DownPaymentSettlementNetAmount>| &&
|<DownPaymentSettlementTaxAmount>0.00</DownPaymentSettlementTaxAmount>| &&
|<OpenTotalGrossAmount>0.00</OpenTotalGrossAmount>| &&
|<OpenTotalTaxAmount>0.00</OpenTotalTaxAmount>| &&
|<TransactionCurrency></TransactionCurrency>| &&
|<DownPaymentProcessingSettlement/>| &&
|</DownPaymentProcessingOverview>| &&
|<Incoterms>| &&
|<Incoterms></Incoterms>| &&
|<IncotermsLocation1>| && ls_billhdr-incoloc1 && |</IncotermsLocation1>| &&
|<IncotermsLocation1Lbl></IncotermsLocation1Lbl>| &&
|<IncotermsLocation2></IncotermsLocation2>| &&
|<IncotermsLocation2Lbl></IncotermsLocation2Lbl>| &&
|<IncotermsVersion>| && ls_billhdr-incotyp && |</IncotermsVersion>| &&
|</Incoterms>| &&
|<ISRPrintDetails>| &&
|<AdditionalSubscriberNo>000000000</AdditionalSubscriberNo>| &&
|<Address></Address>| &&
|<BankCity></BankCity>| &&
|<BankName></BankName>| &&
|<BankNumber></BankNumber>| &&
|<BillingDocument></BillingDocument>| &&
|<City></City>| &&
|<CodingLine></CodingLine>| &&
|<CompanyCode></CompanyCode>| &&
|<Country></Country>| &&
|<CustomerID></CustomerID>| &&
|<District></District>| &&
|<DocumentCurrency></DocumentCurrency>| &&
|<ISRProcedure>00</ISRProcedure>| &&
|<Name1></Name1>| &&
|<Name2></Name2>| &&
|<Name3></Name3>| &&
|<Name4></Name4>| &&
|<NetValue>0.00</NetValue>| &&
|<POBox></POBox>| &&
|<POBoxPostalCode></POBoxPostalCode>| &&
|<PORNumber></PORNumber>| &&
|<PORReferenceNumber></PORReferenceNumber>| &&
|<PostalCode></PostalCode>| &&
|<Region></Region>| &&
|<StreetAndHouseNumber></StreetAndHouseNumber>| &&
|<SubscriberNo>000000000</SubscriberNo>| &&
|<Title></Title>| &&
|</ISRPrintDetails>| &&
|<Items>| &&
|<BillingDocumentItemNode>| &&
|<Batch></Batch>| &&
|<BillingDocumentItem>| && ls_billitm-billitm && |</BillingDocumentItem>| &&
            |<BillingDocumentItemText>| && ls_billitm-itemtxt && |</BillingDocumentItemText>| &&
            |<BillingPeriodOfPerfEndDate>0000-00-00T00:00:00</BillingPeriodOfPerfEndDate>| &&
            |<BillingPeriodOfPerfStartDate>0000-00-00T00:00:00</BillingPeriodOfPerfStartDate>| &&
|<CommodityCode></CommodityCode>| &&
|<CountryOfOrigin></CountryOfOrigin>| &&
|<CustomerInvoice></CustomerInvoice>| &&
|<CustomerInvoiceItem>000000</CustomerInvoiceItem>| &&
|<DebitCreditCode></DebitCreditCode>| &&
|<GloLocalCurr></GloLocalCurr>| &&
|<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
|<GrossAmount>0.00</GrossAmount>| &&
|<Higherlevelitem>000000</Higherlevelitem>| &&
|<IN_GSTControlCodeDesc1>FLUORINE,CHLORINE,BROMINEANDIODINE-CHLORINE</IN_GSTControlCodeDesc1>| &&
|<IN_GSTControlCodeDesc2></IN_GSTControlCodeDesc2>| &&
|<IN_GSTControlCodeDesc3></IN_GSTControlCodeDesc3>| &&
|<IN_GSTControlCodeDesc4></IN_GSTControlCodeDesc4>| &&
|<IN_GSTControlCodeDesc5></IN_GSTControlCodeDesc5>| &&
|<IN_HSNOrSACCode>| && ls_billitm-hsnno && |</IN_HSNOrSACCode>| &&
            |<ItemDiscount>0.00</ItemDiscount>| &&
            |<Material>| && ls_billitm-product && |</Material>| &&
            |<MaterialName>| && ls_billitm-matdesc && |</MaterialName>| &&
            |<Materialisinternalbatchmanaged></Materialisinternalbatchmanaged>| &&
            |<NetAmount>| && ls_billitm-netamt && |</NetAmount>| &&
            |<NetAmountLoccurr>0.00</NetAmountLoccurr>| &&
            |<NetPriceAmount>| && ls_billitm-netamt && |</NetPriceAmount>| &&
            |<NetPriceQuantity>1</NetPriceQuantity>| &&
            |<NetPriceQuantityUnit>EA</NetPriceQuantityUnit>| &&
            |<NetPriceQuantityUnitTechName>EA</NetPriceQuantityUnitTechName>| &&
            |<NetWeight>1.000</NetWeight>| &&
            |<OtherCharges>0.00</OtherCharges>| &&
            |<Plant>| && ls_billitm-plant && |</Plant>| &&
            |<PurchaseOrderByCustomer>| && ls_billhdr-ordrefdat && |</PurchaseOrderByCustomer>| &&
            |<Quantity>| && ls_billitm-billqty && |</Quantity>| &&
            |<QuantityUnit>| && ls_billitm-unit && |</QuantityUnit>| &&
|<QuantityUnitTechName></QuantityUnitTechName>| &&
|<ReferenceSDDocument></ReferenceSDDocument>| &&
|<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
|<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
|<RegionOfOrigin></RegionOfOrigin>| &&
|<SalesContract></SalesContract>| &&
|<SalesContractItem>000000</SalesContractItem>| &&
|<SalesDocument></SalesDocument>| &&
|<SalesOrderExternalDocId></SalesOrderExternalDocId>| &&
|<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
|<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
|<ServicesRenderedDate>2025-01-22T00:00:00</ServicesRenderedDate>| &&
|<SoldProduct></SoldProduct>| &&
|<SolutionOrder></SolutionOrder>| &&
|<SolutionOrderItem>000000</SolutionOrderItem>| &&
|<StatisticalValue></StatisticalValue>| &&
|<TaxAmount>0.00</TaxAmount>| &&
|<TaxAmountLoccurr>0.00</TaxAmountLoccurr>| &&
|<TaxCode></TaxCode>| &&
|<TaxRate>.0</TaxRate>| &&
|<Timesheetovertimecategory></Timesheetovertimecategory>| &&
|<Timesheetovertimecategorytext></Timesheetovertimecategorytext>| &&
|<TotalAmountLoccurr>0.00</TotalAmountLoccurr>| &&
|<TransactionCurrency></TransactionCurrency>| &&
|<Unitprice>0.00</Unitprice>| &&
|<WeightUnit>KG</WeightUnit>| &&
|<YY1_BEDate_BDI>0000-00-00T00:00:00</YY1_BEDate_BDI>| &&
|<YY1_BEDate_BDIF>3</YY1_BEDate_BDIF>| &&
|<YY1_BENo_BDI></YY1_BENo_BDI>| &&
|<YY1_BENo_BDIF>3</YY1_BENo_BDIF>| &&
|<YY1_ContainerNo_BDI></YY1_ContainerNo_BDI>| &&
|<YY1_ContainerNo_BDIF>3</YY1_ContainerNo_BDIF>| &&
|<YY1_CylinderNo_BDI></YY1_CylinderNo_BDI>| &&
|<YY1_CylinderNo_BDIF>3</YY1_CylinderNo_BDIF>| &&
|<YY1_ISO_DATA_BDI></YY1_ISO_DATA_BDI>| &&
|<YY1_ISO_DATA_BDIF>3</YY1_ISO_DATA_BDIF>| &&
|<YY1_MSMEUDYAMNo_BDI>UDYAM-PY-03-0045352</YY1_MSMEUDYAMNo_BDI>| &&
|<YY1_MSMEUDYAMNo_BDIF>3</YY1_MSMEUDYAMNo_BDIF>| &&
|<YY1_PhoneNo_BDI>| && ls_billhdr-phone && |</YY1_PhoneNo_BDI>| &&
            |<YY1_PhoneNo_BDIF>3</YY1_PhoneNo_BDIF>| &&
            |<YY1_Plant_Address_BDI>| && ls_billhdr-street && |</YY1_Plant_Address_BDI>| &&
            |<YY1_Plant_Address_BDIF>3</YY1_Plant_Address_BDIF>| &&
            |<YY1_Plant_CIN_BDI>| && ls_billhdr-cin && |</YY1_Plant_CIN_BDI>| &&
            |<YY1_Plant_CIN_BDIF>3</YY1_Plant_CIN_BDIF>| &&
            |<YY1_Plant_Email_BDI>| && ls_billhdr-email && |</YY1_Plant_Email_BDI>| &&
            |<YY1_Plant_Email_BDIF>3</YY1_Plant_Email_BDIF>| &&
            |<YY1_Plant_GST_BDI>| && ls_billhdr-gstin && |</YY1_Plant_GST_BDI>| &&
            |<YY1_Plant_GST_BDIF>3</YY1_Plant_GST_BDIF>| &&
            |<YY1_Plant_ISO_BDI>| && ls_billhdr-iso && |</YY1_Plant_ISO_BDI>| &&
            |<YY1_Plant_ISO_BDIF>3</YY1_Plant_ISO_BDIF>| &&
            |<YY1_Plant_PAN_BDI>| && ls_billhdr-pan && |</YY1_Plant_PAN_BDI>| &&
            |<YY1_Plant_PAN_BDIF>3</YY1_Plant_PAN_BDIF>| &&
            |<YY1_Plant_TAN_BDI>| && ls_billhdr-tan && |</YY1_Plant_TAN_BDI>| &&
            |<YY1_Plant_TAN_BDIF>3</YY1_Plant_TAN_BDIF>| &&
            |<YY1_SD_PODATE_BDI>0000-00-00T00:00:00</YY1_SD_PODATE_BDI>| &&
|<YY1_SD_PODATE_BDIF>3</YY1_SD_PODATE_BDIF>| &&
|<ItemBatchDetails/>| &&
|<ItemConfiguration/>| &&
|<ItemPricingConditions>| &&
|<ItemPricingConditionNode>| &&
            |<ConditionAmount>| && ls_billitm-conditionamount_zpro && |</ConditionAmount>| &&
            |<ConditionBaseValue>| && ls_billitm-basevalue_zpro && |</ConditionBaseValue>| &&
            |<ConditionBaseValueUnit>| && ls_billitm-basevalueunit_zpro && |</ConditionBaseValueUnit>| &&
            |<ConditionQuantity>| && ls_billitm-conditionquantity_zpro && |</ConditionQuantity>| &&
            |<ConditionQuantityUnit>| && ls_billitm-quantityunit_zpro && |</ConditionQuantityUnit>| &&
            |<ConditionQuantityUnitTechName></ConditionQuantityUnitTechName>| &&
            |<ConditionRateValue>| && ls_billitm-conditionrateamount_zpro && |</ConditionRateValue>| &&
            |<ConditionRateValueUnit>| && ls_billitm-rateunit && |</ConditionRateValueUnit>| &&
            |<ConditionStep>010</ConditionStep>| &&
            |<ConditionType>ZPRO</ConditionType>| &&
            |<ConditionTypeName>BasePrice</ConditionTypeName>| &&
            |<DocumentCurrency>| && ls_billitm-curky && |</DocumentCurrency>| &&
            |<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|<ItemPricingConditionNode>| &&
            |<ConditionAmount>| && ls_billitm-conditionamount_zfri && |</ConditionAmount>| &&
            |<ConditionBaseValue>| && ls_billitm-basevalue_zfri && |</ConditionBaseValue>| &&
            |<ConditionBaseValueUnit>| && ls_billitm-basevalueunit_zfri && |</ConditionBaseValueUnit>| &&
            |<ConditionQuantity>| && ls_billitm-conditionquantity_zfri && |</ConditionQuantity>| &&
            |<ConditionQuantityUnit>| && ls_billitm-quantityunit_zfri && |</ConditionQuantityUnit>| &&
            |<ConditionQuantityUnitTechName></ConditionQuantityUnitTechName>| &&
            |<ConditionRateValue></ConditionRateValue>| &&
            |<ConditionRateValueUnit>| && ls_billitm-rateunit && |</ConditionRateValueUnit>| &&
            |<ConditionStep>020</ConditionStep>| &&
            |<ConditionType>ZFRI</ConditionType>| &&
            |<ConditionTypeName>Freight(PDY)Received</ConditionTypeName>| &&
            |<DocumentCurrency></DocumentCurrency>| &&
|<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|</ItemPricingConditions>| &&
|<ItemSerialNUmber/>| &&
              |<ItemShipToParty>| &&
              |<AddressID>| && ls_billhdr-shpaddrid && |</AddressID>| &&
              |<AddressLine1Text>Company</AddressLine1Text>| &&
              |<AddressLine2Text>| && ls_shaddress-cust-businesspartnername1 && |</AddressLine2Text>| &&
              |<AddressLine3Text>| && ls_shaddress-cust-businesspartnername2 && |</AddressLine3Text>| &&
              |<AddressLine4Text>| && ls_shaddress-cust-streetname && |</AddressLine4Text>| &&
              |<AddressLine5Text>| && ls_shaddress-addr-streetsuffixname1 && |</AddressLine5Text>| &&
              |<AddressLine6Text>| && ls_shaddress-cust-postalcode && ' ' && ls_shaddress-cust-bpaddrcityname && |</AddressLine6Text>| &&
              |<AddressLine7Text></AddressLine7Text>| &&
              |<AddressLine8Text></AddressLine8Text>| &&
              |<AddressType>1</AddressType>| &&
              |<FullName></FullName>| &&
              |<Partner>| && ls_billhdr-shptoid && |</Partner>| &&
              |<PartnerFunction>SH</PartnerFunction>| &&
              |<PartnerFunctionName>ShiptoParty</PartnerFunctionName>| &&
              |<Person></Person>| &&
              |</ItemShipToParty>| &&
              |<ItemTextElements/>| &&
              |</BillingDocumentItemNode>|.
                IF lt_batchdata IS NOT INITIAL.
                  DATA(lv_count) = 1.
                  LOOP AT lt_batchdata INTO DATA(ls_batchdata).

                    lv_xml_exinv = lv_xml_exinv &&
                    |<BillingDocumentItemNode>| &&
                    |<Batch>| && ls_batchdata-batch && |</Batch>| &&
                    |<BillingDocumentItem>| && ls_batchdata-billingdocumentitem && |</BillingDocumentItem>| &&
                    |<BillingDocumentItemText></BillingDocumentItemText>| &&
                    |<BillingPeriodOfPerfEndDate>0000-00-00T00:00:00</BillingPeriodOfPerfEndDate>| &&
                    |<BillingPeriodOfPerfStartDate>0000-00-00T00:00:00</BillingPeriodOfPerfStartDate>| &&
                    |<CommodityCode></CommodityCode>| &&
                    |<CountryOfOrigin></CountryOfOrigin>| &&
                    |<CustomerInvoice></CustomerInvoice>| &&
                    |<CustomerInvoiceItem>000000</CustomerInvoiceItem>| &&
                    |<DebitCreditCode></DebitCreditCode>| &&
                    |<GloLocalCurr></GloLocalCurr>| &&
                    |<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
                    |<GrossAmount>0.00</GrossAmount>| &&
                    |<Higherlevelitem>000000</Higherlevelitem>| &&
                    |<IN_GSTControlCodeDesc1>FLUORINE,CHLORINE,BROMINEANDIODINE-CHLORINE</IN_GSTControlCodeDesc1>| &&
                    |<IN_GSTControlCodeDesc2></IN_GSTControlCodeDesc2>| &&
                    |<IN_GSTControlCodeDesc3></IN_GSTControlCodeDesc3>| &&
                    |<IN_GSTControlCodeDesc4></IN_GSTControlCodeDesc4>| &&
                    |<IN_GSTControlCodeDesc5></IN_GSTControlCodeDesc5>| &&
                    |<IN_HSNOrSACCode></IN_HSNOrSACCode>| &&
                    |<ItemDiscount>0.00</ItemDiscount>| &&
                    |<Material>| && ls_batchdata-product && |</Material>| &&
                    |<MaterialName></MaterialName>| &&
                    |<Materialisinternalbatchmanaged>true</Materialisinternalbatchmanaged>| &&
                    |<NetAmount>0.00</NetAmount>| &&
                    |<NetAmountLoccurr>0.00</NetAmountLoccurr>| &&
                    |<NetPriceAmount>0.00</NetPriceAmount>| &&
                    |<NetPriceQuantity>1</NetPriceQuantity>| &&
                    |<NetPriceQuantityUnit>TO</NetPriceQuantityUnit>| &&
                    |<NetPriceQuantityUnitTechName>t</NetPriceQuantityUnitTechName>| &&
                    |<NetWeight>0.000</NetWeight>| &&
                    |<OtherCharges>0.00</OtherCharges>| &&
                    |<Plant></Plant>| &&
                    |<PurchaseOrderByCustomer></PurchaseOrderByCustomer>| &&
                    |<Quantity>0.000</Quantity>| &&
                    |<QuantityUnit>TO</QuantityUnit>| &&
                    |<QuantityUnitTechName>t</QuantityUnitTechName>| &&
                    |<ReferenceSDDocument></ReferenceSDDocument>| &&
                    |<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
                    |<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
                    |<RegionOfOrigin></RegionOfOrigin>| &&
                    |<SalesContract></SalesContract>| &&
                    |<SalesContractItem>000000</SalesContractItem>| &&
                    |<SalesDocument></SalesDocument>| &&
                    |<SalesOrderExternalDocId></SalesOrderExternalDocId>| &&
                    |<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
                    |<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
                    |<ServicesRenderedDate>0000-00-00T00:00:00</ServicesRenderedDate>| &&
                    |<SoldProduct></SoldProduct>| &&
                    |<SolutionOrder></SolutionOrder>| &&
                    |<SolutionOrderItem>000000</SolutionOrderItem>| &&
                    |<StatisticalValue></StatisticalValue>| &&
                    |<TaxAmount>0.00</TaxAmount>| &&
                    |<TaxAmountLoccurr>0.00</TaxAmountLoccurr>| &&
                    |<TaxCode></TaxCode>| &&
                    |<TaxRate>.0</TaxRate>| &&
                    |<Timesheetovertimecategory></Timesheetovertimecategory>| &&
                    |<Timesheetovertimecategorytext></Timesheetovertimecategorytext>| &&
                    |<TotalAmountLoccurr>0.00</TotalAmountLoccurr>| &&
                    |<TransactionCurrency></TransactionCurrency>| &&
                    |<Unitprice>0.00</Unitprice>| &&
                    |<WeightUnit>KG</WeightUnit>| &&
                    |<YY1_BEDate_BDI>0000-00-00T00:00:00</YY1_BEDate_BDI>| &&
                    |<YY1_BEDate_BDIF>3</YY1_BEDate_BDIF>| &&
                    |<YY1_BENo_BDI></YY1_BENo_BDI>| &&
                    |<YY1_BENo_BDIF>3</YY1_BENo_BDIF>| &&
                    |<YY1_ContainerNo_BDI></YY1_ContainerNo_BDI>| &&
                    |<YY1_ContainerNo_BDIF>3</YY1_ContainerNo_BDIF>| &&
                    |<YY1_CylinderNo_BDI></YY1_CylinderNo_BDI>| &&
                    |<YY1_CylinderNo_BDIF>3</YY1_CylinderNo_BDIF>| &&
                    |<YY1_ISO_DATA_BDI></YY1_ISO_DATA_BDI>| &&
                    |<YY1_ISO_DATA_BDIF>3</YY1_ISO_DATA_BDIF>| &&
                    |<YY1_MSMEUDYAMNo_BDI></YY1_MSMEUDYAMNo_BDI>| &&
                    |<YY1_MSMEUDYAMNo_BDIF>3</YY1_MSMEUDYAMNo_BDIF>| &&
                    |<YY1_PhoneNo_BDI></YY1_PhoneNo_BDI>| &&
                    |<YY1_PhoneNo_BDIF>3</YY1_PhoneNo_BDIF>| &&
                    |<YY1_Plant_Address_BDI></YY1_Plant_Address_BDI>| &&
                    |<YY1_Plant_Address_BDIF>3</YY1_Plant_Address_BDIF>| &&
                    |<YY1_Plant_CIN_BDI></YY1_Plant_CIN_BDI>| &&
                    |<YY1_Plant_CIN_BDIF>3</YY1_Plant_CIN_BDIF>| &&
                    |<YY1_Plant_Email_BDI></YY1_Plant_Email_BDI>| &&
                    |<YY1_Plant_Email_BDIF>3</YY1_Plant_Email_BDIF>| &&
                    |<YY1_Plant_GST_BDI></YY1_Plant_GST_BDI>| &&
                    |<YY1_Plant_GST_BDIF>3</YY1_Plant_GST_BDIF>| &&
                    |<YY1_Plant_ISO_BDI></YY1_Plant_ISO_BDI>| &&
                    |<YY1_Plant_ISO_BDIF>3</YY1_Plant_ISO_BDIF>| &&
                    |<YY1_Plant_PAN_BDI></YY1_Plant_PAN_BDI>| &&
                    |<YY1_Plant_PAN_BDIF>3</YY1_Plant_PAN_BDIF>| &&
                    |<YY1_Plant_TAN_BDI></YY1_Plant_TAN_BDI>| &&
                    |<YY1_Plant_TAN_BDIF>3</YY1_Plant_TAN_BDIF>| &&
                    |<YY1_SD_PODATE_BDI>0000-00-00T00:00:00</YY1_SD_PODATE_BDI>| &&
                    |<YY1_SD_PODATE_BDIF>3</YY1_SD_PODATE_BDIF>| &&
                    |<ItemBatchDetails>| &&
                    |<ItemBatchDetailsNode>| &&
                    |<Characteristic>ZB_CL2_CYLINDER_TRACK</Characteristic>| &&
                    |<CharacteristicDescription>CHLORINECYLINDERTRACKING</CharacteristicDescription>| &&
                    |<CharacteristicValue></CharacteristicValue>| &&
                    |<CharacteristicValueDescript></CharacteristicValueDescript>| &&
                    |</ItemBatchDetailsNode>| &&
                    |<ItemBatchDetailsNode>| &&
                    |<Characteristic>TAREWEIGHT</Characteristic>| &&
                    |<CharacteristicDescription>Tareweight</CharacteristicDescription>| &&
                    |<CharacteristicValue>0.00</CharacteristicValue>| &&
                    |<CharacteristicValueDescript>0.00</CharacteristicValueDescript>| &&
                    |</ItemBatchDetailsNode>| &&
                    |<ItemBatchDetailsNode>| &&
                    |<Characteristic>GROSSWEIGHT</Characteristic>| &&
                    |<CharacteristicDescription>Grossweight</CharacteristicDescription>| &&
                    |<CharacteristicValue>| && ls_batchdata-grswt && |</CharacteristicValue>| &&
                    |<CharacteristicValueDescript>| && ls_batchdata-grswt && |</CharacteristicValueDescript>| &&
                    |</ItemBatchDetailsNode>| &&
                    |<ItemBatchDetailsNode>| &&
                    |<Characteristic>NETWEIGHT</Characteristic>| &&
                    |<CharacteristicDescription>NetWeight</CharacteristicDescription>| &&
                    |<CharacteristicValue>| && ls_batchdata-netwt && |</CharacteristicValue>| &&
                    |<CharacteristicValueDescript>| && ls_batchdata-netwt && |</CharacteristicValueDescript>| &&
                    |</ItemBatchDetailsNode>| &&
                    |<ItemBatchDetailsNode>| &&
                    |<Characteristic>ZB_MANUFACTURE_ID</Characteristic>| &&
                    |<CharacteristicDescription>MANUFACTUREID</CharacteristicDescription>| &&
                    |<CharacteristicValue></CharacteristicValue>| &&
                    |<CharacteristicValueDescript></CharacteristicValueDescript>| &&
                    |</ItemBatchDetailsNode>| &&
                    |</ItemBatchDetails>| &&
                    |<ItemConfiguration/>| &&
                    |<ItemPricingConditions>| &&
                    |<ItemPricingConditionNode>| &&
                    |<ConditionAmount>0.00</ConditionAmount>| &&
                    |<ConditionBaseValue>0.000</ConditionBaseValue>| &&
                    |<ConditionBaseValueUnit>TO</ConditionBaseValueUnit>| &&
                    |<ConditionQuantity>1</ConditionQuantity>| &&
                    |<ConditionQuantityUnit>TO</ConditionQuantityUnit>| &&
                    |<ConditionQuantityUnitTechName>t</ConditionQuantityUnitTechName>| &&
                    |<ConditionRateValue>0.00</ConditionRateValue>| &&
                    |<ConditionRateValueUnit>USD</ConditionRateValueUnit>| &&
                    |<ConditionStep>010</ConditionStep>| &&
                    |<ConditionType>ZPRO</ConditionType>| &&
                    |<ConditionTypeName>BasePrice</ConditionTypeName>| &&
                    |<DocumentCurrency></DocumentCurrency>| &&
                    |<VariantCondition></VariantCondition>| &&
                    |</ItemPricingConditionNode>| &&
                    |<ItemPricingConditionNode>| &&
                    |<ConditionAmount>0.00</ConditionAmount>| &&
                    |<ConditionBaseValue>0.000</ConditionBaseValue>| &&
                    |<ConditionBaseValueUnit>TO</ConditionBaseValueUnit>| &&
                    |<ConditionQuantity>1</ConditionQuantity>| &&
                    |<ConditionQuantityUnit>TO</ConditionQuantityUnit>| &&
                    |<ConditionQuantityUnitTechName>t</ConditionQuantityUnitTechName>| &&
                    |<ConditionRateValue>0.00</ConditionRateValue>| &&
                    |<ConditionRateValueUnit>USD</ConditionRateValueUnit>| &&
                    |<ConditionStep>020</ConditionStep>| &&
                    |<ConditionType>ZFRI</ConditionType>| &&
                    |<ConditionTypeName>Freight(PDY)Received</ConditionTypeName>| &&
                    |<DocumentCurrency></DocumentCurrency>| &&
                    |<VariantCondition></VariantCondition>| &&
                    |</ItemPricingConditionNode>| &&
                    |</ItemPricingConditions>| &&
                    |<ItemSerialNUmber/>| &&
                    |<ItemShipToParty>| &&
                    |<AddressID></AddressID>| &&
                    |<AddressLine1Text>Company</AddressLine1Text>| &&
                    |<AddressLine2Text></AddressLine2Text>| &&
                    |<AddressLine3Text></AddressLine3Text>| &&
                    |<AddressLine4Text></AddressLine4Text>| &&
                    |<AddressLine5Text></AddressLine5Text>| &&
                    |<AddressLine6Text></AddressLine6Text>| &&
                    |<AddressLine7Text></AddressLine7Text>| &&
                    |<AddressLine8Text></AddressLine8Text>| &&
                    |<AddressType>1</AddressType>| &&
                    |<FullName></FullName>| &&
                    |<Partner></Partner>| &&
                    |<PartnerFunction>SH</PartnerFunction>| &&
                    |<PartnerFunctionName>ShiptoParty</PartnerFunctionName>| &&
                    |<Person></Person>| &&
                    |</ItemShipToParty>| &&
                    |<ItemTextElements/>| &&
                    |</BillingDocumentItemNode>|                    "#EC CI_NOORDER
                    .
                    lv_count += 1.
                  ENDLOOP.
                ENDIF.
                lv_xml_exinv = lv_xml_exinv &&
                |</Items>| &&
                |<ItemsAfterCorr/>| &&
                |<ItemsDifference/>| &&
                |<LegallyRequiredTexts/>| &&
                |<OpenDownPayment>| &&
                |<BillingDocument></BillingDocument>| &&
                |<DownPaymentGrossAmount>0.00</DownPaymentGrossAmount>| &&
                |<DownPaymentNetAmount>0.00</DownPaymentNetAmount>| &&
                |<DownPaymentTaxAmount>0.00</DownPaymentTaxAmount>| &&
                |</OpenDownPayment>| &&
                |<PayerParty>| &&
                |<AddressID></AddressID>| &&
                |<AddressLine1Text>Company</AddressLine1Text>| &&
                |<AddressLine2Text></AddressLine2Text>| &&
                |<AddressLine3Text></AddressLine3Text>| &&
                |<AddressLine4Text></AddressLine4Text>| &&
                |<AddressLine5Text></AddressLine5Text>| &&
                |<AddressLine6Text></AddressLine6Text>| &&
                |<AddressLine7Text></AddressLine7Text>| &&
                |<AddressLine8Text></AddressLine8Text>| &&
                |<AddressType>1</AddressType>| &&
                |<FullName></FullName>| &&
                |<Partner></Partner>| &&
                |<PartnerFunction>PY</PartnerFunction>| &&
                |<PartnerFunctionName>Payer</PartnerFunctionName>| &&
                |<Person></Person>| &&
                |</PayerParty>| &&
                |<PaymentCard/>| &&
                |<PaymentMethod>| &&
                |<PaymentMethod></PaymentMethod>| &&
                |<PaymentMethodName></PaymentMethodName>| &&
                |</PaymentMethod>| &&
                |<PaymentRequest/>| &&
                |<PaymentTerms>| &&
                |<PaymentDueDate>0000-00-00T00:00:00</PaymentDueDate>| &&
                |<PaymentTerm1Description></PaymentTerm1Description>| &&
                |<PaymentTerm2Description></PaymentTerm2Description>| &&
                |<PaymentTerm3Description></PaymentTerm3Description>| &&
                |<PaymentTermsName></PaymentTermsName>| &&
                |</PaymentTerms>| &&
                |<PricingConditions/>| &&
                |<PricingTerms>| &&
                |<DeliveryDate>0000-00-00T00:00:00</DeliveryDate>| &&
                |<PricingDate>0000-00-00T00:00:00</PricingDate>| &&
                |</PricingTerms>| &&
                |<SEPA>| &&
                |<BICNumber></BICNumber>| &&
                |<BankName></BankName>| &&
                |<IBAN></IBAN>| &&
                |<PaymentDueDate>0000-00-00T00:00:00</PaymentDueDate>| &&
                |<SEPAMandate></SEPAMandate>| &&
                |</SEPA>| &&
                |<ShipToParty>| &&
                |<AddressID>| && ls_billhdr-shpaddrid && |</AddressID>| &&
                |<AddressLine1Text>Company</AddressLine1Text>| &&
                |<AddressLine2Text>| && ls_shaddress-cust-businesspartnername1 && |</AddressLine2Text>| &&
                |<AddressLine3Text>| && ls_shaddress-cust-businesspartnername2 && |</AddressLine3Text>| &&
                |<AddressLine4Text>| && ls_shaddress-cust-streetname && |</AddressLine4Text>| &&
                |<AddressLine5Text>| && ls_shaddress-addr-streetsuffixname1 && |</AddressLine5Text>| &&
                |<AddressLine6Text>| && ls_shaddress-cust-postalcode && ' ' && ls_shaddress-cust-bpaddrcityname && |</AddressLine6Text>| &&
                |<AddressLine7Text>| && ls_shaddress-addr-country && |</AddressLine7Text>| &&
                |<AddressLine8Text></AddressLine8Text>| &&
                |<AddressType>1</AddressType>| &&
                |<City></City>| &&
                |<Countryname></Countryname>| &&
                |<FullName>| && ls_shaddress-cust-bpcustomerfullname && |</FullName>| &&
                |<PanNoCompany></PanNoCompany>| &&
                |<Partner>| && ls_billhdr-shptoid && |</Partner>| &&
                |<PartnerFunction>SH</PartnerFunction>| &&
                |<PartnerFunctionName></PartnerFunctionName>| &&
                |<Person></Person>| &&
                |<PostalCode></PostalCode>| &&
                |<Region>11</Region>| &&
                |<RegionName>Colombo</RegionName>| &&
                |<Street></Street>| &&
                |</ShipToParty>| &&
                |<SoldToParty>| &&
                |<AddressID></AddressID>| &&
                |<AddressLine1Text>Company</AddressLine1Text>| &&
                |<AddressLine2Text></AddressLine2Text>| &&
                |<AddressLine3Text></AddressLine3Text>| &&
                |<AddressLine4Text></AddressLine4Text>| &&
                |<AddressLine5Text></AddressLine5Text>| &&
                |<AddressLine6Text></AddressLine6Text>| &&
                |<AddressLine7Text></AddressLine7Text>| &&
                |<AddressLine8Text></AddressLine8Text>| &&
                |<AddressType>1</AddressType>| &&
                |<FullName></FullName>| &&
                |<Partner></Partner>| &&
                |<PartnerFunction>SP</PartnerFunction>| &&
                |<PartnerFunctionName>Sold-toParty</PartnerFunctionName>| &&
                |<Person></Person>| &&
                |</SoldToParty>| &&
                |<Supplier>| &&
                |<AddressID></AddressID>| &&
                |<AddressLine1Text>Company</AddressLine1Text>| &&
                |<AddressLine2Text></AddressLine2Text>| &&
                |<AddressLine3Text></AddressLine3Text>| &&
                |<AddressLine4Text></AddressLine4Text>| &&
                |<AddressLine5Text></AddressLine5Text>| &&
                |<AddressLine6Text></AddressLine6Text>| &&
                |<AddressLine7Text></AddressLine7Text>| &&
                |<AddressLine8Text></AddressLine8Text>| &&
                |<AddressType></AddressType>| &&
                |<CompanyCode></CompanyCode>| &&
                |<CompanyName></CompanyName>| &&
                |<Country></Country>| &&
                |<EmailAddress></EmailAddress>| &&
                |<FullName></FullName>| &&
                |<Person></Person>| &&
                |<PhoneNumber></PhoneNumber>| &&
                |<Region></Region>| &&
                |<RegionName></RegionName>| &&
                |</Supplier>| &&
                |<TaxationTerms>| &&
                |<CompanyVATRegistration></CompanyVATRegistration>| &&
                |<CustomerICNumber></CustomerICNumber>| &&
                |<CustomerTINNumber></CustomerTINNumber>| &&
                |<CustomerVATRegistration></CustomerVATRegistration>| &&
                |<ID_CompanyCodeTIN></ID_CompanyCodeTIN>| &&
                |<IN_BillToPtyGSTIdnNmbr></IN_BillToPtyGSTIdnNmbr>| &&
                |<IN_GSTIdentificationNumber></IN_GSTIdentificationNumber>| &&
                |<IN_ShipToPtyGSTIdnNmbr></IN_ShipToPtyGSTIdnNmbr>| &&
                |<ShipToPartyProvSlsTaxRegnNmbr></ShipToPartyProvSlsTaxRegnNmbr>| &&
                |<SupplierICNumber></SupplierICNumber>| &&
                |<TaxDepartureCountry></TaxDepartureCountry>| &&
                |<TaxNumber0></TaxNumber0>| &&
                |<TaxNumber1></TaxNumber1>| &&
                |<TaxNumber2></TaxNumber2>| &&
                |<TaxNumber3></TaxNumber3>| &&
                |<TaxNumber4></TaxNumber4>| &&
                |<TaxNumber5></TaxNumber5>| &&
                |<VATRegistrationCountryName></VATRegistrationCountryName>| &&
                |<VATRegistrationOrigin></VATRegistrationOrigin>| &&
                |<VATRegistrationOriginName></VATRegistrationOriginName>| &&
                |</TaxationTerms>| &&
                |<TextElements/>| &&
                |<VATSummary/>| &&
                |</BillingDocumentNode>| &&
                |</Form>|.

**********************************************************************
                DATA(lv_base64_exinv) = cl_web_http_utility=>encode_base64( unencoded = lv_xml_exinv ).
                CLEAR : ls_req-xml_data.
                ls_req-xml_data     = lv_base64_exinv.
**********************************************************************
                TRY.
                    CALL METHOD /ui2/cl_json=>serialize
                      EXPORTING
                        data        = ls_req
                        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                      RECEIVING
                        r_json      = DATA(lv_body).
                  CATCH cx_root INTO DATA(lx_root1).
                    DATA(lv_err3) = 1.
                ENDTRY.
                lo_request->set_text(  EXPORTING i_text = lv_body ).
**********************************************************************
                TRY.
                    DATA(lo_response) = lo_client->execute(
                    i_method = if_web_http_client=>post
                    i_timeout = 0  ).
                  CATCH cx_web_http_client_error INTO lx_client_error.
                    DATA(lv_err4) = 1.
                ENDTRY.
**********************************************************************
                DATA(lv_respons) = lo_response->get_text(  ).
                DATA(ls_stas) = lo_response->get_status(  ).
**********************************************************************
                CLEAR : ls_response.
                TRY.
                    CALL METHOD /ui2/cl_json=>deserialize
                      EXPORTING
                        json          = lv_respons
                        assoc_arrays  = abap_true
                        name_mappings = VALUE #( ( json = 'filecontent' abap = 'FILECONTENT' ) )
                      CHANGING
                        data          = ls_response.
                  CATCH cx_root INTO lx_root.
                    DATA(lv_err5) = 1.
                ENDTRY.
**********************************************************************
                DATA(lv_basecode_exinv) = ls_response-filecontent.

************************************************************************
*      """ HTTP Communication via URL   """
                TRY.
                    lo_httpreqst->set_text( '{    "AuthorizedSignatory": "Chemfab",'
                               && '    "SignerName": "AG",'
                               && '    "TopLeft": 0,'
                && '    "BottomLeft": 0,'
                && '    "TopRight": 0,'
                && '    "BottomRight": 0,'
                && '    "ExcludePageNo": "",'
                && '    "InvoiceNumber": "818",'
                && '    "pageNo": -1,'
                && '    "PrintDateTime": "",'
                && '    "FindAuth": "Authori",'
                && '    "FindAuthLocation": 0,'
                && '    "fontsize": 24,'
                && '    "adjustCoordinates": 0,'
                && '    "signOnlySearchTextPage": 1,'
                && '    "pdfByte1": "'
                && lv_basecode_exinv
                &&  '" }'     ).
                    " execute HTTP POST-request and store response
                    lo_http_response = lo_http_client->execute( if_web_http_client=>post ).
                    DATA(ls_status_exinv) = lo_http_response->get_status(  ).

                    lv_expinv = lo_http_response->get_text(  ).
                  CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error3).
                    DATA(lv_4) = 4.
                ENDTRY.
**********************************************************************
                IF lv_expinv IS NOT INITIAL.
                  CLEAR ls_dscresponse.
                  TRY.
                      CALL METHOD /ui2/cl_json=>deserialize
                        EXPORTING
                          json          = lv_expinv
                          assoc_arrays  = abap_true
                          name_mappings = VALUE #( ( json = 'file' abap = 'FILECONTENT' ) )
                        CHANGING
                          data          = ls_dscresponse.
                    CATCH cx_root INTO lx_root.
                      DATA(lv_err6) = 1.
                  ENDTRY.
**********************************************************************
                  DATA(lv_print_data_exinv) = cl_web_http_utility=>decode_x_base64( encoded = ls_dscresponse-filecontent  ).
                  DATA(lv_qitem_id_exinv)  = cl_print_queue_utils=>create_queue_itemid(  ).
**********************************************************************

                  zbp_sd_app09_dmrv=>gs_print_data_dc = lv_print_data_exinv .
                  zbp_sd_app09_dmrv=>gs_pqitem_id_dc = lv_qitem_id_exinv.


*****************************************************************************************
****************************** Packing List *********************************************         ****************
*****************************************************************************************

                  ls_req-xdp_template = 'ZDOMINV_PDY/DOMINV_PDY' .   " 'ZPNDYFGINV/ZPFITEMP'.
**********************************************************************
                  DATA(lv_xml_pcklst) = |<?xml version="1.0" encoding="utf-8"?>| &&
                                        |<Form xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/">| &&
                                        |<BillingDocumentNode>| &&
            |<AbsltAccountingExchangeRate></AbsltAccountingExchangeRate>| &&
            |<AccountingDocument>| && ls_billhdr-accdoc && |</AccountingDocument>| &&
            |<AckDate>| && ls_billhdr-ackdate && |</AckDate>| &&
            |<AckNumber>| && ls_billhdr-ackno && |</AckNumber>| &&
            |<AckTime>00:00:00</AckTime>| &&
            |<AmountInWords></AmountInWords>| &&
|<BankBranch></BankBranch>| &&
|<BillingDate>| && ls_billhdr-billdate && |</BillingDate>| &&
|<BillingDocument>| && ls_billhdr-billdoc && |</BillingDocument>| &&
|<BillingDocumentCategory></BillingDocumentCategory>| &&
|<BillingDocumentType></BillingDocumentType>| &&
|<BillingDocumentTypeName>Invoice</BillingDocumentTypeName>| &&
|<BillingSDDocumentCategory>M</BillingSDDocumentCategory>| &&
|<BillingSDDocumentCategoryName>Invoice</BillingSDDocumentCategoryName>| &&
|<CancelledBillingDocument></CancelledBillingDocument>| &&
|<ConditionAmountLocCurr>0.00</ConditionAmountLocCurr>| &&
|<ConditionBaseValueLocCurr>0.00</ConditionBaseValueLocCurr>| &&
|<ContactName>| && lv_user  && |</ContactName>| &&
|<Country></Country>| &&
|<CrrtnInvoiceIsDifferential>false</CrrtnInvoiceIsDifferential>| &&
|<CustomerBranchCode></CustomerBranchCode>| &&
|<CustomerInvoice></CustomerInvoice>| &&
|<CustomerInvoiceDate>0000-00-00T00:00:00</CustomerInvoiceDate>| &&
|<DocumentReferenceID>| && ls_billhdr-refdoc && |</DocumentReferenceID>| &&
|<EwbNumber>000000000000</EwbNumber>| &&
|<EwbValidfromDate>0000-00-00T00:00:00</EwbValidfromDate>| &&
|<EwbValidfromTime>00:00:00</EwbValidfromTime>| &&
|<EwbValidtoDate>0000-00-00T00:00:00</EwbValidtoDate>| &&
|<EwbValidtoTime>00:00:00</EwbValidtoTime>| &&
|<ExchangeRate>0.00000</ExchangeRate>| &&
|<ExchangeRateDate>0000-00-00T00:00:00</ExchangeRateDate>| &&
|<ExchangeRateIsIndirect></ExchangeRateIsIndirect>| &&
|<ExemptionLetterDate>0000-00-00T00:00:00</ExemptionLetterDate>| &&
|<ExemptionLetterNumber></ExemptionLetterNumber>| &&
|<GloLocalCurr></GloLocalCurr>| &&
|<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
|<ID_TaxInvoiceSigner></ID_TaxInvoiceSigner>| &&
|<IndicatorVatSplit></IndicatorVatSplit>| &&
|<InvoiceListStatus></InvoiceListStatus>| &&
|<Irn>| && ls_billhdr-irn && |</Irn>| &&
|<LocCurr></LocCurr>| &&
|<PaymentReference></PaymentReference>| &&
|<PrelimBillingDocument></PrelimBillingDocument>| &&
|<PricingProcedure></PricingProcedure>| &&
|<PurchaseOrderByCustomer>| && ls_billhdr-ordrefdat && |</PurchaseOrderByCustomer>| &&
|<QrcodeBitmap></QrcodeBitmap>| &&
|<ReferenceSDDocument></ReferenceSDDocument>| &&
|<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
|<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
|<RemunerationTotalNetAmount>0.00</RemunerationTotalNetAmount>| &&
|<SalesContract></SalesContract>| &&
|<SalesDocument></SalesDocument>| &&
|<SalesOrderDate>0000-00-00T00:00:00</SalesOrderDate>| &&
|<SalesOrderReason></SalesOrderReason>| &&
|<SalesOrderReasonText></SalesOrderReasonText>| &&
|<SalesOrganization>| && ls_billhdr-sorg && |</SalesOrganization>| &&
|<SalesOrganizationName>| && ls_billhdr-sorgtxt && |</SalesOrganizationName>| &&
|<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
|<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
|<SolutionOrder></SolutionOrder>| &&
|<Status></Status>| &&
|<SupplyDate>0000-00-00T00:00:00</SupplyDate>| &&
|<TaxReportingDate>0000-00-00T00:00:00</TaxReportingDate>| &&
|<TotGrssAmtAsText></TotGrssAmtAsText>| &&
|<TotalDiscount>0.00</TotalDiscount>| &&
|<TotalDiscountLoccurr>0.00</TotalDiscountLoccurr>| &&
|<TotalGrossAmount></TotalGrossAmount>| &&
|<TotalGrossAmountLocurr>0.00</TotalGrossAmountLocurr>| &&
|<TotalNetAmount>| && ls_billhdr-netamt && |</TotalNetAmount>| &&
|<TotalNetAmountLocurr>0.00</TotalNetAmountLocurr>| &&
|<TotalOtherCharges>0.00</TotalOtherCharges>| &&
|<TotalOtherChargesLoccurr>0.00</TotalOtherChargesLoccurr>| &&
|<TotalSalesAmount>0.00</TotalSalesAmount>| &&
|<TotalSalesAmountLoccurr>0.00</TotalSalesAmountLoccurr>| &&
|<TotalTaxAmount>| && ls_billhdr-taxamt && |</TotalTaxAmount>| &&
|<TotalWth>0.00</TotalWth>| &&
|<TotalWthLoccur>0.00</TotalWthLoccur>| &&
|<TransactionCurrency>USD</TransactionCurrency>| &&
|<TransporterGstin></TransporterGstin>| &&
|<TransporterName>| && ls_billhdr-transporter && |</TransporterName>| &&
|<Uuid></Uuid>| &&
|<VehicleNumber></VehicleNumber>| &&
|<YY1_AccountNumber_BDH>000000000000000</YY1_AccountNumber_BDH>| &&
|<YY1_AccountNumber_BDHF>3</YY1_AccountNumber_BDHF>| &&
|<YY1_BILL_PAN_BDH>| && ls_billhdr-pan && |</YY1_BILL_PAN_BDH>| &&
|<YY1_BILL_PAN_BDHF>3</YY1_BILL_PAN_BDHF>| &&
|<YY1_BankName_BDH></YY1_BankName_BDH>| &&
|<YY1_BankName_BDHF>3</YY1_BankName_BDHF>| &&
|<YY1_BankName_BDHT></YY1_BankName_BDHT>| &&
|<YY1_Branch_BDH></YY1_Branch_BDH>| &&
|<YY1_Branch_BDHF>3</YY1_Branch_BDHF>| &&
|<YY1_CHARWT_BDH>0.000</YY1_CHARWT_BDH>| &&
|<YY1_CHARWT_BDHF>3</YY1_CHARWT_BDHF>| &&
|<YY1_CHARWT_BDHT></YY1_CHARWT_BDHT>| &&
|<YY1_CHARWT_BDHU></YY1_CHARWT_BDHU>| &&
|<YY1_CONCN_BDH>| && ls_billhdr-concnwt && |</YY1_CONCN_BDH>| &&
|<YY1_CONCN_BDHF>3</YY1_CONCN_BDHF>| &&
|<YY1_CONCN_BDHT></YY1_CONCN_BDHT>| &&
|<YY1_CONCN_BDHU></YY1_CONCN_BDHU>| &&
|<YY1_CylinderDetailSeal_BDH>| && ls_billhdr-cylinderdetailseal && |</YY1_CylinderDetailSeal_BDH>| &&
|<YY1_CylinderDetailSeal_BDHF>3</YY1_CylinderDetailSeal_BDHF>| &&
|<YY1_DistributionChanne_BDH>| && ls_billhdr-distchn && |</YY1_DistributionChanne_BDH>| &&
|<YY1_DistributionChanne_BDHF>3</YY1_DistributionChanne_BDHF>| &&
|<YY1_Division_BDH>| && ls_billhdr-divsn && |</YY1_Division_BDH>| &&
|<YY1_Division_BDHF>3</YY1_Division_BDHF>| &&
|<YY1_DriverDetails_BDH>| && ls_billhdr-driverdetails && |</YY1_DriverDetails_BDH>| &&
|<YY1_DriverDetails_BDHF>3</YY1_DriverDetails_BDHF>| &&
|<YY1_EINVOICE_QRTEXT_BDH></YY1_EINVOICE_QRTEXT_BDH>| &&
|<YY1_EINVOICE_QRTEXT_BDHF>3</YY1_EINVOICE_QRTEXT_BDHF>| &&
|<YY1_FreightIndicatorSD_BDH>false</YY1_FreightIndicatorSD_BDH>| &&
|<YY1_FreightIndicatorSD_BDHF>3</YY1_FreightIndicatorSD_BDHF>| &&
|<YY1_FreightTerms_BDH>| && ls_billhdr-freightterms && |</YY1_FreightTerms_BDH>| &&
|<YY1_FreightTerms_BDHF>3</YY1_FreightTerms_BDHF>| &&
|<YY1_FreightTerms_BDHT>| && ls_billhdr-freightterms && |</YY1_FreightTerms_BDHT>| &&
|<YY1_GrossWT_BDH>| && ls_billhdr-grosswt && |</YY1_GrossWT_BDH>| &&
|<YY1_GrossWT_BDHF>3</YY1_GrossWT_BDHF>| &&
|<YY1_GrossWT_BDHT></YY1_GrossWT_BDHT>| &&
|<YY1_GrossWT_BDHU></YY1_GrossWT_BDHU>| &&
|<YY1_IFSCCode_BDH></YY1_IFSCCode_BDH>| &&
|<YY1_IFSCCode_BDHF>3</YY1_IFSCCode_BDHF>| &&
|<YY1_ModeOfTransport_BDH>| && ls_billhdr-modeoftransport && |</YY1_ModeOfTransport_BDH>| &&
|<YY1_ModeOfTransport_BDHF>3</YY1_ModeOfTransport_BDHF>| &&
|<YY1_NETWT_BDH>| && ls_billhdr-netwt && |</YY1_NETWT_BDH>| &&
|<YY1_NETWT_BDHF>3</YY1_NETWT_BDHF>| &&
|<YY1_NETWT_BDHT></YY1_NETWT_BDHT>| &&
|<YY1_NETWT_BDHU></YY1_NETWT_BDHU>| &&
|<YY1_NOOFCylinder_BDH>| && ls_billhdr-yy1_noofcylinder_dlh && |</YY1_NOOFCylinder_BDH>| &&
|<YY1_NOOFCylinder_BDHF>3</YY1_NOOFCylinder_BDHF>| &&
|<YY1_Place_BDH></YY1_Place_BDH>| &&
|<YY1_Place_BDHF>3</YY1_Place_BDHF>| &&
|<YY1_Place_BDHT></YY1_Place_BDHT>| &&
|<YY1_SD_PONO_BDH></YY1_SD_PONO_BDH>| &&
|<YY1_SD_PONO_BDHF>3</YY1_SD_PONO_BDHF>| &&
|<YY1_SwiftCode_BDH></YY1_SwiftCode_BDH>| &&
|<YY1_SwiftCode_BDHF>3</YY1_SwiftCode_BDHF>| &&
|<YY1_TAREWT_BDH>0.000</YY1_TAREWT_BDH>| &&
|<YY1_TAREWT_BDHF>3</YY1_TAREWT_BDHF>| &&
|<YY1_TAREWT_BDHT></YY1_TAREWT_BDHT>| &&
|<YY1_TAREWT_BDHU></YY1_TAREWT_BDHU>| &&
|<YY1_Transporter_BDH>| && ls_billhdr-transporter && |</YY1_Transporter_BDH>| &&
|<YY1_Transporter_BDHF>3</YY1_Transporter_BDHF>| &&
|<YY1_VehicleNumber_BDH>| && ls_billhdr-vehiclenumber && |</YY1_VehicleNumber_BDH>| &&
|<YY1_VehicleNumber_BDHF>3</YY1_VehicleNumber_BDHF>| &&
|<YY1_VolumePerCylinder_BDH>| && ls_billhdr-volumepercylinder && |</YY1_VolumePerCylinder_BDH>| &&
|<YY1_VolumePerCylinder_BDHF>3</YY1_VolumePerCylinder_BDHF>| &&
|<YY1_VolumePerCylinder_BDHT></YY1_VolumePerCylinder_BDHT>| &&
|<YY1_VolumePerCylinder_BDHU>| && ls_billhdr-unit && |</YY1_VolumePerCylinder_BDHU>| &&
|<BillToParty>| &&
|<AddressID>| && ls_billhdr-pyraddrid && |</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>| && ls_bpaddress-cust-businesspartnername1 && |</AddressLine2Text>| &&
|<AddressLine3Text>| && ls_bpaddress-cust-businesspartnername2 && |</AddressLine3Text>| &&
|<AddressLine4Text>| && ls_bpaddress-cust-bpaddrstreetname && |</AddressLine4Text>| &&
|<AddressLine5Text>| && ls_bpaddress-addr-streetsuffixname1 && |</AddressLine5Text>| &&
          |<AddressLine6Text>| && ls_bpaddress-cust-postalcode && ' ' && ls_bpaddress-cust-bpaddrcityname &&  |</AddressLine6Text>| &&
          |<AddressLine7Text></AddressLine7Text>| &&
          |<AddressLine8Text>| && lv_copytyp && |</AddressLine8Text>| &&
          |<AddressType>1</AddressType>| &&
          |<City></City>| &&
          |<Countryname></Countryname>| &&
          |<FaxNumber></FaxNumber>| &&
          |<FullName>| && ls_billhdr-payertxt && |</FullName>| &&
          |<Partner>| && ls_billhdr-payerid && |</Partner>| &&
          |<PartnerFunction>BP</PartnerFunction>| &&
          |<PartnerFunctionName></PartnerFunctionName>| &&
          |<Person></Person>| &&
          |<PostalCode></PostalCode>| &&
          |<Region>| && ls_billhdr-billtoregion && |</Region>| &&
          |<RegionName>| && ls_billhdr-pystate && |</RegionName>| &&
          |<Street></Street>| &&
          |<TelephoneNumber></TelephoneNumber>| &&
|</BillToParty>| &&
|<ClearedDownPayment/>| &&
|<ClearedDownPaymentOvw>| &&
|<BillingDocument></BillingDocument>| &&
|<DocumentDescription></DocumentDescription>| &&
|<DownPaymentGrossAmount>0.00</DownPaymentGrossAmount>| &&
|<DownPaymentNetAmount>0.00</DownPaymentNetAmount>| &&
|<DownPaymentTaxAmount>0.00</DownPaymentTaxAmount>| &&
|</ClearedDownPaymentOvw>| &&
|<Company>| &&
|<AddressID></AddressID>| &&
            |<AddressLine1Text>| && ls_billhdr-street && |</AddressLine1Text>| &&
            |<AddressLine2Text></AddressLine2Text>| &&
            |<AddressLine3Text></AddressLine3Text>| &&
            |<AddressLine4Text></AddressLine4Text>| &&
            |<AddressLine5Text></AddressLine5Text>| &&
            |<AddressLine6Text></AddressLine6Text>| &&
            |<AddressLine7Text></AddressLine7Text>| &&
            |<AddressLine8Text></AddressLine8Text>| &&
            |<AddressType></AddressType>| &&
            |<BankAccKey></BankAccKey>| &&
            |<City></City>| &&
            |<CompanyCode>| && ls_billhdr-ccode && |</CompanyCode>| &&
            |<CompanyName>| && ls_billhdr-ccodetxt && |</CompanyName>| &&
            |<Country></Country>| &&
            |<Countryname></Countryname>| &&
            |<EmailAddress></EmailAddress>| &&
            |<FullName></FullName>| &&
            |<Person></Person>| &&
            |<PhoneNumber></PhoneNumber>| &&
            |<PostalCode></PostalCode>| &&
            |<Region></Region>| &&
            |<RegionName></RegionName>| &&
|</Company>| &&
|<CustomerProject>| &&
|<CustomerProject></CustomerProject>| &&
|<CustomerProjectName></CustomerProjectName>| &&
|<EndDate>0000-00-00T00:00:00</EndDate>| &&
|<ProjectManagerName></ProjectManagerName>| &&
|<StartDate>0000-00-00T00:00:00</StartDate>| &&
|</CustomerProject>| &&
|<DownPaymentOverview>| &&
|<DownPaymentGrossAmount>0.00</DownPaymentGrossAmount>| &&
|<DownPaymentNetAmount>0.00</DownPaymentNetAmount>| &&
|<DownPaymentSettlementAmount>0.00</DownPaymentSettlementAmount>| &&
|<DownPaymentTaxAmount>0.00</DownPaymentTaxAmount>| &&
|<DwnPaytRoundingDiffAmount>0.00</DwnPaytRoundingDiffAmount>| &&
|<DwnPaytSettlementNetAmount>0.00</DwnPaytSettlementNetAmount>| &&
|<DwnPaytSettlementTaxAmount>0.00</DwnPaytSettlementTaxAmount>| &&
|<OpenTotalGrossAmount>0.00</OpenTotalGrossAmount>| &&
|<OpenTotalTaxAmount>0.00</OpenTotalTaxAmount>| &&
|<TransactionCurrency></TransactionCurrency>| &&
|<DownPayments/>| &&
|</DownPaymentOverview>| &&
|<DownPaymentProcessingOverview>| &&
|<DownPaymentSettlementGrossAmount>0.00</DownPaymentSettlementGrossAmount>| &&
|<DownPaymentSettlementNetAmount>0.00</DownPaymentSettlementNetAmount>| &&
|<DownPaymentSettlementTaxAmount>0.00</DownPaymentSettlementTaxAmount>| &&
|<OpenTotalGrossAmount>0.00</OpenTotalGrossAmount>| &&
|<OpenTotalTaxAmount>0.00</OpenTotalTaxAmount>| &&
|<TransactionCurrency></TransactionCurrency>| &&
|<DownPaymentProcessingSettlement/>| &&
|</DownPaymentProcessingOverview>| &&
|<Incoterms>| &&
|<Incoterms></Incoterms>| &&
|<IncotermsLocation1>| && ls_billhdr-incoloc1 && |</IncotermsLocation1>| &&
|<IncotermsLocation1Lbl></IncotermsLocation1Lbl>| &&
|<IncotermsLocation2></IncotermsLocation2>| &&
|<IncotermsLocation2Lbl></IncotermsLocation2Lbl>| &&
|<IncotermsVersion>| && ls_billhdr-incotyp && |</IncotermsVersion>| &&
|</Incoterms>| &&
|<ISRPrintDetails>| &&
|<AdditionalSubscriberNo>000000000</AdditionalSubscriberNo>| &&
|<Address></Address>| &&
|<BankCity></BankCity>| &&
|<BankName></BankName>| &&
|<BankNumber></BankNumber>| &&
|<BillingDocument></BillingDocument>| &&
|<City></City>| &&
|<CodingLine></CodingLine>| &&
|<CompanyCode></CompanyCode>| &&
|<Country></Country>| &&
|<CustomerID></CustomerID>| &&
|<District></District>| &&
|<DocumentCurrency></DocumentCurrency>| &&
|<ISRProcedure>00</ISRProcedure>| &&
|<Name1></Name1>| &&
|<Name2></Name2>| &&
|<Name3></Name3>| &&
|<Name4></Name4>| &&
|<NetValue>0.00</NetValue>| &&
|<POBox></POBox>| &&
|<POBoxPostalCode></POBoxPostalCode>| &&
|<PORNumber></PORNumber>| &&
|<PORReferenceNumber></PORReferenceNumber>| &&
|<PostalCode></PostalCode>| &&
|<Region></Region>| &&
|<StreetAndHouseNumber></StreetAndHouseNumber>| &&
|<SubscriberNo>000000000</SubscriberNo>| &&
|<Title></Title>| &&
|</ISRPrintDetails>| &&
|<Items>| &&
|<BillingDocumentItemNode>| &&
|<Batch></Batch>| &&
|<BillingDocumentItem>| && ls_billitm-billitm && |</BillingDocumentItem>| &&
            |<BillingDocumentItemText>| && ls_billitm-itemtxt && |</BillingDocumentItemText>| &&
            |<BillingPeriodOfPerfEndDate>0000-00-00T00:00:00</BillingPeriodOfPerfEndDate>| &&
            |<BillingPeriodOfPerfStartDate>0000-00-00T00:00:00</BillingPeriodOfPerfStartDate>| &&
|<CommodityCode></CommodityCode>| &&
|<CountryOfOrigin></CountryOfOrigin>| &&
|<CustomerInvoice></CustomerInvoice>| &&
|<CustomerInvoiceItem>000000</CustomerInvoiceItem>| &&
|<DebitCreditCode></DebitCreditCode>| &&
|<GloLocalCurr></GloLocalCurr>| &&
|<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
|<GrossAmount>0.00</GrossAmount>| &&
|<Higherlevelitem>000000</Higherlevelitem>| &&
|<IN_GSTControlCodeDesc1>FLUORINE,CHLORINE,BROMINEANDIODINE-CHLORINE</IN_GSTControlCodeDesc1>| &&
|<IN_GSTControlCodeDesc2></IN_GSTControlCodeDesc2>| &&
|<IN_GSTControlCodeDesc3></IN_GSTControlCodeDesc3>| &&
|<IN_GSTControlCodeDesc4></IN_GSTControlCodeDesc4>| &&
|<IN_GSTControlCodeDesc5></IN_GSTControlCodeDesc5>| &&
|<IN_HSNOrSACCode>| && ls_billitm-hsnno && |</IN_HSNOrSACCode>| &&
            |<ItemDiscount>0.00</ItemDiscount>| &&
            |<Material>| && ls_billitm-product && |</Material>| &&
            |<MaterialName>| && ls_billitm-matdesc && |</MaterialName>| &&
            |<Materialisinternalbatchmanaged></Materialisinternalbatchmanaged>| &&
            |<NetAmount>| && ls_billitm-netamt && |</NetAmount>| &&
            |<NetAmountLoccurr>0.00</NetAmountLoccurr>| &&
            |<NetPriceAmount>| && ls_billitm-netamt && |</NetPriceAmount>| &&
            |<NetPriceQuantity>1</NetPriceQuantity>| &&
            |<NetPriceQuantityUnit>EA</NetPriceQuantityUnit>| &&
            |<NetPriceQuantityUnitTechName>EA</NetPriceQuantityUnitTechName>| &&
            |<NetWeight>1.000</NetWeight>| &&
            |<OtherCharges>0.00</OtherCharges>| &&
            |<Plant>| && ls_billitm-plant && |</Plant>| &&
            |<PurchaseOrderByCustomer>| && ls_billhdr-ordrefdat && |</PurchaseOrderByCustomer>| &&
            |<Quantity>| && ls_billitm-billqty && |</Quantity>| &&
            |<QuantityUnit>| && ls_billitm-unit && |</QuantityUnit>| &&
|<QuantityUnitTechName></QuantityUnitTechName>| &&
|<ReferenceSDDocument></ReferenceSDDocument>| &&
|<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
|<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
|<RegionOfOrigin></RegionOfOrigin>| &&
|<SalesContract></SalesContract>| &&
|<SalesContractItem>000000</SalesContractItem>| &&
|<SalesDocument></SalesDocument>| &&
|<SalesOrderExternalDocId></SalesOrderExternalDocId>| &&
|<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
|<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
|<ServicesRenderedDate>2025-01-22T00:00:00</ServicesRenderedDate>| &&
|<SoldProduct></SoldProduct>| &&
|<SolutionOrder></SolutionOrder>| &&
|<SolutionOrderItem>000000</SolutionOrderItem>| &&
|<StatisticalValue></StatisticalValue>| &&
|<TaxAmount>0.00</TaxAmount>| &&
|<TaxAmountLoccurr>0.00</TaxAmountLoccurr>| &&
|<TaxCode></TaxCode>| &&
|<TaxRate>.0</TaxRate>| &&
|<Timesheetovertimecategory></Timesheetovertimecategory>| &&
|<Timesheetovertimecategorytext></Timesheetovertimecategorytext>| &&
|<TotalAmountLoccurr>0.00</TotalAmountLoccurr>| &&
|<TransactionCurrency></TransactionCurrency>| &&
|<Unitprice>0.00</Unitprice>| &&
|<WeightUnit>KG</WeightUnit>| &&
|<YY1_BEDate_BDI>0000-00-00T00:00:00</YY1_BEDate_BDI>| &&
|<YY1_BEDate_BDIF>3</YY1_BEDate_BDIF>| &&
|<YY1_BENo_BDI></YY1_BENo_BDI>| &&
|<YY1_BENo_BDIF>3</YY1_BENo_BDIF>| &&
|<YY1_ContainerNo_BDI></YY1_ContainerNo_BDI>| &&
|<YY1_ContainerNo_BDIF>3</YY1_ContainerNo_BDIF>| &&
|<YY1_CylinderNo_BDI></YY1_CylinderNo_BDI>| &&
|<YY1_CylinderNo_BDIF>3</YY1_CylinderNo_BDIF>| &&
|<YY1_ISO_DATA_BDI></YY1_ISO_DATA_BDI>| &&
|<YY1_ISO_DATA_BDIF>3</YY1_ISO_DATA_BDIF>| &&
|<YY1_MSMEUDYAMNo_BDI>UDYAM-PY-03-0045352</YY1_MSMEUDYAMNo_BDI>| &&
|<YY1_MSMEUDYAMNo_BDIF>3</YY1_MSMEUDYAMNo_BDIF>| &&
|<YY1_PhoneNo_BDI>| && ls_billhdr-phone && |</YY1_PhoneNo_BDI>| &&
            |<YY1_PhoneNo_BDIF>3</YY1_PhoneNo_BDIF>| &&
            |<YY1_Plant_Address_BDI>| && ls_billhdr-street && |</YY1_Plant_Address_BDI>| &&
            |<YY1_Plant_Address_BDIF>3</YY1_Plant_Address_BDIF>| &&
            |<YY1_Plant_CIN_BDI>| && ls_billhdr-cin && |</YY1_Plant_CIN_BDI>| &&
            |<YY1_Plant_CIN_BDIF>3</YY1_Plant_CIN_BDIF>| &&
            |<YY1_Plant_Email_BDI>| && ls_billhdr-email && |</YY1_Plant_Email_BDI>| &&
            |<YY1_Plant_Email_BDIF>3</YY1_Plant_Email_BDIF>| &&
            |<YY1_Plant_GST_BDI>| && ls_billhdr-gstin && |</YY1_Plant_GST_BDI>| &&
            |<YY1_Plant_GST_BDIF>3</YY1_Plant_GST_BDIF>| &&
            |<YY1_Plant_ISO_BDI>| && ls_billhdr-iso && |</YY1_Plant_ISO_BDI>| &&
            |<YY1_Plant_ISO_BDIF>3</YY1_Plant_ISO_BDIF>| &&
            |<YY1_Plant_PAN_BDI>| && ls_billhdr-pan && |</YY1_Plant_PAN_BDI>| &&
            |<YY1_Plant_PAN_BDIF>3</YY1_Plant_PAN_BDIF>| &&
            |<YY1_Plant_TAN_BDI>| && ls_billhdr-tan && |</YY1_Plant_TAN_BDI>| &&
            |<YY1_Plant_TAN_BDIF>3</YY1_Plant_TAN_BDIF>| &&
            |<YY1_SD_PODATE_BDI>0000-00-00T00:00:00</YY1_SD_PODATE_BDI>| &&
|<YY1_SD_PODATE_BDIF>3</YY1_SD_PODATE_BDIF>| &&
|<ItemBatchDetails/>| &&
|<ItemConfiguration/>| &&
|<ItemPricingConditions>| &&
|<ItemPricingConditionNode>| &&
            |<ConditionAmount>| && ls_billitm-conditionamount_zpro && |</ConditionAmount>| &&
            |<ConditionBaseValue>| && ls_billitm-basevalue_zpro && |</ConditionBaseValue>| &&
            |<ConditionBaseValueUnit>| && ls_billitm-basevalueunit_zpro && |</ConditionBaseValueUnit>| &&
            |<ConditionQuantity>| && ls_billitm-conditionquantity_zpro && |</ConditionQuantity>| &&
            |<ConditionQuantityUnit>| && ls_billitm-quantityunit_zpro && |</ConditionQuantityUnit>| &&
            |<ConditionQuantityUnitTechName></ConditionQuantityUnitTechName>| &&
            |<ConditionRateValue>| && ls_billitm-conditionrateamount_zpro && |</ConditionRateValue>| &&
            |<ConditionRateValueUnit>| && ls_billitm-rateunit && |</ConditionRateValueUnit>| &&
            |<ConditionStep>010</ConditionStep>| &&
            |<ConditionType>ZPRO</ConditionType>| &&
            |<ConditionTypeName>BasePrice</ConditionTypeName>| &&
            |<DocumentCurrency>| && ls_billitm-curky && |</DocumentCurrency>| &&
            |<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|<ItemPricingConditionNode>| &&
            |<ConditionAmount>| && ls_billitm-conditionamount_zfri && |</ConditionAmount>| &&
            |<ConditionBaseValue>| && ls_billitm-basevalue_zfri && |</ConditionBaseValue>| &&
            |<ConditionBaseValueUnit>| && ls_billitm-basevalueunit_zfri && |</ConditionBaseValueUnit>| &&
            |<ConditionQuantity>| && ls_billitm-conditionquantity_zfri && |</ConditionQuantity>| &&
            |<ConditionQuantityUnit>| && ls_billitm-quantityunit_zfri && |</ConditionQuantityUnit>| &&
            |<ConditionQuantityUnitTechName></ConditionQuantityUnitTechName>| &&
            |<ConditionRateValue></ConditionRateValue>| &&
            |<ConditionRateValueUnit>| && ls_billitm-rateunit && |</ConditionRateValueUnit>| &&
            |<ConditionStep>020</ConditionStep>| &&
            |<ConditionType>ZFRI</ConditionType>| &&
            |<ConditionTypeName>Freight(PDY)Received</ConditionTypeName>| &&
            |<DocumentCurrency></DocumentCurrency>| &&
|<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|</ItemPricingConditions>| &&
|<ItemSerialNUmber/>| &&
              |<ItemShipToParty>| &&
              |<AddressID>| && ls_billhdr-shpaddrid && |</AddressID>| &&
              |<AddressLine1Text>Company</AddressLine1Text>| &&
              |<AddressLine2Text>| && ls_shaddress-cust-businesspartnername1 && |</AddressLine2Text>| &&
              |<AddressLine3Text>| && ls_shaddress-cust-businesspartnername2 && |</AddressLine3Text>| &&
              |<AddressLine4Text>| && ls_shaddress-cust-streetname && |</AddressLine4Text>| &&
              |<AddressLine5Text>| && ls_shaddress-addr-streetsuffixname1 && |</AddressLine5Text>| &&
              |<AddressLine6Text>| && ls_shaddress-cust-postalcode && ' ' && ls_shaddress-cust-bpaddrcityname && |</AddressLine6Text>| &&
              |<AddressLine7Text></AddressLine7Text>| &&
              |<AddressLine8Text></AddressLine8Text>| &&
              |<AddressType>1</AddressType>| &&
              |<FullName></FullName>| &&
              |<Partner>| && ls_billhdr-shptoid && |</Partner>| &&
              |<PartnerFunction>SH</PartnerFunction>| &&
              |<PartnerFunctionName>ShiptoParty</PartnerFunctionName>| &&
              |<Person></Person>| &&
              |</ItemShipToParty>| &&
|<ItemTextElements/>| &&
|</BillingDocumentItemNode>|.
                  IF lt_batchdata IS NOT INITIAL.
                    LOOP AT lt_batchdata INTO DATA(ls_batchdata1).
                      lv_xml_pcklst = lv_xml_pcklst &&
                      |<BillingDocumentItemNode>| &&
                      |<Batch>| && ls_batchdata1-batch && |</Batch>| &&
                      |<BillingDocumentItem>| && ls_batchdata1-billingdocumentitem && |</BillingDocumentItem>| &&
                      |<BillingDocumentItemText></BillingDocumentItemText>| &&
                      |<BillingPeriodOfPerfEndDate>0000-00-00T00:00:00</BillingPeriodOfPerfEndDate>| &&
                      |<BillingPeriodOfPerfStartDate>0000-00-00T00:00:00</BillingPeriodOfPerfStartDate>| &&
                      |<CommodityCode></CommodityCode>| &&
                      |<CountryOfOrigin></CountryOfOrigin>| &&
                      |<CustomerInvoice></CustomerInvoice>| &&
                      |<CustomerInvoiceItem>000000</CustomerInvoiceItem>| &&
                      |<DebitCreditCode></DebitCreditCode>| &&
                      |<GloLocalCurr></GloLocalCurr>| &&
                      |<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
                      |<GrossAmount>0.00</GrossAmount>| &&
                      |<Higherlevelitem>000000</Higherlevelitem>| &&
                      |<IN_GSTControlCodeDesc1>FLUORINE,CHLORINE,BROMINEANDIODINE-CHLORINE</IN_GSTControlCodeDesc1>| &&
                      |<IN_GSTControlCodeDesc2></IN_GSTControlCodeDesc2>| &&
                      |<IN_GSTControlCodeDesc3></IN_GSTControlCodeDesc3>| &&
                      |<IN_GSTControlCodeDesc4></IN_GSTControlCodeDesc4>| &&
                      |<IN_GSTControlCodeDesc5></IN_GSTControlCodeDesc5>| &&
                      |<IN_HSNOrSACCode></IN_HSNOrSACCode>| &&
                      |<ItemDiscount>0.00</ItemDiscount>| &&
                      |<Material>| && ls_batchdata1-product && |</Material>| &&
                      |<MaterialName></MaterialName>| &&
                      |<Materialisinternalbatchmanaged>true</Materialisinternalbatchmanaged>| &&
                      |<NetAmount>0.00</NetAmount>| &&
                      |<NetAmountLoccurr>0.00</NetAmountLoccurr>| &&
                      |<NetPriceAmount>0.00</NetPriceAmount>| &&
                      |<NetPriceQuantity>1</NetPriceQuantity>| &&
                      |<NetPriceQuantityUnit>TO</NetPriceQuantityUnit>| &&
                      |<NetPriceQuantityUnitTechName>t</NetPriceQuantityUnitTechName>| &&
                      |<NetWeight>0.000</NetWeight>| &&
                      |<OtherCharges>0.00</OtherCharges>| &&
                      |<Plant></Plant>| &&
                      |<PurchaseOrderByCustomer></PurchaseOrderByCustomer>| &&
                      |<Quantity>0.000</Quantity>| &&
                      |<QuantityUnit>TO</QuantityUnit>| &&
                      |<QuantityUnitTechName>t</QuantityUnitTechName>| &&
                      |<ReferenceSDDocument></ReferenceSDDocument>| &&
                      |<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
                      |<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
                      |<RegionOfOrigin></RegionOfOrigin>| &&
                      |<SalesContract></SalesContract>| &&
                      |<SalesContractItem>000000</SalesContractItem>| &&
                      |<SalesDocument></SalesDocument>| &&
                      |<SalesOrderExternalDocId></SalesOrderExternalDocId>| &&
                      |<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
                      |<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
                      |<ServicesRenderedDate>0000-00-00T00:00:00</ServicesRenderedDate>| &&
                      |<SoldProduct></SoldProduct>| &&
                      |<SolutionOrder></SolutionOrder>| &&
                      |<SolutionOrderItem>000000</SolutionOrderItem>| &&
                      |<StatisticalValue></StatisticalValue>| &&
                      |<TaxAmount>0.00</TaxAmount>| &&
                      |<TaxAmountLoccurr>0.00</TaxAmountLoccurr>| &&
                      |<TaxCode></TaxCode>| &&
                      |<TaxRate>.0</TaxRate>| &&
                      |<Timesheetovertimecategory></Timesheetovertimecategory>| &&
                      |<Timesheetovertimecategorytext></Timesheetovertimecategorytext>| &&
                      |<TotalAmountLoccurr>0.00</TotalAmountLoccurr>| &&
                      |<TransactionCurrency></TransactionCurrency>| &&
                      |<Unitprice>0.00</Unitprice>| &&
                      |<WeightUnit>KG</WeightUnit>| &&
                      |<YY1_BEDate_BDI>0000-00-00T00:00:00</YY1_BEDate_BDI>| &&
                      |<YY1_BEDate_BDIF>3</YY1_BEDate_BDIF>| &&
                      |<YY1_BENo_BDI></YY1_BENo_BDI>| &&
                      |<YY1_BENo_BDIF>3</YY1_BENo_BDIF>| &&
                      |<YY1_ContainerNo_BDI></YY1_ContainerNo_BDI>| &&
                      |<YY1_ContainerNo_BDIF>3</YY1_ContainerNo_BDIF>| &&
                      |<YY1_CylinderNo_BDI></YY1_CylinderNo_BDI>| &&
                      |<YY1_CylinderNo_BDIF>3</YY1_CylinderNo_BDIF>| &&
                      |<YY1_ISO_DATA_BDI></YY1_ISO_DATA_BDI>| &&
                      |<YY1_ISO_DATA_BDIF>3</YY1_ISO_DATA_BDIF>| &&
                      |<YY1_MSMEUDYAMNo_BDI></YY1_MSMEUDYAMNo_BDI>| &&
                      |<YY1_MSMEUDYAMNo_BDIF>3</YY1_MSMEUDYAMNo_BDIF>| &&
                      |<YY1_PhoneNo_BDI></YY1_PhoneNo_BDI>| &&
                      |<YY1_PhoneNo_BDIF>3</YY1_PhoneNo_BDIF>| &&
                      |<YY1_Plant_Address_BDI></YY1_Plant_Address_BDI>| &&
                      |<YY1_Plant_Address_BDIF>3</YY1_Plant_Address_BDIF>| &&
                      |<YY1_Plant_CIN_BDI></YY1_Plant_CIN_BDI>| &&
                      |<YY1_Plant_CIN_BDIF>3</YY1_Plant_CIN_BDIF>| &&
                      |<YY1_Plant_Email_BDI></YY1_Plant_Email_BDI>| &&
                      |<YY1_Plant_Email_BDIF>3</YY1_Plant_Email_BDIF>| &&
                      |<YY1_Plant_GST_BDI></YY1_Plant_GST_BDI>| &&
                      |<YY1_Plant_GST_BDIF>3</YY1_Plant_GST_BDIF>| &&
                      |<YY1_Plant_ISO_BDI></YY1_Plant_ISO_BDI>| &&
                      |<YY1_Plant_ISO_BDIF>3</YY1_Plant_ISO_BDIF>| &&
                      |<YY1_Plant_PAN_BDI></YY1_Plant_PAN_BDI>| &&
                      |<YY1_Plant_PAN_BDIF>3</YY1_Plant_PAN_BDIF>| &&
                      |<YY1_Plant_TAN_BDI></YY1_Plant_TAN_BDI>| &&
                      |<YY1_Plant_TAN_BDIF>3</YY1_Plant_TAN_BDIF>| &&
                      |<YY1_SD_PODATE_BDI>0000-00-00T00:00:00</YY1_SD_PODATE_BDI>| &&
                      |<YY1_SD_PODATE_BDIF>3</YY1_SD_PODATE_BDIF>| &&
                      |<ItemBatchDetails>| &&
                      |<ItemBatchDetailsNode>| &&
                      |<Characteristic>ZB_CL2_CYLINDER_TRACK</Characteristic>| &&
                      |<CharacteristicDescription>CHLORINECYLINDERTRACKING</CharacteristicDescription>| &&
                      |<CharacteristicValue></CharacteristicValue>| &&
                      |<CharacteristicValueDescript></CharacteristicValueDescript>| &&
                      |</ItemBatchDetailsNode>| &&
                      |<ItemBatchDetailsNode>| &&
                      |<Characteristic>TAREWEIGHT</Characteristic>| &&
                      |<CharacteristicDescription>Tareweight</CharacteristicDescription>| &&
                      |<CharacteristicValue>0.00</CharacteristicValue>| &&
                      |<CharacteristicValueDescript>0.00</CharacteristicValueDescript>| &&
                      |</ItemBatchDetailsNode>| &&
                      |<ItemBatchDetailsNode>| &&
                      |<Characteristic>GROSSWEIGHT</Characteristic>| &&
                      |<CharacteristicDescription>Grossweight</CharacteristicDescription>| &&
                      |<CharacteristicValue>| && ls_batchdata1-grswt && |</CharacteristicValue>| &&
                      |<CharacteristicValueDescript>| && ls_batchdata1-grswt && |</CharacteristicValueDescript>| &&
                      |</ItemBatchDetailsNode>| &&
                      |<ItemBatchDetailsNode>| &&
                      |<Characteristic>NETWEIGHT</Characteristic>| &&
                      |<CharacteristicDescription>NetWeight</CharacteristicDescription>| &&
                      |<CharacteristicValue>| && ls_batchdata1-netwt && |</CharacteristicValue>| &&
                      |<CharacteristicValueDescript>| && ls_batchdata1-netwt && |</CharacteristicValueDescript>| &&
                      |</ItemBatchDetailsNode>| &&
                      |<ItemBatchDetailsNode>| &&
                      |<Characteristic>ZB_MANUFACTURE_ID</Characteristic>| &&
                      |<CharacteristicDescription>MANUFACTUREID</CharacteristicDescription>| &&
                      |<CharacteristicValue></CharacteristicValue>| &&
                      |<CharacteristicValueDescript></CharacteristicValueDescript>| &&
                      |</ItemBatchDetailsNode>| &&
                      |</ItemBatchDetails>| &&
                      |<ItemConfiguration/>| &&
                      |<ItemPricingConditions>| &&
                      |<ItemPricingConditionNode>| &&
                      |<ConditionAmount>0.00</ConditionAmount>| &&
                      |<ConditionBaseValue>0.000</ConditionBaseValue>| &&
                      |<ConditionBaseValueUnit>TO</ConditionBaseValueUnit>| &&
                      |<ConditionQuantity>1</ConditionQuantity>| &&
                      |<ConditionQuantityUnit>TO</ConditionQuantityUnit>| &&
                      |<ConditionQuantityUnitTechName>t</ConditionQuantityUnitTechName>| &&
                      |<ConditionRateValue>0.00</ConditionRateValue>| &&
                      |<ConditionRateValueUnit>USD</ConditionRateValueUnit>| &&
                      |<ConditionStep>010</ConditionStep>| &&
                      |<ConditionType>ZPRO</ConditionType>| &&
                      |<ConditionTypeName>BasePrice</ConditionTypeName>| &&
                      |<DocumentCurrency></DocumentCurrency>| &&
                      |<VariantCondition></VariantCondition>| &&
                      |</ItemPricingConditionNode>| &&
                      |<ItemPricingConditionNode>| &&
                      |<ConditionAmount>0.00</ConditionAmount>| &&
                      |<ConditionBaseValue>0.000</ConditionBaseValue>| &&
                      |<ConditionBaseValueUnit>TO</ConditionBaseValueUnit>| &&
                      |<ConditionQuantity>1</ConditionQuantity>| &&
                      |<ConditionQuantityUnit>TO</ConditionQuantityUnit>| &&
                      |<ConditionQuantityUnitTechName>t</ConditionQuantityUnitTechName>| &&
                      |<ConditionRateValue>0.00</ConditionRateValue>| &&
                      |<ConditionRateValueUnit>USD</ConditionRateValueUnit>| &&
                      |<ConditionStep>020</ConditionStep>| &&
                      |<ConditionType>ZFRI</ConditionType>| &&
                      |<ConditionTypeName>Freight(PDY)Received</ConditionTypeName>| &&
                      |<DocumentCurrency></DocumentCurrency>| &&
                      |<VariantCondition></VariantCondition>| &&
                      |</ItemPricingConditionNode>| &&
                      |</ItemPricingConditions>| &&
                      |<ItemSerialNUmber/>| &&
                      |<ItemShipToParty>| &&
                      |<AddressID></AddressID>| &&
                      |<AddressLine1Text>Company</AddressLine1Text>| &&
                      |<AddressLine2Text></AddressLine2Text>| &&
                      |<AddressLine3Text></AddressLine3Text>| &&
                      |<AddressLine4Text></AddressLine4Text>| &&
                      |<AddressLine5Text></AddressLine5Text>| &&
                      |<AddressLine6Text></AddressLine6Text>| &&
                      |<AddressLine7Text></AddressLine7Text>| &&
                      |<AddressLine8Text></AddressLine8Text>| &&
                      |<AddressType>1</AddressType>| &&
                      |<FullName></FullName>| &&
                      |<Partner></Partner>| &&
                      |<PartnerFunction>SH</PartnerFunction>| &&
                      |<PartnerFunctionName>ShiptoParty</PartnerFunctionName>| &&
                      |<Person></Person>| &&
                      |</ItemShipToParty>| &&
                      |<ItemTextElements/>| &&
                      |</BillingDocumentItemNode>|                      "#EC CI_NOORDER
                      .

                    ENDLOOP.
                  ENDIF.
                  lv_xml_pcklst = lv_xml_pcklst &&
                  |</Items>| &&
                  |<ItemsAfterCorr/>| &&
                  |<ItemsDifference/>| &&
                  |<LegallyRequiredTexts/>| &&
                  |<OpenDownPayment>| &&
                  |<BillingDocument></BillingDocument>| &&
                  |<DownPaymentGrossAmount>0.00</DownPaymentGrossAmount>| &&
                  |<DownPaymentNetAmount>0.00</DownPaymentNetAmount>| &&
                  |<DownPaymentTaxAmount>0.00</DownPaymentTaxAmount>| &&
                  |</OpenDownPayment>| &&
                  |<PayerParty>| &&
                  |<AddressID></AddressID>| &&
                  |<AddressLine1Text>Company</AddressLine1Text>| &&
                  |<AddressLine2Text></AddressLine2Text>| &&
                  |<AddressLine3Text></AddressLine3Text>| &&
                  |<AddressLine4Text></AddressLine4Text>| &&
                  |<AddressLine5Text></AddressLine5Text>| &&
                  |<AddressLine6Text></AddressLine6Text>| &&
                  |<AddressLine7Text></AddressLine7Text>| &&
                  |<AddressLine8Text></AddressLine8Text>| &&
                  |<AddressType>1</AddressType>| &&
                  |<FullName></FullName>| &&
                  |<Partner></Partner>| &&
                  |<PartnerFunction>PY</PartnerFunction>| &&
                  |<PartnerFunctionName>Payer</PartnerFunctionName>| &&
                  |<Person></Person>| &&
                  |</PayerParty>| &&
                  |<PaymentCard/>| &&
                  |<PaymentMethod>| &&
                  |<PaymentMethod></PaymentMethod>| &&
                  |<PaymentMethodName></PaymentMethodName>| &&
                  |</PaymentMethod>| &&
                  |<PaymentRequest/>| &&
                  |<PaymentTerms>| &&
                  |<PaymentDueDate>0000-00-00T00:00:00</PaymentDueDate>| &&
                  |<PaymentTerm1Description></PaymentTerm1Description>| &&
                  |<PaymentTerm2Description></PaymentTerm2Description>| &&
                  |<PaymentTerm3Description></PaymentTerm3Description>| &&
                  |<PaymentTermsName></PaymentTermsName>| &&
                  |</PaymentTerms>| &&
                  |<PricingConditions/>| &&
                  |<PricingTerms>| &&
                  |<DeliveryDate>0000-00-00T00:00:00</DeliveryDate>| &&
                  |<PricingDate>0000-00-00T00:00:00</PricingDate>| &&
                  |</PricingTerms>| &&
                  |<SEPA>| &&
                  |<BICNumber></BICNumber>| &&
                  |<BankName></BankName>| &&
                  |<IBAN></IBAN>| &&
                  |<PaymentDueDate>0000-00-00T00:00:00</PaymentDueDate>| &&
                  |<SEPAMandate></SEPAMandate>| &&
                  |</SEPA>| &&
                  |<ShipToParty>| &&
                  |<AddressID>| && ls_billhdr-shpaddrid && |</AddressID>| &&
                  |<AddressLine1Text>Company</AddressLine1Text>| &&
                  |<AddressLine2Text>| && ls_shaddress-cust-businesspartnername1 && |</AddressLine2Text>| &&
                  |<AddressLine3Text>| && ls_shaddress-cust-businesspartnername2 && |</AddressLine3Text>| &&
                  |<AddressLine4Text>| && ls_shaddress-cust-streetname && |</AddressLine4Text>| &&
                  |<AddressLine5Text>| && ls_shaddress-addr-streetsuffixname1 && |</AddressLine5Text>| &&
                  |<AddressLine6Text>| && ls_shaddress-cust-postalcode && ' ' && ls_shaddress-cust-bpaddrcityname && |</AddressLine6Text>| &&
                  |<AddressLine7Text>| && ls_shaddress-addr-country && |</AddressLine7Text>| &&
                  |<AddressLine8Text></AddressLine8Text>| &&
                  |<AddressType>1</AddressType>| &&
                  |<City></City>| &&
                  |<Countryname></Countryname>| &&
                  |<FullName>| && ls_shaddress-cust-bpcustomerfullname && |</FullName>| &&
                  |<PanNoCompany></PanNoCompany>| &&
                  |<Partner>| && ls_billhdr-shptoid && |</Partner>| &&
                  |<PartnerFunction>SH</PartnerFunction>| &&
                  |<PartnerFunctionName></PartnerFunctionName>| &&
                  |<Person></Person>| &&
                  |<PostalCode></PostalCode>| &&
                  |<Region>11</Region>| &&
                  |<RegionName>Colombo</RegionName>| &&
                  |<Street></Street>| &&
                  |</ShipToParty>| &&
                  |<SoldToParty>| &&
                  |<AddressID></AddressID>| &&
                  |<AddressLine1Text>Company</AddressLine1Text>| &&
                  |<AddressLine2Text></AddressLine2Text>| &&
                  |<AddressLine3Text></AddressLine3Text>| &&
                  |<AddressLine4Text></AddressLine4Text>| &&
                  |<AddressLine5Text></AddressLine5Text>| &&
                  |<AddressLine6Text></AddressLine6Text>| &&
                  |<AddressLine7Text></AddressLine7Text>| &&
                  |<AddressLine8Text></AddressLine8Text>| &&
                  |<AddressType>1</AddressType>| &&
                  |<FullName></FullName>| &&
                  |<Partner></Partner>| &&
                  |<PartnerFunction>SP</PartnerFunction>| &&
                  |<PartnerFunctionName>Sold-toParty</PartnerFunctionName>| &&
                  |<Person></Person>| &&
                  |</SoldToParty>| &&
                  |<Supplier>| &&
                  |<AddressID></AddressID>| &&
                  |<AddressLine1Text>Company</AddressLine1Text>| &&
                  |<AddressLine2Text></AddressLine2Text>| &&
                  |<AddressLine3Text></AddressLine3Text>| &&
                  |<AddressLine4Text></AddressLine4Text>| &&
                  |<AddressLine5Text></AddressLine5Text>| &&
                  |<AddressLine6Text></AddressLine6Text>| &&
                  |<AddressLine7Text></AddressLine7Text>| &&
                  |<AddressLine8Text></AddressLine8Text>| &&
                  |<AddressType></AddressType>| &&
                  |<CompanyCode></CompanyCode>| &&
                  |<CompanyName></CompanyName>| &&
                  |<Country></Country>| &&
                  |<EmailAddress></EmailAddress>| &&
                  |<FullName></FullName>| &&
                  |<Person></Person>| &&
                  |<PhoneNumber></PhoneNumber>| &&
                  |<Region></Region>| &&
                  |<RegionName></RegionName>| &&
                  |</Supplier>| &&
                  |<TaxationTerms>| &&
                  |<CompanyVATRegistration></CompanyVATRegistration>| &&
                  |<CustomerICNumber></CustomerICNumber>| &&
                  |<CustomerTINNumber></CustomerTINNumber>| &&
                  |<CustomerVATRegistration></CustomerVATRegistration>| &&
                  |<ID_CompanyCodeTIN></ID_CompanyCodeTIN>| &&
                  |<IN_BillToPtyGSTIdnNmbr></IN_BillToPtyGSTIdnNmbr>| &&
                  |<IN_GSTIdentificationNumber></IN_GSTIdentificationNumber>| &&
                  |<IN_ShipToPtyGSTIdnNmbr></IN_ShipToPtyGSTIdnNmbr>| &&
                  |<ShipToPartyProvSlsTaxRegnNmbr></ShipToPartyProvSlsTaxRegnNmbr>| &&
                  |<SupplierICNumber></SupplierICNumber>| &&
                  |<TaxDepartureCountry></TaxDepartureCountry>| &&
                  |<TaxNumber0></TaxNumber0>| &&
                  |<TaxNumber1></TaxNumber1>| &&
                  |<TaxNumber2></TaxNumber2>| &&
                  |<TaxNumber3></TaxNumber3>| &&
                  |<TaxNumber4></TaxNumber4>| &&
                  |<TaxNumber5></TaxNumber5>| &&
                  |<VATRegistrationCountryName></VATRegistrationCountryName>| &&
                  |<VATRegistrationOrigin></VATRegistrationOrigin>| &&
                  |<VATRegistrationOriginName></VATRegistrationOriginName>| &&
                  |</TaxationTerms>| &&
                  |<TextElements/>| &&
                  |<VATSummary/>| &&
                  |</BillingDocumentNode>| &&
                  |</Form>|.

                ENDIF.


**********************************************************************
                DATA(lv_base64_pcklst) = cl_web_http_utility=>encode_base64( unencoded = lv_xml_pcklst ).
                CLEAR : ls_req-xml_data.
                ls_req-xml_data     = lv_base64_pcklst.
**********************************************************************
                TRY.
                    CALL METHOD /ui2/cl_json=>serialize
                      EXPORTING
                        data        = ls_req
                        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                      RECEIVING
                        r_json      = DATA(lv_body2).
                  CATCH cx_root INTO DATA(lx_root2).
                    DATA(lv_err7) = 1.
                ENDTRY.
                lo_request->set_text(  EXPORTING i_text = lv_body2 ).
**********************************************************************
                TRY.
                    DATA(lo_response2) = lo_client->execute(
                    i_method = if_web_http_client=>post
                    i_timeout = 0  ).
                  CATCH cx_web_http_client_error INTO lx_client_error.
                    DATA(lv_err8) = 1.
                ENDTRY.
**********************************************************************
                DATA(lv_respons2) = lo_response2->get_text(  ).
                DATA(ls_stas2) = lo_response2->get_status(  ).
**********************************************************************
                CLEAR : ls_response2.
                TRY.
                    CALL METHOD /ui2/cl_json=>deserialize
                      EXPORTING
                        json          = lv_respons2
                        assoc_arrays  = abap_true
                        name_mappings = VALUE #( ( json = 'filecontent' abap = 'FILECONTENT' ) )
                      CHANGING
                        data          = ls_response2.
                  CATCH cx_root INTO lx_root.
                    DATA(lv_err9) = 1.
                ENDTRY.
**********************************************************************
                DATA(lv_basecode_pcklst) = ls_response2-filecontent.

************************************************************************
*      """ HTTP Communication via URL   """
                TRY.
                    lo_httpreqst->set_text( '{    "AuthorizedSignatory": "Chemfab",'
                               && '    "SignerName": "AG",'
                               && '    "TopLeft": 0,'
                && '    "BottomLeft": 0,'
                && '    "TopRight": 0,'
                && '    "BottomRight": 0,'
                && '    "ExcludePageNo": "",'
                && '    "InvoiceNumber": "818",'
                && '    "pageNo": -1,'
                && '    "PrintDateTime": "",'
                && '    "FindAuth": "Authori",'
                && '    "FindAuthLocation": 0,'
                && '    "fontsize": 24,'
                && '    "adjustCoordinates": 0,'
                && '    "signOnlySearchTextPage": 1,'
                && '    "pdfByte1": "'
                && lv_basecode_pcklst
                &&  '" }'     ).
                    " execute HTTP POST-request and store response
                    lo_http_response = lo_http_client->execute( if_web_http_client=>post ).
                    DATA(ls_status_pcklst) = lo_http_response->get_status(  ).

                    lv_packlist = lo_http_response->get_text(  ).
                  CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error4).
                    DATA(lv_5) = 5.
                ENDTRY.
**********************************************************************
                IF lv_packlist IS NOT INITIAL.
                  CLEAR ls_dscresponse.
                  TRY.
                      CALL METHOD /ui2/cl_json=>deserialize
                        EXPORTING
                          json          = lv_packlist
                          assoc_arrays  = abap_true
                          name_mappings = VALUE #( ( json = 'file' abap = 'FILECONTENT' ) )
                        CHANGING
                          data          = ls_dscresponse.
                    CATCH cx_root INTO lx_root.
                      lv_err1 = 1.
                  ENDTRY.
**********************************************************************
                  DATA(lv_print_data_pcklst) = cl_web_http_utility=>decode_x_base64( encoded = ls_dscresponse-filecontent  ).
                  DATA(lv_qitem_id_pcklst)  = cl_print_queue_utils=>create_queue_itemid(  ).
**********************************************************************

                  zbp_sd_app09_dmrv=>gs_print_data_tc = lv_print_data_pcklst .
                  zbp_sd_app09_dmrv=>gs_pqitem_id_tc = lv_qitem_id_pcklst.
                  zbp_sd_app09_dmrv=>gv_tag_tc = '_PL'.


                ENDIF.
              ENDIF.
            ENDIF.

**********************************************************************
            APPEND VALUE #( %tky = ls_billhdr-%tky
            %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                                    text = 'Printed Successfully' )
                                     ) TO reported-header.
          ELSE.
            APPEND VALUE #( %tky = ls_billhdr-%tky ) TO failed-header.
            APPEND VALUE #( %tky = ls_billhdr-%tky
            %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text = 'Not Printed' )
                                     ) TO reported-header.

          ENDIF.
        ENDIF.
******************************* User not Authorized ***************************************
      ELSE.
        APPEND VALUE #( %tky = ls_billhdr-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_billhdr-%tky
        %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text = 'User Authorization not maintained' )
                                 ) TO reported-header.
      ENDIF.
    ENDIF.

**********************************************************************
    result = VALUE #( FOR ls_ord IN lt_billhdr
                         ( %tky   = ls_ord-%tky
                           %param = ls_ord ) ).

  ENDMETHOD.

  METHOD Email.
****************************************************************************
*****------Automatic Email Triger Part-----Start Process

            READ ENTITIES OF zsd_app09_dmrv IN LOCAL MODE
            ENTITY Header
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(gt_emailhd)
            FAILED DATA(gt_failedem).
****************************************************************************
            data(gs_emailhd) = gt_emailhd[ 1 ].
            data(lv_filename) = |Invoice :{ gs_emailhd-billdoc }|.
            data: lv_sender type c LENGTH 512,
                  lv_recemail type c length 512,
                  lv_reciever type c length 512.
            data: gt_email type table of ZSD_DSC_FILE_DB,
                  gs_email TYPE ZSD_DSC_FILE_DB.
****************************************************************************
******---Email Validation----***********************************************
            select AddressID,AddressPersonID,EmailAddress
            from ZI_CUST_ADDR1 wiTH PRIVILEGED ACCESS
            where AddressID = @gs_emailhd-Pyraddrid
            and EmailAddress is not iNITIAL
            into table @dATA(lt_email).

if lt_email is not INITIAL.

    "-----------------------------------------------------------
    " Add body Content
    "-----------------------------------------------------------
    data(lv_date) = |{ gs_emailhd-billdate+6(2) }-{ SWITCH string( gs_emailhd-billdate+4(2)
                            WHEN '01' THEN 'Jan'
                            WHEN '02' THEN 'Feb'
                            WHEN '03' THEN 'Mar'
                            WHEN '04' THEN 'Apr'
                            WHEN '05' THEN 'May'
                            WHEN '06' THEN 'Jun'
                            WHEN '07' THEN 'Jul'
                            WHEN '08' THEN 'Aug'
                            WHEN '09' THEN 'Sep'
                            WHEN '10' THEN 'Oct'
                            WHEN '11' THEN 'Nov'
                            WHEN '12' THEN 'Dec' ) }-{ gs_emailhd-billdate(4) }|.
    data(lv_text) = 'This is an automated email from the SAP system. Please find attached the invoice details for your reference.'.
    data(lv_invre) = |•   Invoice Number: { gs_emailhd-refdoc } |.
    data(lv_invdate) = |•   Invoice Date: { lv_date } |.
    data(lv_text2) = 'Kindly ensure timely payment as per the agreed terms.'.
    data(lv_text3) = 'This is a system-generated email. Please do not reply to this message.'.
    data ccname tYPE c LENGTH 100.
    if ( gs_emailhd-ccode = '1000' or gs_emailhd-ccode = '3000' ).
    ccname = 'Chemfab Alkalis Limited'.
    elseif gs_emailhd-ccode = '2000'.
    ccname = 'Chemfab Alkalis Karaikal Limited'.
    endif.

    DATA : iv_content      TYPE string .
    data(iv_content1) = |<p>Dear { gs_emailhd-customertxt }</p><p></p><p>{ lv_text }</p><p></p><p><b>Invoice Details :</b></p><p></p><b>{ lv_invre }</b>|.
    data(iv_content2) = | <p></p><b>{ lv_invdate }</b><p></p><p>{ lv_text2 }</p><p></p><p>{ lv_text3 }</p><p></p><p>Best Regards,</p><p>{ ccname }</p>|.
    iv_content = iv_content1 && iv_content2 .
    "-----------------------------------------------------------
    " Add Sender Mail
    "-----------------------------------------------------------
    lv_sender = 'SAPAutomail@ccal.in'.
*                lv_reciever = gs_emailhd-EmailAddress.
*    lv_reciever = ''.
*    data: lt_receivers TYPE STANDARD TABLE OF string.
*    SPLIT lv_reciever AT ';' INTO TABLE lt_receivers.

    "-----------------------------------------------------------
    " Add Sender Mail
    "-----------------------------------------------------------
    try.
    data(lo_mail) = cl_bcs_mail_message=>create_instance(  ).
    lo_mail->set_sender( lv_sender ).
    lo_mail->set_subject( 'Invoice' ) .
    "-----------------------------------------------------------
    "Add multiple recipients
    "-----------------------------------------------------------
    LOOP AT lt_email INTO DATA(lv_email).
    CONDENSE lv_email-EmailAddress NO-GAPS.
    IF lv_email-EmailAddress IS NOT INITIAL.
    lv_recemail = lv_email-EmailAddress.
    lo_mail->add_recipient( lv_recemail ).
    ENDIF.
    ENDLOOP.

    "-----------------------------------------------------------
    " Add HTML body
    "-----------------------------------------------------------
    lo_mail->set_main(
        cl_bcs_mail_textpart=>create_instance(
            iv_content      = iv_content
            iv_content_type = 'text/html'
        )
    ).
    "---------------------------------------------------------------
    " Add PDF attachment from Base64
    "---------------------------------------------------------------
    lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
*                            iv_content = lv_print_data   " PDF Base64 from ADS
                            iv_content = gs_emailhd-attachment   " PDF Base64 from ADS
                            iv_content_type = 'application/pdf'
                            iv_filename     = 'Invoice.pdf' ) ).
    "-----------------------------------------------------------
    " Send Email & Capture Status
    "-----------------------------------------------------------
    lo_mail->send(
        IMPORTING et_status = DATA(lt_status)
    ).
    "--------------------------------------------------
    " Validate Send Status
    "--------------------------------------------------
    data(wa_em) = lt_status[ 1 ].
            if wa_em-status = 'S'.
              gs_email-billdoc = gs_emailhd-billdoc.
              gs_email-attachment = gs_emailhd-attachment.
              gs_email-mimetype = 'application/pdf'.
              gs_email-filename = lv_filename.
              gs_email-emailstatus = 'X'.
              gs_email-dscstatus = 'X'.
              APPEND gs_email TO gt_email.
              zbp_sd_app09_dmrv=>up_email = gt_email.
            endif.


        CATCH cx_bcs_mail INTO data(lx_mail1).
            data(lv_cxemail) = 1.
          " TODO: log failure
      ENDTRY.

ELSE.
      APPEND VALUE #( %tky = gs_emailhd-%tky ) TO failed-header.
      APPEND VALUE #( %tky = gs_emailhd-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'Maintain the Email in Customer Master Level' )
                               ) TO reported-header.

ENDIF.
**********************************************************************
    result = VALUE #( FOR ls_emailhd IN gt_emailhd
                         ( %tky   = ls_emailhd-%tky
                           %param = ls_emailhd ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsd_app09_dmrv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsd_app09_dmrv IMPLEMENTATION.

  METHOD save_modified.
**********************************************************************
**************************** Original Copy Print *********************
    IF zbp_sd_app09_dmrv=>gs_print_data_oc IS NOT INITIAL.
      DATA : lv_name TYPE c LENGTH 120.
      lv_name = zbp_sd_app09_dmrv=>gv_invnum.
      cl_print_queue_utils=>create_queue_item_by_data(
        EXPORTING
          iv_qname            = zbp_sd_app09_dmrv=>gv_printq
          iv_print_data       =  zbp_sd_app09_dmrv=>gs_print_data_oc
          iv_name_of_main_doc =  lv_name
          iv_itemid           = zbp_sd_app09_dmrv=>gs_pqitem_id_oc
        IMPORTING
          ev_err_msg          = DATA(gs_error_msg1)
      ).
    ENDIF.
***************************** Duplicate Copy Print *********************
    IF zbp_sd_app09_dmrv=>gs_print_data_dc IS NOT INITIAL.
      cl_print_queue_utils=>create_queue_item_by_data(
        EXPORTING
          iv_qname            = zbp_sd_app09_dmrv=>gv_printq
          iv_print_data       =  zbp_sd_app09_dmrv=>gs_print_data_dc
          iv_name_of_main_doc =  zbp_sd_app09_dmrv=>gv_invnum && '_EX'
          iv_itemid           = zbp_sd_app09_dmrv=>gs_pqitem_id_dc
        IMPORTING
          ev_err_msg          = DATA(gs_error_msg2)
      ).
    ENDIF.
****************************** Packing List Print *********************
    IF zbp_sd_app09_dmrv=>gs_print_data_tc IS NOT INITIAL.
      cl_print_queue_utils=>create_queue_item_by_data(
        EXPORTING
          iv_qname            = zbp_sd_app09_dmrv=>gv_printq
          iv_print_data       =  zbp_sd_app09_dmrv=>gs_print_data_tc
          iv_name_of_main_doc =  zbp_sd_app09_dmrv=>gv_invnum && '_PL'
          iv_itemid           = zbp_sd_app09_dmrv=>gs_pqitem_id_tc
        IMPORTING
          ev_err_msg          = DATA(gs_error_msg3)
      ).
    ENDIF.
****************************** Attachment File Output *********************
        if zbp_sd_app09_dmrv=>up_attach is not initial.
            modify ZSD_DSC_FILE_DB from table @zbp_sd_app09_dmrv=>up_attach.
        endif.
****************************** Email Sent Status *********************
        if zbp_sd_app09_dmrv=>up_email is not initial.
            modify ZSD_DSC_FILE_DB from table @zbp_sd_app09_dmrv=>up_email.
        endif.

  ENDMETHOD.
**********************************************************************
  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
