@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Adobe Form Services'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBTP_ADOBE_CDS
  as select from zbtp_adobe_db
{
  key parameters   as Parameters,
      value        as Value,
      createdby    as Createdby,
      createdon    as Createdon,
      lastchangeby as Lastchangeby,
      lastchangeon as Lastchangeon
}
