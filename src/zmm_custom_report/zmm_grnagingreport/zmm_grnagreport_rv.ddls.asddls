@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOT ENITITY FOR GRN AGING REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
 define root view entity ZMM_GRNAGREPORT_RV  as select from I_MaterialDocumentItem_2 as MDI 
 left outer join I_MaterialDocumentHeader_2 as MDH on MDH.MaterialDocument = MDI.MaterialDocument and 
                                                      MDH.MaterialDocumentYear = MDI.MaterialDocumentYear
 left outer join I_SuplrInvcItemPurOrdRefAPI01 as SI on //SIPOA.PurchaseOrderItemMaterial = MDI.Material and
                                                           //SIPOA.SupplierInvoice = MDI.MaterialDocument  AND
                                                           //SIPOA.SupplierInvoiceItem = MDI.MaterialDocumentItem  
                                                           SI.ReferenceDocument = MDI.InvtryMgmtReferenceDocument and
                                                           SI.ReferenceDocumentItem = MDI.InvtryMgmtRefDocumentItem and
                                                           SI.ReferenceDocumentFiscalYear = MDI.ReferenceDocumentFiscalYear and
                                                           SI.ReferenceDocument is not initial                                    //added for removing duplication in case of blank reference documents
                                                           //SI.DocumentCurrency = 'INR' 
left outer join I_ProductDescription    as PD on PD.Product = MDI.Material and PD.Language = 'E'                                                                                                              
left outer join I_BusinessPartner    as BP on BP.BusinessPartner = MDI.Supplier 
left outer join I_PurchaseOrderAPI01 as POA on POA.PurchaseOrder = MDI.PurchaseOrder 
//left outer join ZSD_APP03_RV         as ZSD on ZSD.material = MDI.Material                                            
{
key MDI.MaterialDocument                   as     GRNNO      ,
key MDI.MaterialDocumentItem               as     GRNItem,
key MDI.MaterialDocumentYear               as     GRNYear,
key MDI.CompanyCode                        as     COMPANYCODE,
    MDI.Plant                              as     PLANT      ,
    MDI.YY1_GATEENTRYNUMBER_MMI            as     GATEENTRYNO,
    MDI.PostingDate                        as     GRNDate,
    MDI.Supplier                           as     VendorCode ,
    MDI.PurchaseOrder                      as     PurchaseOrder,
    MDI.PurchaseOrderItem                  as     POItem      ,
    MDI.MaterialDocumentItemText           as     Remarks    ,
   // MDI.InventoryStockType                 as     StockType,
    case MDI.InventoryStockType
    when '01'  then   'Unrestricted-Use'
    when '02'  then   'Quality Inspection'
    when '03'  then   'Blocked'
    else ' '
    end as StockType,
    
    MDH.ReferenceDocument                  as     DeliveryNote,
    BP.BusinessPartnerFullName             as     SupplierName,
    MDI.Material                           as     MaterialCode,
    PD.ProductDescription                  as     MaterialDescription,  
    POA.PurchasingGroup                    as     PurchaseGroup,
    case POA.PurchasingGroup
    when '001' then 'GROUP 001'
    when '002' then 'GROUP 002'
    when '003' then 'GROUP 003'
    when 'P01' then 'MECHANICAL DEPT'
    when 'P02' then 'ELECTRICAL DEPT'
    when 'P03' then 'INST DEPT'
    when 'P04' then 'CIVIL DEPT'
    when 'P05' then 'PROCESS DEPT'
    when 'P06' then 'QA AND R & D DEPT'
    when 'P07' then 'HR & ADMIN DEPT'
    when 'P08' then 'MARKETING DEPT'
    when 'P09' then 'PROJECT DEPT'
    when 'P010' then 'IT DEPT'
    when 'P011' then 'SAFETY DEPT'
    when 'P012' then 'MATERIAL DEPT'
    when 'P013' then 'SECURITY DEPT'
    when 'P014' then 'FINANCE DPT'
    else 'DEPT'
    end as DEPARTMENT,
    
    MDI.EntryUnit                          as     UOM        ,
    @Semantics.quantity.unitOfMeasure: 'UOM'
    MDI.QuantityInEntryUnit                as     RecievedQuantity,
    MDI.GoodsMovementType                  as     MOVTYPE    ,
    //SI.DocumentCurrency                    as     Currency,
    MDI.CompanyCodeCurrency                as     Currency,
    @Semantics.amount.currencyCode: 'Currency'
    SI.SupplierInvoiceItemAmount           as     INVOICEAMOUNT,
    //cast( cast( $session.system_date as abap.int4 ) - cast( MDI.PostingDate as abap.int4 ) as abap.int2 ) as AgeingDays,
    dats_days_between( MDI.PostingDate, $session.system_date ) as AgeingDays,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) between 0 and 30 then SI.SupplierInvoiceItemAmount end as b0_30,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) between 31 and 60 then SI.SupplierInvoiceItemAmount end as b30_60,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) between 61 and 90 then SI.SupplierInvoiceItemAmount end as b60_90,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) between 91 and 120 then SI.SupplierInvoiceItemAmount end as b90_120,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) between 121 and 150 then SI.SupplierInvoiceItemAmount end as b120_150,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) between 151 and 180 then SI.SupplierInvoiceItemAmount end as b150_180,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) between 181 and 365 then SI.SupplierInvoiceItemAmount end as upto365,
    @Semantics.amount.currencyCode: 'Currency'
    case when dats_days_between( MDI.PostingDate, $session.system_date ) > 365 then SI.SupplierInvoiceItemAmount end as beyond1year
       } where MDI.GoodsMovementType = '101' or MDI.GoodsMovementType = '102' or MDI.GoodsMovementType = '103' 
