@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_INVENTORY_AGING_RV 
as select from I_StockQuantityCurrentValue_2(
                    P_DisplayCurrency: 'INR'
               ) as SQCV 
 
{
        key SQCV.Product,
    key SQCV.Plant,
    key SQCV.StorageLocation,
    key SQCV.InventorySpecialStockType,

    /* Stock info */
    key SQCV.InventoryStockType,    
    key SQCV.SDDocument,
    SQCV.MaterialBaseUnit,
    SQCV.SDDocumentItem,
    SQCV.ProductGroup,
    SQCV.ProductType,
    SQCV.Supplier,
    
      
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
   cast(
    sum(
        case
           when  ( SQCV.ValuationAreaType         = '1')
                //or SQCV.ValuationAreaType         = '3'
             and (
                    SQCV.InventoryStockType = '01'
                 or SQCV.InventoryStockType = '02'
                 or SQCV.InventoryStockType = '07'
                 or SQCV.InventoryStockType = '06'
                 )
            then cast(
                    SQCV.MatlWrhsStkQtyInMatlBaseUnit
                    as abap.dec(23,3)
                 )
            else cast( 0 as abap.dec(23,3) )
        end
    ) as abap.dec(23,3)
) as Quantity, 

    
    /* Display currency */
      cast( 'INR' as abap.cuky ) as NSDM_Display_Currency,
      

    /* Display amount */
    @Semantics.amount.currencyCode: 'NSDM_Display_Currency'
    cast(
    sum(
        case            
           when  ( SQCV.ValuationAreaType         = '1'
                or SQCV.ValuationAreaType         = '3' )
             and (
                    SQCV.InventoryStockType = '01'
                 or SQCV.InventoryStockType = '02'
                 or SQCV.InventoryStockType = '07'
                 or SQCV.InventoryStockType = '06'
                 )
            then cast(
                    SQCV.StockValueInDisplayCurrency
                    as abap.dec(23,2)
                 )
            else cast( 0 as abap.dec(23,2) )
        end
    ) as abap.dec(23,2)
) as StockValueInDisplayCurrency
}

where 
    SQCV.MatlWrhsStkQtyInMatlBaseUnit <> 0 and SQCV.InventoryStockType <> '08'  
group by
    SQCV.Product,
    SQCV.Plant,
    SQCV.StorageLocation,
    SQCV.InventorySpecialStockType,
    SQCV.InventoryStockType,
    SQCV.MaterialBaseUnit,
    SQCV.SDDocument,
    SQCV.SDDocumentItem,
    SQCV.ProductGroup,
    SQCV.ProductType,
    SQCV.Supplier
