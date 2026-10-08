@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Bill To Party F4 Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZF4_HELP_BILLTOPARTY as select from I_Customer as bill
{
  @EndUserText.label: 'Bill To Party Code'
  key bill.Customer,
  @EndUserText.label: 'Name'
      bill.CustomerName  
}
