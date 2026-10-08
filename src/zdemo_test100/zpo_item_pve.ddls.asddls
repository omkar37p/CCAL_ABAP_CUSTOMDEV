@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define  view entity ZPO_ITEM_PVE 
provider contract transactional_query
as projection on ZPO_ITEM_RV
{
 key Uuid,
 key Ebelp,
 Ebeln,
 Matnr,
 Werks,
 Lgort,
 Matkl,
 Extmatgrp,
 @Semantics.quantity.unitOfMeasure: 'bprme'
 Ktmng,
 @Semantics.quantity.unitOfMeasure: 'bprme'
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
 Meins,
 Peinh,
 Itemcreatedby,
 Itemcreatedat,
 Itemlastchangedby,
 Itemlastchangedat ,
 _Header  
}
