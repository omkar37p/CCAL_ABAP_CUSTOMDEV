@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Outward Entry - RE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP12_RV
  as select from zmm_app12_tb1 as a
   left outer join zmm_app12_chtb as c on c.uuid = a.uuid
  composition [0..*] of ZMM_APP12_IV1 as _Item1
  
  association [0..*] to ZI_GPTYPE     as _gptyp on $projection.Gptype = _gptyp.value_low

{
  key a.uuid          as Uuid,
      a.plant         as Plant,
      a.plantname     as Plantname,
      a.gpnum         as Gpnum,
      a.gptype        as Gptype,
      a.vendnum       as Vendnum,
      a.vendname      as Vendname,
      a.plnrtndate    as Plnrtndate,
      a.vehicleno     as Vehicleno,
      a.dispby        as Dispby,
      a.issuedate     as Issuedate,
      a.issuedby      as Issuedby,
      a.transporter   as Transporter,
      a.remarks       as Remarks,
      @Semantics.amount.currencyCode: 'Curky'
      a.gpvalue       as Gpvalue,
      a.curky         as Curky,
      a.rsngp         as Rsngp,
      a.frghtscope    as Frghtscope,
      a.pcklist       as Pcklist,
      a.delmark       as Delmark,
      a.mark          as Mark,
      a.mark2        as Mark2,
      @Semantics.user.createdBy: true
      a.createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      a.createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      a.lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      a.lastchangedat as Lastchangedat,
      @EndUserText.label: 'Attachments'
      @Semantics.largeObject:{fileName: 'Filename' ,
                                mimeType: 'Minetype',
                                contentDispositionPreference: #INLINE
                                 }
      a.zattachment   as Zattachment,
      @Semantics.mimeType: true
      a.minetype      as Minetype,
      a.filename      as Filename,
      a.ebeln         as Ebeln,
      a.insurno       as Insurno,
      a.ewabillno     as Ewabillno,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      a.netwgt        as Netwgt,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      a.grosswgt      as Grosswgt,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      a.tarewgt       as Tarewgt,
      a.uom           as Uom,
      a.gateno        as Gateno,
      a.gitdat        as Gitdat,
      a.gittim        as Gittim,
      a.gotdat        as Gotdat,
      a.gottim        as Gottim,
      a.statustext    as Statustext,
      a.contpr        as Contpr,
      a.reqby         as Reqby,
      a.reqdpt        as Reqdpt,
      @EndUserText.label: 'Attachments'
      @Semantics.largeObject:{fileName: 'Cfilename' ,
                                mimeType: 'Cminetype',
                                contentDispositionPreference: #INLINE
                                 }
      c.zattachment   as Pdfattchement,
      c.filename      as Cfilename,
      c.minetype      as Cminetype,
      _Item1,
      _gptyp
}
where
  a.mark = 'C'
