function getPlaid(plaidData) {
    var url = null;
    var token = plaidData.data('token');
    var env = plaidData.data('env');
    if (typeof token === 'undefined') {
        url = '/plaid/authenticate';
        token = null;
    } else {
        url = '/plaid/update';
    }
    // set token for test environment
    if (env === 'sandbox' && typeof plaidData.data('type') !== 'undefined') {
        token = 'test,' + plaidData.data('type') + ',connected'
    }

    var linkHandler = Plaid.create({
        env: env,
        apiVersion: 'v2',
        clientName: plaidData.data('client-name'),
        key: plaidData.data('key'),
        product: ['auth','transactions'],
        webhook: plaidData.data('webhook'),
        onLoad: function () {
            // The Link module finished loading.
        },
        onSuccess: function (public_token, metadata) {
            // Send the public_token to your app server here.
            // The metadata object contains info about the institution the
            // user selected and the account ID, if selectAccount is enabled.
            $.ajax({
                type: 'POST',
                dataType: 'script',
                url: url,
                data: {
                    public_token: public_token,
                    name: metadata.account.name,
                    type: metadata.account.type,
                    owner_type: plaidData.data('owner-type'),
                    owner_id: plaidData.data('owner-id'),
                    number: metadata.account.mask
                }
            });
        },
        onExit: function () {
            // The user exited the Link flow.
        }
    });
    return linkHandler;
}
// Trigger the authentication view
$(document).on("click", '#plaidLinkButton', function () {
    var plaidData = $(this);
    linkHandler = getPlaid(plaidData);
    var plaidType = plaidData.data('type')
    //open handler for the institution
    if (typeof plaidType === 'undefined') {
        linkHandler.open();
    } else {
        linkHandler.open(plaidType);
    }

});

