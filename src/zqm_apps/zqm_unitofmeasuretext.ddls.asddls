@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit of Measure Description'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZQM_UnitOfMeasureText
  as select from I_UnitOfMeasureText
{
  key Language,
  key UnitOfMeasure,
      UnitOfMeasureLongName,
      UnitOfMeasureName,
      UnitOfMeasureTechnicalName,
      case
            when UnitOfMeasure = '4G' then 'Microliter' // µl
            when UnitOfMeasure = '4O' then 'Microfarad' // µF
            when UnitOfMeasure = 'B84' then 'Microampere'  //µA
            when UnitOfMeasure = 'FA' then 'Fahrenheit'  // °F
            when UnitOfMeasure = 'GC' then 'Degrees C'  // °C
            when UnitOfMeasure = 'GQ' then 'Microgram/cubic meter'  // µg/m3
            when UnitOfMeasure = 'MIM' then 'Micrometer'  // µm
            when UnitOfMeasure = 'MIS' then 'Microsecond'  // µs
            when UnitOfMeasure = 'PMR' then 'Permeation Rate SI'  // kg/m2*s
            when UnitOfMeasure = 'PRM' then 'Permeation Rate'  // ug/cm2*min
            when UnitOfMeasure = 'UG' then 'Microgram'  // µg
            when UnitOfMeasure = 'UGL' then 'Microgram/liter'  // µg/l
            when UnitOfMeasure = 'V01' then 'Microsiemens per centimeter'  // µS/cm
            when UnitOfMeasure = 'V01' then 'Micrograms Per Cubic Meter'  // µg/cum
            when UnitOfMeasure = 'ZPM' then 'Micrograms Per Cubic Meter'  // µg/m3            
            when UnitOfMeasure = 'ZS' then 'Microsecond'  // µs
            when UnitOfMeasure = 'ZSM' then 'Micromho'  // μmhos
            when UnitOfMeasure = 'ZK' then 'Microgram/Kg'  // µg/kg   
            else UnitOfMeasureTechnicalName end as UnitofMeas
}
where Language = $session.system_language
