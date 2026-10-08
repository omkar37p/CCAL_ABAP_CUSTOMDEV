CLASS lhc_zmm_app18_rv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zmm_app18_rv RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_app18_rv RESULT result.

    METHODS document FOR MODIFY
      IMPORTING keys FOR ACTION zmm_app18_rv~document RESULT result.

ENDCLASS.

CLASS lhc_zmm_app18_rv IMPLEMENTATION.

METHOD get_instance_features.
**********************************************************************
***this Action is working if the purchase order status completed
***the E-sign Button it automatically enable other wise disable
**********************************************************************
        READ ENTITIES OF zmm_app18_rv IN LOCAL MODE
        ENTITY zmm_app18_rv
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(postatus).

        DATA(ls_postatus) = postatus[ 1 ].

**********************************************************************
        result = VALUE #( for ls_key in keys
                        (    %tky = ls_key-%tky

                          %action = VALUE #( Document = COND #( WHEN ls_postatus-Purchasestatus = 'COMPLETED'
                                                THEN if_abap_behv=>fc-o-enabled
                                                ELSE if_abap_behv=>fc-o-disabled ) )
                          ) ) .
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD document.

**********************************************************************
    DATA : lv_gpdf_url TYPE string.
    DATA : lv_copytyp           TYPE string,
           lv_formb64           TYPE xstring,
           lv_dscb64            TYPE string,
           ls_req               TYPE zmm_app17_str1,
           ls_dscresponse       TYPE zmm_app17_str2,
           ls_qrresponse        TYPE zmm_app17_str2,
           ls_response          TYPE zmm_app17_str2,
           ls_response2         TYPE zmm_app17_str2,
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
****Get data from Custom Application PO header & Item

    READ ENTITIES OF zmm_app18_rv IN LOCAL MODE
    ENTITY zmm_app18_rv
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_pohead)
    ENTITY zmm_app18_rv BY \_item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_poitem).

    DATA(ls_pohead) = lt_pohead[ 1 ].

    zbp_mm_app18_rv=>gv_ponum = ls_pohead-purchaseorder.

**********************************************************************
      try.
        data(system_url) = cl_abap_context_info=>get_system_url(  ).
        CATCH cx_abap_context_info_error.
        data(ls_systemerror) = 1.
        ENDTRY.

**********************************************************************
***Purchase order Custom Pricing Condition Type Values
    SELECT * FROM zmm_app18_contype WITH PRIVILEGED ACCESS
            WHERE purchaseorder = @ls_pohead-purchaseorder
            INTO TABLE @DATA(lt_pocontype).

    SORT lt_pocontype BY purchaseorderitem ASCENDING.

***********************************************************************
******************************* User Validations **********************

    TRY.
        DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
      CATCH cx_abap_context_info_error.
        DATA(ls_x1) = 1.
    ENDTRY.
    DATA(lv_cbuser) = 'CB' && lv_user.

    SELECT SINGLE * FROM zmm_app18_b_tb1 WHERE userid = @lv_cbuser
                                       AND ccode = @ls_pohead-companycode
                                       AND cplant = @ls_pohead-plant
    INTO @DATA(ls_authsign).

***********************************************************************
***********************************************************************
        if sy-subrc = 0 AND not ls_authsign is INITIAL.
    "  static link
*        lv_dsc_url = |https://esign.chemfabalkalis.com:820/RESTAPI/SignPDF_Base64String|.
    lv_dsc_url = |https://esign.chemfabalkalis.com:810/Sandbox_RESTAPI/SignPDF_Base64String|.

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

    TRY.

        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
        comm_scenario = 'ZADS_CS'
        comm_system_id = 'ZADS'
        service_id = 'ZADS_OUT_REST'      ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_error).
*                    lv_err1 = 1.
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
    ls_req-xdp_template = 'ZDSC_PO1/ZPURCHASE' .   " 'ZPNDYFGINV/ZPFITEMP'.
    ls_req-form_type    = 'print'.
    ls_req-form_locale  = 'en_US'.
    ls_req-tagged_pdf = 1.
    ls_req-embed_font = 0.
    ls_req-change_not_allowed = abap_false.
    ls_req-print_not_allowed = abap_false.

**********************************************************************
*****get the Purchase Order Header text node from API Call

    DATA: lv_request_string TYPE string,
          lo_hhtp_response  TYPE REF TO if_web_http_response.
    DATA: lo_http_destination1 TYPE REF TO if_http_destination,
          lo_http_client1      TYPE REF TO if_web_http_client,
          lv_response1         TYPE string.
**********************************************************************
    lv_request_string = |https://my414007-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PURCHASEORDER_PROCESS_SRV/A_PurchaseOrder('{ ls_pohead-purchaseorder }')/to_PurchaseOrderNote|.

