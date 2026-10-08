@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Key Register Report - PV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_POKEY_REPORT_PV
  provider contract transactional_query
  as projection on ZMM_POKEY_REPORT_RV
{
  key  PurchaseOrder,
  key  PurchaseOrderItem,
  key  PurchaseRequisition,
  key  Accno,
       PurchaseOrderType,
       PurchaseOrderDate,
       CompanyCode,
       CreatedByUser,
       PaymentTerms,
       IncotermsClassification,
       Vendor,
       Plant,
       Material,
       BaseUnit,
       YY1_budget_code_PDI,
       YY1_bdgdesc_PDI,
       DocumentCurrency,
       PoQty,
       UnitPrice,
       TaxableValue,
       CGSTAmount,
       SGSTAmount,
       IGSTAmount,
       GrossAmount,
       DiscountAmt,
       PurchaseReqCreationDate,
       RecQty,
       MaterialDocument,
       MaterialDocumentYear,
       DocumentDate,
       SupplierInvoice,
       vendorpaymentno,
       Vendorpaymentdate,
       VendorPayAmt,
       InvoiceNumber,
       _SUP.BPSupplierFullName as Vendorname,
       _SUP.TaxNumber3         as GSTIN,
       _SUP.CityName,
       _SUP.Region             as State,
       _SUP.Country,
       _PRDES.ProductDescription,
       _uname.PersonFullName,
//       PaymentAmount,
       /* Associations */
       _PRDES,
       _SUP,
       _uname
}
