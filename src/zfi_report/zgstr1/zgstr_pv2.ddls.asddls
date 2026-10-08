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
define root view entity ZGSTR_PV2
  provider contract transactional_query
  as projection on ZGSTR_RE1

{

  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key AccountingDocumentItem,
  key TaxReportingDate,
      TaxCode,
      GLAccount,
      Material,
      Plant,
     //// ProfitCenter,
      PlaceOfSupply1,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,
      TransactionCurrency,
      AccountingDocumentType,
      DocumentDate,
      PostingDate,                                                    //                            
      HSNCode,                                                       // HSN / Control Code
      ITEMDescription,                                               //Item Decription
      UOM,
      @Semantics.quantity.unitOfMeasure: 'UOM'                       // UNIT
    @Aggregation.default: #SUM @Aggregation.exception: #LAST
    QUANTITY,                                                       // QUANTITY
    
      DocumentReferenceID,
      AccountingDocumentHeaderText,
      ////IsReversal,
      ////IsReversed,
      ////taxtype,
      ////zprocedure,
      ////taxate,
      ////      taxate,
      PriceUnit,
      CurrencyCode1,
      PriceUnit1,
      PlaceOfSupply,
     @Semantics.amount.currencyCode: 'PriceUnit'
      cgstamount,
      @Semantics.amount.currencyCode: 'CurrencyCode1'
      sgstamount,
      @Semantics.amount.currencyCode: 'PriceUnit1'
      igstamount
   
}
