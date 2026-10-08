@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Form Data Provider - Domestic Invoices'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFDP_DMINV01
  as select from    I_BillingDocumentBasic        as bdb
    left outer join      I_CompanyCode                 as cc      on  cc.CompanyCode = bdb.CompanyCode
                                                             and cc.Language    = $session.system_language
    left outer join      I_BillingDocumentTypeText_2   as bdt     on  bdt.BillingDocumentType = bdb.BillingDocumentType
                                                             and bdt.Language            = $session.system_language
    left outer join      I_SalesOrganizationText       as sot     on  sot.SalesOrganization = bdb.SalesOrganization
                                                             and sot.Language          = $session.system_language
    left outer join      I_DistributionChannelText     as dct     on  dct.DistributionChannel = bdb.DistributionChannel
                                                             and dct.Language            = $session.system_language
    left outer join      I_DivisionText                as dvt     on  dvt.Division = bdb.Division
                                                             and dvt.Language = $session.system_language
    left outer join      I_InvoiceListTypeText         as ilt     on  ilt.InvoiceListType = bdb.InvoiceListType
                                                             and ilt.Language        = $session.system_language
    left outer join      I_ShippingConditionText       as sct     on  sct.ShippingCondition = bdb.ShippingCondition
                                                             and sct.Language          = $session.system_language
    left outer join      I_IncotermsClassificationText as ict     on  ict.IncotermsClassification = bdb.IncotermsClassification
                                                             and ict.Language                = $session.system_language
    left outer join      I_PaymentTermsText            as pyt     on  pyt.PaymentTerms = bdb.CustomerPaymentTerms
                                                             and pyt.Language     = $session.system_language
    left outer join I_Customer                    as pyr     on pyr.Customer = bdb.PayerParty
    left outer join      I_BusinessPartner             as stt     on stt.BusinessPartner = bdb.SoldToParty
  //                                                      and stt.Language        = $session.system_language
    left outer join      I_OverallBillingStatusText    as bst     on  bst.OverallBillingStatus = bdb.OverallBillingStatus
                                                             and bst.Language             = $session.system_language
    left outer join      I_BillingDocumentItemBasic    as _bid    on  _bid.BillingDocument     = bdb.BillingDocument
                                                             and _bid.BillingDocumentItem = '000010'
    left outer join      I_DeliveryDocumentItem        as _Did    on  _Did.DeliveryDocument     = _bid.ReferenceSDDocument
                                                             and _Did.DeliveryDocumentItem = _bid.ReferenceSDDocumentItem
    left outer join      I_DeliveryDocument            as _dhd    on _dhd.DeliveryDocument = _Did.DeliveryDocument
    left outer join I_Customer                    as _Shipto on _Shipto.Customer = _dhd.ShipToParty
    left outer join I_IN_ElectronicDocInvoice     as _Edoc   on _Edoc.ElectronicDocSourceKey = bdb.BillingDocument
    left outer join I_IN_ElectronicDocTransptRegn as _Eway   on _Eway.ElectronicDocSourceKey = bdb.BillingDocument
    left outer join      I_SalesOrder                  as _so     on _so.SalesOrder = _Did.ReferenceSDDocument
    left outer join I_BuPaIdentification          as spn     on  spn.BusinessPartner      = _dhd.ShipToParty
                                                             and spn.BPIdentificationType = 'PAN'
    left outer join I_BuPaIdentification          as ppn     on  ppn.BusinessPartner      = bdb.PayerParty
                                                             and ppn.BPIdentificationType = 'PAN'
    left outer join      I_RegionText                  as srg     on  srg.Country = _Shipto.Country
                                                             and srg.Region  = _Shipto.Region
    left outer join      I_RegionText                  as prg     on  prg.Country = pyr.Country
                                                             and prg.Region  = pyr.Region
    left outer join  zsd_dsc_file_db as dscatt on dscatt.billdoc = bdb.BillingDocument
