@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Code VH' 
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S, 
    dataClass: #MIXED
}
define view entity ZI_BDGCODE_VH2
  as select distinct from ZMM_APP09_IV1   as itm
    left outer join       ZMM_APP05_RV    as usr on  usr.Plant  = itm.Plant
                                                 and usr.Deptid = itm.Deptid
    inner join            ZI_BDGCODE_AGG1 as bdc on  bdc.Plant  = itm.Plant
                                                 and bdc.Deptid = itm.Deptid
                                                 and bdc.Uuid   = itm.Uuid
  //    association [0..*] to ZMM_APP09_IV1 as _itm on  $projection.plant   = bdc.Plant
  //                                               and $projection.deptid  = bdc.Deptid
  //                                               and $projection.bdgcode = bdc.Bdgcode
{
      @EndUserText.label: 'Budget Code'
      @UI.facet: [{position: 10 }]
  key itm.Uuid     as bdgcode,
      @EndUserText.label: 'Budget Desc.'
      @UI.facet: [{position: 20 }]
      itm.Bdgitxt  as bdgitxt,
      @EndUserText.label: 'Department'
      @UI.facet: [{position: 30 }]
      usr.Deptid   as deptid,
      @EndUserText.label: 'Department Name'
      @UI.facet: [{position: 40 }]
      usr.Deptname as deptname,
      @UI.hidden: true
      bdc.Curky    as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      @EndUserText.label: 'Budget Allotted'
      @UI.facet: [{position: 50 }]
      bdc.totamt   as totamt,
      @EndUserText.label: 'Plant'
      @UI.facet: [{position: 60 }]
      usr.Plant    as plant,
      @EndUserText.label: 'Plant Name'
      @UI.facet: [{position: 70 }]
      usr.Plntname as plntname,
      @EndUserText.label: 'User ID'
      @UI.facet: [{position: 80 }]
      @UI.hidden: true
      usr.Userid   as userid,
      @EndUserText.label: 'User Name'
      @UI.facet: [{position: 90 }]
      @UI.hidden: true
      usr.Username as username
}
where
      usr.Delmrk <> 'X'
  and usr.Userid = $session.user
