@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Header - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP03_RV
  as select from zmm_app03_tb1
  composition [0..*] of ZMM_APP03_IV1 as _Item
{
  key uuid          as Uuid,
      ebeln         as Ebeln,
      banfn         as Banfn,
      bukrs         as Bukrs,
      bsart         as Bsart,
      doctypdesc    as Doctypdesc,
      lifnr         as Lifnr,
      suppname      as Suppname,
      ekorg         as Ekorg,
      ekgrp         as Ekgrp,
      waers         as Waers,
      bedat         as Bedat,
      mark          as Mark,
      @Semantics.user.createdBy: true
      createdby     as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      createdat     as CreatedAt,
      @Semantics.user.lastChangedBy: true
      lastchangedby as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as LastChangedAt,
      _Item
}
