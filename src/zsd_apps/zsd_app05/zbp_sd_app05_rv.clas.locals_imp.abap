CLASS lhc_zsd_app05_rv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zsd_app05_rv RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsd_app05_rv RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zsd_app05_rv~print RESULT result.

ENDCLASS.

CLASS lhc_zsd_app05_rv IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print.

    READ ENTITIES OF zsd_app05_rv IN LOCAL MODE
    ENTITY billhdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_billhdr).
    DATA(ls_billhdr) = lt_billhdr[ 1 ].

**********************************************************************
**********************************************************************
    DATA(lv_xml) = |<?xml version="1.0" encoding="utf-8"?>| &&
|<Form xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/">| &&
|<BillingDocumentNode>| &&
|<AbsltAccountingExchangeRate>1.00000</AbsltAccountingExchangeRate>| &&
|<AccountingDocument>9400000058</AccountingDocument>| &&
|<AckDate>0000-00-00T00:00:00</AckDate>| &&
|<AckNumber></AckNumber>| &&
|<AckTime>00:00:00</AckTime>| &&
|<AmountInWords></AmountInWords>| &&
|<BankBranch></BankBranch>| &&
|<BillingDate>2024-07-24T00:00:00</BillingDate>| &&
|<BillingDocument>90000010</BillingDocument>| &&
|<BillingDocumentCategory>L</BillingDocumentCategory>| &&
|<BillingDocumentType>F2</BillingDocumentType>| &&
|<BillingDocumentTypeName>Invoice</BillingDocumentTypeName>| &&
|<BillingSDDocumentCategory>M</BillingSDDocumentCategory>| &&
|<BillingSDDocumentCategoryName>Invoice</BillingSDDocumentCategoryName>| &&
|<CancelledBillingDocument></CancelledBillingDocument>| &&
|<ConditionAmountLocCurr>0.00</ConditionAmountLocCurr>| &&
|<ConditionBaseValueLocCurr>0.00</ConditionBaseValueLocCurr>| &&
|<ContactName>CB9980000011</ContactName>| &&
|<Country>IN</Country>| &&
|<CrrtnInvoiceIsDifferential>false</CrrtnInvoiceIsDifferential>| &&
|<CustomerBranchCode></CustomerBranchCode>| &&
|<CustomerInvoice></CustomerInvoice>| &&
|<CustomerInvoiceDate>0000-00-00T00:00:00</CustomerInvoiceDate>| &&
|<DocumentReferenceID>F20000000025</DocumentReferenceID>| &&
|<EwbNumber>000000000000</EwbNumber>| &&
|<EwbValidfromDate>0000-00-00T00:00:00</EwbValidfromDate>| &&
|<EwbValidfromTime>00:00:00</EwbValidfromTime>| &&
|<EwbValidtoDate>0000-00-00T00:00:00</EwbValidtoDate>| &&
|<EwbValidtoTime>00:00:00</EwbValidtoTime>| &&
|<ExchangeRate>0.00000</ExchangeRate>| &&
|<ExchangeRateDate>2024-07-24T00:00:00</ExchangeRateDate>| &&
|<ExchangeRateIsIndirect></ExchangeRateIsIndirect>| &&
|<ExemptionLetterDate>0000-00-00T00:00:00</ExemptionLetterDate>| &&
|<ExemptionLetterNumber></ExemptionLetterNumber>| &&
|<GloLocalCurr></GloLocalCurr>| &&
|<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
|<ID_TaxInvoiceSigner></ID_TaxInvoiceSigner>| &&
|<IndicatorVatSplit></IndicatorVatSplit>| &&
|<InvoiceListStatus></InvoiceListStatus>| &&
|<Irn></Irn>| &&
|<LocCurr></LocCurr>| &&
|<PaymentReference></PaymentReference>| &&
|<PrelimBillingDocument></PrelimBillingDocument>| &&
|<PricingProcedure>ZDOMS1</PricingProcedure>| &&
|<PurchaseOrderByCustomer>FOC</PurchaseOrderByCustomer>| &&
|<QrcodeBitmap></QrcodeBitmap>| &&
|<ReferenceSDDocument>80000002</ReferenceSDDocument>| &&
|<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
|<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
|<RemunerationTotalNetAmount>0.00</RemunerationTotalNetAmount>| &&
|<SalesContract></SalesContract>| &&
|<SalesDocument>4</SalesDocument>| &&
|<SalesOrderDate>2024-07-24T00:00:00</SalesOrderDate>| &&
|<SalesOrderReason></SalesOrderReason>| &&
|<SalesOrderReasonText></SalesOrderReasonText>| &&
|<SalesOrganization>1000</SalesOrganization>| &&
|<SalesOrganizationName>CCAL-Chemicals</SalesOrganizationName>| &&
|<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
|<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
|<SolutionOrder></SolutionOrder>| &&
|<Status></Status>| &&
|<SupplyDate>0000-00-00T00:00:00</SupplyDate>| &&
|<TaxReportingDate>0000-00-00T00:00:00</TaxReportingDate>| &&
|<TotGrssAmtAsText>ONE PAISE</TotGrssAmtAsText>| &&
|<TotalDiscount>0.00</TotalDiscount>| &&
|<TotalDiscountLoccurr>0.00</TotalDiscountLoccurr>| &&
|<TotalGrossAmount>0.01</TotalGrossAmount>| &&
|<TotalGrossAmountLocurr>0.00</TotalGrossAmountLocurr>| &&
|<TotalNetAmount>0.01</TotalNetAmount>| &&
|<TotalNetAmountLocurr>0.00</TotalNetAmountLocurr>| &&
|<TotalOtherCharges>0.00</TotalOtherCharges>| &&
|<TotalOtherChargesLoccurr>0.00</TotalOtherChargesLoccurr>| &&
|<TotalSalesAmount>0.00</TotalSalesAmount>| &&
|<TotalSalesAmountLoccurr>0.00</TotalSalesAmountLoccurr>| &&
|<TotalTaxAmount>0.00</TotalTaxAmount>| &&
|<TotalWth>0.00</TotalWth>| &&
|<TotalWthLoccur>0.00</TotalWthLoccur>| &&
|<TransactionCurrency>INR</TransactionCurrency>| &&
|<TransporterGstin></TransporterGstin>| &&
|<TransporterName></TransporterName>| &&
|<Uuid></Uuid>| &&
|<VehicleNumber></VehicleNumber>| &&
|<YY1_AccountNumber_BDH>000000000000000</YY1_AccountNumber_BDH>| &&
|<YY1_AccountNumber_BDHF>3</YY1_AccountNumber_BDHF>| &&
|<YY1_BILL_PAN_BDH></YY1_BILL_PAN_BDH>| &&
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
|<YY1_CONCN_BDH>0.000</YY1_CONCN_BDH>| &&
|<YY1_CONCN_BDHF>3</YY1_CONCN_BDHF>| &&
|<YY1_CONCN_BDHT></YY1_CONCN_BDHT>| &&
|<YY1_CONCN_BDHU></YY1_CONCN_BDHU>| &&
|<YY1_CustRefDate_BDH>0000-00-00T00:00:00</YY1_CustRefDate_BDH>| &&
|<YY1_CustRefDate_BDHF>3</YY1_CustRefDate_BDHF>| &&
|<YY1_CylinderDetailSeal_BDH></YY1_CylinderDetailSeal_BDH>| &&
|<YY1_CylinderDetailSeal_BDHF>3</YY1_CylinderDetailSeal_BDHF>| &&
|<YY1_DistributionChanne_BDH>50</YY1_DistributionChanne_BDH>| &&
|<YY1_DistributionChanne_BDHF>3</YY1_DistributionChanne_BDHF>| &&
|<YY1_Division_BDH>01</YY1_Division_BDH>| &&
|<YY1_Division_BDHF>3</YY1_Division_BDHF>| &&
|<YY1_DriverDetails_BDH></YY1_DriverDetails_BDH>| &&
|<YY1_DriverDetails_BDHF>3</YY1_DriverDetails_BDHF>| &&
|<YY1_FreightIndicatorSD_BDH>false</YY1_FreightIndicatorSD_BDH>| &&
|<YY1_FreightIndicatorSD_BDHF>3</YY1_FreightIndicatorSD_BDHF>| &&
|<YY1_FreightTerms_BDH></YY1_FreightTerms_BDH>| &&
|<YY1_FreightTerms_BDHF>3</YY1_FreightTerms_BDHF>| &&
|<YY1_FreightTerms_BDHT></YY1_FreightTerms_BDHT>| &&
|<YY1_GrossWT_BDH>0.000</YY1_GrossWT_BDH>| &&
|<YY1_GrossWT_BDHF>3</YY1_GrossWT_BDHF>| &&
|<YY1_GrossWT_BDHT></YY1_GrossWT_BDHT>| &&
|<YY1_GrossWT_BDHU></YY1_GrossWT_BDHU>| &&
|<YY1_IFSCCode_BDH></YY1_IFSCCode_BDH>| &&
|<YY1_IFSCCode_BDHF>3</YY1_IFSCCode_BDHF>| &&
|<YY1_ModeOfTransport_BDH></YY1_ModeOfTransport_BDH>| &&
|<YY1_ModeOfTransport_BDHF>3</YY1_ModeOfTransport_BDHF>| &&
|<YY1_NETWT_BDH>0.000</YY1_NETWT_BDH>| &&
|<YY1_NETWT_BDHF>3</YY1_NETWT_BDHF>| &&
|<YY1_NETWT_BDHT></YY1_NETWT_BDHT>| &&
|<YY1_NETWT_BDHU></YY1_NETWT_BDHU>| &&
|<YY1_NOOFCylinder_BDH>00000</YY1_NOOFCylinder_BDH>| &&
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
|<YY1_Transporter_BDH></YY1_Transporter_BDH>| &&
|<YY1_Transporter_BDHF>3</YY1_Transporter_BDHF>| &&
|<YY1_VehicleNumber_BDH></YY1_VehicleNumber_BDH>| &&
|<YY1_VehicleNumber_BDHF>3</YY1_VehicleNumber_BDHF>| &&
|<YY1_VolumePerCylinder_BDH>0.000</YY1_VolumePerCylinder_BDH>| &&
|<YY1_VolumePerCylinder_BDHF>3</YY1_VolumePerCylinder_BDHF>| &&
|<YY1_VolumePerCylinder_BDHT></YY1_VolumePerCylinder_BDHT>| &&
|<YY1_VolumePerCylinder_BDHU></YY1_VolumePerCylinder_BDHU>| &&
|<BillToParty>| &&
|<AddressID>144</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>TEST CUSTOMER</AddressLine2Text>| &&
|<AddressLine3Text>ccalbuyer6@ccal.in</AddressLine3Text>| &&
|<AddressLine4Text>NO.7 Balaji Street</AddressLine4Text>| &&
|<AddressLine5Text>605001 Puducherry</AddressLine5Text>| &&
|<AddressLine6Text></AddressLine6Text>| &&
|<AddressLine7Text></AddressLine7Text>| &&
|<AddressLine8Text></AddressLine8Text>| &&
|<AddressType>1</AddressType>| &&
|<City></City>| &&
|<Countryname></Countryname>| &&
|<FaxNumber></FaxNumber>| &&
|<FullName>TEST CUSTOMER</FullName>| &&
|<Partner>100001</Partner>| &&
|<PartnerFunction>BP</PartnerFunction>| &&
|<PartnerFunctionName></PartnerFunctionName>| &&
|<Person></Person>| &&
|<PostalCode></PostalCode>| &&
|<Region>PY</Region>| &&
|<RegionName>Pondicherry</RegionName>| &&
|<Street></Street>| &&
|<TelephoneNumber></TelephoneNumber>| &&
|</BillToParty>| &&
|<ClearedDownPayment/>| &&
|<ClearedDownPaymentOvw>| &&
|<BillingDocument></BillingDocument>| &&
|<DocumentDescription></DocumentDescription>| &&
|<DownPaymentGrossAmount>0.00 </DownPaymentGrossAmount>| &&
|<DownPaymentNetAmount>0.00 </DownPaymentNetAmount>| &&
|<DownPaymentTaxAmount>0.00 </DownPaymentTaxAmount>| &&
|</ClearedDownPaymentOvw>| &&
|<Company>| &&
|<AddressID>21</AddressID>| &&
|<AddressLine1Text>1 GNANANANDA PLACE, ECR ROAD, KALAPET, PUDUCHERRY-605014.</AddressLine1Text>| &&
|<AddressLine2Text>605014 PUDUCHERRY</AddressLine2Text>| &&
|<AddressLine3Text></AddressLine3Text>| &&
|<AddressLine4Text></AddressLine4Text>| &&
|<AddressLine5Text></AddressLine5Text>| &&
|<AddressLine6Text></AddressLine6Text>| &&
|<AddressLine7Text></AddressLine7Text>| &&
|<AddressLine8Text></AddressLine8Text>| &&
|<AddressType></AddressType>| &&
|<BankAccKey></BankAccKey>| &&
|<City></City>| &&
|<CompanyCode>1000</CompanyCode>| &&
|<CompanyName>CCAL-Chemicals</CompanyName>| &&
|<Country>IN</Country>| &&
|<Countryname></Countryname>| &&
|<EmailAddress></EmailAddress>| &&
|<FullName></FullName>| &&
|<Person></Person>| &&
|<PhoneNumber></PhoneNumber>| &&
|<PostalCode></PostalCode>| &&
|<Region>PY</Region>| &&
|<RegionName>Pondicherry</RegionName>| &&
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
|<TransactionCurrency>INR</TransactionCurrency>| &&
|<DownPayments/>| &&
|</DownPaymentOverview>| &&
|<Incoterms>| &&
|<Incoterms>CFR</Incoterms>| &&
|<IncotermsLocation1>Puducherry</IncotermsLocation1>| &&
|<IncotermsLocation1Lbl></IncotermsLocation1Lbl>| &&
|<IncotermsLocation2></IncotermsLocation2>| &&
|<IncotermsLocation2Lbl></IncotermsLocation2Lbl>| &&
|<IncotermsVersion></IncotermsVersion>| &&
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
|<Batch>V202D</Batch>| &&
|<BillingDocumentItem>10</BillingDocumentItem>| &&
|<BillingDocumentItemText>CAUSTIC SODA 48%</BillingDocumentItemText>| &&
|<BillingPeriodOfPerfEndDate>0000-00-00T00:00:00</BillingPeriodOfPerfEndDate>| &&
|<BillingPeriodOfPerfStartDate>0000-00-00T00:00:00</BillingPeriodOfPerfStartDate>| &&
|<CommodityCode></CommodityCode>| &&
|<CountryOfOrigin></CountryOfOrigin>| &&
|<CustomerInvoice></CustomerInvoice>| &&
|<CustomerInvoiceItem>000000</CustomerInvoiceItem>| &&
|<DebitCreditCode></DebitCreditCode>| &&
|<GloLocalCurr>INR</GloLocalCurr>| &&
|<GoodsIssueOrReceiptSlipNumber></GoodsIssueOrReceiptSlipNumber>| &&
|<GrossAmount>0.00</GrossAmount>| &&
|<Higherlevelitem>000000</Higherlevelitem>| &&
|<IN_GSTControlCodeDesc1>Business consulting services including pubic relations servi</IN_GSTControlCodeDesc1>| &&
|<IN_GSTControlCodeDesc2></IN_GSTControlCodeDesc2>| &&
|<IN_GSTControlCodeDesc3></IN_GSTControlCodeDesc3>| &&
|<IN_GSTControlCodeDesc4></IN_GSTControlCodeDesc4>| &&
|<IN_GSTControlCodeDesc5></IN_GSTControlCodeDesc5>| &&
|<IN_HSNOrSACCode>998312</IN_HSNOrSACCode>| &&
|<ItemDiscount>0.00</ItemDiscount>| &&
|<Material>30000000</Material>| &&
|<MaterialName>CAUSTIC SODA 48%</MaterialName>| &&
|<Materialisinternalbatchmanaged>true</Materialisinternalbatchmanaged>| &&
|<NetAmount>0.01</NetAmount>| &&
|<NetAmountLoccurr>0.00</NetAmountLoccurr>| &&
|<NetPriceAmount>0.01</NetPriceAmount>| &&
|<NetPriceQuantity>1</NetPriceQuantity>| &&
|<NetPriceQuantityUnit>TO</NetPriceQuantityUnit>| &&
|<NetPriceQuantityUnitTechName>t</NetPriceQuantityUnitTechName>| &&
|<NetWeight>900.000</NetWeight>| &&
|<OtherCharges>0.00</OtherCharges>| &&
|<Plant>1100</Plant>| &&
|<PurchaseOrderByCustomer>FOC</PurchaseOrderByCustomer>| &&
|<Quantity>1.000</Quantity>| &&
|<QuantityUnit>TO</QuantityUnit>| &&
|<QuantityUnitTechName>t</QuantityUnitTechName>| &&
|<ReferenceSDDocument>80000002</ReferenceSDDocument>| &&
|<ReferenceSDDocumentCategory>J</ReferenceSDDocumentCategory>| &&
|<ReferenceSDDocumentCategoryName>Delivery</ReferenceSDDocumentCategoryName>| &&
|<RegionOfOrigin></RegionOfOrigin>| &&
|<SalesContract></SalesContract>| &&
|<SalesContractItem>000000</SalesContractItem>| &&
|<SalesDocument>4</SalesDocument>| &&
|<SalesOrderExternalDocId></SalesOrderExternalDocId>| &&
|<SalesSDDocumentCategory>C</SalesSDDocumentCategory>| &&
|<SalesSDDocumentCategoryName>Order</SalesSDDocumentCategoryName>| &&
|<ServicesRenderedDate>2024-07-24T00:00:00</ServicesRenderedDate>| &&
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
|<TransactionCurrency>INR</TransactionCurrency>| &&
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
|<YY1_PhoneNo_BDI>00 914132261000</YY1_PhoneNo_BDI>| &&
|<YY1_PhoneNo_BDIF>3</YY1_PhoneNo_BDIF>| &&
|<YY1_Plant_Address_BDI>GNANANANDA PLACE, KALAPET, PUDUCHERRY - 605014</YY1_Plant_Address_BDI>| &&
|<YY1_Plant_Address_BDIF>3</YY1_Plant_Address_BDIF>| &&
|<YY1_Plant_CIN_BDI>L24290TN2009PLC071563</YY1_Plant_CIN_BDI>| &&
|<YY1_Plant_CIN_BDIF>3</YY1_Plant_CIN_BDIF>| &&
|<YY1_Plant_Email_BDI>chemfabmktg@ccal.in</YY1_Plant_Email_BDI>| &&
|<YY1_Plant_Email_BDIF>3</YY1_Plant_Email_BDIF>| &&
|<YY1_Plant_GST_BDI>34AADCT1820F1ZT</YY1_Plant_GST_BDI>| &&
|<YY1_Plant_GST_BDIF>3</YY1_Plant_GST_BDIF>| &&
|<YY1_Plant_ISO_BDI>(ISO 14001:2015 &amp; 45001:2018 CERTIFIED COMPANY)</YY1_Plant_ISO_BDI>| &&
|<YY1_Plant_ISO_BDIF>3</YY1_Plant_ISO_BDIF>| &&
|<YY1_Plant_PAN_BDI>AADCT1820F</YY1_Plant_PAN_BDI>| &&
|<YY1_Plant_PAN_BDIF>3</YY1_Plant_PAN_BDIF>| &&
|<YY1_Plant_TAN_BDI>CHEC13571F</YY1_Plant_TAN_BDI>| &&
|<YY1_Plant_TAN_BDIF>3</YY1_Plant_TAN_BDIF>| &&
|<YY1_SD_PODATE_BDI>0000-00-00T00:00:00</YY1_SD_PODATE_BDI>| &&
|<YY1_SD_PODATE_BDIF>3</YY1_SD_PODATE_BDIF>| &&
|<YY1_bedt_BDI></YY1_bedt_BDI>| &&
|<YY1_bedt_BDIF>3</YY1_bedt_BDIF>| &&
|<ItemBatchDetails>| &&
|<ItemBatchDetailsNode>| &&
|<Characteristic>YB_BATCH_NUMBER</Characteristic>| &&
|<CharacteristicDescription>Batch Number</CharacteristicDescription>| &&
|<CharacteristicValue>V202D</CharacteristicValue>| &&
|<CharacteristicValueDescript>V202D</CharacteristicValueDescript>| &&
|</ItemBatchDetailsNode>| &&
|</ItemBatchDetails>| &&
|<ItemConfiguration/>| &&
|<ItemPricingConditions>| &&
|<ItemPricingConditionNode>| &&
|<ConditionAmount>0.01</ConditionAmount>| &&
|<ConditionBaseValue>1.000</ConditionBaseValue>| &&
|<ConditionBaseValueUnit>TO</ConditionBaseValueUnit>| &&
|<ConditionQuantity>1</ConditionQuantity>| &&
|<ConditionQuantityUnit>TO</ConditionQuantityUnit>| &&
|<ConditionQuantityUnitTechName>t</ConditionQuantityUnitTechName>| &&
|<ConditionRateValue>0.01</ConditionRateValue>| &&
|<ConditionRateValueUnit>INR</ConditionRateValueUnit>| &&
|<ConditionStep>010</ConditionStep>| &&
|<ConditionType>ZPRO</ConditionType>| &&
|<ConditionTypeName>Base Price</ConditionTypeName>| &&
|<DocumentCurrency>INR</DocumentCurrency>| &&
|<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|<ItemPricingConditionNode>| &&
|<ConditionAmount>0.00</ConditionAmount>| &&
|<ConditionBaseValue>0</ConditionBaseValue>| &&
|<ConditionBaseValueUnit></ConditionBaseValueUnit>| &&
|<ConditionQuantity>0</ConditionQuantity>| &&
|<ConditionQuantityUnit></ConditionQuantityUnit>| &&
|<ConditionQuantityUnitTechName></ConditionQuantityUnitTechName>| &&
|<ConditionRateValue>0.00</ConditionRateValue>| &&
|<ConditionRateValueUnit></ConditionRateValueUnit>| &&
|<ConditionStep>020</ConditionStep>| &&
|<ConditionType>ZFRI</ConditionType>| &&
|<ConditionTypeName>Freight(PDY)Received</ConditionTypeName>| &&
|<DocumentCurrency>INR</DocumentCurrency>| &&
|<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|<ItemPricingConditionNode>| &&
|<ConditionAmount>0.00</ConditionAmount>| &&
|<ConditionBaseValue>0.01</ConditionBaseValue>| &&
|<ConditionBaseValueUnit>INR</ConditionBaseValueUnit>| &&
|<ConditionQuantity>0</ConditionQuantity>| &&
|<ConditionQuantityUnit></ConditionQuantityUnit>| &&
|<ConditionQuantityUnitTechName></ConditionQuantityUnitTechName>| &&
|<ConditionRateValue>9.000</ConditionRateValue>| &&
|<ConditionRateValueUnit>%</ConditionRateValueUnit>| &&
|<ConditionStep>070</ConditionStep>| &&
|<ConditionType>JOCG</ConditionType>| &&
|<ConditionTypeName>IN:Central GST - OP</ConditionTypeName>| &&
|<DocumentCurrency>INR</DocumentCurrency>| &&
|<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|<ItemPricingConditionNode>| &&
|<ConditionAmount>0.00</ConditionAmount>| &&
|<ConditionBaseValue>0.01</ConditionBaseValue>| &&
|<ConditionBaseValueUnit>INR</ConditionBaseValueUnit>| &&
|<ConditionQuantity>0</ConditionQuantity>| &&
|<ConditionQuantityUnit></ConditionQuantityUnit>| &&
|<ConditionQuantityUnitTechName></ConditionQuantityUnitTechName>| &&
|<ConditionRateValue>9.000</ConditionRateValue>| &&
|<ConditionRateValueUnit>%</ConditionRateValueUnit>| &&
|<ConditionStep>080</ConditionStep>| &&
|<ConditionType>JOSG</ConditionType>| &&
|<ConditionTypeName>IN: State GST – OP</ConditionTypeName>| &&
|<DocumentCurrency>INR</DocumentCurrency>| &&
|<VariantCondition></VariantCondition>| &&
|</ItemPricingConditionNode>| &&
|</ItemPricingConditions>| &&
|<ItemSerialNUmber/>| &&
|<ItemShipToParty>| &&
|<AddressID>144</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>TEST CUSTOMER</AddressLine2Text>| &&
|<AddressLine3Text>ccalbuyer6@ccal.in</AddressLine3Text>| &&
|<AddressLine4Text>NO.7 Balaji Street</AddressLine4Text>| &&
|<AddressLine5Text>605001 Puducherry</AddressLine5Text>| &&
|<AddressLine6Text></AddressLine6Text>| &&
|<AddressLine7Text></AddressLine7Text>| &&
|<AddressLine8Text></AddressLine8Text>| &&
|<AddressType>1</AddressType>| &&
|<FullName>TEST CUSTOMER</FullName>| &&
|<Partner>100001</Partner>| &&
|<PartnerFunction>SH</PartnerFunction>| &&
|<PartnerFunctionName>Ship to Party</PartnerFunctionName>| &&
|<Person></Person>| &&
|</ItemShipToParty>| &&
|<ItemTextElements/>| &&
|</BillingDocumentItemNode>| &&
|</Items>| &&
|<ItemsAfterCorr/>| &&
|<ItemsDifference/>| &&
|<LegallyRequiredTexts>| &&
|<LegallyRequiredTextNode>| &&
|<LegallyRequiredText></LegallyRequiredText>| &&
|<TaxCode>F4</TaxCode>| &&
|</LegallyRequiredTextNode>| &&
|</LegallyRequiredTexts>| &&
|<OpenDownPayment>| &&
|<BillingDocument></BillingDocument>| &&
|<DownPaymentGrossAmount>0.00 </DownPaymentGrossAmount>| &&
|<DownPaymentNetAmount>0.00 </DownPaymentNetAmount>| &&
|<DownPaymentTaxAmount>0.00 </DownPaymentTaxAmount>| &&
|</OpenDownPayment>| &&
|<PayerParty>| &&
|<AddressID>144</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>TEST CUSTOMER</AddressLine2Text>| &&
|<AddressLine3Text>ccalbuyer6@ccal.in</AddressLine3Text>| &&
|<AddressLine4Text>NO.7 Balaji Street</AddressLine4Text>| &&
|<AddressLine5Text>605001 Puducherry</AddressLine5Text>| &&
|<AddressLine6Text></AddressLine6Text>| &&
|<AddressLine7Text></AddressLine7Text>| &&
|<AddressLine8Text></AddressLine8Text>| &&
|<AddressType>1</AddressType>| &&
|<FullName>TEST CUSTOMER</FullName>| &&
|<Partner>100001</Partner>| &&
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
|<PaymentDueDate>2024-07-24T00:00:00</PaymentDueDate>| &&
|<PaymentTerm1Description>Up to 24.07.2024 without deduction</PaymentTerm1Description>| &&
|<PaymentTerm2Description></PaymentTerm2Description>| &&
|<PaymentTerm3Description></PaymentTerm3Description>| &&
|<PaymentTermsName>Pay Immediately w/o Deduction</PaymentTermsName>| &&
|</PaymentTerms>| &&
|<PricingConditions/>| &&
|<PricingTerms>| &&
|<DeliveryDate>2024-07-24T00:00:00</DeliveryDate>| &&
|<PricingDate>2024-07-24T00:00:00</PricingDate>| &&
|</PricingTerms>| &&
|<SEPA>| &&
|<BICNumber></BICNumber>| &&
|<BankName></BankName>| &&
|<IBAN></IBAN>| &&
|<PaymentDueDate>0000-00-00T00:00:00</PaymentDueDate>| &&
|<SEPAMandate></SEPAMandate>| &&
|</SEPA>| &&
|<ShipToParty>| &&
|<AddressID>144</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>TEST CUSTOMER</AddressLine2Text>| &&
|<AddressLine3Text>ccalbuyer6@ccal.in</AddressLine3Text>| &&
|<AddressLine4Text>NO.7 Balaji Street</AddressLine4Text>| &&
|<AddressLine5Text>605001 Puducherry</AddressLine5Text>| &&
|<AddressLine6Text></AddressLine6Text>| &&
|<AddressLine7Text></AddressLine7Text>| &&
|<AddressLine8Text></AddressLine8Text>| &&
|<AddressType>1</AddressType>| &&
|<City></City>| &&
|<Countryname></Countryname>| &&
|<FullName>TEST CUSTOMER</FullName>| &&
|<PanNoCompany></PanNoCompany>| &&
|<Partner>100001</Partner>| &&
|<PartnerFunction>SH</PartnerFunction>| &&
|<PartnerFunctionName></PartnerFunctionName>| &&
|<Person></Person>| &&
|<PostalCode></PostalCode>| &&
|<Region>PY</Region>| &&
|<RegionName>Pondicherry</RegionName>| &&
|<Street></Street>| &&
|</ShipToParty>| &&
|<SoldToParty>| &&
|<AddressID>144</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>TEST CUSTOMER</AddressLine2Text>| &&
|<AddressLine3Text>ccalbuyer6@ccal.in</AddressLine3Text>| &&
|<AddressLine4Text>NO.7 Balaji Street</AddressLine4Text>| &&
|<AddressLine5Text>605001 Puducherry</AddressLine5Text>| &&
|<AddressLine6Text></AddressLine6Text>| &&
|<AddressLine7Text></AddressLine7Text>| &&
|<AddressLine8Text></AddressLine8Text>| &&
|<AddressType>1</AddressType>| &&
|<FullName>TEST CUSTOMER</FullName>| &&
|<Partner>100001</Partner>| &&
|<PartnerFunction>SP</PartnerFunction>| &&
|<PartnerFunctionName>Sold-to Party</PartnerFunctionName>| &&
|<Person></Person>| &&
|</SoldToParty>| &&
|<Supplier>| &&
|<AddressID>211</AddressID>| &&
|<AddressLine1Text>Company</AddressLine1Text>| &&
|<AddressLine2Text>CCAL-Chemicals</AddressLine2Text>| &&
|<AddressLine3Text>1 GNANANANDA PLACE, ECR ROAD,KALAPET</AddressLine3Text>| &&
|<AddressLine4Text>605014 PUDUCHERRY</AddressLine4Text>| &&
|<AddressLine5Text></AddressLine5Text>| &&
|<AddressLine6Text></AddressLine6Text>| &&
|<AddressLine7Text></AddressLine7Text>| &&
|<AddressLine8Text></AddressLine8Text>| &&
|<AddressType></AddressType>| &&
|<CompanyCode>1000</CompanyCode>| &&
|<CompanyName></CompanyName>| &&
|<Country></Country>| &&
|<EmailAddress></EmailAddress>| &&
|<FullName></FullName>| &&
|<Person></Person>| &&
|<PhoneNumber></PhoneNumber>| &&
|<Region>PY</Region>| &&
|<RegionName>Pondicherry</RegionName>| &&
|</Supplier>| &&
|<TaxationTerms>| &&
|<CompanyVATRegistration>IN123456789</CompanyVATRegistration>| &&
|<CustomerICNumber></CustomerICNumber>| &&
|<CustomerTINNumber></CustomerTINNumber>| &&
|<CustomerVATRegistration></CustomerVATRegistration>| &&
|<ID_CompanyCodeTIN></ID_CompanyCodeTIN>| &&
|<IN_BillToPtyGSTIdnNmbr>123456789990</IN_BillToPtyGSTIdnNmbr>| &&
|<IN_GSTIdentificationNumber>34AADCT1820F1ZT</IN_GSTIdentificationNumber>| &&
|<IN_ShipToPtyGSTIdnNmbr>123456789990</IN_ShipToPtyGSTIdnNmbr>| &&
|<ShipToPartyProvSlsTaxRegnNmbr></ShipToPartyProvSlsTaxRegnNmbr>| &&
|<SupplierICNumber></SupplierICNumber>| &&
|<TaxDepartureCountry>IN</TaxDepartureCountry>| &&
|<TaxNumber0></TaxNumber0>| &&
|<TaxNumber1></TaxNumber1>| &&
|<TaxNumber2></TaxNumber2>| &&
|<TaxNumber3>123456789990</TaxNumber3>| &&
|<TaxNumber4></TaxNumber4>| &&
|<TaxNumber5></TaxNumber5>| &&
|<VATRegistrationCountryName>India</VATRegistrationCountryName>| &&
|<VATRegistrationOrigin>A</VATRegistrationOrigin>| &&
|<VATRegistrationOriginName>Ship-to Party</VATRegistrationOriginName>| &&
|</TaxationTerms>| &&
|<TextElements/>| &&
|<VATSummary/>| &&
|</BillingDocumentNode>| &&
|</Form>|.

    DATA: lv_formb64 TYPE xstring,
          lv_dscb64  TYPE string.

    DATA(lv_base64_data) = cl_web_http_utility=>encode_base64( unencoded = lv_xml ).


