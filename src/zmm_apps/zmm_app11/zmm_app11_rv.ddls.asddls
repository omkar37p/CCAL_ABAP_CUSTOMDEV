@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Utilization Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP11_RV
  as select from ZMM_APP11_BDGHDR
  composition [0..*] of ZMM_APP11_IV1 as _poline
{
  key Bdgcode,
      Plant,
      Deptid,
      Validon,
      Validto,
      Plntname,
      Deptname,
      Curky,
      @Semantics.amount.currencyCode: 'Curky'
      Basebdg,
      @Semantics.amount.currencyCode: 'Curky'
      Talcbdg,
      Bdghtxt,
      Bdgtype,
      @Semantics.amount.currencyCode: 'Curky'
      totpoamt,
//      @Semantics.amount.currencyCode: 'Curky'
//      cast((cast(Talcbdg as abap.fltp) - cast(totpoamt as abap.fltp) ) as abap.curr( 13, 2)) as bdgbal, ////""""reversed code by 20.06.2026
      
@Semantics.amount.currencyCode: 'Curky'
cast(
      ( coalesce( cast( Talcbdg  as abap.fltp ), 0 ) -
        coalesce( cast( totpoamt as abap.fltp ), 0 ) )
      as abap.curr( 13, 2 )
    ) as BdgBal,
////""""reversed code by 20.06.2026            
//      case
//      when totpoamt is not initial then
//      cast((cast(Talcbdg as abap.fltp) - cast(totpoamt as abap.fltp) ) as abap.curr( 13, 2))
//      else
//      cast((cast(Talcbdg as abap.fltp)  ) as abap.curr( 13, 2))
//      end as bdgbal,
////""""reversed code by 20.06.2026
      _poline
}
