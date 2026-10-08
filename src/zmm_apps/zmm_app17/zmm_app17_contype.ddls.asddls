@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item Condition Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP17_CONTYPE 
  as select from I_PurOrdItmPricingElementAPI01
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key PricingDocument,
  key PricingDocumentItem,
  key PricingProcedureStep,
  key PricingProcedureCounter,
      ConditionCurrency,
      ConditionType,
      @Semantics.amount.currencyCode: 'ConditionCurrency'
      ConditionAmount,
      cast(ConditionRateValue as abap.dec( 24, 2 )) as ConditionRate
    
}
