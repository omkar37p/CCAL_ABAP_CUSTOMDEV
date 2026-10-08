@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Report - BDG Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP11_BDGHDR
  as select from    ZMM_APP11_BDG1 as bdg1
//    left outer join ZMM_APP11_PO2  as po2 on bdg1.Bdgcode = po2.bgdcode   "old code 09/07/2026
left outer join ZI_PO_GR_AGG as po2 on bdg1.Bdgcode = substring( po2.BudgetCode, 4, 10 ) // new code added 09/07/2026
{
  key bdg1.Bdgcode,
      bdg1.Plant,
      bdg1.Deptid,
      bdg1.Validon,
      bdg1.Validto,
      bdg1.Plntname,
      bdg1.Deptname,
      bdg1.Curky,
      @Semantics.amount.currencyCode: 'Curky'
      bdg1.Basebdg,
      @Semantics.amount.currencyCode: 'Curky'
      bdg1.Talcbdg,
      bdg1.Bdghtxt,
      bdg1.Bdgtype,
      @Semantics.amount.currencyCode: 'Curky'
//      cast(po2.totpoamt  as abap.curr( 13, 2 ) ) as totpoamt
      cast(po2.UsedbdgAmt  as abap.curr( 13, 2 ) ) as totpoamt

}
where
  bdg1.Bdgcode <> '0000000000'   //""reversed code by 20.06.2026
