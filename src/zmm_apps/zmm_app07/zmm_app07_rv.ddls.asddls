@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Header Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP07_RV
  as select from zmm_app07_tb1
  composition [0..*] of ZMM_APP07_IV1 as _Item
{
  key uuid               as Uuid,
      purreqnum          as Purreqnum,
      purreqdesc         as Purreqdesc,
      purreqtyp          as Purreqtyp,
      prtypdesc          as Prtypdesc,
      totitms            as Totitms,
      @Semantics.amount.currencyCode: 'Currency'
      totnet             as Totnet,
      userid             as userid,
      currency           as Currency,
      status             as Status,
      mark               as Mark,
      delmark            as Delmark,
      @Semantics.user.createdBy: true
      createdby          as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      createdat          as CreatedAt,
      @Semantics.user.lastChangedBy: true
      lastchangedby      as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as LocalLastChangedAt,
      _Item
}