**********************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination1 = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client1 = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination1 ).
        " adding Header fields
        lo_http_client1->get_http_request(  )->set_header_fields( VALUE #( ( name = if_web_http_header=>authorization value = 'Basic Q1BNX0NPTV9VU0VSUzpmMmQrI1lFJm9HNG9ibmV0RmNEWH1kJGV6fVRcL3stJSlBJHdQbnpH' )
                                                                           ( name = if_web_http_header=>accept      value = if_web_http_header=>accept_application_json  ) ) ).

        " execute HTTP POST-request and store response


        lo_hhtp_response = lo_http_client1->execute( if_web_http_client=>get ).

        DATA(ls_status1) = lo_hhtp_response->get_status(  ).

        lv_response1 = lo_hhtp_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error12).
        DATA(lv_12) = 2.
    ENDTRY.

**********************************************************************
* Define the nested types to match the JSON structure
    TYPES: BEGIN OF ty_purchaseorder_note,
             purchaseorder  TYPE c LENGTH 10,   "e.g. 4500000493
             textobjecttype TYPE c LENGTH 3,    "e.g. F01, F05, F07, F22
             language       TYPE c LENGTH 2,    "e.g. EN
             plainlongtext  TYPE string,        "Note text
           END OF ty_purchaseorder_note.

    TYPES tt_purchaseorder_note TYPE STANDARD TABLE OF ty_purchaseorder_note WITH DEFAULT KEY.

* Define the intermediate structure for the "d" key
    TYPES: BEGIN OF ty_results,
             results TYPE tt_purchaseorder_note, " This must be a table type
           END OF ty_results.

* Define the root structure for the entire JSON payload
    TYPES: BEGIN OF ty_root,
             d TYPE ty_results,
           END OF ty_root.

* Declare variables
    DATA: lv_json TYPE string,
          ls_root TYPE ty_root.

* Assign your JSON string here
    lv_json = lv_response1.

* Deserialize the JSON into the root structure
    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING
            json         = lv_json
            pretty_name  = /ui2/cl_json=>pretty_mode-camel_case " Auto-converts names
            assoc_arrays = abap_true
          CHANGING
            data         = ls_root
        ).
        " You can now access the internal table via ls_root-d-results
        DATA(lt_poheadtext) = ls_root-d-results.


      CATCH cx_root INTO DATA(lx).
        DATA(lv_err1) = 1.

    ENDTRY.

