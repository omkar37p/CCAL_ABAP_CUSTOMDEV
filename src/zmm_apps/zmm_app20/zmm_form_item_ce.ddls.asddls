@EndUserText.label: 'Rejection Note Item Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZMM_PRINT_ITEM_CLS'
define custom entity ZMM_FORM_ITEM_CE
  // with parameters parameter_name : parameter_type
{
  key Uuid                 : sysuuid_x16;
  key Materialdocument     : abap.char(10);
  key Materialdocumentyear : abap.numc(4);
  key Materialdocumentitem : abap.numc(4);
      Plant                : abap.char(4);
      Companycode          : abap.char(4);
      Companycodecurrency  : abap.cuky;
      Material             : abap.char(40);
      Productdescription   : abap.char(40);
      Materialbaseunit     : abap.unit( 3 );
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      Migoqty              : abap.quan( 13, 3 );
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      Poqty                : abap.quan( 13, 3 );
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      Invoiceqty           : abap.quan( 13, 3 );
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      Receivedqty          : abap.quan( 13, 3 );
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      Acceptedqty          : abap.quan( 13, 3 );
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      Rejectedqty          : abap.quan( 13, 3 );

}
