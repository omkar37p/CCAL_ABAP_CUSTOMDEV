@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COA Item Print Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@UI.presentationVariant: [{sortOrder: [{ by: 'InspectionCharacteristic', direction: #ASC }]}]
define view entity ZQM_ITEM_VIEW 
as select from zqm_result_db as Item

{
    key Item.uuid,
    key Item.inspectionlot,
    key Item.inspplanoperationinternalid,
    key Item.inspectioncharacteristic,
    Item.inspectioncharacteristictext,
    Item.inspectionspecification,
    Item.inspectioncodetext,
    Item.personfullname,
    Item.indicators,
    Item.unitofmeasuretechnicalname,
    Item.inspectionspecificationunit,
    Item.inspectionresultmeanvalue,
    Item.inspectionmeth,
    Item.resultmeanvalue,
    Item.inspspecificationname
        
}
