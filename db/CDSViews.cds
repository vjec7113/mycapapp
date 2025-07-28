namespace anubhav.myviews;

using {
    anubhav.db.master,
    anubhav.db.transaction
} from './datamodel';


context CDSViews {

    //If we want the object name and column name alias to be exact same
    //respecting case we use ![ObjectName]
    define view ![PoWorklist] as
        select from transaction.purchaseorder {
            key PO_ID                             as ![PurchaseOrderId],
            key Items.PO_ITEM_POS                 as ![ItemPosition],
                PARTNER_GUID.BP_ID                as ![PartnerID],
                PARTNER_GUID.COMPANY_NAME         as ![CompanyName],
                Items.GROSS_AMOUNT                as ![GrossAmount],
                Items.NET_AMOUNT                  as ![NetAmount],
                Items.TAX_AMOUNT                  as ![TaxAmount],
                Items.CURRENCY                    as ![CurrencyCode],
                OVERALL_STATUS                    as ![Status],
                Items.PRODUCT_GUID.CATEGORY       as ![Category],
                Items.PRODUCT_GUID.DESCRIPTION    as ![ProductName],
                PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
                PARTNER_GUID.ADDRESS_GUID.CITY    as ![City]

        };

    define view ![ProductHelpView] as
        select from master.product {
            @EndUserText.Label: [
                {
                    language: 'EN',
                    text    : 'Product Id'
                },
                {
                    language: 'TA',
                    text    : 'தயாரிப்பு ஐடி'
                }
            ]
            PRODUCT_ID                 as ![ProductId],
            @EndUserText.Label: [
                {
                    language: 'EN',
                    text    : 'Description'
                },
                {
                    language: 'TA',
                    text    : 'விளக்கம்'
                }
            ]
            DESCRIPTION                as ![Description],
            @EndUserText.Label: [
                {
                    language: 'EN',
                    text    : 'Category'
                },
                {
                    language: 'TA',
                    text    : 'வகை'
                }
            ]
            CATEGORY                   as ![Category],
            PRICE                      as ![Price],
            CURRENCY_CODE              as ![CurrencyCode],
            SUPPLIER_GUID.COMPANY_NAME as ![SupplierName]
        };

    define view ![ItemView] as
        select from transaction.poitems {
            key PARENT_KEY.PARTNER_GUID   as ![SupplierId],
            key PRODUCT_GUID.NODE_KEY     as ![ProductKey],
            GROSS_AMOUNT              as ![GrossAmount],
            NET_AMOUNT                as ![NetAmount],
            TAX_AMOUNT                as ![TaxAmount],
            CURRENCY                  as ![CurrencyCode],
            PARENT_KEY.OVERALL_STATUS as ![Status]

        };

    //view on view along with lazy loading
    define view ![ProductView] as
        select from master.product
        //Mixin is a keyword to define loose coupling of dependent data
        //which tells framework never load the depenedent data until requested
        mixin {
            //$projection - predicate indicate the selection list of defined fields with alias
            PO_ITEMS : Association to many ItemView
                           on PO_ITEMS.ProductKey = $projection.ProductId
        }
        into {
            NODE_KEY                           as ![ProductId],
            DESCRIPTION                        as ![ProductName],
            CATEGORY                           as ![Category],
            SUPPLIER_GUID.BP_ID                as ![SupplierId],
            SUPPLIER_GUID.COMPANY_NAME         as ![SupplierName],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
            //exposed Association, @Runtime the data will be loaded on demand -Lazy Loading
            PO_ITEMS                           as ![To_Items]
        };

    define view CProductSalesAnalytics as
        select from ProductView {
            key ProductName,
                Country,
                round(
                    sum(To_Items.GrossAmount), 2
                ) as ![TotalPurchaseAmount] : Decimal(15, 2),
                To_Items.CurrencyCode
        }
        group by
            ProductName,
            Country,
            To_Items.CurrencyCode;
}
