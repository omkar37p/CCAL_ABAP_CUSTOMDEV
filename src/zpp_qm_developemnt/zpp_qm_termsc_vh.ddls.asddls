@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Terms Condition Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP , resultSet.sizeCategory: #XS }
@Search.searchable: true
define view entity zpp_qm_termsc_vh as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZTERMCONDITION')
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @Semantics.language: true
      @UI.hidden: true
  key language,
      @EndUserText.label: 'Header Desc.'
      @ObjectModel.text.element: [ 'text' ]
      value_low,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      text
    
}
