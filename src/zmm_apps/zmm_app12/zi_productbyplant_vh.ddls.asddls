@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product by Plant Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRODUCTBYPLANT_VH
  as select from I_ProductPlantBasic as pla
  left outer join I_ProductValuationBasic as _Valu on _Valu.Product = pla.Product and _Valu.ValuationArea = pla.Plant
  association [1..1] to I_Product              as _Product on $projection.Product = _Product.Product
  association [1..1] to I_ProductDescription_2 as _Desc    on $projection.Product = _Desc.Product
//  association [1..1] to I_ProductValuationBasic as _Valu on $projection.Prodesc = _Valu.Product
{
  key pla.Product,
  key pla.Plant,
      _Product.BaseUnit        as Baseunit,
      _Desc.ProductDescription as Prodesc,
       @UI.hidden: true
      pla.ConsumptionTaxCtrlCode as Hsncode,
      @UI.hidden: true
 @Semantics.amount.currencyCode: 'Currency'
      case when _Valu.InventoryValuationProcedure = 'S'
      then  _Valu.StandardPrice
      else
      _Valu.MovingAveragePrice
      end as Netprice,
       @UI.hidden: true
  _Valu.Currency as Currency,

      _Product,
      _Desc
}
