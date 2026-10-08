@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZGSTR1_NEW_PV
  provider contract transactional_query
  as projection on ZGSTR1_NEW_RE

{
   key GLAcc,
  key billdoc,
  key billitm,
  
      GSTR1RETURNPERIOD,
      BAUTOFILLPERIOD,
      //RevenueAccount,
      //igststep,
      //igstcnt,
      lang,
      custname,
      taxno2,
      billdate,
      Fidocdate,
      stcurr,
      @Semantics.amount.currencyCode: 'stcurr'
      tottaxamt,
      @Semantics.amount.currencyCode: 'stcurr'
      totnetamt,
      excgrate,
      prdgrp,
      refdoc,
      Gstrate,
      @Semantics.amount.currencyCode: 'igstcurr'
      cgstamt,
      @Semantics.amount.currencyCode: 'igstcurr'
      sgstamt,
      @Semantics.amount.currencyCode: 'igstcurr'
      igstamt,
      IGSTCURR,
      //@Semantics.amount.currencyCode: 'igstcurr'
      //Cessamt,
      itmtxt,
      uom,
      @Semantics.quantity.unitOfMeasure: 'uom'
      billqty,
      hsncode,
      //igstcntyp,
      //cgstcntyp,
      //sgstcntyp,
      SupplierGSTIN,
      State,
      Divisionb,
      BillingType,
      Accdoc,
      InStus,
      // @Semantics.amount.currencyCode: 'stcurr'
      @Semantics.amount.currencyCode: 'igstcurr'
      Cessamt,
      Supplytype1,
      Supply,
      ExportType,
      Notenumber,
      NoteDate,
      @Semantics.amount.currencyCode: 'stcurr'
      NoteValue,
      Plant,
      PlantName
}
