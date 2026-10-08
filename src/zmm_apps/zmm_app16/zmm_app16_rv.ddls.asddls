@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Outward Processing Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZMM_APP16_RV
  as select from zmm_app12_tb1
  association[1..1] to ZMM_SECQ_STATUS_V as _status on _status.value_low = $projection.Mark
  association[0..*] to zmm_app16_V as _item on _item.Uuid = $projection.Uuid
{
  key uuid          as Uuid,
      plant         as Plant,
      plantname     as Plantname,
      gpnum         as Gpnum,
      gptype        as Gptype,
      vendnum       as Vendnum,
      vendname      as Vendname,
      plnrtndate    as Plnrtndate,
      vehicleno     as Vehicleno,
      dispby        as Dispby,
      issuedate     as Issuedate,
      issuedby      as Issuedby,
      transporter   as Transporter,
      remarks       as Remarks,
      @Semantics.amount.currencyCode: 'Curky'
      gpvalue       as Gpvalue,
      curky         as Curky,
      rsngp         as Rsngp,
      frghtscope    as Frghtscope,
      pcklist       as Pcklist,
      delmark       as Delmark,
      mark          as Mark,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
      zattachment   as Zattachment,
      minetype      as Minetype,
      filename      as Filename,
      ebeln         as Ebeln,
      insurno       as Insurno,
      ewabillno     as Ewabillno,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      netwgt        as Netwgt,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      grosswgt      as Grosswgt,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      tarewgt       as Tarewgt,
      uom           as Uom,
      gateno        as Gateno,
      gitdat        as Gitdat,
      gittim        as Gittim,
      gotdat        as Gotdat,
      gottim        as Gottim,
     /* Association */
      _status,
      _item,
      _status.text as Statustext
}


