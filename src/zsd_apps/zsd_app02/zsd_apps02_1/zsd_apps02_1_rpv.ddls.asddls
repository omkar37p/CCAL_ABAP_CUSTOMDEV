@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Weigh Scale Division wise'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APPS02_1_RPV
  provider contract transactional_query
  as projection on ZSD_APPS02_1_RV
{
      @EndUserText.label: 'Division'
  key Division,
      @UI.hidden: true
  key Language,
      @EndUserText.label: 'Division Name'
      Divisionname,
      @EndUserText.label: 'Is Weigh-Scale Active'
      Whgmark,
      @EndUserText.label: 'Concentration Rate Needed'
      Cncmark
}