**********************************************************************
***** Generate the Own XML File
    DATA(postal) = |{ ls_pohead-postalcode } { ls_pohead-cityname }|.
    DATA(system_lan) = sy-langu.

    DATA(lv_xml_dsign) = |<?xml version="1.0" encoding="utf-8"?>| &&
                            |<Form xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/">| &&
    |<PurchaseOrderNode>| &&
    |<AddressLine1></AddressLine1>| &&
    |<AddressLine2></AddressLine2>| &&
    |<AddressLine3></AddressLine3>| &&
    |<AddressLine4></AddressLine4>| &&
    |<AddressLine5></AddressLine5>| &&
    |<AddressLine6></AddressLine6>| &&
    |<AddressLine7></AddressLine7>| &&
    |<AddressLine8></AddressLine8>| &&
    |<CashDiscount1Days></CashDiscount1Days>| &&
    |<CashDiscount1Percent></CashDiscount1Percent>| &&
    |<CashDiscount2Days></CashDiscount2Days>| &&
    |<CashDiscount2Percent></CashDiscount2Percent>| &&
    |<CompanyCode>| && ls_pohead-companycode && |</CompanyCode>| &&
    |<CompanyCodeAddressID></CompanyCodeAddressID>| &&
    |<CompanyCodeCountry></CompanyCodeCountry>| &&
    |<CorrespncExternalReference></CorrespncExternalReference>| &&
    |<CorrespncInternalReference></CorrespncInternalReference>| &&
    |<CountryRegOfSalesTaxIDNumber></CountryRegOfSalesTaxIDNumber>| &&
    |<CreatedByUser>| && ls_pohead-createdbyuser && |</CreatedByUser>| &&
    |<CreatedByUserName>| && ls_pohead-personfullname && |</CreatedByUserName>| &&
    |<Currency>| && ls_pohead-documentcurrency && |</Currency>| &&
    |<CurrencyText></CurrencyText>| &&
    |<ExchangeRate>| && ls_pohead-exchangerate && |</ExchangeRate>| &&
    |<IncotermsClassification>| && ls_pohead-incotermsclassification && |</IncotermsClassification>| &&
    |<IncotermsClassificationName>| && ls_pohead-pricebasic && |</IncotermsClassificationName>| &&
    |<IncotermsLocation1>| && ls_pohead-freightterms && |</IncotermsLocation1>| &&
    |<IncotermsLocation2></IncotermsLocation2>| &&
    |<IncotermsTransferLcation></IncotermsTransferLcation>| &&
    |<IncotermsVersion></IncotermsVersion>| &&
    |<IncotermsVersionName></IncotermsVersionName>| &&
    |<IsDraftPreview></IsDraftPreview>| &&
    |<IsHierarchyPresent></IsHierarchyPresent>| &&
    |<IsIntrastatReportingExcluded></IsIntrastatReportingExcluded>| &&
    |<IsIntrastatReportingRelevant></IsIntrastatReportingRelevant>| &&
    |<IsItemPresent></IsItemPresent>| &&
    |<IsLimitItemPresent></IsLimitItemPresent>| &&
    |<Language>| && system_lan && |</Language>| &&
    |<NetAmountIsToBePrinted></NetAmountIsToBePrinted>| &&
    |<NetPaymentDays>0</NetPaymentDays>| &&
    |<Outputtypeidentifier></Outputtypeidentifier>| &&
    |<PaymentTerms>| && ls_pohead-paymenttermscode && |</PaymentTerms>| &&
    |<PaymentTermsName>| && ls_pohead-paymenttermsdescription && |</PaymentTermsName>| &&
    |<PricingProcedure></PricingProcedure>| &&
    |<PurchaseOrder>| && ls_pohead-purchaseorder && |</PurchaseOrder>| &&
    |<PurchaseOrderChangeFlag></PurchaseOrderChangeFlag>| &&
    |<PurchaseOrderDate>| && ls_pohead-purchaseorderdate && |</PurchaseOrderDate>| &&
    |<PurchaseOrderNetAmount></PurchaseOrderNetAmount>| &&
    |<PurchasingDocumentCondition></PurchasingDocumentCondition>| &&
    |<PurchasingGroup></PurchasingGroup>| &&
    |<Supplier>| && ls_pohead-vendorcode && |</Supplier>| &&
    |<SupplierPhoneNumber></SupplierPhoneNumber>| &&
    |<SupplierRespSalesPersonName></SupplierRespSalesPersonName>| &&
    |<VATRegistrationNumber>IN123456789</VATRegistrationNumber>| &&
    |<YY1_APPROVEDBY_PO_PDH>| && ls_pohead-poapprovedby && |</YY1_APPROVEDBY_PO_PDH>| &&
    |<YY1_APPROVEDBY_PO_PDHF>3</YY1_APPROVEDBY_PO_PDHF>| &&
    |<YY1_DestinationPlace_PDH>| && ls_pohead-destinationplace && |</YY1_DestinationPlace_PDH>| &&
    |<YY1_DestinationPlace_PDHF>3</YY1_DestinationPlace_PDHF>| &&
    |<YY1_GRNNUMBER_PDH></YY1_GRNNUMBER_PDH>| &&
    |<YY1_GRNNUMBER_PDHF>3</YY1_GRNNUMBER_PDHF>| &&
    |<YY1_GRN_DATE_PDH>0000-00-00T00:00:00</YY1_GRN_DATE_PDH>| &&
    |<YY1_GRN_DATE_PDHF>3</YY1_GRN_DATE_PDHF>| &&
    |<YY1_PODocType_PDH>NB</YY1_PODocType_PDH>| &&
    |<YY1_PODocType_PDHF>3</YY1_PODocType_PDHF>| &&
    |<YY1_PO_DATE_PDH>0000-00-00T00:00:00</YY1_PO_DATE_PDH>| &&
    |<YY1_PO_DATE_PDHF>3</YY1_PO_DATE_PDHF>| &&
    |<YY1_PO_NUMBER_PDH></YY1_PO_NUMBER_PDH>| &&
    |<YY1_PO_NUMBER_PDHF>3</YY1_PO_NUMBER_PDHF>| &&
    |<YY1_ZDELIVERY_DATE_PDH>| && ls_pohead-cusdeliverydate && |</YY1_ZDELIVERY_DATE_PDH>| &&
    |<YY1_ZDELIVERY_DATE_PDHF>3</YY1_ZDELIVERY_DATE_PDHF>| &&
    |<InvoicingPartyNode>| &&
    |<AddressLine1></AddressLine1>| &&
    |<AddressLine2></AddressLine2>| &&
    |<AddressLine3></AddressLine3>| &&
    |<AddressLine4></AddressLine4>| &&
    |<AddressLine5></AddressLine5>| &&
    |<AddressLine6></AddressLine6>| &&
    |<AddressLine7></AddressLine7>| &&
    |<AddressLine8></AddressLine8>| &&
    |<IN_GSTIdentificationNumber></IN_GSTIdentificationNumber>| &&
    |<Supplier></Supplier>| &&
    |<SupplierAddressID></SupplierAddressID>| &&
    |<SupplierName></SupplierName>| &&
    |<VatRegistration></VatRegistration>| &&
    |</InvoicingPartyNode>| &&
        |<OrderingAddress>| &&
            |<AddressLine1>Company</AddressLine1>| &&
            |<AddressLine2>BATTENFELD-CINCINNATI</AddressLine2>| &&
            |<AddressLine3>AUSTRIA GMBH,LAXENBURGER STRASSE 246</AddressLine3>| &&
            |<AddressLine4>1230 VIENNA</AddressLine4>| &&
            |<AddressLine5>9999 VIENNA</AddressLine5>| &&
            |<AddressLine6>AUSTRIA</AddressLine6>| &&
            |<AddressLine7></AddressLine7>| &&
            |<AddressLine8></AddressLine8>| &&
            |<EmailAddress></EmailAddress>| &&
            |<Fax></Fax>| &&
            |<PartnerName>BATTENFELD-CINCINNATI</PartnerName>| &&
            |<PartnerNumber>0140000010</PartnerNumber>| &&
            |<TelephoneNumber></TelephoneNumber>| &&
        |</OrderingAddress>| &&
    |<PurchaseOrderChanges/>| &&
    |<PurchaseOrderHeaderSTTextsSet>| &&
    |<PurchaseOrderHeaderSTTexts>| &&
    |<Language>EN</Language>| &&
    |<PurchaseOrder>4500000490</PurchaseOrder>| &&
    |<PurchaseOrderHeaderSTTextElement></PurchaseOrderHeaderSTTextElement>| &&
    |<PurchaseOrderHeaderSTTextID>ST</PurchaseOrderHeaderSTTextID>| &&
    |<PurchaseOrderHeaderSTTextIDDesc></PurchaseOrderHeaderSTTextIDDesc>| &&
    |<PurchasingDocumentType>NB</PurchasingDocumentType>| &&
    |<PurgOutputOperationCode>1</PurgOutputOperationCode>| &&
    |<PurgTextPrintSequenceValue>21</PurgTextPrintSequenceValue>| &&
    |<TextObjectCategory>TEXT</TextObjectCategory>| &&
    |<TextObjectKey>ZPAYEMENT_TERMS</TextObjectKey>| &&
    |</PurchaseOrderHeaderSTTexts>| &&
    |</PurchaseOrderHeaderSTTextsSet>| &&
