@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Outward Entry - RPE'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP12_RPV
  provider contract transactional_query
  as projection on ZMM_APP12_RV
{
  key Uuid,
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'Plantname' ]
      Plant,
      Plantname,
      Gpnum,
      Gptype,
      @EndUserText.label: 'Vendor'
      @ObjectModel.text.element: [ 'Vendname' ]
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
      Mark2,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,
      @Semantics.largeObject:{fileName: 'Filename' ,
                                mimeType: 'Minetype',
                                contentDispositionPreference: #INLINE  }
       Zattachment,
       @Semantics.mimeType: true
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
Contpr,
Reqby,
Reqdpt, 
 @EndUserText.label: 'Attachments PDF'
      @Semantics.largeObject:{fileName: 'Cfilename' ,
                                mimeType: 'Cminetype',
                                contentDispositionPreference: #INLINE
                                 }
   Pdfattchement,
     Cfilename,
       Cminetype,

      /* Associations */
      _gptyp,
      _Item1 : redirected to composition child ZMM_APP12_IPV1
}
