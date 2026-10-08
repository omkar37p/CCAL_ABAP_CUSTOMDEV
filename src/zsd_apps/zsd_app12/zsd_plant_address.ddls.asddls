@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_PLANT_ADDRESS as select from zsd_plant
{
   key plant   as plant,
   plantaddress,
   plantgst,      
   plantpan,     
   planttan,     
   email ,        
   cinnumber,
   @Semantics.user.createdBy: true
   createdby,
   @Semantics.systemDateTime.createdAt: true
   createdat,
   @Semantics.user.lastChangedBy: true
   lastchangedby,
   @Semantics.systemDateTime.lastChangedAt: true
   lastchangedate,
   phoneno,
   iso,
   msmeno 
}
