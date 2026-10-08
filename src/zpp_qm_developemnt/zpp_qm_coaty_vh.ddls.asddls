@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA TYPE VALUE HELP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP , resultSet.sizeCategory: #XS  }
@Search.searchable: true
define view entity ZPP_QM_COATY_VH 
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZQMPP_COA_DES01')
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
@Search.defaultSearchElement: true      
      value_low,
      @Semantics.text: true
      text

}
