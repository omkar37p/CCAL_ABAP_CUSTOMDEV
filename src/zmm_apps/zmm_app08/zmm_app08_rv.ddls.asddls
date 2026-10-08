@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department Base Budget - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP08_RV
  as select from zmm_app08_tb1
  composition [0..*] of ZMM_APP08_IV as _Item
{
  key plant     as Plant,
  key deptid    as Deptid,
  key bdgyear   as Bdgyear,
      validon   as Validon,
      validto   as Validto,
      deptname  as Deptname,
      plntname  as Plntname,
      @Semantics.amount.currencyCode : 'Curky'
      allcbdg   as Allcbdg,
      curky     as Curky,
      delemrk   as Delemrk,
      @Semantics.systemDateTime.createdAt: true
      createdat as Createdat,
      @Semantics.user.createdBy: true
      createdby as Createdby,
      _Item
}
where
  delemrk <> 'X'
