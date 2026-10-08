@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Maintenance'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP09_RV
  as select from zmm_app09_tb1
  composition [0..*] of ZMM_APP09_IV1 as _Item
  association [0..*] to ZI_BDGTYP     as _bdgtyp on $projection.Bdgtype = _bdgtyp.value_low
{
  key plant     as Plant,
  key deptid    as Deptid,
  key uuid      as Uuid,
      bdgcode   as Bdgcode,
      validon   as Validon,
      validto   as Validto,
      plntname  as Plntname,
      deptname  as Deptname,
      curky     as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      basebdg   as Basebdg,
      @Semantics.amount.currencyCode: 'Curky'
      talcbdg   as Talcbdg,
      bdghtxt   as Bdghtxt,
      bdgtype   as Bdgtype,
      wbselmt   as Wbselmt,
      exmptmrk  as Exmptmrk,
      delemrk   as Delemrk,
      @Semantics.systemDateTime.createdAt: true
      createdat as Createdat,
      @Semantics.user.createdBy: true
      createdby as Createdby,
      _bdgtyp,
      _Item
}
//where
//  delemrk is initial
