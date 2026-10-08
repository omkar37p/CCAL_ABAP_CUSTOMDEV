@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Code VH1' 
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BDGCODE_VH1
  as select from zmm_app05_tb1   as usr
    inner join   zmm_app09_tb1   as dep on  dep.plant  = usr.plant
                                        and dep.deptid = usr.deptid
    inner join   ZI_BDGCODE_AGG2 as bdc on  bdc.Plant   = dep.plant
                                        and bdc.Deptid  = dep.deptid
                                        and bdc.Uuid    = dep.uuid
                                        and bdc.Bdgcode = dep.bdgcode
{
       @EndUserText.label: 'Budget Code'
  key  dep.bdgcode  as bdgcode,
       @EndUserText.label: 'Budget Desc.'
       dep.bdghtxt  as bdghtxt,
       @EndUserText.label: 'Budget Type'
       dep.bdgtype  as bdgtype,
       @Semantics.amount.currencyCode: 'Curky'
       @EndUserText.label: 'Budget Amount'
       bdc.totamt   as totamt,
       @EndUserText.label: 'Plant'
       usr.plant    as plant,
       @UI.hidden: true
       usr.deptid   as deptid,
       @EndUserText.label: 'Plant Name'
       usr.plntname as plntname,
       @EndUserText.label: 'Department'
       usr.deptname as deptname,
       @EndUserText.label: 'User ID'
       @UI.hidden: true
       usr.userid   as userid,
       @UI.hidden: true
       bdc.Curky    as Curky

}
where
      usr.delmrk <> 'X'
  and usr.userid = $session.user
