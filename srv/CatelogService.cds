using {
    anubhav.db.master,
    anubhav.db.transaction
} from '../db/datamodel';

using {anubhav.myviews} from '../db/CDSViews';

service CatelogService @(
    path    : 'CatelogService',
    requires: 'authenticated-user'
) {
    //Entityset Which offers all the GET,PUT,POST,DELETE
    //@readonly
    @capabilities: {
        Updatable: true,
        Deletable: true,
    }
    entity EmployeeSet @(restrict: [
        {
            grant: ['READ'],
            to   : 'Display',
            where: 'bankName = $user.BankName'
        },
        {
            grant: ['WRITE'],
            to   : 'Edit'
        }
    ])                        as projection on master.employees;

    entity BusinessPartnerSet as projection on master.businesspartner;

    entity AddressSet @(restrict: [{
        grant: ['READ'],
        to   : 'Display',
        where: 'COUNTRY = $user.Country'
    }])                       as projection on master.address;

    entity POs @(odata.draft.enabled:true,
    Common.DefaultValuesFunction: 'getOrderDefault')               as projection on transaction.purchaseorder
    {
        *,
        case OVERALL_STATUS
        when 'P' then 'Pending'
        when 'D' then 'Delivered'
        end as overallStatusText: String(10),

        case OVERALL_STATUS
        when 'P' then 2
        when 'D' then 3
        end as IconColor:Integer
    }
        actions {
            action boost() returns POs;
            action setDelivered() returns POs;
        };

    entity POItems            as projection on transaction.poitems;
    entity ProductSet         as projection on myviews.CDSViews.ProductView;
    //A non instance bound function -- If you want mutiple => array of
    function getMostExpensiveOrder() returns POs;
    function getOrderDefault() returns POs;

}
