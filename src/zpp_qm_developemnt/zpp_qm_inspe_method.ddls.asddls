@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Method'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPP_QM_INSPE_METHOD
 as select from I_InspectionMethodVersion
{
    key InspectionMethodPlant,
    key InspectionMethod,
    key InspectionMethodVersion,
    InspectionMethodValidFromDate,
    InspectionMethodSearchField,
    InspectionMethodStatus,
    InspectorQualification,
    InspMethInformationField1,
    InspMethInformationField2,
    InspMethInformationField3,
    QltyMstrDataAuthorizationGroup,
    CreatedByUser,
    CreationDate,
    LastChangedByUser,
    LastChangeDate,
    ChangedDateTime
    }
