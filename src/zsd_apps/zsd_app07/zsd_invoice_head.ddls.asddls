@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Invoice Header CDS View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_INVOICE_HEAD
  as select from I_BillingDocumentBasic as _Bhd
  inner join I_BillingDocumentItemBasic as _bid on _bid.BillingDocument = _Bhd.BillingDocument
                                                and _bid.BillingDocumentItem = '000010'
  inner join I_DeliveryDocumentItem as _Did on _Did.DeliveryDocument = _bid.ReferenceSDDocument
                                                and _Did.DeliveryDocumentItem = _bid.ReferenceSDDocumentItem
  inner join I_DeliveryDocument as _dhd on _dhd.DeliveryDocument = _Did.DeliveryDocument
  inner join I_SalesOrderItem as _sid on _sid.SalesOrder = _Did.ReferenceSDDocument
                                       and _sid.SalesOrderItem = _Did.ReferenceSDDocumentItem
  inner join I_SalesOrder as _shd on _shd.SalesOrder = _sid.SalesOrder
  
  left outer join I_IN_ElectronicDocInvoice as _Edoc on _Edoc.ElectronicDocSourceKey = _Bhd.BillingDocument
  left outer join I_IN_ElectronicDocTransptRegn as _Eway on _Eway.ElectronicDocSourceKey = _Bhd.BillingDocument
  
  left outer join I_Customer as _Billto on _Billto.Customer = _Bhd.PayerParty
  left outer join I_Customer as _Shipto on _Shipto.Customer = _dhd.ShipToParty
  
