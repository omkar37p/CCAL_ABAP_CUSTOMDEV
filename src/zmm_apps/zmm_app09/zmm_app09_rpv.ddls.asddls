@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Maintenance'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP09_RPV
  provider contract transactional_query
  as projection on ZMM_APP09_RV
{
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'Plntname' ]
  key Plant,
      @EndUserText.label: 'Department'
      @ObjectModel.text.element: [ 'Deptname' ]
  key Deptid,
  key Uuid,
      Bdgcode,
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
      Wbselmt,
      Exmptmrk,
      Delemrk,
      Createdat,
      Createdby,
      /* Associations */
      //      _bdgtyp,
      _Item : redirected to composition child ZMM_APP09_IPV1
}
