@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ITEM DATA'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZPO_ITEM_RV as select from zpo_item_t1
//composition of target_data_source_name as _association_name
association to parent ZPO_HEAD_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid as Uuid,
  key ebelp as Ebelp,
  ebeln as Ebeln,
  matnr as Matnr,
  werks as Werks,
  lgort as Lgort,
  matkl as Matkl,
  extmatgrp as Extmatgrp,
  @Semantics.quantity.unitOfMeasure: 'bprme'
  ktmng as Ktmng,
   @Semantics.quantity.unitOfMeasure: 'bprme'
  menge as Menge,
  bprme as Bprme,
   @Semantics.amount.currencyCode: 'Peinh'
  netprice as Netprice,
   @Semantics.amount.currencyCode: 'Peinh'
  netvalue as Netvalue,
   @Semantics.amount.currencyCode: 'Peinh'
  alltbdgamt as Alltbdgamt,
   @Semantics.amount.currencyCode: 'Peinh'
  avlbdgamt as Avlbdgamt,
  banfn as Banfn,
  bnfpo as Bnfpo,
  meins as Meins,
  peinh as Peinh,
  itemcreatedby as Itemcreatedby,
  itemcreatedat as Itemcreatedat,
  itemlastchangedby as Itemlastchangedby,
  itemlastchangedat as Itemlastchangedat,
  _Header
}
