@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define  root view entity ZPO_HEAD_PVE 
provider contract transactional_query
as projection on ZPO_HEAD_RV
{
  key Uuid,
  Ebeln,
  Banfn,
  Bukrs,
  Bsart,
  Doctypdesc,
  Lifnr,
  Suppname,
  Ekorg,
  Ekgrp,
  Waers,
  Bedat,
  Mark,
  Createdby,
  Createdat,
  Lastchangedby,
  Lastchangedat  ,
  _item
}