**********************************************************************
    TRY.

        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
        comm_scenario = 'ZADS_CS'
        comm_system_id = 'ZADS'
        service_id = 'ZADS_OUT_REST'      ).

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


    DATA: ls_req         TYPE zsd_app05_str1,
          ls_dscresponse TYPE zsd_app05_str2,
          ls_response    TYPE zsd_app05_str2.

    ls_req-xdp_template = 'ZPNDYFGINV/ZPFITEMP'.
    ls_req-xml_data     = lv_base64_data.
    ls_req-form_type    = 'print'.
    ls_req-form_locale  = 'en_US'.
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

    DATA(lv_respons) = lo_response->get_text(  ).
    DATA(ls_stas) = lo_response->get_status(  ).

    TRY.
        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json          = lv_respons
            assoc_arrays  = abap_true
            name_mappings = VALUE #( ( json = 'filecontent' abap = 'FILECONTENT' ) )
          CHANGING
            data          = ls_response.
      CATCH cx_root INTO lx_root.

    ENDTRY.

    DATA(lv_basecode) = ls_response-filecontent.

************************************************************************
*      """ HTTP Communication via URL   """

    DATA: lv_url            TYPE string,

          lv_request_string TYPE string,
          lo_http_response  TYPE REF TO if_web_http_response.
    DATA: lo_http_destination TYPE REF TO if_http_destination,
          lo_http_client      TYPE REF TO if_web_http_client,
          lv_response         TYPE string,
          lv_dscrespb1        TYPE string.

    "  static link
    lv_url = |https://esign.chemfabalkalis.com:810/Sandbox_RESTAPI/SignPDF_Base64String|.
    lv_request_string = lv_url.  "|/?pdfByte1=| && lv_base64_data.