*    |<PurchaseOrderHeaderTextsSet/>| &&

        |<PurchaseOrderHeaderTextsSet>|.
            if lt_poheadtext is not INITIAL.
            data(ls_count) = 1.
            LOOP AT lt_poheadtext INTO DATA(ls_poheadtext).
            lv_xml_dsign = lv_xml_dsign &&
            |<PurchaseOrderHeaderTexts>| &&
                |<Language>| && ls_poheadtext-language && |</Language>| &&
                |<PurchaseOrder>| && ls_poheadtext-purchaseorder && |</PurchaseOrder>| &&
                |<PurchaseOrderHeaderTextElement>| && ls_poheadtext-plainlongtext && |</PurchaseOrderHeaderTextElement>| &&
                |<PurchaseOrderHeaderTextID>| && ls_poheadtext-textobjecttype && |</PurchaseOrderHeaderTextID>| &&
                |<PurchaseOrderHeaderTextName></PurchaseOrderHeaderTextName>| &&
            |</PurchaseOrderHeaderTexts>|.
            ls_count += 1.
            ENDLOOP.
            endif.
        lv_xml_dsign = lv_xml_dsign &&
        |</PurchaseOrderHeaderTextsSet>| &&
      |<PurchaseHierOrderItems/>| &&
            |<PurchaseOrderItems>|.
    IF lt_poitem IS NOT INITIAL.
      DATA(lv_count) = 1.
      LOOP AT lt_poitem INTO DATA(ls_poitem).
        lv_xml_dsign = lv_xml_dsign &&
    |<PurchaseOrderItemNode>| &&
    |<AcknowledgmentNumber></AcknowledgmentNumber>| &&
    |<AddressLine1>Company</AddressLine1>| &&
    |<AddressLine2>CHEMFAB ALKALIS LIMITED</AddressLine2>| &&
    |<AddressLine3>CAUSTIC SODA DIVISION PDY</AddressLine3>| &&
    |<AddressLine4>GNANANANDA PLACE</AddressLine4>| &&
    |<AddressLine5>KALAPET</AddressLine5>| &&
    |<AddressLine6>GST:34AADCT1820F1ZT</AddressLine6>| &&
    |<AddressLine7>605014 PUDUCHERRY</AddressLine7>| &&
    |<AddressLine8>INDIA</AddressLine8>| &&
    |<BaseUnit></BaseUnit>| &&
    |<BaseUnitTechName></BaseUnitTechName>| &&
    |<CommodityCode></CommodityCode>| &&
    |<ConfirmedQuantity>0</ConfirmedQuantity>| &&
    |<Currency>INR</Currency>| &&
    |<CurrencyText>Indian Rupee</CurrencyText>| &&
    |<ExpectedOverallLimitAmount>0.00</ExpectedOverallLimitAmount>| &&
    |<FirstDeliveryDate>| && ls_poitem-PurgDocPriceDate && |</FirstDeliveryDate>| &&
    |<GoodsReceivedQuantity>0</GoodsReceivedQuantity>| &&
    |<HierarchyNumber></HierarchyNumber>| &&
    |<IN_HSNOrSACCode>| && ls_poitem-hsn && |</IN_HSNOrSACCode>| &&
    |<IncotermsClassification></IncotermsClassification>| &&
    |<IncotermsClassificationName></IncotermsClassificationName>| &&
    |<IncotermsLocation1></IncotermsLocation1>| &&
    |<IncotermsLocation2></IncotermsLocation2>| &&
    |<IncotermsVersion></IncotermsVersion>| &&
    |<IncotermsVersionName></IncotermsVersionName>| &&
    |<InternationalArticleNumber></InternationalArticleNumber>| &&
    |<IntrastatServiceCode></IntrastatServiceCode>| &&
    |<IsAckRequired>false</IsAckRequired>| &&
    |<IsCompletelyDelivered></IsCompletelyDelivered>| &&
    |<IsDeleted>| && ls_poitem-isdeleate && |</IsDeleted>| &&
    |<IsReturnsItem></IsReturnsItem>| &&
    |<ItemDeliveryAddressID>25</ItemDeliveryAddressID>| &&
    |<ManufacturerMaterial>10000011</ManufacturerMaterial>| &&
    |<Material>| && |{  ls_poitem-material ALPHA = OUT }| && |</Material>| &&
    |<MaterialGroup>| && ls_poitem-materialgroup && |</MaterialGroup>| &&
    |<OrdPriceUnitToOrderUnitDnmntr>1</OrdPriceUnitToOrderUnitDnmntr>| &&
    |<OrderItemQtyToBaseQtyDnmntr>1</OrderItemQtyToBaseQtyDnmntr>| &&
    |<OrderItemQtyToBaseQtyNmrtr>1</OrderItemQtyToBaseQtyNmrtr>| &&
    |<OrderPriceUnitToOrderUnitNmrtr>1</OrderPriceUnitToOrderUnitNmrtr>| &&
    |<PerformancePeriodEndDate>0000-00-00T00:00:00</PerformancePeriodEndDate>| &&
    |<PerformancePeriodStartDate>0000-00-00T00:00:00</PerformancePeriodStartDate>| &&
    |<Plant>| && ls_poitem-plant && |</Plant>| &&
    |<PriceIsToBePrinted>X</PriceIsToBePrinted>| &&
    |<ProductType>1</ProductType>| &&
    |<PurchaseOrder>| && ls_poitem-purchaseorder && |</PurchaseOrder>| &&
    |<PurchaseOrderItem>| && ls_poitem-purchaseorderitem && |</PurchaseOrderItem>| &&
    |<PurchaseOrderItemCategory>0</PurchaseOrderItemCategory>| &&
    |<PurchaseOrderItemNetAmount>89600.00</PurchaseOrderItemNetAmount>| &&
    |<PurchaseOrderNetPriceAmount>8960.00</PurchaseOrderNetPriceAmount>| &&
    |<PurchaseOrderNetPriceQuantity>1</PurchaseOrderNetPriceQuantity>| &&
    |<PurchaseOrderPriceUnit>FT3</PurchaseOrderPriceUnit>| &&
    |<PurchaseOrderPriceUnitTechName>ft3</PurchaseOrderPriceUnitTechName>| &&
    |<PurchaseOrderPriceUnitText>Cubic foot</PurchaseOrderPriceUnitText>| &&
    |<PurchaseOrderQty>| && ls_poitem-orderquantity && |</PurchaseOrderQty>| &&
    |<PurchaseOrderQuantityUnit>| && ls_poitem-orderpriceunit && |</PurchaseOrderQuantityUnit>| &&
    |<PurchaseOrderQuantityUnitTechName>ft3</PurchaseOrderQuantityUnitTechName>| &&
    |<PurchaseOrderQuantityUnitText>Cubic foot</PurchaseOrderQuantityUnitText>| &&
    |<PurchaseOutlineAgreement></PurchaseOutlineAgreement>| &&
    |<PurchaseOutlineAgreementItem>00000</PurchaseOutlineAgreementItem>| &&
    |<PurchasingDocumentItemText>| && ls_poitem-purchaseorderitemtext && |</PurchasingDocumentItemText>| &&
    |<PurchasingInfoRecord></PurchasingInfoRecord>| &&
    |<RevisionLevel></RevisionLevel>| &&
    |<ScheduledQuantity>10</ScheduledQuantity>| &&
    |<ServicePerformer></ServicePerformer>| &&
    |<ServicePerformerName></ServicePerformerName>| &&
    |<ShippingInstruction></ShippingInstruction>| &&
    |<ShippingInstructionText></ShippingInstructionText>| &&
    |<StorageLocation></StorageLocation>| &&
    |<StorageLocationName></StorageLocationName>| &&
    |<SupplierMaterialNumber></SupplierMaterialNumber>| &&
    |<TaxAmount>16128.00</TaxAmount>| &&
    |<TaxCode>| && ls_poitem-taxcode && |</TaxCode>| &&
    |<ThirdPtyOrdProcgExtRefItem></ThirdPtyOrdProcgExtRefItem>| &&
    |<ThirdPtyOrdProcgExtReference></ThirdPtyOrdProcgExtReference>| &&
    |<ConfigurationItems/>| &&

            |<ItemPricingConditionNodeSet>|.
        IF lt_pocontype IS NOT INITIAL.
          DATA(lv_count1) = 1.
          LOOP AT lt_pocontype INTO DATA(ls_pocontype) WHERE purchaseorder = ls_poitem-purchaseorder
                                                       AND purchaseorderitem = ls_poitem-purchaseorderitem.

            lv_xml_dsign = lv_xml_dsign &&
            |<ItemPricingConditionNode>| &&
                |<ConditionAmount>| && ls_pocontype-conditionamount && |</ConditionAmount>| &&
                |<ConditionBaseValue>10.000</ConditionBaseValue>| &&
                |<ConditionBaseValueUnit>FT3</ConditionBaseValueUnit>| &&
                |<ConditionBaseValueUnit_I>3</ConditionBaseValueUnit_I>| &&
                |<ConditionQuantity>1</ConditionQuantity>| &&
                |<ConditionQuantityUnitTechName>ft3</ConditionQuantityUnitTechName>| &&
                |<ConditionRateValue>| && ls_pocontype-conditionrate && |</ConditionRateValue>| &&
                |<ConditionRateValueUnit>EUR</ConditionRateValueUnit>| &&
                |<ConditionRateValueUnit_I>EUR</ConditionRateValueUnit_I>| &&
                |<ConditionType>| && ls_pocontype-conditiontype && |</ConditionType>| &&
                |<ConditionTypeName>Manual Gross Price</ConditionTypeName>| &&
                |<ContitionQuantityUnit>FT3</ContitionQuantityUnit>| &&
                |<DocumentCurrency>| && ls_pocontype-conditioncurrency && |</DocumentCurrency>| &&
                |<PurchaseOrder>| && ls_pocontype-purchaseorder && |</PurchaseOrder>| &&
                |<PurchaseOrderItem>| && ls_pocontype-purchaseorderitem && |</PurchaseOrderItem>| &&
            |</ItemPricingConditionNode>|.
            lv_count1 += 1.
          ENDLOOP.
        ENDIF.
        lv_xml_dsign = lv_xml_dsign &&
        |</ItemPricingConditionNodeSet>| &&

    |<ItemTaxConditions>|.
        IF ls_poitem-cgstcontype IS NOT INITIAL.
          lv_xml_dsign = lv_xml_dsign &&
          |<ItemTaxConditionsNode>| &&
              |<ConditionAmount>| && ls_poitem-csgstamount && |</ConditionAmount>| &&
              |<ConditionRateValue>| && ls_poitem-cgstconrate && |</ConditionRateValue>| &&
              |<ConditionRateValueIntUnit>%</ConditionRateValueIntUnit>| &&
              |<ConditionType>| && ls_poitem-cgstcontype && |</ConditionType>| &&
              |<ConditionTypeName>IN: Central GST</ConditionTypeName>| &&
              |<DocumentCurrency>| && ls_poitem-documentcurrency && |</DocumentCurrency>| &&
              |<PurchaseOrder>| && ls_poitem-purchaseorder && |</PurchaseOrder>| &&
              |<PurchaseOrderItem>| && ls_poitem-purchaseorderitem && |</PurchaseOrderItem>| &&
          |</ItemTaxConditionsNode>|.
        ENDIF.
        IF ls_poitem-igstcontype IS NOT INITIAL.
          lv_xml_dsign = lv_xml_dsign &&
          |<ItemTaxConditionsNode>| &&
              |<ConditionAmount>| && ls_poitem-igstamount && |</ConditionAmount>| &&
              |<ConditionRateValue>| && ls_poitem-igstconrate && |</ConditionRateValue>| &&
              |<ConditionRateValueIntUnit>%</ConditionRateValueIntUnit>| &&
              |<ConditionType>| && ls_poitem-igstcontype && |</ConditionType>| &&
              |<ConditionTypeName>IN: State GST</ConditionTypeName>| &&
              |<DocumentCurrency>| && ls_poitem-documentcurrency && |</DocumentCurrency>| &&
              |<PurchaseOrder>| && ls_poitem-purchaseorder && |</PurchaseOrder>| &&
              |<PurchaseOrderItem>| && ls_poitem-purchaseorderitem && |</PurchaseOrderItem>| &&
          |</ItemTaxConditionsNode>|.
        ENDIF.
        lv_xml_dsign = lv_xml_dsign &&
        |</ItemTaxConditions>| &&

