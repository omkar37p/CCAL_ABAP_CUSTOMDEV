@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP09_DMRV
  as select from ZFDP_DMINV01
  composition [0..*] of ZSD_APP09_DMIV1 as _Item
{
  key ccode,
  key billdoc,
      billtyp,
      sorg,
      distchn,
      divsn,
      billdate,
      refdoc,
      invlstyp,
      shpcond,
      incotyp,
      incoloc1,
      payterms,
      payer,
      customer,
      sddocsts,
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
      Batch,
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
      Itemno,
      Itemtxt,
      ////e-document details---------------------------------------
      attachment,
      filename,
      mimetype,
      emailstatus,
      EmailStausText,
      dscstatus,
      DSCStausText,
//      EmailAddress,
      InvoiceText,
      CreatedByUser,
      PersonFullName,
      _Item
}

//      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZBP_SD_APP09_DMRV'
//      @EndUserText.label: 'Plant Street'
//      //      @ObjectModel.virtualElement: true
//      cast( 0 as abap.char( 100 ) ) as PStreet,
