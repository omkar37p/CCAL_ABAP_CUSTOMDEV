@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR Line Item PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{ 
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP07_IPV1
  as projection on ZMM_APP07_IV1
{
  key Uuid,
      @EndUserText.label: 'Item No.'
  key Purreqitm,
      @ObjectModel.text.element: [ 'Matdesc' ]
      @EndUserText.label: 'Material'
      Material,
      Matdesc,
      Matgrp,
      @ObjectModel.text.element: [ 'Plantdesc' ]
      @EndUserText.label: 'Plant'
      Plant,
      Plantdesc,
      @ObjectModel.text.element: [ 'Purgrpdesc' ]
      Purgrp,
      Purgrpdesc,
      Delvdate,
      Purorg,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      @EndUserText.label: 'Requested Quantity'
      Reqqty,
      Uom,
      @Semantics.amount.currencyCode: 'Currency'
      Valprice,
      @Semantics.amount.currencyCode: 'Currency'
      Totvalue,
      @Semantics.amount.currencyCode: 'Currency'
      Alltbdgamt,
      @Semantics.amount.currencyCode: 'Currency'
      Avlbdgamt,
      Currency,
      Userid,
      Deptid,
      Bdgcode,
      Bdghtxt,
      Wbselmt,
      Delmark,
      @Semantics.user.createdBy: true
      ItemCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      ItemCreatedAt,
      @Semantics.user.lastChangedBy: true
      ItemLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      ItemLastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      ItemLocalLastChangedAt,
      /* Associations */
      _Header : redirected to parent ZMM_APP07_RPV
}