|<PurchaseOrderItemBatchSet/>| &&
|<PurchaseOrderItemSTTextsSet/>| &&
|<PurchaseOrderItemTextsSet/>| &&
|<PurchaseOrderItemChanges/>| &&
|<PurchaseOrderScheduleLineNode>| &&
|<PurchaseOrderScheduleLineNode>| &&
|<Batch></Batch>| &&
|<DeliveryCategoryTxt>Day</DeliveryCategoryTxt>| &&
|<DeliveryDateCategory>1</DeliveryDateCategory>| &&
|<DeliveryTime>00:00:00</DeliveryTime>| &&
|<Openquantity>10.000</Openquantity>| &&
|<PurchaseOrder>4500000490</PurchaseOrder>| &&
|<PurchaseOrderItem>00010</PurchaseOrderItem>| &&
|<PurchaseOrderQuantityUnit>FT3</PurchaseOrderQuantityUnit>| &&
|<PurchaseOrderQuantityUnitTechName>ft3</PurchaseOrderQuantityUnitTechName>| &&
|<ReminderText></ReminderText>| &&
|<ScheduleLine>0001</ScheduleLine>| &&
|<ScheduleLineDeliveryDate>2025-09-11T00:00:00</ScheduleLineDeliveryDate>| &&
|<ScheduleLineOrderQuantity>10</ScheduleLineOrderQuantity>| &&
|<PurchaseOrderScheduleLineComponents/>| &&
|</PurchaseOrderScheduleLineNode>| &&
|</PurchaseOrderScheduleLineNode>| &&
|</PurchaseOrderItemNode>|.
        lv_count += 1.
      ENDLOOP.
    ENDIF.
    lv_xml_dsign = lv_xml_dsign &&

      |</PurchaseOrderItems>| &&
      |<PurchaseOrderLimitItems/>| &&
      |<PurchasingGroups>| &&
      |<PurchasingGroup>001</PurchasingGroup>| &&
      |<PurchasingGroupEmailAddress>a</PurchasingGroupEmailAddress>| &&
      |<PurchasingGroupFaxNumber>770 840 9000</PurchasingGroupFaxNumber>| &&
      |<PurchasingGroupName>Group 001</PurchasingGroupName>| &&
      |<PurchasingGroupPhoneNumber>331</PurchasingGroupPhoneNumber>| &&
      |</PurchasingGroups>| &&
      |<ShipToParty>| &&
          |<AddressLine1></AddressLine1>| &&
          |<AddressLine2></AddressLine2>| &&
          |<AddressLine3></AddressLine3>| &&
          |<AddressLine4></AddressLine4>| &&
          |<AddressLine5>INDIA</AddressLine5>| &&
          |<AddressLine6></AddressLine6>| &&
          |<AddressLine7></AddressLine7>| &&
          |<AddressLine8></AddressLine8>| &&
          |<IN_GSTIdentificationNumber></IN_GSTIdentificationNumber>| &&
          |<ShipToAddress>0000000211</ShipToAddress>| &&
      |</ShipToParty>| &&
      |<Suppliers>| &&
          |<AddressLine1>Company</AddressLine1>| &&
          |<AddressLine2>| && ls_pohead-bpsupplierfullname && |</AddressLine2>| &&
          |<AddressLine3>| && ls_pohead-streetprefixname1 && |</AddressLine3>| &&
          |<AddressLine4>| && ls_pohead-streetprefixname2 && |</AddressLine4>| &&
          |<AddressLine5>| && postal && |</AddressLine5>| &&
          |<AddressLine6>| && ls_pohead-vencountryname && |</AddressLine6>| &&
          |<AddressLine7></AddressLine7>| &&
          |<AddressLine8></AddressLine8>| &&
          |<IN_GSTIdentificationNumber>| && ls_pohead-gstn && |</IN_GSTIdentificationNumber>| &&
          |<Supplier>| && ls_pohead-vendorcode && |</Supplier>| &&
          |<SupplierAddressID></SupplierAddressID>| &&
          |<SupplierEmailAddress></SupplierEmailAddress>| &&
          |<SupplierMobileNumber></SupplierMobileNumber>| &&
          |<SupplierName>| && ls_pohead-bpsupplierfullname && |</SupplierName>| &&
          |<SupplierTelephoneNumber></SupplierTelephoneNumber>| &&
          |<VatRegistration></VatRegistration>| &&
      |</Suppliers>| &&
      |<TaxSummary>| &&
          |<TaxSummaryNode>| &&
              |<ConditionAmount>8064.00</ConditionAmount>| &&
              |<ConditionRateValue>0.00 </ConditionRateValue>| &&
              |<ConditionType></ConditionType>| &&
              |<ConditionTypeName>IN: Central GST</ConditionTypeName>| &&
              |<DocumentCurrency>INR</DocumentCurrency>| &&
              |<PurchaseOrder></PurchaseOrder>| &&
              |</TaxSummaryNode>| &&
          |<TaxSummaryNode>| &&
              |<ConditionAmount>8064.00</ConditionAmount>| &&
              |<ConditionRateValue>0.00 </ConditionRateValue>| &&
              |<ConditionType></ConditionType>| &&
              |<ConditionTypeName>IN: State GST</ConditionTypeName>| &&
              |<DocumentCurrency>INR</DocumentCurrency>| &&
              |<PurchaseOrder></PurchaseOrder>| &&
          |</TaxSummaryNode>| &&
      |</TaxSummary>| &&
      |<TotalAmounts>| &&
          |<GrossAmount>105728.00</GrossAmount>| &&
          |<GrossInWords>Rupees One Hundred Five Thousand Seven Hundred Twenty-eight and Zero Paise</GrossInWords>| &&
          |<PurchaseOrder>| && ls_pohead-purchaseorder && |</PurchaseOrder>| &&
          |<TotalTaxAmount>16128.00</TotalTaxAmount>| &&
      |</TotalAmounts>| &&
      |</PurchaseOrderNode>| &&