************************************************************************
    TRY.
        " Create HTTP destination via URL
        lo_http_destination = cl_http_destination_provider=>create_by_url( lv_request_string ).
        " Create HTTP client by HTTP destination
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).
        " adding Header fields
        DATA(lo_httpreqst) = lo_http_client->get_http_request(  ).
        lo_httpreqst->set_header_field( i_name  = 'Authorization'
                            i_value = 'Basic UnNjI0AxIWVSMDk0NDUkQHN2YjpzY0VSTDBAIUdAY3ZydGN4Ug==' ).
        lo_httpreqst->set_content_type( 'application/json' ).
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
&& lv_basecode
&&  '" }'
                    ).
        " execute HTTP POST-request and store response
        lo_http_response = lo_http_client->execute( if_web_http_client=>post ).

        DATA(ls_status) = lo_http_response->get_status(  ).

        lv_dscrespb1 = lo_http_response->get_text(  ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error1).
*        RAISE EXCEPTION TYPE cx_web_http_client_error.
*        DATA(lv_1) = 1.
*        RAISE EXCEPTION TYPE cx_http_dest_provider_error.
        DATA(lv_2) = 2.
    ENDTRY.
    IF lv_dscrespb1 IS NOT INITIAL.


      TRY.
          CALL METHOD /ui2/cl_json=>deserialize
            EXPORTING
              json          = lv_dscrespb1
              assoc_arrays  = abap_true
              name_mappings = VALUE #( ( json = 'file' abap = 'FILECONTENT' ) )
            CHANGING
              data          = ls_dscresponse.
        CATCH cx_root INTO lx_root.

      ENDTRY.

      DATA(lv_print_data) = cl_web_http_utility=>decode_x_base64( encoded = ls_dscresponse-filecontent  ).
      DATA(lv_qitem_id)  = cl_print_queue_utils=>create_queue_itemid(  ).

      zbp_sd_app05_rv=>gs_print_data = lv_print_data.
      zbp_sd_app05_rv=>gs_pqitem_id = lv_qitem_id.

    ENDIF.
************************************************************************

**

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsd_app05_rv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsd_app05_rv IMPLEMENTATION.

  METHOD save_modified.
    IF zbp_sd_app05_rv=>gs_print_data IS NOT INITIAL.
      DATA(wa_print_data) = zbp_sd_app05_rv=>gs_print_data.
      DATA(wa_pqitem_id) = zbp_sd_app05_rv=>gs_pqitem_id.


      cl_print_queue_utils=>create_queue_item_by_data(
        EXPORTING
          iv_qname            = 'ZPRINT'
          iv_print_data       =  wa_print_data
          iv_name_of_main_doc = 'DSC-' && 'GOPA1001001'
          iv_itemid           = wa_pqitem_id
        IMPORTING
          ev_err_msg          = DATA(gs_error_msg)
      ).
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
