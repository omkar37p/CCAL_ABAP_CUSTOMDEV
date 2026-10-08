@EndUserText.label: 'COA Item Print Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZQM_PRINT_ITEM_CLASS'
define custom entity ZQM_ITEM_CE
  // with parameters parameter_name : parameter_type
{
  key uuid                         : sysuuid_x16;
  key inspectionlot                : zqminspno;
  key inspplanoperationinternalid  : abap.numc(8);
  key inspectioncharacteristic     : abap.numc(4);
      inspectioncharacteristictext : abap.char(40);
      inspectionspecification      : abap.char(8);
      inspectioncodetext           : abap.char(40);
      personfullname               : abap.char(80);
      indicators                   : abap.char(18);
      unitofmeasuretechnicalname   : abap.char(6);
      inspectionspecificationunit  : abap.char(3);
      inspectionresultmeanvalue    : abap.char(40);
      inspectionmeth               : abap.char(40);
      resultmeanvalue              : abap.char(40);
      inspspecificationname        : abap.char(72);

}
