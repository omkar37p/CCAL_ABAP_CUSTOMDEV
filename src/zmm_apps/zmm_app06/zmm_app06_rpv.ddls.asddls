@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Budget  Root Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP06_RPV
  provider contract transactional_query
  as projection on ZMM_APP06_RV
{
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'Plntname' ]
  key Plant,
      @EndUserText.label: 'Department'
      @ObjectModel.text.element: [ 'Deptname' ]
  key Deptid,
  key Bdgcode,
      Validon,
      Validto,
      Plntname,
      Deptname,
      @Semantics.amount.currencyCode: 'Curky'
      Allcbdg,
      Bdghtxt,
      Bdgtype,
      Wbselmt,
      ExmptMrk,
      Delemrk,
      Curky,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.createdBy: true
      Createdby
}
