@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CEO Dashboard GL List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP03_GL_LIST as select from I_JournalEntryItem  
{
          
   /*   1st CDS  
                USED IN  ----   ZAPP03_GL_SUM      */


//    key CompanyCode,
    key AccountingDocument,
    key FiscalYear             as Fiscal_YEAR,
    key AccountingDocumentItem,
        PostingDate,
        BaseUnit,
        DebitCreditCode,
        FiscalPeriod           as Fiscal_Period,
        Product,
        GLAccount,
        CompanyCodeCurrency,
 
        case
        
             /* Other Income    */
             
           when GLAccount = '0000400004'
             or GLAccount = '0000410300'
             or GLAccount = '0000410501'
             or GLAccount = '0000410000'
             or GLAccount = '0000410003'
             or GLAccount = '0000410100'
             or GLAccount = '0000410101'
             or GLAccount = '0000410102'
             or GLAccount = '0000410105'
             or GLAccount = '0000410200'
             or GLAccount = '0000410201'
             or GLAccount = '0000410202'
             or GLAccount = '0000410401'
             or GLAccount = '0000606003'
             or GLAccount = '0000651000'
             
             
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as OTHER_INCOME,
        

            /* Consumption of Raw Materials  */
     case
            when GLAccount = '0000510001'

                      then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
           end as Raw_Materials,

             /* Stores Consumables  */
        case        
            when  GLAccount = '0000609001'
               or GLAccount = '0000609003'
               or GLAccount = '0000609004'

               
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Stores_Consumables,  

            /* Power  */
     case
            when GLAccount = '0000620000'
              or GLAccount = '0000620001'

              
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as POWER,

            /* Fuel  */
          case  
            when GLAccount = '0000622000'
            
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as FUEL,
                
            /* Labour Charges  */
    case
            when GLAccount = '0000605001'
              or GLAccount = '0000605002'
              or GLAccount = '0000625000'
              or GLAccount = '0000625001'
              or GLAccount = '0000625002'
              or GLAccount = '0000625003'
              or GLAccount = '0000625006'
              or GLAccount = '0000625007'
              or GLAccount = '0000625008'
              or GLAccount = '0000625010'
              or GLAccount = '0000625011'
              or GLAccount = '0000625015'
              or GLAccount = '0000625016'
              or GLAccount = '0000625017'
              or GLAccount = '0000631003'
              or GLAccount = '0000625005'

              
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as LABOUR,

            /* Inc/Dec in Stock of FG & WIP  */
      case
            when GLAccount = '0000500040'
              or GLAccount = '0000500050'
              or GLAccount = '0000500090'
              or GLAccount = '0000503900'
              or GLAccount = '0000505000'
              or GLAccount = '0000506000'
              or GLAccount = '0000507100'
              or GLAccount = '0000509000'
              or GLAccount = '0000509100'
              or GLAccount = '0000509110'
              or GLAccount = '0000500102'
              or GLAccount = '0000500103'
              
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )

        end as FG_WIP,
        
                    /* Depreciation */
            case
             when GLAccount = '0000690000'
               or GLAccount = '0000690001'
               or GLAccount = '0000690002'
               or GLAccount = '0000690003'
               or GLAccount = '0000690004'
               or GLAccount = '0000690005'
               or GLAccount = '0000690006'
               or GLAccount = '0000690007'
               
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Depreciation,
        
        
        /* Employees Remuneration & Benefits */
        
       case
   
when GLAccount = '0000600001'
  or GLAccount = '0000600002'
  or GLAccount = '0000600003'
  or GLAccount = '0000600004'
  or GLAccount = '0000600005'
  or GLAccount = '0000600006'
  or GLAccount = '0000600007'
  or GLAccount = '0000600008'
  or GLAccount = '0000600009'
  or GLAccount = '0000600010'
  or GLAccount = '0000600011'
  or GLAccount = '0000600012'
  or GLAccount = '0000600013'
  or GLAccount = '0000600014'
  or GLAccount = '0000601001'
  or GLAccount = '0000601002'
  or GLAccount = '0000601003'
  or GLAccount = '0000601004'
  or GLAccount = '0000601005'
  or GLAccount = '0000601006'
  or GLAccount = '0000601007'
  or GLAccount = '0000602001'
  or GLAccount = '0000602003'
  or GLAccount = '0000602004'
  or GLAccount = '0000602005'
  or GLAccount = '0000602006'
  or GLAccount = '0000602007'
  or GLAccount = '0000602501'
  or GLAccount = '0000602503'

  
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Employees_R_B,

