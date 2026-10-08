@EndUserText.label: 'Custom Entity Item'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_APPS12_PRINT_ITM'
define custom entity ZPP_APPS05_CITM
  // with parameters parameter_name : parameter_type
{
      //  key key_element_name : key_element_type;
      //  element_name : element_type;
  key uuid     : sysuuid_x16;
  key sno   : abap.numc(5);
      Mcode    : matnr;
      Mdesc    : maktx;
      Uom      : meins;
      Hsn      : abap.char(30);
      @Semantics.quantity.unitOfMeasure: 'Uom'
      Qty      : menge_d;
      Curky    : abap.cuky( 5 );
      @Semantics.amount.currencyCode: 'Curky'
      Rate     : abap.curr( 13, 2 );
      @Semantics.amount.currencyCode: 'Curky'
      Talav : abap.curr( 13, 2 );





}
