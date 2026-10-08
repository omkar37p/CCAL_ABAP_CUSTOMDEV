@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Batch Char Value'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSD_APP09_CHARVALUE 
as select from I_ClfnObjectCharcValForKeyDate ( P_KeyDate : $session.system_date )

{
  key ClfnObjectID,
  key ClfnObjectTable,
  key CharcInternalID,
  key CharcValuePositionNumber,
  key ClfnObjectType,
  key ClassType,
      substring(ClfnObjectID, 1, 18) as Material,
      substring(ClfnObjectID,41,10) as Batch,
      CharcValue,
      cast(CharcFromDecimalValue as abap.dec( 13, 3 ) ) as CharV
//      case
//            when ( CharcValue is initial or CharcValue is null ) 
//                    then cast(CharcFromDecimalValue as abap.dec( 13, 3 ) ) 
//            when ( CharcValue is not initial or CharcFromDecimalValue is not null ) 
//                    then cast(CharcValue as abap.dec( 13, 3 ))
//                     else null end  as CharValue

}