/* Repairs & Maintenance - Machinery */
case
when 
    GLAccount = '0000608001'  
  or GLAccount = '0000608002'
  or GLAccount = '0000608003'
  or GLAccount = '0000608007'
  or GLAccount = '0000608009'
  or GLAccount = '0000609002'
  or GLAccount = '0000609006'
  or GLAccount = '0000635001'
  or GLAccount = '0000500020'
  or GLAccount = '0000500100'
               
                 

  
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as R_M_Machinery,
                
                /* Repairs & Maintenance - Buildings */
case
when 
     GLAccount = '0000606013'
  or GLAccount = '0000608004'
  or GLAccount = '0000608008'
  or GLAccount = '0000608010'
  or GLAccount = '0000649004'
  or GLAccount = '0000649102'
                  
  
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as R_M_Buildings,
                

/* Insurance */
case
when GLAccount = '0000607001'
  or GLAccount = '0000607002'
  or GLAccount = '0000607003'
  or GLAccount = '0000607004'
  or GLAccount = '0000607005'
  or GLAccount = '0000607006'
  or GLAccount = '0000607007'
  or GLAccount = '0000607008'
  or GLAccount = '0000607009'
  or GLAccount = '0000607010'

  
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Insurance,

/* Travelling Expenses */
case
when GLAccount = '0000647001'
  or GLAccount = '0000647003'
  or GLAccount = '0000647004'
  or GLAccount = '0000647005'
  or GLAccount = '0000647006'
  or GLAccount = '0000647007'
  or GLAccount = '0000647009'
  or GLAccount = '0000647011'
  or GLAccount = '0000647012'
  or GLAccount = '0000647013'
  or GLAccount = '0000647014'
  or GLAccount = '0000647015'
  or GLAccount = '0000647016'
  or GLAccount = '0000647017'
  
  
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Trvelling_Expenses,

/* Miscellaneous Expenses */
case
when GLAccount = '0000606000'
  or GLAccount = '0000606001'
  or GLAccount = '0000606002'
  or GLAccount = '0000606004'
  or GLAccount = '0000606005'
  or GLAccount = '0000606006'
  or GLAccount = '0000606007'
  or GLAccount = '0000606008'
  or GLAccount = '0000606009'
  or GLAccount = '0000606010'
  or GLAccount = '0000606011'
  or GLAccount = '0000606012'
  or GLAccount = '0000606014'
  or GLAccount = '0000606015'
  or GLAccount = '0000606016'
  or GLAccount = '0000606017'
  or GLAccount = '0000606018'
  or GLAccount = '0000606019'
  or GLAccount = '0000606021'
  or GLAccount = '0000606501'
  or GLAccount = '0000606504'
  or GLAccount = '0000608011'
  or GLAccount = '0000610001'
  or GLAccount = '0000610002'
  or GLAccount = '0000610004'
  or GLAccount = '0000617001'
  or GLAccount = '0000617505'
  or GLAccount = '0000617506'
  or GLAccount = '0000617507'
  or GLAccount = '0000617509'
  or GLAccount = '0000640004'
  or GLAccount = '0000641001'
  or GLAccount = '0000641002'
  or GLAccount = '0000642001'
  or GLAccount = '0000642002'
  or GLAccount = '0000642003'
  or GLAccount = '0000643002'
  or GLAccount = '0000643003'
  or GLAccount = '0000643005'
  or GLAccount = '0000643006'
  or GLAccount = '0000644001'
  or GLAccount = '0000646001'
  or GLAccount = '0000646002'
  or GLAccount = '0000646004'
  or GLAccount = '0000648001'
  or GLAccount = '0000648003'
  or GLAccount = '0000649002'
  or GLAccount = '0000649003'
  or GLAccount = '0000649005'

        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Miscellaneous_Expe,

/* Director's Remuneration */
case
when GLAccount = '0000643008'
  or GLAccount = '0000256010'

  
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Director_Rem,

/* Diff in Frt/ED paid & Collected */
case
when GLAccount = '0000400101'
  or GLAccount = '0000410103'
  or GLAccount = '0000410107'
  or GLAccount = '0000635002'
  or GLAccount = '0000635005'
  or GLAccount = '0000635006'

        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
                end as Frt_ED_paid,

/* Auditors Remuneration */
case
when GLAccount = '0000643001'


        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )

        end as Auditors_Rem, 
        
        /*  Finance Charges */
        
  case 
    
     when GLAccount = '0000615001'
       or GLAccount = '0000615002'             
       or GLAccount = '0000615003'
       or GLAccount = '0000615004'
       or GLAccount = '0000615005'
       or GLAccount = '0000615006'
       or GLAccount = '0000617503'
       or GLAccount = '0000616001'
       
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
  end as Finance_Charges,
  
  
  case
      
     when GLAccount = '0000400003'
       or GLAccount = '0000510003'

       
        then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
  end as Trading_Profit
           
        /*******
         ************* Amount
                      **********/
                      

}
where Ledger = '0L'
