@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mode of Transport VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS 
define view entity ZI_TRANSMODE
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZD_TRANSMODE')

{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @Semantics.language: true
      @UI.hidden: true
  key language,
      @EndUserText.label: 'Mode of Transport'
      @ObjectModel.text.element: [ 'text' ]
      value_low,
      @Semantics.text: true
      text
}
