@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Budget Type VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_BDGTYP
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZBUDGETTYPE')
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @Semantics.language: true
      @UI.hidden: true
  key language,
      @EndUserText.label: 'Budget Type'
      @ObjectModel.text.element: [ 'text' ]
      value_low,
      @Semantics.text: true
      text
}
