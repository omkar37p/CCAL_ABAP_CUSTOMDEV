@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZSD_PLANT_PV provider contract transactional_query
as projection on ZSD_PLANT_ADDRESS
{
    key plant,
    plantaddress,
    plantgst,
    plantpan,
    planttan,
    email,
    cinnumber,
    createdby,
    createdat,
    lastchangedby,
    lastchangedate,
    phoneno,
    iso,
    msmeno
}
