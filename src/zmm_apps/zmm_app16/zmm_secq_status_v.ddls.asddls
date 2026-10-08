@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Outward Processing Security Check Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_SECQ_STATUS_V as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZMM_SECQ_STATUS' )
{
     @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @Semantics.language: true
      @UI.hidden: true
  key language,
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: [ 'text' ]
      value_low,
      @Semantics.text: true
      text
}
