@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Procurement User Department VH'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DEPARTMENTVH1
  as select from I_ExtProdGrp
  association [0..*] to I_ExtProdGrpText as _Text on $projection.ExternalProductGroup = _Text.ExternalProductGroup
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.text.association: '_Text'

  key ExternalProductGroup,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      _Text.ExternalProductGroupName as Groupname,
      /* Associations */
      _Text
}
