@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Departments Purchase Budget VH'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DEPARTMENT_VH1
  as select from zmm_app05_tb1
{

      @ObjectModel.text.element: [ 'plntname' ]
  key plant,
      @UI.hidden: true
  key userid,
      @EndUserText.label: 'Department ID'
  key deptid,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Department Description'
      deptname,
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'plant' ]
      plntname
}
where
  delmrk is initial
