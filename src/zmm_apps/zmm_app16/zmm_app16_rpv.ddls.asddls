@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Outward Processing Root Projection View  Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_APP16_RPV provider contract transactional_query as projection on ZMM_APP16_RV
{
    key Uuid,
    Plant,
    Plantname,
    Gpnum,
    Gptype,
    Vendnum,
    Vendname,
    Plnrtndate,
    Vehicleno,
    Dispby,
    Issuedate,
    Issuedby,
    Transporter,
    Remarks,
      @Semantics.amount.currencyCode: 'Curky'
    Gpvalue,
    Curky,
    Rsngp,
    Frghtscope,
    Pcklist,
    Delmark,
    Mark,
    @Semantics.user.createdBy: true
    Createdby,
    @Semantics.systemDateTime.createdAt: true
    Createdat,
    @Semantics.user.lastChangedBy: true
    Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    Lastchangedat,
    Zattachment,
    Minetype,
    Filename,
    Ebeln,
    Insurno,
    Ewabillno,
    @Semantics.quantity.unitOfMeasure : 'Uom'
    Netwgt,
    @Semantics.quantity.unitOfMeasure : 'Uom'
    Grosswgt,
    @Semantics.quantity.unitOfMeasure : 'Uom'
    Tarewgt,
    Uom,
    Gateno,
    Gitdat,
    Gittim,
    Gotdat,
    Gottim,
    Statustext,
    /* Associations */
    _item,
    _status
}
