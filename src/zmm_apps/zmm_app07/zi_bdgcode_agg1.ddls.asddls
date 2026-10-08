@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget Code - Aggregated Amount'
@Metadata.ignorePropagatedAnnotations: true 
define view entity ZI_BDGCODE_AGG1
  as select from ZMM_APP09_IV1 as itm
    inner join   ZMM_APP09_RV  as _vld on  _vld.Plant  = itm.Plant
                                       and _vld.Deptid = itm.Deptid
                                       and _vld.Uuid   = itm.Uuid
{
  key itm.Plant          as Plant,
  key itm.Deptid         as Deptid,
  key itm.Uuid           as Uuid,
  key itm.Bdgcode        as Bdgcode,
      itm.Curky          as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      sum( itm.Allcbdg ) as totamt
}
where
      itm.Actstss  =  'X'
//  and _vld.Validon <= $session.system_date
//  and _vld.Validto >= $session.system_date
  and _vld.Delemrk <> 'X'
group by
  itm.Plant,
  itm.Deptid,
  itm.Uuid,
  itm.Bdgcode,
  itm.Curky
