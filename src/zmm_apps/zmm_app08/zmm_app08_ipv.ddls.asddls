@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department Base Budget - Child PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP08_IPV
  as projection on ZMM_APP08_IV
{
      @ObjectModel.text.element: [ 'Plntname' ]
  key Plant,
      @ObjectModel.text.element: [ 'Deptname' ]
  key Deptid,
  key Bdgyear,
  key Itemno,
      @EndUserText.label: 'Remarks'
      Remarks,
      Curky,
      Deptname,
      Plntname,
      @Semantics.amount.currencyCode: 'Curky'
      @EndUserText.label: 'Base Amount'
      Allcbdg,
      @Semantics.user.createdBy: true
      Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      Localcreatedat,
      /* Associations */
      _Header : redirected to parent ZMM_APP08_RPV
}
