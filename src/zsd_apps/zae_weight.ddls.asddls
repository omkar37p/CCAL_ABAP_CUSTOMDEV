@EndUserText.label: 'Capture Weight value'
define abstract entity ZAE_WEIGHT
  //  with parameters parameter_name : parameter_type
{
  @Semantics.quantity.unitOfMeasure: 'Unit'
  @EndUserText.label: 'Weigh-Scale reading'
  Weight : abap.quan(11,3);
  @Semantics.unitOfMeasure: true
  @Consumption.defaultValue: 'TO'
  @Consumption.valueHelpDefault.display: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasureStdVH',
  element: 'UnitOfMeasure' } }]
  Unit   : abap.unit(3);

}
