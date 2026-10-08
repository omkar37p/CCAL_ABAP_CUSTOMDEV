@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revenue'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.supportedCapabilities: [#SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE, #CDS_MODELING_ASSOCIATION_TARGET]
define view entity ZAPP02_REVENUE
as select from Z_MANFACT_AGG 
{
  key  CompanyCode,
       Fiscal_Period,
       Fiscal_Year,
       GLAccount,
       Product,

     @Semantics.amount.currencyCode: 'TransactionCurrency'
     sum(AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency,

    TransactionCurrency
}
group by 

CompanyCode,
Fiscal_Period,
Fiscal_Year,
GLAccount,
Product,
TransactionCurrency;








//  as select from Z_MANFACT_AGG
//{
//    key CompanyCode,
//     
//      Fiscal_Period,
//
//      Fiscal_Year,
//
//     GLAccount,
//
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    sum( AmountInCompanyCodeCurrency ) as AmountInCompanyCodeCurrency,
//
//    TransactionCurrency
//}
//
//group by
//    CompanyCode,
//    Fiscal_Period,
//    Fiscal_Year,
//    GLAccount,
//    TransactionCurrency
//
//





//define view entity ZAPP02_REVENUE as select from I_JournalEntryItem 
//{
//    key AccountingDocument,
//    CompanyCode,
//    PostingDate,
//
//        substring( PostingDate, 5, 2 ) as Month_R,
//        substring( PostingDate, 1, 4 ) as Year_R,
//    GLAccount,
//    Product,
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    AmountInCompanyCodeCurrency,
//    TransactionCurrency    
//    
//}
//where 
//    GLAccount = '0000400000'
// or GLAccount = '0000400001'
// or GLAccount = '0000400002';
//// group by 
//// AccountingDocument,
//// CompanyCode,
//// PostingDate,
//// GLAccount,
//// Product,
//// AmountInCompanyCodeCurrency,
//// TransactionCurrency
 
