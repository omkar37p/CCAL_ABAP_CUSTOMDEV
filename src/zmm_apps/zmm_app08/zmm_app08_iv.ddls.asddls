@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department Base Budget - Child Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP08_IV
  as select from zmm_app08_tb2
  association to parent ZMM_APP08_RV as _Header on  $projection.Plant   = _Header.Plant
                                                and $projection.Deptid  = _Header.Deptid
                                                and $projection.Bdgyear = _Header.Bdgyear
{
  key plant          as Plant,
  key deptid         as Deptid,
  key bdgyear        as Bdgyear,
  key itemno         as Itemno,
      remarks        as Remarks,
      curky          as Curky,
      deptname       as Deptname,
      plntname       as Plntname,
      @Semantics.amount.currencyCode: 'Curky'
      allcbdg        as Allcbdg,
      @Semantics.user.createdBy: true
      localcreatedby as Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      localcreatedat as Localcreatedat,
      _Header
}
