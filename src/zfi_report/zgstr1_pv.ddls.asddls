@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZGSTR1_PV
  provider contract transactional_query
  as projection on ZGSTR1_RE

{

  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key AccountingDocumentItem,
      TaxCode,
      GLAccount,
      Material,
      Plant,
      ProfitCenter,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,
      TransactionCurrency,
      AccountingDocumentType,
      DocumentDate,
      PostingDate,
      TaxReportingDate,
      DocumentReferenceID,
      AccountingDocumentHeaderText,
      IsReversal,
      IsReversed,
      //taxtype,
      //zprocedure,
      //taxate,
      //      taxate,
      PriceUnit,
      CurrencyCode1,
      PriceUnit1,
     
     
      @Semantics.amount.currencyCode: 'PriceUnit'
      cgstamount,
      @Semantics.amount.currencyCode: 'CurrencyCode1'
      sgstamount,
      @Semantics.amount.currencyCode: 'PriceUnit1'
      igstamount
}