//    left outer join  ZI_CUST_ADDR1 as CusEmail on CusEmail.AddressID = pyr.AddressID
    left outer join I_BusinessUserBasic           as UserName    on UserName.UserID = bdb.CreatedByUser                                                           
{
  key bdb.CompanyCode                             as ccode,
  key bdb.BillingDocument                         as billdoc,
      bdb.BillingDocumentType                     as billtyp,
      bdb.SalesOrganization                       as sorg,
      bdb.DistributionChannel                     as distchn,
      bdb.Division                                as divsn,
      bdb.BillingDocumentDate                     as billdate,
      bdb.DocumentReferenceID                     as refdoc,
      bdb.InvoiceListType                         as invlstyp,
      bdb.ShippingCondition                       as shpcond,
      bdb.IncotermsClassification                 as incotyp,
      bdb.IncotermsLocation1                      as incoloc1,
      bdb.CustomerPaymentTerms                    as payterms,
      bdb.PayerParty                              as payer,
      bdb.SoldToParty                             as customer,
      bdb.OverallSDProcessStatus                  as sddocsts,
      bdb.OverallBillingStatus                    as billsts,
      bdb.AccountingPostingStatus,
      bdb.AccountingTransferStatus,
      bdb.TransactionCurrency                     as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      bdb.TotalNetAmount                          as Netamt,
      @Semantics.amount.currencyCode: 'Curky'
      bdb.TotalTaxAmount                          as Taxamt,
      @Semantics.amount.currencyCode: 'Curky'
      ( bdb.TotalNetAmount + bdb.TotalTaxAmount ) as Totamt,
      bdb.AccountingDocument                      as accdoc,
      bdb.InvoiceClearingStatus                   as clrsts,
      bdb.YY1_ModeOfTransport_BDH                 as ModeOfTransport,
      bdb.YY1_Transporter_BDH                     as Transporter,
      bdb.YY1_VehicleNumber_BDH                   as VehicleNumber,
      bdb.YY1_FreightTerms_BDH                    as FreightTerms,
      bdb.YY1_DriverDetails_BDH                   as DriverDetails,
      bdb.YY1_CylinderDetailSeal_BDH              as CylinderDetailSeal,
      _dhd.YY1_GrossWT_DLHU                       as Unit,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _dhd.YY1_GrossWT_DLH                        as GrossWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _dhd.YY1_TAREWT_DLH                         as TareWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _dhd.YY1_NETWT_DLH                          as NetWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _dhd.YY1_CONCN_DLH                          as ConcnWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _dhd.YY1_CHARWT_DLH                         as CharWT,
      _dhd.YY1_NOOFCylinder_DLH,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _dhd.YY1_VolumePerCylinder_DLH              as VolumePerCylinder,
      cc.CompanyCodeName                          as ccodetxt,
      bdt.BillingDocumentTypeName                 as billtyptxt,
      sot.SalesOrganizationName                   as sorgtxt,
      dct.DistributionChannelName                 as distchntxt,
      dvt.DivisionName                            as divsntxt,
      ilt.InvoiceListTypeName                     as invlstyptxt,
      sct.ShippingConditionName                   as shpcondtxt,
      ict.IncotermsClassificationName             as incotyptxt,
      pyt.PaymentTermsDescription                 as paytermstxt,
      stt.BusinessPartnerFullName                 as customertxt,
      ////Bill to party address details--------------------------
      pyr.Customer                                as Payerid,
      pyr.AddressID                               as Pyraddrid,
      pyr.BPCustomerFullName                      as payertxt,
      pyr.TaxNumber3                              as BilltoGSTIN,
      pyr.Country                                 as BilltoCountry,
      pyr.StreetName                              as BilltoStreetName,
      pyr.Region                                  as BilltoRegion,
      pyr.PostalCode                              as Billtopostalcode,
      pyr.TaxNumber3                              as payergst,
      ppn.BPIdentificationNumber                  as payerpan,
      prg.RegionName                              as pystate,
      ////Ship to party address details--------------------------
      _Shipto.AddressID                           as Shpaddrid,
      _Shipto.Customer                            as Shptoid,
      _Shipto.BPCustomerFullName                  as ShiptoCompanyName,
      _Shipto.TaxNumber3                          as ShiptoGSTIN,
      _Shipto.Country                             as ShiptoCountry,
      _Shipto.StreetName                          as ShiptoStreetName,
      _Shipto.Region                              as ShiptoRegion,
      _Shipto.PostalCode                          as Shiptopostalcode,
      _Shipto.TaxNumber3                          as shpgst,
      spn.BPIdentificationNumber                  as shppan,
      srg.RegionName                              as shstate,
      ////e-document details---------------------------------------
      _Edoc.IN_ElectronicDocInvcRefNmbr           as IRN,
      _Edoc.IN_ElectronicDocAcknDate              as AckDate,
      _Edoc.IN_ElectronicDocAcknNmbr              as AckNo,
      _Edoc.IN_ElectronicDocQRCodeTxt             as Qrcode,
      _Eway.IN_ElectronicDocEWbillNmbr            as EwaybillNo,
      _Eway.IN_EDocEWbillCreateDate               as EwaybillDate,
      bst.OverallBillingStatusDesc                as billststxt,
      _so.PurchaseOrderByCustomer                 as ordrefdat,
      _bid.Batch                                  as Batch,
      _bid.BillingDocumentItem                    as Itemno,
      _bid.BillingDocumentItemText                as Itemtxt,

      case
                  when _bid.Plant = '1100' then 'GNANANANDA PLACE, KALAPET, PUDUCHERRY-605014'
                  when _bid.Plant = '1200' then 'NO 1 CHUNAMPET ROAD VILLPAKKAM VILLAGE, CHEYYUR TALUK,CHENGALPATTU,TAMIL NADU-603401'
                  when _bid.Plant = '1300' then 'SAYALKUDI NO. 1,MOOKAIYUR SALAI, SAYALKUDI, RAMANATHAPURAM-623120'
                  when _bid.Plant = '2100' then 'NO 1,Industrial Growth Centre, Polagam Karaikal Puducherry-609606'
                  when _bid.Plant = '3100' then 'NO 650 CHIGURUPALEM ROAD, SRICITY-517646'
                  else null end                   as Street,
      case
          when _bid.Plant = '1100' then 'chemfabmktg@ccal.in'
          when _bid.Plant = '1200' then 'ccalsd1@ccal.in'
          when _bid.Plant = '1300' then 'ccalsd2@ccal.in'
          when _bid.Plant = '2100' then 'chemfabkaraikal@ckkl.in'
          when _bid.Plant = '3100' then 'ccalpvcomktg@ccal.in'
          else null end                           as Email,
      case
         when _bid.Plant = '1100' then 'L24290TN2009PLC071563'
         when _bid.Plant = '1200' then 'L24290TN2009PLC071563'
         when _bid.Plant = '1300' then 'L24290TN2009PLC071563'
         when _bid.Plant = '2100' then 'U24100TN2019PLC133285'
         when _bid.Plant = '3100' then 'L24290TN2009PLC071563'
         else null end                            as CIN,
      case
         when _bid.Plant = '1100' then '00 914132261000'
         when _bid.Plant = '1200' then '00 914132261000'
         when _bid.Plant = '1300' then '00 914132261000'
         when _bid.Plant = '2100' then '00 914368299110'
         when _bid.Plant = '3100' then '00 919489648419'
         else null end                            as Phone,
      case
         when _bid.Plant = '1100' then '(ISO 14001:2015 &amp; 45001:2018 CERTIFIED COMPANY)'
         when _bid.Plant = '1200' then ' '
         when _bid.Plant = '1300' then ' '
         when _bid.Plant = '2100' then ' '
         when _bid.Plant = '3100' then '(ISO 9001:2015 CERTIFIED COMPANY)'
         else null end                            as ISO,
      case
         when _bid.Plant = '1100' then '34AADCT1820F1ZT'
         when _bid.Plant = '1200' then '33AADCT1820F3ZT'
         when _bid.Plant = '1300' then '33AADCT1820F3ZT'
         when _bid.Plant = '2100' then '34AAICC5330L1ZN'
         when _bid.Plant = '3100' then '37AADCT1820F1ZN'
         else null end                            as GSTIN,
      case
         when _bid.Plant = '1100' then 'AADCT1820F'
         when _bid.Plant = '1200' then 'AADCT1820F'
         when _bid.Plant = '1300' then 'AADCT1820F'
         when _bid.Plant = '2100' then 'AAICC5330L'
         when _bid.Plant = '3100' then 'AADCT1820F'
         else null end                            as PAN,
      case
         when _bid.Plant = '1100' then 'CHEC13571F'
         when _bid.Plant = '1200' then 'CHEC13571F'
         when _bid.Plant = '1300' then 'CHEC13571F'
         when _bid.Plant = '2100' then 'CHEC14112A'
         when _bid.Plant = '3100' then 'CHEC13571F'
         else null end                            as TAN,
      ////dsc form-document details---------------------------------------         
         dscatt.attachment,
         dscatt.filename,
         dscatt.mimetype,
         dscatt.emailstatus,
         dscatt.dscstatus,
      case
         when dscatt.emailstatus = 'X' then 'Success'
         when ( dscatt.emailstatus is initial or dscatt.emailstatus is null ) then 'Not Success'         
         else  null end as EmailStausText,
      case
         when dscatt.dscstatus = 'X' then 'Success'
         when ( dscatt.dscstatus is initial or dscatt.dscstatus is null ) then 'Not Success'         
         else  null end as DSCStausText,         
//         CusEmail.EmailAddress,
         abap.string'InvoiceNo' as InvoiceText,
         bdb.CreatedByUser,
         UserName.PersonFullName 
         



}
