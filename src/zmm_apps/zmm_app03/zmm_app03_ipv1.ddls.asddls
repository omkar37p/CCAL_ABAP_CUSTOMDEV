@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item - Child PEntity1'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP03_IPV1
  as projection on ZMM_APP03_IV1
{
  key Uuid,
  key Ebelp,
      Ebeln,
      Matnr,
      Werks,
      Lgort,
      Matkl,
      Extmatgrp,
      @Semantics.quantity.unitOfMeasure: 'Bprme'
      Ktmng,
      @Semantics.quantity.unitOfMeasure: 'Bprme'
      Menge,
      Bprme,
      @Semantics.amount.currencyCode: 'Peinh'
      Netprice,
      @Semantics.amount.currencyCode: 'Peinh'
      Netvalue,
      @Semantics.amount.currencyCode: 'Peinh'
      Alltbdgamt,
      @Semantics.amount.currencyCode: 'Peinh'
      Avlbdgamt,
      Banfn,
      Bnfpo,
      Peinh,
      Meins,
      @Semantics.user.createdBy: true
      Itemcreatedby,
      @Semantics.systemDateTime.createdAt: true
      Itemcreatedat,
      @Semantics.user.lastChangedBy: true
      Itemlastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Itemlastchangedat,
      /* Associations */
      _Header : redirected to parent ZMM_APP03_RPV
}
