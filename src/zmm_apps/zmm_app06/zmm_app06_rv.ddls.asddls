@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Budget Maintenance Root'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP06_RV
  as select from zmm_app06_tb1
  association [0..1] to ZI_BDGTYP as _bdgtyp on $projection.Bdgtype = _bdgtyp.value_low
{
  key plant     as Plant,
  key deptid    as Deptid,
  key bdgcode   as Bdgcode,
      validon   as Validon,
      validto   as Validto,
      plntname  as Plntname,
      deptname  as Deptname,
      @Semantics.amount.currencyCode: 'Curky'
      allcbdg   as Allcbdg,
      bdghtxt   as Bdghtxt,
      bdgtype   as Bdgtype,
      wbselmt   as Wbselmt,
      exmptmrk  as ExmptMrk,
      delemrk   as Delemrk,
      curky     as Curky,
      @Semantics.systemDateTime.createdAt: true
      createdat as Createdat,
      @Semantics.user.createdBy: true
      createdby as Createdby,
      _bdgtyp
}
where
  delemrk is initial