|</Form>|.


**********************************************************************
    DATA(lv_base64_exinv) = cl_web_http_utility=>encode_base64( unencoded = lv_xml_dsign ).
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
      CATCH cx_root INTO DATA(lx_root).
        DATA(lv_err5) = 1.
    ENDTRY.
**********************************************************************
    DATA(lv_basecode_exinv) = ls_response-filecontent.

************************************************************************
*      """ HTTP Communication via URL   """
                TRY.
                    lo_httpreqst->set_text( '{    "AuthorizedSignatory": "Chemfab",'

                               && '    "SignerName": "'
                               && ls_authsign-signername
                               && '",'
                               && '    "TopLeft": 0,'
                && '    "BottomLeft": 0,'
                && '    "TopRight": 0,'
                && '    "BottomRight": 0,'
                && '    "ExcludePageNo": "",'
                && '    "InvoiceNumber": "'
                && ls_pohead-PurchaseOrder
                && '",'
                && '    "pageNo": -1,'
                && '    "PrintDateTime": "",'
                && '    "FindAuth": "Authori",'
                && '    "FindAuthLocation": 0,'
                && '    "fontsize": 24,'
                && '    "adjustCoordinates": 0,'
                && '    "signOnlySearchTextPage": 1,'
                && '    "pdfByte1": "'
                && lv_basecode_exinv
                &&  '" }'      ).

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
      DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_dscresponse-filecontent  ).
      DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).

