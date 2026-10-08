@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item - Child Entity1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP03_IV1
  as select from zmm_app03_tb2
  association to parent ZMM_APP03_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid              as Uuid,
  key ebelp             as Ebelp,
      ebeln             as Ebeln,
      matnr             as Matnr,
      werks             as Werks,
      lgort             as Lgort,
      matkl             as Matkl,
      extmatgrp         as Extmatgrp,
      @Semantics.quantity.unitOfMeasure: 'Bprme'
      ktmng             as Ktmng,
      @Semantics.quantity.unitOfMeasure: 'Bprme'
      menge             as Menge,
      bprme             as Bprme,
      @Semantics.amount.currencyCode: 'Peinh'
      netprice          as Netprice,
      @Semantics.amount.currencyCode: 'Peinh'
      netvalue          as Netvalue,
      @Semantics.amount.currencyCode: 'Peinh'
      alltbdgamt        as Alltbdgamt,
      @Semantics.amount.currencyCode: 'Peinh'
      avlbdgamt         as Avlbdgamt,
      banfn             as Banfn,
      bnfpo             as Bnfpo,
      peinh             as Peinh,
      meins             as Meins,
      @Semantics.user.createdBy: true
      itemcreatedby     as Itemcreatedby,
      @Semantics.systemDateTime.createdAt: true
      itemcreatedat     as Itemcreatedat,
      @Semantics.user.lastChangedBy: true
      itemlastchangedby as Itemlastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      itemlastchangedat as Itemlastchangedat,
      _Header
}
