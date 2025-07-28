using CatelogService as service from '../../srv/CatelogService';


annotate service.POs with @(

    UI.SelectionFields      : [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        CURRENCY_code,
        OVERALL_STATUS
    ],

    UI.LineItem             : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'boost',
            Inline: true,
            Action: 'CatelogService.boost',
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type      : 'UI.DataField',
            Criticality: IconColor,
            Value      : overallStatusText,
        },


    ],

    UI.HeaderInfo           : {
        TypeName      : 'Purchase order',
        TypeNamePlural: 'Purchase orders',
        Title         : {Value: PO_ID},
        Description   : {Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfWIANYvwZs-lxsx2lIEoUZzTHcCcaScdcVQ&s'
    },

    UI.Facets               : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Order Details',
                    Target: '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Configuration Details',
                    Target: '@UI.FieldGroup#Spiderman',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status',
                    Target: '@UI.FieldGroup#Superman',
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Order Items',
            Target: 'Items/@UI.LineItem',
        }
    ],
    UI.Identification       : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Business Partner GUID',
            Value: PARTNER_GUID_NODE_KEY
        },
        {
            $Type: 'UI.DataField',
            Label: 'Life Cycle Status',
            Value: LIFECYCLE_STATUS,
        },
        {
            $Type: 'UI.DataFieldForAction',
            Label: 'Deliver',
            Action: 'CatelogService.setDelivered',
        },
    ],
    UI.FieldGroup #Spiderman: {
        Label: 'Pricing',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Gross Amount',
                Value: GROSS_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Net Amount',
                Value: NET_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Tax Amount',
                Value: TAX_AMOUNT,
            },
        ],
    },
    UI.FieldGroup #Superman : {
        Label: 'Status Info',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Currency Code',
                Value: CURRENCY_code,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Overall Status',
                Value: OVERALL_STATUS,
            }
        ]
    }

);

annotate service.POItems with @(
    UI.LineItem            : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
    ],
    UI.HeaderInfo          : {
        TypeName      : 'Purchase order Item',
        TypeNamePlural: 'Purchase orders Items',
        Title         : {Value: PO_ITEM_POS},
        Description   : {Value: PRODUCT_GUID.ProductName},
        ImageUrl      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfWIANYvwZs-lxsx2lIEoUZzTHcCcaScdcVQ&s'
    },
    UI.Facets              : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Details',
            Target: '@UI.Identification',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Product Details',
            Target: '@UI.FieldGroup#ProdInfo',
        },
    ],
    UI.Identification      : [
        {
            $Type: 'UI.DataField',
            Label: 'Item',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Product GUID',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Gross Amount',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Net Amount',
            Value: NET_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Tax Amount',
            Value: TAX_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Currency Code',
            Value: CURRENCY_code,
        },
    ],
    UI.FieldGroup #ProdInfo: {
        Label: 'Product Info',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Product ID',
                Value: PRODUCT_GUID.ProductId,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Product Name',
                Value: PRODUCT_GUID.ProductName,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Product Category',
                Value: PRODUCT_GUID.Category
            },
            {
                $Type: 'UI.DataField',
                Label: 'Supplier Name',
                Value: PRODUCT_GUID.SupplierName,
            },
        ]
    }
);

annotate service.POs with {
    PARTNER_GUID @(
        Common.Text: PARTNER_GUID.COMPANY_NAME
    )
};
annotate service.POs with {
    OVERALL_STATUS @(
        Common.Text: overallStatusText
    )
};
annotate service.POItems with {
    PRODUCT_GUID @(
        Common.Text: PRODUCT_GUID.ProductName
    )
};

//Define a value help for an entity
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification:[{
        $Type: 'UI.DataField',
        Value: COMPANY_NAME,
    }]
);

@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification:[{
        $Type: 'UI.DataField',
        Value: ProductName,
    }]
);