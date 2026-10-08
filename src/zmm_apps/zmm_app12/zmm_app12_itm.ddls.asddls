@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item View Entity'
@Metadata.ignorePropagatedAnnotations: true
@UI.presentationVariant: [{
    sortOrder: [{
        by: 'sno' ,
        direction: #ASC
    }]
}]
define root view entity ZMM_APP12_ITM as select from zmm_app12_tb2
//composition of target_data_source_name as _association_name
{
    key uuid as Uuid,
    key itemno as sno,
    matnr as Mcode,
    maktx as Mdesc,
    uom as Uom,
    hsncode as Hsn,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    quantity as Qty,
    curky as Curky,
    @Semantics.amount.currencyCode: 'Curky'
    netprice as Rate,
    @Semantics.amount.currencyCode: 'Curky'
    totvalue as Talav

}
