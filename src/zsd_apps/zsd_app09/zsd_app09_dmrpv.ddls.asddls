@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP09_DMRPV
  provider contract transactional_query
  as projection on ZSD_APP09_DMRV
{
      @ObjectModel.text.element: [ 'ccodetxt' ]
  key ccode,
      @Consumption.semanticObject: 'BillingDocument'
  key billdoc,
      @ObjectModel.text.element: [ 'billtyptxt' ]
      billtyp,
      @ObjectModel.text.element: [ 'sorgtxt' ]
      sorg,
      @ObjectModel.text.element: [ 'distchntxt' ]
      distchn,
      @ObjectModel.text.element: [ 'divsntxt' ]
      divsn,
      billdate,
      refdoc,
      @ObjectModel.text.element: [ 'invlstyptxt' ]
      invlstyp,
      @ObjectModel.text.element: [ 'shpcondtxt' ]
      shpcond,
      @ObjectModel.text.element: [ 'incotyptxt' ]
      incotyp,
      incoloc1,
      @ObjectModel.text.element: [ 'paytermstxt' ]
      payterms,
      @ObjectModel.text.element: [ 'payertxt' ]
      payer,
      @ObjectModel.text.element: [ 'customertxt' ]
      customer,
      sddocsts,
      @ObjectModel.text.element: [ 'billststxt' ]
      billsts,
      AccountingPostingStatus,
      AccountingTransferStatus,
      Curky,
      @Semantics.amount.currencyCode: 'Curky'
      Netamt,
      @Semantics.amount.currencyCode: 'Curky'
      Taxamt,
      @Semantics.amount.currencyCode: 'Curky'

      Totamt,
      accdoc,
      clrsts,
      ModeOfTransport,
      Transporter,
      VehicleNumber,
      FreightTerms,
      DriverDetails,
      CylinderDetailSeal,
      Unit,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      GrossWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      TareWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      NetWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      ConcnWT,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      CharWT,
      YY1_NOOFCylinder_DLH,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      VolumePerCylinder,
      ccodetxt,
      billtyptxt,
      sorgtxt,
      distchntxt,
      divsntxt,
      invlstyptxt,
      shpcondtxt,
      incotyptxt,
      paytermstxt,
      customertxt,
      payertxt,
      BilltoGSTIN,
      BilltoCountry,
      BilltoStreetName,
      BilltoRegion,
      Billtopostalcode,
      payergst,
      payerpan,
      pystate,
      Payerid,
      Pyraddrid,
      Shpaddrid,
      Shptoid,
      ShiptoCompanyName,
      ShiptoGSTIN,
      ShiptoCountry,
      ShiptoStreetName,
      ShiptoRegion,
      Shiptopostalcode,
      shpgst,
      shppan,
      shstate,
      IRN,
      AckDate,
      AckNo,
      Qrcode,
      EwaybillNo,
      EwaybillDate,
      billststxt,
      ordrefdat,
      Street,
      Email,
      CIN,
      Phone,
      ISO,
      GSTIN,
      PAN,
      TAN,
      Batch,
      Itemno,
      Itemtxt,
      ////e-document details---------------------------------------
              @Semantics.largeObject:{
          mimeType: 'mimetype',
          fileName: 'filename',
          contentDispositionPreference: #INLINE
          }   
      attachment,
      filename,
      mimetype,
      emailstatus,
      EmailStausText,
      dscstatus,
      DSCStausText,
      InvoiceText,
      @ObjectModel.text.element: [ 'PersonFullName' ]
      CreatedByUser,
      PersonFullName,
      /* Associations */
      _Item : redirected to composition child ZSD_APP09_DMIPV1
}
