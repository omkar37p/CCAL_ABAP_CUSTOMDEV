@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MANUFACTURIN AGG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_MANFACT_AGG  
 as select from I_JournalEntryItem
{
   key AccountingDocument,
    key AccountingDocumentItem,
    CompanyCode,
       PostingDate,
       Product,

     substring( PostingDate, 5, 2 ) as Fiscal_Period,

     substring( PostingDate, 1, 4 ) as Fiscal_Year,
     GLAccount,

    @Semantics.amount.currencyCode: 'TransactionCurrency'
     AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,

    TransactionCurrency
}
where
       GLAccount = '0000400000'
    or GLAccount = '0000400001'
    or GLAccount = '0000400002'
   
  









//  as select from ZAPP01_MANUFACTUIRNG
//{
//    key CompanyCode,
//    key ProductionUnit,
//
//    @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
//    sum( ActualDeliveredQuantity ) as ProductionQuantity
//}
//where CompanyCode = '1000'
//group by
//    CompanyCode,
//    ProductionUnit