{
    key _bid.BillingDocument as ReferenceNo,
    key _bid.BillingDocumentItem as InvoiceItem,
    key _Did.DeliveryDocument,
    key _Did.DeliveryDocumentItem,
    key _sid.SalesOrder,
    key _sid.SalesOrderItem,
        _Bhd.CreationDate as InvoiceDate,
        _Bhd.DocumentReferenceID as InvoiceNo,
        _Bhd.YY1_ModeOfTransport_BDH as ModeOfTransport,
        _Bhd.YY1_Transporter_BDH as Transporter,
        _Bhd.YY1_VehicleNumber_BDH as VehicleNumber,
        _Bhd.YY1_FreightTerms_BDH as FreightTerms,
        _Bhd.YY1_DriverDetails_BDH as DriverDetails,
        _Bhd.YY1_CylinderDetailSeal_BDH as CylinderDetailSeal,
        _dhd.YY1_GrossWT_DLHU as Unit,
        @Semantics.quantity.unitOfMeasure: 'Unit'
        _dhd.YY1_GrossWT_DLH as GrossWT,
        @Semantics.quantity.unitOfMeasure: 'Unit'        
        _dhd.YY1_TAREWT_DLH as TareWT,
        @Semantics.quantity.unitOfMeasure: 'Unit'        
        _dhd.YY1_NETWT_DLH as NetWT,
        @Semantics.quantity.unitOfMeasure: 'Unit'
        _dhd.YY1_CONCN_DLH as ConcnWT,
        @Semantics.quantity.unitOfMeasure: 'Unit'
        _dhd.YY1_CHARWT_DLH as CharWT,
        _dhd.YY1_NOOFCylinder_DLH,
        @Semantics.quantity.unitOfMeasure: 'Unit'        
        _dhd.YY1_VolumePerCylinder_DLH as VolumePerCylinder,
        _Edoc.IN_ElectronicDocInvcRefNmbr as IRN,
        _Edoc.IN_ElectronicDocAcknDate as AckDate,
        _Edoc.IN_ElectronicDocAcknNmbr as AckNo,
        _Eway.IN_ElectronicDocEWbillNmbr as EwaybillNo,
        _Eway.IN_EDocEWbillCreateDate as EwaybillDate,
        
////Bill to party address details--------------------------
        _Billto.BPCustomerFullName as BilltoCompanyName,
        _Billto.TaxNumber3 as BilltoGSTIN,
        _Billto.Country as BilltoCountry,
        _Billto.StreetName as BilltoStreetName,
        _Billto.Region as BilltoRegion,
        _Billto.PostalCode as Billtopostalcode,

////Ship to party address details--------------------------
        _Shipto.BPCustomerFullName as ShiptoCompanyName,
        _Shipto.TaxNumber3 as ShiptoGSTIN,
        _Shipto.Country as ShiptoCountry,
        _Shipto.StreetName as ShiptoStreetName,
        _Shipto.Region as ShiptoRegion,
        _Shipto.PostalCode as Shiptopostalcode,

/////CCAL Plant Wise Company Address
        _bid.Plant,
        case
            when _bid.Plant = '1100' then 'GNANANANDA PLACE, KALAPET, PUDUCHERRY-605014'
            when _bid.Plant = '1200' then 'NO 1 CHUNAMPET ROAD VILLPAKKAM VILLAGE, CHEYYUR TALUK,CHENGALPATTU,TAMIL NADU-603401'
            when _bid.Plant = '1300' then 'SAYALKUDI NO. 1,MOOKAIYUR SALAI, SAYALKUDI, RAMANATHAPURAM-623120'
            when _bid.Plant = '2100' then 'NO 1,Industrial Growth Centre, Polagam Karaikal Puducherry-609606'
            when _bid.Plant = '3100' then 'NO 650 CHIGURUPALEM ROAD, SRICITY-517646'                                                
            else null end as Street,
        case
            when _bid.Plant = '1100' then 'chemfabmktg@ccal.in'
            when _bid.Plant = '1200' then 'ccalsd1@ccal.in'
            when _bid.Plant = '1300' then 'ccalsd2@ccal.in'
            when _bid.Plant = '2100' then 'chemfabkaraikal@ckkl.in'
            when _bid.Plant = '3100' then 'ccalpvcomktg@ccal.in'                                                
            else null end as Email,            
         case
            when _bid.Plant = '1100' then 'L24290TN2009PLC071563'
            when _bid.Plant = '1200' then 'L24290TN2009PLC071563'
            when _bid.Plant = '1300' then 'L24290TN2009PLC071563'
            when _bid.Plant = '2100' then 'U24100TN2019PLC133285'
            when _bid.Plant = '3100' then 'L24290TN2009PLC071563'                                                
            else null end as CIN,
         case
            when _bid.Plant = '1100' then '00 914132261000'
            when _bid.Plant = '1200' then '00 914132261000'
            when _bid.Plant = '1300' then '00 914132261000'
            when _bid.Plant = '2100' then '00 914368299110'
            when _bid.Plant = '3100' then '00 919489648419'                                                
            else null end as Phone,
         case
            when _bid.Plant = '1100' then '(ISO 14001:2015 & 45001:2018 CERTIFIED COMPANY)'
            when _bid.Plant = '1200' then ' '
            when _bid.Plant = '1300' then ' '
            when _bid.Plant = '2100' then ' '
            when _bid.Plant = '3100' then '(ISO 9001:2015 CERTIFIED COMPANY)'                                                
            else null end as ISO,
         case
            when _bid.Plant = '1100' then '34AADCT1820F1ZT'
            when _bid.Plant = '1200' then '33AADCT1820F3ZT'
            when _bid.Plant = '1300' then '33AADCT1820F3ZT'
            when _bid.Plant = '2100' then '34AAICC5330L1ZN'
            when _bid.Plant = '3100' then '37AADCT1820F1ZN'                                                
            else null end as GSTIN,
         case
            when _bid.Plant = '1100' then 'AADCT1820F'
            when _bid.Plant = '1200' then 'AADCT1820F'
            when _bid.Plant = '1300' then 'AADCT1820F'
            when _bid.Plant = '2100' then 'AAICC5330L'
            when _bid.Plant = '3100' then 'AADCT1820F'                                                
            else null end as PAN,
         case
            when _bid.Plant = '1100' then 'CHEC13571F'
            when _bid.Plant = '1200' then 'CHEC13571F'
            when _bid.Plant = '1300' then 'CHEC13571F'
            when _bid.Plant = '2100' then 'CHEC14112A'
            when _bid.Plant = '3100' then 'CHEC13571F'                                                
            else null end as TAN                                                            
 }
