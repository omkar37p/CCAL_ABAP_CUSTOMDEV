@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Report - BDG data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S, 
    dataClass: #MIXED
}
define view entity ZMM_APP11_BDG1
  as select from zmm_app09_tb1
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
      createdat as Createdat,
      createdby as Createdby
}
