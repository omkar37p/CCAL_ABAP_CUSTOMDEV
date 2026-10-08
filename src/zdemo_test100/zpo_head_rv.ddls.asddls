@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header data'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZPO_HEAD_RV as select from zpo_hd_t

composition[0..*] of ZPO_ITEM_RV as _item
{
  key uuid as Uuid,
  ebeln as Ebeln,
  banfn as Banfn,
  bukrs as Bukrs,
  bsart as Bsart,
  doctypdesc as Doctypdesc,
  lifnr as Lifnr,
  suppname as Suppname,
  ekorg as Ekorg,
  ekgrp as Ekgrp,
  waers as Waers,
  bedat as Bedat,
  mark as Mark,
  createdby as Createdby,
  createdat as Createdat,
  lastchangedby as Lastchangedby,
  lastchangedat as Lastchangedat ,
  _item 
    
}
