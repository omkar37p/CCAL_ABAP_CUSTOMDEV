@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Weigh Scale Division wise'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APPS02_1_RV
  as select from zsd_apps02_1_tb1
{
  key division     as Division,
  key language     as Language,
      divisionname as Divisionname,
      whgmark      as Whgmark,
      cncmark      as Cncmark
}