**********************************************************************
      zbp_mm_app18_rv=>gs_print_data = lv_print_data.
      zbp_mm_app18_rv=>gs_pqitem_id = lv_qitem_id.
      zbp_mm_app18_rv=>gv_printq = ls_authsign-prntque.

    ENDIF.
**********************************************************************


    IF ls_stas-reason = 'OK' AND ls_stas-code = '200'.

      APPEND VALUE #( %tky = ls_pohead-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                              text = 'Printed Successfully' )
                               ) TO reported-zmm_app18_rv.
    ELSE.
      APPEND VALUE #( %tky = ls_pohead-%tky ) TO failed-zmm_app18_rv.
      APPEND VALUE #( %tky = ls_pohead-%tky
      %msg =  new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'Not Printed' )
                               ) TO reported-zmm_app18_rv.

    ENDIF.

**********************************************************************
    ELSE.
          APPEND VALUE #( %tky = ls_pohead-%tky ) to failed-zmm_app18_rv.
          APPEND VALUE #( %tky = ls_pohead-%tky
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                        text = 'User Authorization not Maintained' )
                                        ) to reported-zmm_app18_rv.
    ENDIF.

**********************************************************************
    result = VALUE #( FOR ls_pord  IN lt_pohead
                            ( %tky = ls_pord-%tky
                              %param = ls_pord ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_app17_pohd_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_app17_pohd_rv IMPLEMENTATION.

  METHOD save_modified.

**********************************************************************
    IF zbp_mm_app18_rv=>gs_print_data IS NOT INITIAL.

      DATA(wa_print_data) = zbp_mm_app18_rv=>gs_print_data.
      DATA(wa_pqitem_id) = zbp_mm_app18_rv=>gs_pqitem_id.

      DATA(wa_ponum) = zbp_mm_app18_rv=>gv_ponum.

      cl_print_queue_utils=>create_queue_item_by_data(
        EXPORTING
          iv_qname            = zbp_mm_app18_rv=>gv_printq
          iv_print_data       =  wa_print_data
          iv_name_of_main_doc = 'DSC-' && wa_ponum
          iv_itemid           = wa_pqitem_id
        IMPORTING
          ev_err_msg          = DATA(gs_error_msg)
      ).

    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
